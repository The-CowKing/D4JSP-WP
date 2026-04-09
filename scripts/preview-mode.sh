#!/bin/bash
set -e
WP_ROOT="$HOME/domains/d4jsp.org/public_html"
SRC_DIR="$HOME/d4jsp-wp-src"
PREVIEW="lightsalmon-marten-733948.hostingersite.com"
export PATH="$HOME/bin:$PATH"
cd "$WP_ROOT"

echo "=== refresh .htaccess from repo ==="
git -C "$SRC_DIR" fetch --quiet
git -C "$SRC_DIR" reset --hard origin/main --quiet
cp "$SRC_DIR/.htaccess" .htaccess

echo "=== restore DOMAIN_CURRENT_SITE -> d4jsp.org temporarily ==="
sed -i "s|define( 'DOMAIN_CURRENT_SITE', '[^']*' );|define( 'DOMAIN_CURRENT_SITE', 'd4jsp.org' );|" wp-config.php

echo "=== rewrite wp_site / wp_blogs to preview host ==="
PFX=$(wp db prefix --url="https://d4jsp.org/")
echo "PFX=$PFX"
wp db query "UPDATE ${PFX}site SET domain='${PREVIEW}', path='/' WHERE id=1" --url="https://d4jsp.org/"
wp db query "UPDATE ${PFX}blogs SET domain='${PREVIEW}', path='/' WHERE blog_id=1" --url="https://d4jsp.org/"

declare -A SLUGS=(
  [2]=diablo4marketplace
  [3]=diablo4mods
  [4]=diablo4exploits
  [5]=diablo4clans
  [6]=diablo4calculator
  [7]=diablo4guides
  [8]=diablo4tools
)
for id in "${!SLUGS[@]}"; do
  slug="${SLUGS[$id]}"
  wp db query "UPDATE ${PFX}blogs SET domain='${PREVIEW}', path='/${slug}/' WHERE blog_id=${id}" --url="https://d4jsp.org/"
done

echo "=== now flip DOMAIN_CURRENT_SITE to preview host ==="
sed -i "s|define( 'DOMAIN_CURRENT_SITE', 'd4jsp.org' );|define( 'DOMAIN_CURRENT_SITE', '${PREVIEW}' );|" wp-config.php
grep DOMAIN_CURRENT_SITE wp-config.php

echo "=== home/siteurl per blog (HTTP preview) ==="
wp option update home    "http://${PREVIEW}" --url="http://${PREVIEW}/"
wp option update siteurl "http://${PREVIEW}" --url="http://${PREVIEW}/"
for id in "${!SLUGS[@]}"; do
  slug="${SLUGS[$id]}"
  url="http://${PREVIEW}/${slug}/"
  wp option update home    "http://${PREVIEW}/${slug}" --url="$url"
  wp option update siteurl "http://${PREVIEW}/${slug}" --url="$url"
done

echo "=== flush rewrites ==="
wp site list --field=url | while read u; do
  wp rewrite flush --url="$u" || true
done

echo "=== final state ==="
wp site list --fields=blog_id,domain,path,url
