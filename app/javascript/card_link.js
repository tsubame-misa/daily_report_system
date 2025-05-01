document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll('.report-card-link').forEach(function(card) {
    card.addEventListener('click', function(e) {
      // ボタンやリンクがクリックされた場合は遷移しない
      if (
        e.target.closest('a') ||
        e.target.closest('button') ||
        e.target.tagName === 'A' ||
        e.target.tagName === 'BUTTON' ||
        e.target.closest('form')
      ) {
        return;
      }
      const href = card.getAttribute('data-href');
      if (href) {
        window.location.href = href;
      }
    });
  });
});
