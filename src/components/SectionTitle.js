import React from 'react';
import { useScrollAnimation } from './useScrollAnimation';

function SectionTitle({ label, title, subtitle }) {
  const [ref, visible] = useScrollAnimation(0.2);

  return (
    <div ref={ref}>
      <p className="section-label" style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateY(0)' : 'translateY(20px)',
        transition: 'opacity 0.5s ease, transform 0.5s ease',
      }}>{label}</p>
      <h2 className="section-title" style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateY(0)' : 'translateY(20px)',
        transition: 'opacity 0.5s ease 0.1s, transform 0.5s ease 0.1s',
      }}>{title}</h2>
      {subtitle && (
        <p className="section-subtitle" style={{
          opacity: visible ? 1 : 0,
          transform: visible ? 'translateY(0)' : 'translateY(20px)',
          transition: 'opacity 0.5s ease 0.2s, transform 0.5s ease 0.2s',
        }}>{subtitle}</p>
      )}
    </div>
  );
}

export default SectionTitle;
