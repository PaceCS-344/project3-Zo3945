import React from 'react';
import { useScrollAnimation, useCountUp } from './useScrollAnimation';
import SearchHighlight from './SearchHighlight';
import './About.css';

const BIO = "Born and raised in New York, I'm a Computer Science rising senior at Pace University who loves seeing ideas come to life through code. Whether it's a mobile app, a web tool, or something in between, there's nothing better than building something from scratch and watching it actually work. Outside of school I stay active lifting and playing sports, and that same drive carries into everything I build. I got into CS because I wanted to create things that make an impact, and that's still what pushes me every day.";

const HIGHLIGHTS = [
  { label: 'Pace University', icon: '🎓' },
  { label: 'SWE Intern Experience', icon: '💼' },
  { label: 'Best Website Award — WiCyS', icon: '🏆' },
  { label: 'Android Developer', icon: '📱' },
];

function StatCard({ number, label, visible }) {
  const count = useCountUp(number, visible);
  return (
    <div className="stat-card">
      <span className="stat-card__num">{visible ? count || number : '0'}</span>
      <span className="stat-card__label">{label}</span>
    </div>
  );
}

function About({ searchQuery }) {
  const [ref, visible] = useScrollAnimation(0.1);
  return (
    <section id="about" className="about">
      <div className="container">
        <p className="section-label">About Me</p>
        <div className="about__grid" ref={ref}
          style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(40px)', transition: 'opacity 0.7s ease, transform 0.7s ease' }}>
          <div className="about__text">
            <h2 className="section-title">Who I Am</h2>
            <p className="about__para"><SearchHighlight text={BIO} query={searchQuery} /></p>
            <div className="about__tags">
              {HIGHLIGHTS.map((h, i) => (
                <span key={h.label} className="about__tag"
                  style={{ transitionDelay: `${i * 0.08}s`, opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(12px)', transition: 'opacity 0.5s ease, transform 0.5s ease' }}>
                  <span aria-hidden="true">{h.icon}</span> <SearchHighlight text={h.label} query={searchQuery} />
                </span>
              ))}
            </div>
            <div style={{ marginTop: '2rem' }}>
              <a href="/Zoheb-s-website/resume.pdf" download="Zoheb_Khan_Resume.pdf" className="btn btn--outline">Download Resume</a>
            </div>
          </div>
          <div className="about__stats">
            <StatCard number="6+" label="Projects Built" visible={visible} />
            <StatCard number="5+" label="Languages Used" visible={visible} />
            <StatCard number="3+" label="Years Coding" visible={visible} />
            <StatCard number="∞" label="Bugs Fixed" visible={visible} />
          </div>
        </div>
      </div>
    </section>
  );
}
export default About;
