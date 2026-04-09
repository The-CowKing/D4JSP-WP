#!/bin/bash
# =============================================================
# D4JSP WordPress Multisite - Full Install Script
# Run via: bash install.sh from your WordPress root on Hostinger
# =============================================================

set -e

WP_ROOT="/home/u704061244/domains/d4jsp.org/public_html"
DB_NAME="u704061244_d4jsp_wp"
DB_USER="u704061244_adam"
DB_PASS='fcerf22321@224E1X@@#'
DB_HOST="localhost"
ADMIN_EMAIL="adam87lewis@gmail.com"
ADMIN_USER="cowking"
ADMIN_PASS='D4jsp!Cw9k$mGv2Xq7Lp'
SITE_URL="https://d4jsp.org"
SITE_TITLE="D4JSP - Diablo 4 Trading Platform"
# Server info (for reference)
# IP: 82.29.193.20
# Preview URL: lightsalmon-marten-733948.hostingersite.com

echo "=== D4JSP WP Multisite Install ==="
cd "$WP_ROOT"

# --- 1. Download WordPress ---
echo "[1/8] Downloading WordPress..."
wp core download --skip-content --force

# --- 2. Create wp-config.php (single-site first; multisite-convert adds the rest) ---
echo "[2/8] Generating wp-config.php..."
rm -f wp-config.php
wp config create \
  --dbname="$DB_NAME" \
  --dbuser="$DB_USER" \
  --dbpass="$DB_PASS" \
  --dbhost="$DB_HOST" \
  --extra-php <<'PHP'
define('WP_ALLOW_MULTISITE', true);
define('WP_MEMORY_LIMIT', '256M');
define('WP_MAX_MEMORY_LIMIT', '512M');
define('COMPRESS_CSS', true);
define('COMPRESS_SCRIPTS', true);
define('ENFORCE_GZIP', true);
define('DISALLOW_FILE_EDIT', true);
PHP

# --- 3. Install WordPress core (single site) ---
echo "[3/8] Installing WordPress core..."
wp db reset --yes
wp core install \
  --url="$SITE_URL" \
  --title="$SITE_TITLE" \
  --admin_user="$ADMIN_USER" \
  --admin_password="$ADMIN_PASS" \
  --admin_email="$ADMIN_EMAIL" \
  --skip-email

# --- 4. Convert to Multisite (subdirectory) ---
echo "[4/8] Converting to Multisite..."
wp core multisite-convert --title="$SITE_TITLE"

# Place sunrise.php BEFORE enabling SUNRISE constant
cp "$(dirname "$0")/sunrise.php" wp-content/sunrise.php
wp config set SUNRISE on --type=constant
# Force-quote the value (some wp-cli versions write a bareword)
sed -i "s/define( 'SUNRISE', on );/define( 'SUNRISE', 'on' );/" wp-config.php

# --- 5. Create subsites ---
echo "[5/8] Creating subsites..."
declare -A SITES=(
  ["diablo4mods.com"]="Diablo 4 Mods - Tools & Modding Resources"
  ["diablo4marketplace.com"]="Diablo 4 Marketplace - Item Trading & Exchange"
  ["diablo4exploits.com"]="Diablo 4 Exploits - Bugs, Glitches & Cheese"
  ["diablo4guides.com"]="Diablo 4 Guides - Builds, Classes & Leveling"
  ["diablo4tools.com"]="Diablo 4 Tools - Planners, Utilities & Calculators"
  ["diablo4clans.com"]="Diablo 4 Clans - Find Groups & Party Finder"
  ["diablo4calculator.com"]="Diablo 4 Calculator - Damage & Stat Calculator"
)

for domain in "${!SITES[@]}"; do
  title="${SITES[$domain]}"
  slug="${domain%%.*}"
  echo "  Creating: $domain"
  wp site create \
    --slug="$slug" \
    --title="$title" \
    --email="$ADMIN_EMAIL"
done

# --- 6. Install & activate theme on all sites ---
echo "[6/8] Installing D4JSP dark theme..."
wp theme activate d4jsp-dark --url="$SITE_URL"

# Activate on all subsites
wp site list --field=url | while read site_url; do
  wp theme activate d4jsp-dark --url="$site_url"
done

# --- 7. Install essential plugins network-wide ---
echo "[7/8] Installing plugins..."
wp plugin install wordpress-seo --activate-network         # Yoast SEO
wp plugin install redirection --activate-network           # 301 redirects
wp plugin install wp-super-cache --activate-network        # Caching
wp plugin install mercator --activate-network              # Domain mapping (Mercator by Automattic)

# --- 8. Set permalinks ---
echo "[8/8] Configuring permalinks..."
wp site list --field=url | while read site_url; do
  wp rewrite structure '/%postname%/' --url="$site_url"
  wp rewrite flush --url="$site_url"
done

echo ""
echo "=== INSTALL COMPLETE ==="
echo "Next: Add addon domains in Hostinger pointing to $WP_ROOT"
echo "Next: Upload sunrise.php to wp-content/ for domain mapping"
echo "Next: In Network Admin > Sites, set each site's domain"
echo "==============================="
