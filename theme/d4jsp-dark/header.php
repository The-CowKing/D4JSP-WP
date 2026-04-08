<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
  <meta charset="<?php bloginfo('charset'); ?>">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
  <?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
<?php wp_body_open(); ?>

<header class="site-header" role="banner">
  <div class="container">
    <a href="<?php echo esc_url(home_url('/')); ?>" class="site-logo" aria-label="<?php bloginfo('name'); ?>">
      <span class="logo-dot" aria-hidden="true"></span>
      <?php bloginfo('name'); ?>
    </a>

    <nav class="site-nav" role="navigation" aria-label="Primary">
      <?php
      wp_nav_menu([
        'theme_location' => 'primary',
        'container'      => false,
        'depth'          => 1,
        'fallback_cb'    => false,
      ]);
      ?>
      <a href="https://d4jsp.org" class="nav-cta" <?php if (strpos(home_url(), 'd4jsp.org') === false): ?>target="_blank" rel="noopener"<?php endif; ?>>
        Trade Now
      </a>
    </nav>

    <button class="nav-toggle" aria-label="Toggle menu" aria-expanded="false">☰</button>
  </div>
</header>
