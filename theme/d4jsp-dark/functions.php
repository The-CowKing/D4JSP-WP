<?php
/**
 * D4JSP Dark Theme - functions.php
 * Gothic medieval dark theme for the D4JSP Diablo 4 network.
 */

// =====================================================
// PER-SITE SEO CONFIGURATION
// =====================================================
define('D4JSP_NETWORK_SITES', [
    'd4jsp.org' => [
        'title'       => 'D4JSP - Diablo 4 Trading Platform | Buy & Sell D4 Items',
        'description' => 'The premier Diablo 4 trading platform. Buy, sell and trade D4 items safely. Verified traders, reputation system, and real-time listings.',
        'keywords'    => 'Diablo 4 trading, D4 items, buy Diablo 4 items, sell D4 gold, Diablo 4 marketplace, D4 trade',
        'og_type'     => 'website',
        'schema_type' => 'WebApplication',
        'schema_desc' => 'D4JSP is the leading Diablo 4 player-to-player trading platform with verified sellers, real-time listings, and reputation scoring.',
        'color'       => '#D4AF37',
    ],
    'diablo4mods.com' => [
        'title'       => 'Diablo 4 Mods - Best D4 Mods, Tools & Modding Resources',
        'description' => 'Discover the best Diablo 4 mods, modding tools, and community resources. Enhance your D4 experience with top-rated mods.',
        'keywords'    => 'Diablo 4 mods, D4 modding, Diablo 4 mod tools, D4 mod resources, Diablo IV mods',
        'og_type'     => 'website',
        'schema_type' => 'WebSite',
        'schema_desc' => 'Diablo4Mods.com — the hub for Diablo 4 mods, modding guides, and community tools.',
        'color'       => '#D4AF37',
    ],
    'diablo4marketplace.com' => [
        'title'       => 'Diablo 4 Marketplace - Buy & Sell D4 Items & Gold',
        'description' => 'The Diablo 4 marketplace for buying and selling items, gold, and services. Safe trades, trusted sellers, and the best prices.',
        'keywords'    => 'Diablo 4 marketplace, buy D4 items, sell Diablo 4 gold, D4 item shop, Diablo IV marketplace',
        'og_type'     => 'website',
        'schema_type' => 'WebSite',
        'schema_desc' => 'Diablo4Marketplace.com — buy and sell Diablo 4 items, gold, and services in a trusted player marketplace.',
        'color'       => '#D4AF37',
    ],
    'diablo4exploits.com' => [
        'title'       => 'Diablo 4 Exploits - Bugs, Glitches & Cheese Strategies',
        'description' => 'Latest Diablo 4 exploits, bugs, glitches, and cheese strategies. Stay ahead with the newest D4 tricks and shortcuts.',
        'keywords'    => 'Diablo 4 exploits, D4 glitches, Diablo 4 bugs, D4 cheese, Diablo 4 tricks, D4 shortcuts',
        'og_type'     => 'website',
        'schema_type' => 'WebSite',
        'schema_desc' => 'Diablo4Exploits.com — discover Diablo 4 exploits, glitches, bugs, and cheese strategies updated regularly.',
        'color'       => '#D4AF37',
    ],
    'diablo4guides.com' => [
        'title'       => 'Diablo 4 Guides - Builds, Class Guides & Leveling Tips',
        'description' => 'Expert Diablo 4 guides covering all classes, top tier builds, leveling strategies, and endgame content. Master D4 with our guides.',
        'keywords'    => 'Diablo 4 guides, D4 builds, Diablo 4 class guide, D4 leveling guide, Diablo IV tier list, best D4 build',
        'og_type'     => 'website',
        'schema_type' => 'WebSite',
        'schema_desc' => 'Diablo4Guides.com — comprehensive Diablo 4 build guides, class breakdowns, leveling tips, and endgame strategies.',
        'color'       => '#D4AF37',
    ],
    'diablo4tools.com' => [
        'title'       => 'Diablo 4 Tools - Planners, Utilities & Online Tools',
        'description' => 'Free Diablo 4 online tools including build planners, skill calculators, item databases, and gameplay utilities.',
        'keywords'    => 'Diablo 4 tools, D4 planner, Diablo 4 build planner, D4 utilities, Diablo IV tools, D4 skill tree',
        'og_type'     => 'website',
        'schema_type' => 'WebSite',
        'schema_desc' => 'Diablo4Tools.com — free online Diablo 4 tools: build planners, item databases, skill calculators, and more.',
        'color'       => '#D4AF37',
    ],
    'diablo4clans.com' => [
        'title'       => 'Diablo 4 Clans - Find Clans, Groups & Party Finder',
        'description' => 'Find and join Diablo 4 clans, guilds, and groups. Use the D4 party finder to connect with players for dungeons, bosses, and PvP.',
        'keywords'    => 'Diablo 4 clans, D4 guilds, Diablo 4 party finder, D4 group finder, join Diablo IV clan',
        'og_type'     => 'website',
        'schema_type' => 'WebSite',
        'schema_desc' => 'Diablo4Clans.com — find Diablo 4 clans, guilds, and groups. Connect with other players for all D4 content.',
        'color'       => '#D4AF37',
    ],
    'diablo4calculator.com' => [
        'title'       => 'Diablo 4 Calculator - Damage, Stats & DPS Calculator',
        'description' => 'Free Diablo 4 damage calculator and stat optimizer. Calculate DPS, crit, resistances, and optimize your D4 build.',
        'keywords'    => 'Diablo 4 calculator, D4 damage calculator, Diablo 4 DPS calculator, D4 stat calculator, Diablo IV calc',
        'og_type'     => 'website',
        'schema_type' => 'WebSite',
        'schema_desc' => 'Diablo4Calculator.com — free Diablo 4 damage, DPS, and stat calculator to optimize your builds.',
        'color'       => '#D4AF37',
    ],
]);

// =====================================================
// THEME SETUP
// =====================================================
function d4jsp_setup() {
    add_theme_support('title-tag');
    add_theme_support('post-thumbnails');
    add_theme_support('html5', ['search-form', 'comment-form', 'gallery', 'caption', 'navigation-widgets']);
    add_theme_support('custom-logo');
    add_theme_support('automatic-feed-links');

    register_nav_menus([
        'primary' => __('Primary Navigation', 'd4jsp-dark'),
        'footer'  => __('Footer Navigation', 'd4jsp-dark'),
    ]);
}
add_action('after_setup_theme', 'd4jsp_setup');

// =====================================================
// ENQUEUE ASSETS
// =====================================================
function d4jsp_enqueue_assets() {
    // Google Fonts
    wp_enqueue_style(
        'd4jsp-fonts',
        'https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700&family=Barlow+Condensed:wght@300;400;500;600&family=Barlow:wght@300;400;500&display=swap',
        [],
        null
    );

    // Theme stylesheet
    wp_enqueue_style(
        'd4jsp-dark',
        get_stylesheet_uri(),
        ['d4jsp-fonts'],
        wp_get_theme()->get('Version')
    );
}
add_action('wp_enqueue_scripts', 'd4jsp_enqueue_assets');

// =====================================================
// DISABLE GUTENBERG BLOCK STYLES (not needed)
// =====================================================
function d4jsp_dequeue_block_styles() {
    wp_dequeue_style('wp-block-library');
    wp_dequeue_style('wp-block-library-theme');
    wp_dequeue_style('wc-blocks-style');
    wp_dequeue_style('global-styles');
}
add_action('wp_enqueue_scripts', 'd4jsp_dequeue_block_styles', 100);

// =====================================================
// SEO - GET CURRENT SITE CONFIG
// =====================================================
function d4jsp_get_site_config() {
    $host = strtolower($_SERVER['HTTP_HOST'] ?? '');
    $host = preg_replace('/^www\./', '', $host);
    $sites = D4JSP_NETWORK_SITES;
    return $sites[$host] ?? $sites['d4jsp.org'];
}

// =====================================================
// SEO - DOCUMENT TITLE
// =====================================================
function d4jsp_document_title_parts($title) {
    if (is_front_page() || is_home()) {
        $config = d4jsp_get_site_config();
        $title['title'] = $config['title'];
        unset($title['tagline'], $title['site']);
    }
    return $title;
}
add_filter('document_title_parts', 'd4jsp_document_title_parts');

// =====================================================
// SEO - META TAGS (description, keywords, robots,
//               og:*, twitter:*, JSON-LD schema)
// =====================================================
function d4jsp_meta_tags() {
    $config = d4jsp_get_site_config();
    $host   = strtolower(preg_replace('/^www\./', '', $_SERVER['HTTP_HOST'] ?? 'd4jsp.org'));
    $url    = 'https://' . $host . $_SERVER['REQUEST_URI'];

    if (is_front_page() || is_home()) {
        $page_title = $config['title'];
        $page_desc  = $config['description'];
        $canonical  = 'https://' . $host . '/';
    } else {
        global $post;
        $page_title = get_the_title() . ' | ' . get_bloginfo('name');
        $page_desc  = $config['description'];
        $canonical  = get_permalink($post->ID ?? 0) ?: $url;
    }

    $page_title = esc_attr($page_title);
    $page_desc  = esc_attr($page_desc);
    $keywords   = esc_attr($config['keywords']);
    $canonical  = esc_url($canonical);
    $color      = esc_attr($config['color']);
    $og_image   = esc_url(get_template_directory_uri() . '/assets/og-default.png');
    ?>

    <!-- SEO Core -->
    <meta name="description" content="<?php echo $page_desc; ?>">
    <meta name="keywords" content="<?php echo $keywords; ?>">
    <meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1">
    <link rel="canonical" href="<?php echo $canonical; ?>">

    <!-- Theme -->
    <meta name="theme-color" content="<?php echo $color; ?>">
    <meta name="color-scheme" content="dark">
    <meta name="msapplication-TileColor" content="<?php echo $color; ?>">

    <!-- Open Graph -->
    <meta property="og:type" content="<?php echo esc_attr($config['og_type']); ?>">
    <meta property="og:title" content="<?php echo $page_title; ?>">
    <meta property="og:description" content="<?php echo $page_desc; ?>">
    <meta property="og:url" content="<?php echo $canonical; ?>">
    <meta property="og:site_name" content="<?php echo esc_attr(get_bloginfo('name')); ?>">
    <meta property="og:image" content="<?php echo $og_image; ?>">
    <meta property="og:image:width" content="1200">
    <meta property="og:image:height" content="630">
    <meta property="og:image:alt" content="<?php echo esc_attr(get_bloginfo('name')); ?> - Diablo 4 Network">
    <meta property="og:locale" content="en_US">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="<?php echo $page_title; ?>">
    <meta name="twitter:description" content="<?php echo $page_desc; ?>">
    <meta name="twitter:image" content="<?php echo $og_image; ?>">
    <meta name="twitter:site" content="@D4JSP">

    <!-- JSON-LD Schema -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "<?php echo esc_js($config['schema_type']); ?>",
      "name": "<?php echo esc_js(get_bloginfo('name')); ?>",
      "description": "<?php echo esc_js($config['schema_desc']); ?>",
      "url": "<?php echo esc_js('https://' . $host . '/'); ?>",
      "publisher": {
        "@type": "Organization",
        "name": "D4JSP Network",
        "url": "https://d4jsp.org",
        "logo": {
          "@type": "ImageObject",
          "url": "<?php echo esc_js(get_template_directory_uri() . '/assets/logo.png'); ?>"
        }
      },
      "potentialAction": {
        "@type": "SearchAction",
        "target": {
          "@type": "EntryPoint",
          "urlTemplate": "https://d4jsp.org/?s={search_term_string}"
        },
        "query-input": "required name=search_term_string"
      }
    }
    </script>

    <?php
}
add_action('wp_head', 'd4jsp_meta_tags', 1);

// Remove WP default generator tag (security)
remove_action('wp_head', 'wp_generator');
remove_action('wp_head', 'wlwmanifest_link');
remove_action('wp_head', 'rsd_link');
remove_action('wp_head', 'wp_shortlink_wp_head');

// =====================================================
// NETWORK SITES HELPER (for under-construction pages)
// =====================================================
function d4jsp_network_sites_list() {
    return [
        'd4jsp.org'               => 'D4JSP Trading',
        'diablo4mods.com'         => 'D4 Mods',
        'diablo4marketplace.com'  => 'D4 Marketplace',
        'diablo4exploits.com'     => 'D4 Exploits',
        'diablo4guides.com'       => 'D4 Guides',
        'diablo4tools.com'        => 'D4 Tools',
        'diablo4clans.com'        => 'D4 Clans',
        'diablo4calculator.com'   => 'D4 Calculator',
    ];
}
