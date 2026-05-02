import React from 'react';

function SearchHighlight({ text, query }) {
  if (!query || !query.trim() || !text) return <span>{text}</span>;
  
  const escaped = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const regex = new RegExp(`(${escaped})`, 'gi');
  const parts = text.split(regex);
  
  return (
    <span>
      {parts.map((part, i) =>
        part.toLowerCase() === query.toLowerCase()
          ? <mark key={i} className="search-highlight">{part}</mark>
          : <span key={i}>{part}</span>
      )}
    </span>
  );
}

export default SearchHighlight;
