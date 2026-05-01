#!/bin/bash

cat > src/components/Hero.js << 'EOF'
import React, { useState, useEffect } from 'react';
import Button from './Button';
import './Hero.css';

const ROLES = ['Software Engineer', 'Android Developer', 'CS Rising Senior', 'Problem Solver'];
const TAGLINE = "CS student at Pace University who loves building things and solving real problems.";
const GITHUB_URL = 'https://github.com/Zo3945';

function useTypewriter(words, speed = 80, pause = 1800) {
  const [index, setIndex] = useState(0);
  const [subIndex, setSubIndex] = useState(0);
  const [deleting, setDeleting] = useState(false);
  const [text, setText] = useState('');

  useEffect(() => {
    if (!deleting && subIndex === words[index].length) {
      const t = setTimeout(() => setDeleting(true), pause);
      return () => clearTimeout(t);
    }
    if (deleting && subIndex === 0) {
      setDeleting(false);
      setIndex(prev => (prev + 1) % words.length);
      return;
    }
    const t = setTimeout(() => {
      const next = subIndex + (deleting ? -1 : 1);
      setSubIndex(next);
      setText(words[index].substring(0, next));
    }, deleting ? speed / 2 : speed);
    return () => clearTimeout(t);
  }, [subIndex, deleting, index, words, speed, pause]);

  return text;
}

function Hero() {
  const role = useTypewriter(ROLES);
  const scrollToProjects = () => document.querySelector('#projects')?.scrollIntoView({ behavior: 'smooth' });

  return (
    <section id="hero" className="hero">
      <div className="hero__bg-grid" aria-hidden="true" />

      {/* Glowing orbs */}
      <div className="hero__orb hero__orb--1" aria-hidden="true" />
      <div className="hero__orb hero__orb--2" aria-hidden="true" />

      <div className="container hero__inner">
        <div className="hero__content">
          <div className="hero__eyebrow">
            <span className="hero__dot" />
            <span>Available for internships</span>
          </div>

          <h1 className="hero__name">
            <span className="hero__name-line">Zoheb</span>
            <span className="hero__name-line hero__name-line--accent">Khan</span>
          </h1>

          <div className="hero__role-wrap">
            <span className="hero__role-label">~/ </span>
            <span className="hero__role-text">{role}</span>
            <span className="hero__cursor" aria-hidden="true">|</span>
          </div>

          <p className="hero__tagline">{TAGLINE}</p>

          <div className="hero__actions">
            <Button onClick={scrollToProjects} variant="primary">View My Work</Button>
            <Button href={GITHUB_URL} variant="ghost" external>GitHub Profile</Button>
          </div>

          <div className="hero__stats">
            <div className="hero__stat">
              <span className="hero__stat-num">2</span>
              <span className="hero__stat-label">Internships</span>
            </div>
            <div className="hero__stat-divider" />
            <div className="hero__stat">
              <span className="hero__stat-num">6+</span>
              <span className="hero__stat-label">Projects</span>
            </div>
            <div className="hero__stat-divider" />
            <div className="hero__stat">
              <span className="hero__stat-num">🏆</span>
              <span className="hero__stat-label">WiCyS Award</span>
            </div>
          </div>
        </div>

        <div className="hero__right">
          <div className="hero__card-wrap">
            <div className="hero__card-border" />
            <div className="hero__card">
              <div className="terminal__bar">
                <span className="terminal__dot terminal__dot--red" />
                <span className="terminal__dot terminal__dot--yellow" />
                <span className="terminal__dot terminal__dot--green" />
                <span className="terminal__title">about-me.js</span>
              </div>
              <div className="terminal__body">
                <pre className="terminal__code">{`const developer = {
  name: "Zoheb Khan",
  school: "Pace University",
  experience: "SWE Intern",
  focus: [
    "Android Development",
    "Python Automation",
    "Web Development",
  ],
  awards: [
    "Best Website @ WiCyS",
  ],
  lookingFor: "SWE Internship",
};`}</pre>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="hero__scroll-hint" aria-hidden="true">
        <span>scroll</span>
        <div className="hero__scroll-arrow" />
      </div>
    </section>
  );
}
export default Hero;
EOF

cat > src/components/Hero.css << 'EOF'
.hero {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 8rem 0 4rem;
  position: relative;
  overflow: hidden;
}

.hero__bg-grid {
  position: absolute;
  inset: 0;
  background-image:
    radial-gradient(1px 1px at 20% 30%, rgba(139,124,248,0.6) 0%, transparent 100%),
    radial-gradient(1px 1px at 80% 10%, rgba(255,255,255,0.4) 0%, transparent 100%),
    radial-gradient(1px 1px at 50% 60%, rgba(87,240,176,0.4) 0%, transparent 100%),
    radial-gradient(1px 1px at 10% 80%, rgba(255,255,255,0.3) 0%, transparent 100%),
    radial-gradient(1px 1px at 90% 70%, rgba(139,124,248,0.5) 0%, transparent 100%),
    linear-gradient(var(--border) 1px, transparent 1px),
    linear-gradient(90deg, var(--border) 1px, transparent 1px);
  background-size: 100% 100%, 100% 100%, 100% 100%, 100% 100%, 100% 100%, 48px 48px, 48px 48px;
  mask-image: radial-gradient(ellipse 80% 60% at 50% 50%, black 30%, transparent 100%);
  -webkit-mask-image: radial-gradient(ellipse 80% 60% at 50% 50%, black 30%, transparent 100%);
  pointer-events: none;
}

/* Glowing orbs */
.hero__orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  pointer-events: none;
  animation: orbFloat 8s ease-in-out infinite;
}

.hero__orb--1 {
  width: 400px; height: 400px;
  background: radial-gradient(circle, rgba(124,106,255,0.15) 0%, transparent 70%);
  top: 10%; left: -10%;
  animation-delay: 0s;
}

.hero__orb--2 {
  width: 300px; height: 300px;
  background: radial-gradient(circle, rgba(87,240,176,0.1) 0%, transparent 70%);
  bottom: 10%; right: -5%;
  animation-delay: 3s;
}

@keyframes orbFloat {
  0%, 100% { transform: translateY(0px) scale(1); }
  50% { transform: translateY(-30px) scale(1.05); }
}

.hero__inner {
  display: grid;
  grid-template-columns: 1.1fr 0.9fr;
  align-items: center;
  gap: 4rem;
  position: relative;
  z-index: 1;
}

/* Eyebrow */
.hero__eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-family: var(--font-mono);
  font-size: 0.75rem;
  color: var(--green);
  background: rgba(87,240,176,0.08);
  border: 1px solid rgba(87,240,176,0.2);
  padding: 0.35rem 0.85rem;
  border-radius: 100px;
  margin-bottom: 1.5rem;
  animation: fadeUp 0.6s ease both;
}

.hero__dot {
  width: 7px; height: 7px;
  background: var(--green);
  border-radius: 50%;
  box-shadow: 0 0 8px var(--green);
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; box-shadow: 0 0 8px var(--green); }
  50% { opacity: 0.6; box-shadow: 0 0 16px var(--green); }
}

/* Name */
.hero__name {
  display: flex;
  flex-direction: column;
  line-height: 1;
  margin-bottom: 1rem;
  animation: fadeUp 0.6s 0.1s ease both;
}

.hero__name-line {
  font-size: clamp(3rem, 6vw, 5.5rem);
  font-weight: 700;
  letter-spacing: -0.04em;
  color: var(--text-primary);
}

.hero__name-line--accent {
  background: linear-gradient(135deg, #a78bfa, #7c6aff, #57f0b0);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  background-size: 200% 200%;
  animation: gradientShift 4s ease infinite, fadeUp 0.6s 0.15s ease both;
}

@keyframes gradientShift {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

/* Role */
.hero__role-wrap {
  font-family: var(--font-mono);
  font-size: 1.1rem;
  color: var(--accent);
  margin-bottom: 1.25rem;
  min-height: 1.7em;
  animation: fadeUp 0.6s 0.2s ease both;
}

.hero__role-label {
  color: var(--green);
  opacity: 0.7;
}

.hero__cursor {
  animation: blink 0.9s step-end infinite;
  color: var(--accent);
}

.hero__tagline {
  font-size: 1.05rem;
  color: var(--text-secondary);
  max-width: 440px;
  margin-bottom: 2rem;
  line-height: 1.7;
  animation: fadeUp 0.6s 0.25s ease both;
}

.hero__actions {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
  margin-bottom: 2.5rem;
  animation: fadeUp 0.6s 0.3s ease both;
}

/* Stats row */
.hero__stats {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  animation: fadeUp 0.6s 0.35s ease both;
}

.hero__stat {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
}

.hero__stat-num {
  font-family: var(--font-mono);
  font-size: 1.4rem;
  font-weight: 700;
  color: var(--text-primary);
  line-height: 1;
}

.hero__stat-label {
  font-size: 0.72rem;
  color: var(--text-muted);
  font-family: var(--font-mono);
  text-transform: uppercase;
  letter-spacing: 0.06em;
}

.hero__stat-divider {
  width: 1px;
  height: 32px;
  background: var(--border);
}

/* Right side card with animated border */
.hero__right {
  animation: fadeUp 0.8s 0.2s ease both;
}

.hero__card-wrap {
  position: relative;
  border-radius: 16px;
}

.hero__card-border {
  position: absolute;
  inset: -1px;
  border-radius: 17px;
  background: linear-gradient(135deg, rgba(124,106,255,0.6), rgba(87,240,176,0.3), rgba(124,106,255,0.1), rgba(87,240,176,0.4));
  background-size: 300% 300%;
  animation: borderRotate 4s linear infinite;
  z-index: 0;
}

@keyframes borderRotate {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.hero__card {
  position: relative;
  z-index: 1;
  background: var(--bg-card);
  border-radius: 16px;
  overflow: hidden;
}

.terminal__bar {
  background: var(--bg-secondary);
  padding: 0.65rem 1rem;
  display: flex;
  align-items: center;
  gap: 6px;
  border-bottom: 1px solid var(--border);
}

.terminal__dot { width: 12px; height: 12px; border-radius: 50%; }
.terminal__dot--red { background: #ff5f57; }
.terminal__dot--yellow { background: #ffbd2e; }
.terminal__dot--green { background: #28ca41; }

.terminal__title {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  color: var(--text-muted);
  margin: 0 auto;
}

.terminal__body { padding: 1.5rem; }

.terminal__code {
  font-family: var(--font-mono);
  font-size: 0.82rem;
  line-height: 1.8;
  color: var(--text-secondary);
  white-space: pre-wrap;
  word-break: break-word;
}

/* Scroll hint */
.hero__scroll-hint {
  position: absolute;
  bottom: 2rem;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  font-family: var(--font-mono);
  font-size: 0.65rem;
  color: var(--text-muted);
  letter-spacing: 0.1em;
  text-transform: uppercase;
  animation: fadeUp 1s 1s both;
}

.hero__scroll-arrow {
  width: 1px;
  height: 40px;
  background: linear-gradient(to bottom, var(--text-muted), transparent);
}

@media (max-width: 800px) {
  .hero__inner { grid-template-columns: 1fr; gap: 3rem; }
  .hero__right { display: none; }
  .hero__name-line { font-size: clamp(2.5rem, 10vw, 4rem); }
}
EOF

echo "✅ Hero redesigned — glowing name, animated border card, floating orbs, stats row!"
