#!/bin/bash
set -e
WP_ROOT="$HOME/domains/d4jsp.org/public_html"
SRC_DIR="$HOME/d4jsp-wp-src"
export PATH="$HOME/bin:$PATH"
cd "$WP_ROOT"

echo "=== theme list (network) ==="
wp theme list

echo "=== activate d4jsp-dark per site ==="
wp site list --field=url | while read u; do
  echo "  $u"
  wp theme activate d4jsp-dark --url="$u" 2>&1 || true
done

echo "=== run post-install from WP_ROOT ==="
bash "$SRC_DIR/scripts/post-install.sh"

echo "=== final ==="
wp site list --fields=blog_id,domain,path,url
ls .htaccess wp-content/sunrise.php wp-content/themes/d4jsp-dark/style.css
