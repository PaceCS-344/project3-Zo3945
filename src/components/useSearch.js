import { useState, useEffect, useCallback } from 'react';

export function useSearch() {
  const [query, setQuery] = useState('');
  const [matches, setMatches] = useState([]);

  const search = useCallback((q) => {
    setQuery(q);
    if (!q.trim()) {
      // Clear all highlights
      document.querySelectorAll('.search-highlight').forEach(el => {
        el.outerHTML = el.innerHTML;
      });
      setMatches([]);
      return;
    }

    // Remove old highlights first
    document.querySelectorAll('.search-highlight').forEach(el => {
      el.outerHTML = el.innerHTML;
    });

    const walker = document.createTreeWalker(
      document.querySelector('main') || document.body,
      NodeFilter.SHOW_TEXT,
      null,
      false
    );

    const found = [];
    let node;
    const regex = new RegExp(`(${q})`, 'gi');

    while ((node = walker.nextNode())) {
      if (node.nodeValue.match(regex)) {
        const span = document.createElement('span');
        span.innerHTML = node.nodeValue.replace(regex, '<mark class="search-highlight">$1</mark>');
        node.parentNode.replaceChild(span, node);
        found.push(node);
      }
    }

    setMatches(found);

    // Scroll to first match
    const first = document.querySelector('.search-highlight');
    if (first) {
      first.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  }, []);

  // Clear on empty
  useEffect(() => {
    if (!query) {
      document.querySelectorAll('.search-highlight').forEach(el => {
        const parent = el.parentNode;
        if (parent) {
          parent.replaceChild(document.createTextNode(el.textContent), el);
          parent.normalize();
        }
      });
    }
  }, [query]);

  return { query, setQuery: search, matches };
}
