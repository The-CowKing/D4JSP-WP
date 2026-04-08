<?php
/**
 * sunrise.php - Domain Mapping for D4JSP Multisite
 * Place this file in: wp-content/sunrise.php
 * Requires SUNRISE constant defined in wp-config.php
 *
 * Uses Mercator by Automattic for modern WP multisite domain mapping.
 * After plugin install, map domains in Network Admin > Sites > each site > Domains tab.
 */

// Mercator handles sunrise automatically once installed.
// This file activates the SUNRISE hook.
if ( file_exists( WP_CONTENT_DIR . '/plugins/mercator/mercator.php' ) ) {
    include_once WP_CONTENT_DIR . '/plugins/mercator/mercator.php';
}
