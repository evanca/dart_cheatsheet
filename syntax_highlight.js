/**
 * syntax_highlight.js
 * Post-processes code blocks to add two visual cues:
 *  1. `.property` (no trailing parens) → bold
 *  2. `()` (empty call parens) → subtle yellow background
 */
(function () {
  'use strict';

  // Don't process text inside these span types (already styled)
  const SKIP_CLASSES = ['string', 'comment'];

  function isInsideSkippedSpan(node, codeRoot) {
    let el = node.parentElement;
    while (el && el !== codeRoot) {
      if (SKIP_CLASSES.some(c => el.classList.contains(c))) return true;
      el = el.parentElement;
    }
    return false;
  }

  // \b after identifier prevents backtracking: .filled( can't shrink to .fille
  const PATTERN = /(\(\)(?!\s*=>))|\.([a-zA-Z_$][a-zA-Z0-9_$]*)\b(?!\s*\()/g;

  function processTextNode(textNode) {
    const text = textNode.textContent;
    PATTERN.lastIndex = 0;

    let match;
    let lastIndex = 0;
    const parts = [];

    while ((match = PATTERN.exec(text)) !== null) {
      if (match.index > lastIndex) {
        parts.push(document.createTextNode(text.slice(lastIndex, match.index)));
      }

      if (match[1]) {
        // Empty parens `()` → yellow bg
        const span = document.createElement('span');
        span.className = 'call-parens';
        span.textContent = '()';
        parts.push(span);
      } else if (match[2]) {
        // `.property` → dot stays plain, name becomes bold
        parts.push(document.createTextNode('.'));
        const strong = document.createElement('strong');
        strong.className = 'prop-access';
        strong.textContent = match[2];
        parts.push(strong);
      }

      lastIndex = match.index + match[0].length;
    }

    if (parts.length === 0) return;

    if (lastIndex < text.length) {
      parts.push(document.createTextNode(text.slice(lastIndex)));
    }

    const fragment = document.createDocumentFragment();
    parts.forEach(p => fragment.appendChild(p));
    textNode.parentNode.replaceChild(fragment, textNode);
  }

  function highlightCallSyntax() {
    document.querySelectorAll('.code-block pre code').forEach(code => {
      // Collect text nodes first (modifying DOM while walking breaks TreeWalker)
      const walker = document.createTreeWalker(code, NodeFilter.SHOW_TEXT);
      const textNodes = [];
      let n;
      while ((n = walker.nextNode())) {
        if (!isInsideSkippedSpan(n, code)) textNodes.push(n);
      }
      textNodes.forEach(processTextNode);
    });
  }

  // Run once after all content (fonts, scripts) is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', highlightCallSyntax);
  } else {
    highlightCallSyntax();
  }
})();
