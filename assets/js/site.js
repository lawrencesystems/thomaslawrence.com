// Copy buttons for the speaker bios. Falls back to selecting the text.
document.querySelectorAll('button.copy').forEach(function (btn) {
  btn.addEventListener('click', function () {
    var el = document.getElementById(btn.dataset.copy);
    var text = Array.from(el.querySelectorAll('p')).map(function (p) { return p.textContent.trim(); }).join('\n\n');
    var done = function () {
      btn.textContent = 'Copied';
      btn.classList.add('is-done');
      setTimeout(function () { btn.textContent = 'Copy'; btn.classList.remove('is-done'); }, 2000);
    };
    var select = function () {
      var range = document.createRange();
      range.selectNodeContents(el);
      var sel = window.getSelection();
      sel.removeAllRanges();
      sel.addRange(range);
      btn.textContent = 'Selected';
    };
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text).then(done, select);
    } else {
      select();
    }
  });
});
