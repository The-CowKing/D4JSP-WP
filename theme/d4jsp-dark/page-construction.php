<?php
/**
 * Template Name: Under Construction
 * Template Post Type: page
 */

$host   = strtolower(preg_replace('/^www\./', '', $_SERVER['HTTP_HOST'] ?? 'd4jsp.org'));
$config = d4jsp_get_site_config();
$sites  = d4jsp_network_sites_list();

// Site-specific copy
$copy = [
    'd4jsp.org' => [
        'rune'    => '⚔',
        'eyebrow' => 'The Premier Platform',
        'title'   => 'Diablo 4',
        'sub'     => 'Trading Platform',
        'desc'    => 'D4JSP is the most trusted Diablo 4 player-to-player trading platform. Real-time listings, verified traders, and a reputation system built for serious players.',
        'cta'     => 'Enter the Trade Hub',
        'cta_url' => 'https://d4jsp.org/app',
    ],
    'diablo4mods.com' => [
        'rune'    => '🔧',
        'eyebrow' => 'Modding Resources',
        'title'   => 'Diablo 4',
        'sub'     => 'Mods & Tools',
        'desc'    => 'Your hub for Diablo 4 mods, modding tools, and community resources. Customize, enhance, and extend your D4 experience.',
        'cta'     => 'Go to D4JSP',
        'cta_url' => 'https://d4jsp.org',
    ],
    'diablo4marketplace.com' => [
        'rune'    => '💰',
        'eyebrow' => 'Item Trading',
        'title'   => 'Diablo 4',
        'sub'     => 'Marketplace',
        'desc'    => 'Buy and sell Diablo 4 items, gold, and services in the safest D4 marketplace. Powered by D4JSP — the trusted name in Diablo trading.',
        'cta'     => 'Trade on D4JSP',
        'cta_url' => 'https://d4jsp.org',
    ],
    'diablo4exploits.com' => [
        'rune'    => '⚡',
        'eyebrow' => 'Bugs & Cheese',
        'title'   => 'Diablo 4',
        'sub'     => 'Exploits & Glitches',
        'desc'    => 'Stay ahead with the latest Diablo 4 exploits, bugs, glitches, and cheese strategies. Updated daily by the D4 community.',
        'cta'     => 'Visit D4JSP',
        'cta_url' => 'https://d4jsp.org',
    ],
    'diablo4guides.com' => [
        'rune'    => '📖',
        'eyebrow' => 'Builds & Strategy',
        'title'   => 'Diablo 4',
        'sub'     => 'Guides & Builds',
        'desc'    => 'Expert class guides, top-tier builds, and leveling strategies for every D4 season. Master every aspect of Diablo 4.',
        'cta'     => 'Visit D4JSP',
        'cta_url' => 'https://d4jsp.org',
    ],
    'diablo4tools.com' => [
        'rune'    => '⚙',
        'eyebrow' => 'Planners & Utils',
        'title'   => 'Diablo 4',
        'sub'     => 'Tools & Planners',
        'desc'    => 'Free Diablo 4 online tools — build planners, skill trees, item databases, and calculators to optimize every character.',
        'cta'     => 'Visit D4JSP',
        'cta_url' => 'https://d4jsp.org',
    ],
    'diablo4clans.com' => [
        'rune'    => '🛡',
        'eyebrow' => 'Guilds & Groups',
        'title'   => 'Diablo 4',
        'sub'     => 'Clans & Community',
        'desc'    => 'Find your clan in Diablo 4. Browse guilds, use the party finder, and connect with players for dungeons, world bosses, and PvP.',
        'cta'     => 'Visit D4JSP',
        'cta_url' => 'https://d4jsp.org',
    ],
    'diablo4calculator.com' => [
        'rune'    => '🧮',
        'eyebrow' => 'Stats & DPS',
        'title'   => 'Diablo 4',
        'sub'     => 'Calculator',
        'desc'    => 'Optimize your Diablo 4 build with our damage calculator. Compute DPS, crit values, resistances, and find the perfect stat rolls.',
        'cta'     => 'Visit D4JSP',
        'cta_url' => 'https://d4jsp.org',
    ],
];

$c = $copy[$host] ?? $copy['d4jsp.org'];

get_header();
?>

<main id="main" class="page-construction" role="main">
  <div class="construction-inner">

    <div class="construction-rune animate-fade-up animate-delay-1">
      <?php echo $c['rune']; ?>
    </div>

    <div class="construction-eyebrow animate-fade-up animate-delay-2">
      <?php echo esc_html($c['eyebrow']); ?>
    </div>

    <h1 class="construction-title animate-fade-up animate-delay-3">
      <?php echo esc_html($c['title']); ?>
      <span><?php echo esc_html($c['sub']); ?></span>
    </h1>

    <div class="construction-divider animate-fade-up animate-delay-3"></div>

    <p class="construction-desc animate-fade-up animate-delay-4">
      <?php echo esc_html($c['desc']); ?>
      <br><br>
      <strong style="color: var(--gold); font-family: var(--font-label); letter-spacing: 0.1em; font-size: 0.85rem;">
        COMING SOON — FORGING THE REALM
      </strong>
    </p>

    <a href="<?php echo esc_url($c['cta_url']); ?>" class="construction-cta animate-fade-up animate-delay-5">
      <?php echo esc_html($c['cta']); ?> &rarr;
    </a>

    <!-- D4JSP Network Links -->
    <div class="construction-network animate-fade-up animate-delay-5">
      <span class="label">D4JSP Network</span>
      <div class="network-grid">
        <?php foreach ($sites as $domain => $label) :
          $current = ($domain === $host); ?>
          <a href="https://<?php echo esc_attr($domain); ?>"
             class="network-item<?php echo $current ? ' active' : ''; ?>"
             <?php echo $current ? 'aria-current="page"' : ''; ?>>
            <span class="dot" aria-hidden="true"></span>
            <?php echo esc_html($label); ?>
          </a>
        <?php endforeach; ?>
      </div>
    </div>

  </div>
</main>

<?php get_footer(); ?>
