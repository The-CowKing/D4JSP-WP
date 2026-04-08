#!/bin/bash
# =============================================================
# D4JSP - Post-Install Setup
# Run AFTER install.sh completes
# Sets up under-construction pages on every subsite
# =============================================================

set -e

SITES=(
  "https://d4jsp.org"
  "https://diablo4mods.com"
  "https://diablo4marketplace.com"
  "https://diablo4exploits.com"
  "https://diablo4guides.com"
  "https://diablo4tools.com"
  "https://diablo4clans.com"
  "https://diablo4calculator.com"
)

SITE_TITLES=(
  "D4JSP - Diablo 4 Trading Platform"
  "Diablo 4 Mods"
  "Diablo 4 Marketplace"
  "Diablo 4 Exploits"
  "Diablo 4 Guides"
  "Diablo 4 Tools"
  "Diablo 4 Clans"
  "Diablo 4 Calculator"
)

echo "=== D4JSP Post-Install Setup ==="

for i in "${!SITES[@]}"; do
  url="${SITES[$i]}"
  title="${SITE_TITLES[$i]}"

  echo ""
  echo "--- Setting up: $url ---"

  # Set tagline
  wp option update blogdescription "Diablo 4 Network - Coming Soon" --url="$url"

  # Create front-page using Under Construction template
  PAGE_ID=$(wp post create \
    --post_type=page \
    --post_title="$title" \
    --post_status=publish \
    --post_content="<!-- Under Construction -->" \
    --page_template="page-construction.php" \
    --url="$url" \
    --porcelain)

  echo "  Created page ID: $PAGE_ID"

  # Set as static front page
  wp option update show_on_front page --url="$url"
  wp option update page_on_front "$PAGE_ID" --url="$url"

  # SEO settings via Yoast
  wp option update wpseo_titles '{"title-home-wpseo":"%%sitename%% - Diablo 4 Network"}' --url="$url" --format=json || true

  # Disable comments on all posts/pages
  wp option update default_comment_status closed --url="$url"
  wp option update default_ping_status closed --url="$url"

  # Set timezone
  wp option update timezone_string "America/New_York" --url="$url"
  wp option update date_format "F j, Y" --url="$url"

  # Delete sample page/post
  wp post delete 1 --force --url="$url" 2>/dev/null || true
  wp post delete 2 --force --url="$url" 2>/dev/null || true

  echo "  ✓ Done: $url"
done

# Upload sunrise.php
echo ""
echo "--- Copying sunrise.php to wp-content ---"
cp sunrise.php "$(wp eval 'echo WP_CONTENT_DIR;' --url='https://d4jsp.org')/sunrise.php"
echo "  ✓ sunrise.php installed"

echo ""
echo "=== POST-INSTALL COMPLETE ==="
echo ""
echo "Next steps:"
echo "1. Add all domains as Addon Domains in Hostinger pointing to same WordPress root"
echo "2. In Network Admin > Sites - set each site's domain to the mapped domain"
echo "3. Activate Mercator domain mapping in Network Admin > Plugins"
echo "4. Upload og-default.png to /wp-content/themes/d4jsp-dark/assets/"
echo "5. Set up SSL for each addon domain in Hostinger"
echo "================================================"
