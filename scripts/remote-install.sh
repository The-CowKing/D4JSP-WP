#!/bin/bash
# =============================================================
# D4JSP-WP — Single-shot remote installer
# Pipe via:
#   ssh -p 65002 u704061244@82.29.193.20 'bash -s' < scripts/remote-install.sh
# =============================================================
set -e

REPO_URL="https://github.com/The-CowKing/D4JSP-WP.git"
SRC_DIR="$HOME/d4jsp-wp-src"
WP_ROOT="$HOME/domains/d4jsp.org/public_html"
DEPLOY_PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObw6XWbbtmCmcfmdW9dv3ttij6CIr0jkutR1CpGX31Z d4jsp-deploy"

export PATH="$HOME/bin:$PATH"

echo "=== [0/9] Environment ==="
echo "HOME=$HOME"
echo "WP_ROOT=$WP_ROOT"
mkdir -p "$HOME/bin" "$WP_ROOT"

# --- 1. Ensure WP-CLI ---
if ! command -v wp >/dev/null 2>&1; then
  echo "=== [1/9] Installing WP-CLI to ~/bin ==="
  curl -sSL -o "$HOME/bin/wp.phar" https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x "$HOME/bin/wp.phar"
  ln -sf "$HOME/bin/wp.phar" "$HOME/bin/wp"
else
  echo "=== [1/9] WP-CLI present: $(command -v wp) ==="
fi
wp --info | head -6 || true

# --- 2. Clone (or refresh) the source ---
echo "=== [2/9] Fetching repo ==="
if [ -d "$SRC_DIR/.git" ]; then
  git -C "$SRC_DIR" fetch --all --quiet
  git -C "$SRC_DIR" reset --hard origin/main --quiet
else
  rm -rf "$SRC_DIR"
  git clone --depth 1 "$REPO_URL" "$SRC_DIR"
fi

# --- 3. Run install.sh (downloads WP, configures, multisite, subsites, plugins) ---
echo "=== [3/9] Running install.sh ==="
bash "$SRC_DIR/scripts/install.sh"

# --- 4. Deploy sunrise.php (required for domain mapping) ---
echo "=== [4/9] Installing sunrise.php ==="
cp "$SRC_DIR/scripts/sunrise.php" "$WP_ROOT/wp-content/sunrise.php"

# --- 5. Deploy theme ---
echo "=== [5/9] Installing theme d4jsp-dark ==="
mkdir -p "$WP_ROOT/wp-content/themes/d4jsp-dark"
cp -r "$SRC_DIR/theme/d4jsp-dark/." "$WP_ROOT/wp-content/themes/d4jsp-dark/"

# --- 6. Deploy .htaccess ---
echo "=== [6/9] Installing .htaccess ==="
cp "$SRC_DIR/.htaccess" "$WP_ROOT/.htaccess"

# --- 7. Map subsites to their real domains in wp_blogs ---
echo "=== [7/9] Mapping subsite domains ==="
cd "$WP_ROOT"
PFX=$(wp db prefix --allow-root 2>/dev/null || wp db prefix)
declare -A MAP=(
  ["diablo4mods"]="diablo4mods.com"
  ["diablo4marketplace"]="diablo4marketplace.com"
  ["diablo4exploits"]="diablo4exploits.com"
  ["diablo4guides"]="diablo4guides.com"
  ["diablo4tools"]="diablo4tools.com"
  ["diablo4clans"]="diablo4clans.com"
  ["diablo4calculator"]="diablo4calculator.com"
)
for slug in "${!MAP[@]}"; do
  domain="${MAP[$slug]}"
  echo "  $slug -> $domain"
  # Update home/siteurl while still addressable by path
  wp option update home    "https://$domain" --url="https://d4jsp.org/$slug/" || true
  wp option update siteurl "https://$domain" --url="https://d4jsp.org/$slug/" || true
  # Then rewrite blogs table to the new domain
  wp db query "UPDATE ${PFX}blogs SET domain='$domain', path='/' WHERE path='/$slug/'"
done

# --- 8. Run post-install (creates under-construction pages on every site) ---
echo "=== [8/9] Running post-install.sh ==="
cd "$SRC_DIR"
bash "$SRC_DIR/scripts/post-install.sh" || echo "  (post-install reported a non-fatal error)"

# --- 9. Authorize GitHub Actions deploy key ---
echo "=== [9/9] Installing GitHub Actions deploy key ==="
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
touch "$HOME/.ssh/authorized_keys"
chmod 600 "$HOME/.ssh/authorized_keys"
if ! grep -qF "$DEPLOY_PUBKEY" "$HOME/.ssh/authorized_keys"; then
  echo "$DEPLOY_PUBKEY" >> "$HOME/.ssh/authorized_keys"
  echo "  Added deploy key."
else
  echo "  Deploy key already present."
fi

echo ""
echo "==================================================="
echo "  D4JSP-WP REMOTE INSTALL COMPLETE"
echo "==================================================="
echo "Next manual steps in Hostinger panel:"
echo "  1. Add addon domains (each pointed to public_html of d4jsp.org):"
echo "       diablo4mods.com  diablo4marketplace.com  diablo4exploits.com"
echo "       diablo4guides.com  diablo4tools.com  diablo4clans.com"
echo "       diablo4calculator.com"
echo "  2. Enable SSL for each addon domain"
echo "  3. (Optional) Add 301 source domains: d4mods.com, d4marketplace.com"
echo "==================================================="
