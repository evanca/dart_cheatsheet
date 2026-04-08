/**
 * wallpaper.js
 * Generates a 4K (3840×2160) desktop wallpaper from cheatsheet cards.
 * Layout: U-shape — top rows, left/right columns, empty center.
 */
(function () {
  'use strict';

  const W = 3840, H = 2160;
  const GAP = 14, PAD = 28;
  const TOP_COUNT = 10; // 2 rows × 5 columns

  function addStyles() {
    if (document.getElementById('wp-css')) return;
    const s = document.createElement('style');
    s.id = 'wp-css';
    s.textContent = `
      #wp-root {
        position: absolute; left: -10000px; top: 0;
        width: ${W}px; height: ${H}px; padding: ${PAD}px;
        display: grid;
        grid-template-areas: "top top top" "left center right";
        grid-template-columns: 1fr 2.8fr 1fr;
        grid-template-rows: auto 1fr;
        gap: ${GAP}px; overflow: hidden;
        font-family: 'Poppins', -apple-system, sans-serif;
      }
      #wp-root .wp-top    { grid-area: top;    display: grid; grid-template-columns: repeat(5,1fr); gap: ${GAP}px; align-items: start; }
      #wp-root .wp-left   { grid-area: left;   display: grid; grid-auto-rows: 1fr; gap: ${GAP}px; }
      #wp-root .wp-mid    { grid-area: center; }
      #wp-root .wp-right  { grid-area: right;  display: grid; grid-auto-rows: 1fr; gap: ${GAP}px; }

      #wp-root .card {
        margin-bottom: 0 !important;
        transform: none !important;
        box-shadow: 0 1px 3px rgba(0,0,0,.1) !important;
        padding: 16px !important;
        border-radius: 8px !important;
        font-size: 13px !important;
      }
      #wp-root .card h2         { font-size: 16px !important; margin-bottom: 8px !important; }
      #wp-root .card h2::before { width: 4px !important; height: 14px !important; margin-right: 6px !important; }
      #wp-root .subtitle        { font-size: 11px !important; margin-bottom: 6px !important; }
      #wp-root .subtitle code   { font-size: 11px !important; }
      #wp-root .code-block      { padding: 10px 12px !important; border-radius: 6px !important; }
      #wp-root .code-block pre  { font-size: 12.5px !important; line-height: 1.35 !important; }
    `;
    document.head.appendChild(s);
  }

  function build() {
    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    const root = document.createElement('div');
    root.id = 'wp-root';
    root.style.background = isDark
      ? 'linear-gradient(160deg, #0f172a, #1e293b 50%, #0f172a)'
      : 'linear-gradient(160deg, #f0f4f8, #e2e8f0 50%, #f0f4f8)';

    const areas = {};
    ['top', 'left', 'mid', 'right'].forEach(a => {
      const d = document.createElement('div');
      d.className = 'wp-' + a;
      root.appendChild(d);
      areas[a] = d;
    });

    const cards = Array.from(document.querySelectorAll('.grid-container .card'));
    const split = Math.ceil((cards.length - TOP_COUNT) / 2);

    cards.slice(0, TOP_COUNT).forEach(c => areas.top.appendChild(c.cloneNode(true)));
    cards.slice(TOP_COUNT, TOP_COUNT + split).forEach(c => areas.left.appendChild(c.cloneNode(true)));
    cards.slice(TOP_COUNT + split).forEach(c => areas.right.appendChild(c.cloneNode(true)));

    return root;
  }

  window.generateWallpaper = async function () {
    const btn = document.getElementById('wallpaper-btn');
    const orig = btn.textContent;
    btn.textContent = 'Generating…';
    btn.disabled = true;

    addStyles();
    const root = build();
    document.body.appendChild(root);

    try {
      await document.fonts.ready;
      await new Promise(r => setTimeout(r, 300));

      const canvas = await html2canvas(root, {
        width: W, height: H, scale: 1,
        useCORS: true, logging: false, backgroundColor: null,
      });

      canvas.toBlob(async blob => {
        try {
          if (window.showSaveFilePicker) {
            const handle = await window.showSaveFilePicker({
              suggestedName: 'dart-cheatsheet-wallpaper.png',
              types: [{
                description: 'PNG Image',
                accept: { 'image/png': ['.png'] },
              }],
            });
            const writable = await handle.createWritable();
            await writable.write(blob);
            await writable.close();
          } else {
            const a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = 'dart-cheatsheet-wallpaper.png';
            a.click();
            URL.revokeObjectURL(a.href);
          }
        } catch (err) {
          if (err.name !== 'AbortError') {
            console.error('Save failed:', err);
            alert('Failed to save wallpaper.');
          }
        }
      }, 'image/png');
    } catch (e) {
      console.error('Wallpaper failed:', e);
      alert('Failed to generate wallpaper.');
    } finally {
      root.remove();
      btn.textContent = orig;
      btn.disabled = false;
    }
  };
})();
