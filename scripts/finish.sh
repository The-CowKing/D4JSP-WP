#!/bin/bash
set -e
WP_ROOT="$HOME/domains/d4jsp.org/public_html"
SRC_DIR="$HOME/d4jsp-wp-src"
DEPLOY_PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObw6XWbbtmCmcfmdW9dv3ttij6CIr0jkutR1CpGX31Z d4jsp-deploy"
ADMIN_EMAIL="adam87lewis@gmail.com"
export PATH="$HOME/bin:$PATH"

cd "$WP_ROOT"

echo "=== refresh repo ==="
rm -rf "$SRC_DIR"
git clone --depth 1 https://github.com/The-CowKing/D4JSP-WP.git "$SRC_DIR"

echo "=== sunrise.php (idempotent) ==="
cp "$SRC_DIR/scripts/sunrise.php" wp-content/sunrise.php

echo "=== create subsites ==="
declare -A SITES=(
  [diablo4mods]="Diablo 4 Mods - Tools & Modding Resources"
  [diablo4marketplace]="Diablo 4 Marketplace - Item Trading & Exchange"
  [diablo4exploits]="Diablo 4 Exploits - Bugs, Glitches & Cheese"
  [diablo4guides]="Diablo 4 Guides - Builds, Classes & Leveling"
  [diablo4tools]="Diablo 4 Tools - Planners, Utilities & Calculators"
  [diablo4clans]="Diablo 4 Clans - Find Groups & Party Finder"
  [diablo4calculator]="Diablo 4 Calculator - Damage & Stat Calculator"
)
for slug in "${!SITES[@]}"; do
  if wp site list --field=path | grep -q "^/${slug}/$"; then
    echo "  exists: $slug"
  else
    echo "  creating: $slug"
    wp site create --slug="$slug" --title="${SITES[$slug]}" --email="$ADMIN_EMAIL"
  fi
done

echo "=== install theme ==="
mkdir -p wp-content/themes/d4jsp-dark
cp -r "$SRC_DIR/theme/d4jsp-dark/." wp-content/themes/d4jsp-dark/
wp theme enable d4jsp-dark --network --activate || true
wp site list --field=url | while read u; do
  wp theme activate d4jsp-dark --url="$u" || true
done

echo "=== install plugins ==="
wp plugin install wordpress-seo --activate-network || true
wp plugin install redirection --activate-network || true
wp plugin install wp-super-cache --activate-network || true
wp plugin install mercator --activate-network || true

echo "=== .htaccess ==="
cp "$SRC_DIR/.htaccess" .htaccess

echo "=== permalinks ==="
wp site list --field=url | while read u; do
  wp rewrite structure '/%postname%/' --url="$u" || true
  wp rewrite flush --url="$u" || true
done

echo "=== map subsite domains ==="
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

echo "=== post-install ==="
cd "$SRC_DIR"
bash "$SRC_DIR/scripts/post-install.sh" || echo "  (post-install non-fatal error)"
cd "$WP_ROOT"

echo "=== deploy key ==="
mkdir -p "$HOME/.ssh"; chmod 700 "$HOME/.ssh"
touch "$HOME/.ssh/authorized_keys"; chmod 600 "$HOME/.ssh/authorized_keys"
grep -qF "$DEPLOY_PUBKEY" "$HOME/.ssh/authorized_keys" || echo "$DEPLOY_PUBKEY" >> "$HOME/.ssh/authorized_keys"

echo "=== final state ==="
wp site list --fields=blog_id,domain,path
echo DONE
