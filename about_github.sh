#!/bin/bash

cat > src/components/About.js << 'JSEOF'
import React from 'react';
import { useScrollAnimation, useCountUp } from './useScrollAnimation';
import { useGitHubProfile } from './useGitHub';
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

function About() {
  const [ref, visible] = useScrollAnimation(0.1);
  const { profile } = useGitHubProfile();

  return (
    <section id="about" className="about">
      <div className="container">
        <p className="section-label">About Me</p>
        <div className="about__grid" ref={ref}
          style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(40px)', transition: 'opacity 0.7s ease, transform 0.7s ease' }}>
          <div className="about__text">
            <h2 className="section-title">Who I Am</h2>
            <p className="about__para">{BIO}</p>

            {profile && (
              <div className="about__github-pill">
                <img src={profile.avatar_url} alt="GitHub" className="about__github-pill-avatar" />
                <div className="about__github-pill-info">
                  <span className="about__github-pill-name">@{profile.login}</span>
                  <span className="about__github-pill-stats">
                    👥 {profile.followers} followers · 📦 {profile.public_repos} repos
                  </span>
                </div>
                <a href={profile.html_url} target="_blank" rel="noopener noreferrer"
                  className="about__github-pill-link">View ↗</a>
              </div>
            )}

            <div className="about__tags">
              {HIGHLIGHTS.map((h, i) => (
                <span key={h.label} className="about__tag"
                  style={{ transitionDelay: `${i * 0.08}s`, opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(12px)', transition: 'opacity 0.5s ease, transform 0.5s ease' }}>
                  <span aria-hidden="true">{h.icon}</span> {h.label}
                </span>
              ))}
            </div>
            <div style={{ marginTop: '2rem' }}>
              <a href="/resume.pdf" download="Zoheb_Khan_Resume.pdf" className="btn btn--outline">
                Download Resume
              </a>
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
JSEOF

cat >> src/components/About.css << 'CSSEOF'

.about__github-pill {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  background: var(--bg-card);
  border: 1px solid var(--border-accent);
  border-radius: 100px;
  padding: 0.5rem 1rem 0.5rem 0.5rem;
  margin: 1.25rem 0;
  width: fit-content;
  transition: box-shadow var(--transition), border-color var(--transition);
}

.about__github-pill:hover {
  box-shadow: 0 0 16px rgba(124,106,255,0.2);
  border-color: rgba(124,106,255,0.5);
}

.about__github-pill-avatar {
  width: 36px; height: 36px;
  border-radius: 50%;
  border: 1px solid var(--border-accent);
}

.about__github-pill-info {
  display: flex;
  flex-direction: column;
  gap: 0.1rem;
}

.about__github-pill-name {
  font-family: var(--font-mono);
  font-size: 0.8rem;
  color: var(--text-primary);
  font-weight: 600;
}

.about__github-pill-stats {
  font-family: var(--font-mono);
  font-size: 0.68rem;
  color: var(--text-muted);
}

.about__github-pill-link {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  color: var(--accent);
  text-decoration: none;
  margin-left: 0.25rem;
}
CSSEOF

echo "✅ GitHub profile pill added to About Me!"
