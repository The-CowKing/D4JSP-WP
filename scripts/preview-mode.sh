#!/bin/bash
set -e
WP_ROOT="$HOME/domains/d4jsp.org/public_html"
SRC_DIR="$HOME/d4jsp-wp-src"
PREVIEW="lightsalmon-marten-733948.hostingersite.com"
export PATH="$HOME/bin:$PATH"
cd "$WP_ROOT"

echo "=== backup ==="
cp .htaccess .htaccess.bak.$(date +%s) || true
cp wp-config.php wp-config.php.bak.$(date +%s)

echo "=== refresh repo + deploy clean .htaccess ==="
git -C "$SRC_DIR" fetch --quiet
git -C "$SRC_DIR" reset --hard origin/main --quiet
cp "$SRC_DIR/.htaccess" .htaccess
grep -c "R=301" .htaccess || true

echo "=== set DOMAIN_CURRENT_SITE -> preview host ==="
sed -i "s|define( 'DOMAIN_CURRENT_SITE', '[^']*' );|define( 'DOMAIN_CURRENT_SITE', '${PREVIEW}' );|" wp-config.php
grep DOMAIN_CURRENT_SITE wp-config.php

echo "=== rewrite wp_site / wp_blogs to preview host ==="
PFX=$(wp db prefix)
wp db query "UPDATE ${PFX}site SET domain='${PREVIEW}', path='/' WHERE id=1"
wp db query "UPDATE ${PFX}blogs SET domain='${PREVIEW}', path='/' WHERE blog_id=1"

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
  wp db query "UPDATE ${PFX}blogs SET domain='${PREVIEW}', path='/${slug}/' WHERE blog_id=${id}"
done

echo "=== home/siteurl per blog (HTTP) ==="
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

echo "=== final ==="
wp site list --fields=blog_id,domain,path,url
