#!/bin/bash
set -e
REPO_URL="https://github.com/The-CowKing/D4JSP-WP.git"
SRC_DIR="$HOME/d4jsp-wp-src"
WP_ROOT="$HOME/domains/d4jsp.org/public_html"
DEPLOY_PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObw6XWbbtmCmcfmdW9dv3ttij6CIr0jkutR1CpGX31Z d4jsp-deploy"
export PATH="$HOME/bin:$PATH"

echo "=== [0/9] Environment ==="
echo "HOME=$HOME"
mkdir -p "$HOME/bin" "$WP_ROOT"

echo "=== [1/9] WP-CLI ==="
if ! command -v wp >/dev/null 2>&1; then
  curl -sSL -o "$HOME/bin/wp.phar" https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x "$HOME/bin/wp.phar"; ln -sf "$HOME/bin/wp.phar" "$HOME/bin/wp"
fi
wp --version

echo "=== [2/9] Fetching repo ==="
rm -rf "$SRC_DIR"
git clone --depth 1 "$REPO_URL" "$SRC_DIR"

echo "=== [3/9] Running install.sh ==="
bash "$SRC_DIR/scripts/install.sh"

echo "=== [4/9] sunrise.php ==="
cp "$SRC_DIR/scripts/sunrise.php" "$WP_ROOT/wp-content/sunrise.php"

echo "=== [5/9] theme ==="
mkdir -p "$WP_ROOT/wp-content/themes/d4jsp-dark"
cp -r "$SRC_DIR/theme/d4jsp-dark/." "$WP_ROOT/wp-content/themes/d4jsp-dark/"

echo "=== [6/9] .htaccess ==="
cp "$SRC_DIR/.htaccess" "$WP_ROOT/.htaccess"

echo "=== [7/9] Mapping subsite domains ==="
cd "$WP_ROOT"
PFX=$(wp db prefix)
declare -A MAP=(
  [diablo4mods]=diablo4mods.com
  [diablo4marketplace]=diablo4marketplace.com
  [diablo4exploits]=diablo4exploits.com
  [diablo4guides]=diablo4guides.com
  [diablo4tools]=diablo4tools.com
  [diablo4clans]=diablo4clans.com
  [diablo4calculator]=diablo4calculator.com
)
for slug in "${!MAP[@]}"; do
  domain="${MAP[$slug]}"
  echo "  $slug -> $domain"
  wp option update home    "https://$domain" --url="https://d4jsp.org/$slug/" || true
  wp option update siteurl "https://$domain" --url="https://d4jsp.org/$slug/" || true
  wp db query "UPDATE ${PFX}blogs SET domain='$domain', path='/' WHERE path='/$slug/'"
done

echo "=== [8/9] post-install.sh ==="
cd "$SRC_DIR"
bash "$SRC_DIR/scripts/post-install.sh" || echo "  (post-install non-fatal error)"

echo "=== [9/9] Deploy key ==="
mkdir -p "$HOME/.ssh"; chmod 700 "$HOME/.ssh"
touch "$HOME/.ssh/authorized_keys"; chmod 600 "$HOME/.ssh/authorized_keys"
grep -qF "$DEPLOY_PUBKEY" "$HOME/.ssh/authorized_keys" || echo "$DEPLOY_PUBKEY" >> "$HOME/.ssh/authorized_keys"

echo "=== DONE ==="
