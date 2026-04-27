/**
 * Floating Quick Reference Bar
 * Vertical-column layout with Dart syntax highlighting (dark-theme palette).
 */
(function () {
    const STORAGE_KEY = 'quickRefCollapsed';

    /* ── Dart tokeniser ─────────────────────────────────────────────── */
    // Ordered: first match wins on each position.
    const TOKEN_RULES = [
        { re: /^(\/\/.*)/, cls: 'comment' },
        { re: /^('(?:[^'\\]|\\.)*'|"(?:[^"\\]|\\.)*")/, cls: 'string' },
        { re: /^(import|export|var|final|const|void|if|else|for|while|return|null|true|false|in|new|this|class|extends|implements|abstract|async|await|yield|switch|case|default|break|continue|throw|try|catch|finally|is|as)\b/, cls: 'keyword' },
        { re: /^(int|bool|String|double|num|dynamic|Object|List|Map|Set|Queue|PriorityQueue|SplayTreeMap|SplayTreeSet|ListNode|Iterable|Never)\b/, cls: 'type' },
        { re: /^(print|max|min|sqrt|pow|log)\b/, cls: 'built_in' },
        { re: /^-?\d+(?:\.\d+)?/, cls: 'number' },
    ];

    function highlightDart(raw) {
        let out = '';
        let s = raw;
        while (s.length > 0) {
            let matched = false;
            for (const rule of TOKEN_RULES) {
                const m = rule.re.exec(s);
                if (m) {
                    out += `<span class="${rule.cls}">${esc(m[0])}</span>`;
                    s = s.slice(m[0].length);
                    matched = true;
                    break;
                }
            }
            if (!matched) {
                // Advance one char as plain text
                out += esc(s[0]);
                s = s.slice(1);
            }
        }
        return out;
    }

    function esc(str) {
        return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    /* ── Quick-ref data ──────────────────────────────────────────────── */
    const GROUPS = [
        {
            label: 'Loop + List',
            accent: '#13b9fd',
            cmds: [
                'for (var i = 0; i <',
                '  list.length; i++) {',
                '  // ...',
                '}',
                'list.removeLast();',
                'var zeros = List.generate(3,',
                '  (_) => List.filled(4, 0));',
            ],
        },
        {
            label: 'Set + Map',
            accent: '#4ade80',
            cmds: [
                'var set = <int>{1, 2, 3};',
                'set.contains(3);',
                '',
                'map.containsKey(\'b\');',
                'for (var entry in',
                '  map.entries) {',
                '  // entry.key, .value',
                '}',
                'var adj = { for (var i in',
                '  [1,2,3]) i: [] };',
            ],
        },
        {
            label: 'Matrices',
            accent: '#f472b6',
            cmds: [
                'while (queue.isNotEmpty) {',
                '  final cur = queue.removeFirst();',
                '  int r = cur[0], c = cur[1];',
                '  // Add logic or return',
                '  for (final d in dirs) {',
                '    int nr = r + d[0],',
                '      nc = c + d[1];',
                '    if (inBounds(nr, nc) &&',
                '      !visited[nr][nc]) {',
                '      visited[nr][nc] = true;',
                '      queue.add([nr, nc]);',
                '    }',
                '  }',
                '}',
            ],
        },
        {
            label: 'Stack (DFS)',
            accent: '#38bdf8',
            cmds: [
                'var stack = <int>[];',
                'stack.add(1);',
                'var peek = stack.last;',
                'stack.removeLast();',
            ],
        },
        {
            label: 'Queue (BFS)',
            accent: '#13b9fd',
            cmds: [
                "import 'dart:collection';",
                'var queue = Queue<int>();',
                'queue.addLast(1);',
                'if (queue.isNotEmpty)',
                '  queue.removeFirst();',
            ],
        },
        {
            label: 'Min Heap',
            accent: '#e879f9',
            cmds: [
                "import 'package:collection/collection.dart';",
                'final minHeap =',
                '  PriorityQueue<List<int>>(',
                '  (a, b) => a[0]',
                '    .compareTo(b[0]),',
                ');',
                'minHeap.add([dist, node]);',
                'minHeap.removeFirst();',
            ],
        },
        {
            label: 'Sort + Max',
            accent: '#fb923c',
            cmds: [
                "import 'dart:math';",
                'arr.sort((a, b) =>',
                '  a.compareTo(b));',
                'var largest = max(a, b);',
            ],
        },
        {
            label: 'Class',
            accent: '#fbbf24',
            cmds: [
                "import 'package:collection/collection.dart';",
                'class MedianFinder {',
                '  final left = PriorityQueue<int>();',
                '  final right = PriorityQueue<int>();',
                '',
                '  void addNum(int num) {}',
                '  double findMedian() {}',
                '}',
            ],
        },
        {
            label: 'Math',
            accent: '#f87171',
            cmds: [
                'var div = 5 ~/ 2; // 2',
                'var mod = 5 % 2;  // 1',
            ],
        },
    ];

    /* ── DOM builder ─────────────────────────────────────────────────── */
    function buildBar() {
        const root = document.createElement('div');
        root.id = 'quick-ref';

        /* header */
        const header = document.createElement('div');
        header.id = 'quick-ref-header';
        header.innerHTML = `
            <span id="quick-ref-title">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="2.5"
                     stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="4 7 4 4 20 4 20 7"/>
                    <line x1="9" y1="20" x2="15" y2="20"/>
                    <line x1="12" y1="4" x2="12" y2="20"/>
                </svg>
                Quick Ref
            </span>
            <button id="quick-ref-toggle-btn" aria-label="Toggle quick reference">
                <span id="quick-ref-chevron">▲</span>
                <span id="quick-ref-toggle-label">Collapse</span>
            </button>`;
        root.appendChild(header);

        /* body: CSS grid, one column per group */
        const body = document.createElement('div');
        body.id = 'quick-ref-body';
        body.style.setProperty('--qr-cols', GROUPS.length);

        GROUPS.forEach(group => {
            const col = document.createElement('div');
            col.className = 'qr-group';
            col.style.setProperty('--qr-accent', group.accent);

            const label = document.createElement('div');
            label.className = 'qr-label';
            label.textContent = group.label;
            col.appendChild(label);

            group.cmds.forEach(code => {
                const line = document.createElement('div');
                line.className = 'qr-line';
                // innerHTML so syntax-highlight spans render
                line.innerHTML = `<code>${highlightDart(code)}</code>`;
                col.appendChild(line);
            });

            body.appendChild(col);
        });

        root.appendChild(body);
        document.body.appendChild(root);

        /* toggle */
        const toggleLabel = document.getElementById('quick-ref-toggle-label');

        function applyState(collapsed, animate) {
            if (!animate) root.style.transition = 'none';
            root.classList.toggle('is-collapsed', collapsed);
            toggleLabel.textContent = collapsed ? 'Expand' : 'Collapse';
            if (!animate) requestAnimationFrame(() => { root.style.transition = ''; });
            updateBodyPad();
            localStorage.setItem(STORAGE_KEY, collapsed ? '1' : '0');
        }

        function updateBodyPad() {
            document.body.style.paddingBottom =
                root.getBoundingClientRect().height + 'px';
        }

        header.addEventListener('click', () =>
            applyState(!root.classList.contains('is-collapsed'), true));

        applyState(localStorage.getItem(STORAGE_KEY) === '1', false);
        window.addEventListener('resize', updateBodyPad);
        window.addEventListener('load', updateBodyPad);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', buildBar);
    } else {
        buildBar();
    }
})();
