<footer class="site-footer" role="contentinfo">
  <div class="container">
    <p>
      &copy; <?php echo date('Y'); ?> <a href="https://d4jsp.org">D4JSP Network</a> &mdash; 
      Part of the Diablo 4 Trading &amp; Resource Network. Not affiliated with Blizzard Entertainment.
    </p>
  </div>
</footer>

<script>
// Mobile nav toggle
const toggle = document.querySelector('.nav-toggle');
const nav    = document.querySelector('.site-nav');
if (toggle && nav) {
  toggle.addEventListener('click', () => {
    const open = toggle.getAttribute('aria-expanded') === 'true';
    toggle.setAttribute('aria-expanded', String(!open));
    nav.style.display = open ? '' : 'flex';
    nav.style.flexDirection = 'column';
    nav.style.position = 'absolute';
    nav.style.top = '64px';
    nav.style.left = '0';
    nav.style.right = '0';
    nav.style.background = 'rgba(8,6,8,0.98)';
    nav.style.padding = '1rem 1.5rem';
    nav.style.borderBottom = '1px solid #2a2535';
  });
}
</script>

<?php wp_footer(); ?>
</body>
</html>
