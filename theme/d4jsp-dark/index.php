<?php
/**
 * Default template - shows under construction for all pages
 */
get_header();
?>

<main id="main" class="page-construction" role="main">
  <div class="construction-inner">
    <?php if (have_posts()) : while (have_posts()) : the_post();
      the_content();
    endwhile; else : ?>
      <div class="construction-rune">⚔</div>
      <div class="construction-eyebrow">Diablo 4 Network</div>
      <h1 class="construction-title">D4JSP <span>Trading Network</span></h1>
      <div class="construction-divider"></div>
      <p class="construction-desc">
        The D4JSP network is coming online. The realm is being forged.
      </p>
      <a href="https://d4jsp.org" class="construction-cta">Enter D4JSP &rarr;</a>
    <?php endif; ?>
  </div>
</main>

<?php get_footer(); ?>
