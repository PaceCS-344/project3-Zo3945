#!/bin/bash

# Remove CursorGlow and add space theme, fix resume
cat > src/App.js << 'EOF'
import React from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import About from './components/About';
import Experience from './components/Experience';
import Skills from './components/Skills';
import Projects from './components/Projects';
import Contact from './components/Contact';
import Footer from './components/Footer';
import ParticleBackground from './components/ParticleBackground';
import './styles/App.css';

function App() {
  return (
    <div className="app">
      <ParticleBackground />
      <Navbar />
      <main style={{ position: 'relative', zIndex: 1 }}>
        <Hero />
        <About />
        <Experience />
        <Skills />
        <Projects />
        <Contact />
      </main>
      <Footer />
    </div>
  );
}
export default App;
EOF

# Fix resume in About.js - use plain anchor tag
cat > src/components/About.js << 'EOF'
import React from 'react';
import { useScrollAnimation, useCountUp } from './useScrollAnimation';
import './About.css';

const BIO = "I'm a Computer Science rising senior at Pace University who learns best by building things. I've optimized SQL databases, automated Python workflows, and integrated third-party APIs on real teams shipping real code. I'm actively looking for a software engineering internship where I can keep growing and contribute to meaningful projects.";

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
  return (
    <section id="about" className="about">
      <div className="container">
        <p className="section-label">About Me</p>
        <div className="about__grid" ref={ref}
          style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(40px)', transition: 'opacity 0.7s ease, transform 0.7s ease' }}>
          <div className="about__text">
            <h2 className="section-title">Who I Am</h2>
            <p className="about__para">{BIO}</p>
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
EOF

# Space theme - update CSS variables and add space effects
cat >> src/styles/App.css << 'EOF'

/* ── SPACE THEME ── */
:root {
  --bg-primary: #04040d;
  --bg-secondary: #07071a;
  --bg-card: #0d0d24;
  --bg-hover: #13132e;
  --accent: #8b7cf8;
  --accent-dim: rgba(139, 124, 248, 0.12);
  --accent-glow: rgba(139, 124, 248, 0.4);
  --green: #57f0b0;
  --amber: #f0c040;
  --text-primary: #eeeeff;
  --text-secondary: #8888bb;
  --text-muted: #44446a;
  --border: rgba(139, 124, 248, 0.08);
  --border-accent: rgba(139, 124, 248, 0.35);
}

/* Nebula glow behind hero */
#hero::after {
  content: '';
  position: absolute;
  top: 10%; left: 50%;
  transform: translateX(-50%);
  width: 600px; height: 400px;
  background: radial-gradient(ellipse, rgba(139,124,248,0.08) 0%, transparent 70%);
  pointer-events: none;
  z-index: 0;
}

/* Star shimmer on section backgrounds */
.about, .projects {
  background: var(--bg-secondary);
  position: relative;
}

/* Glowing accent line on exp cards */
.exp-card--current::before {
  content: '';
  position: absolute;
  top: 0; left: 0;
  width: 3px; height: 100%;
  background: linear-gradient(to bottom, var(--accent), transparent);
  border-radius: 3px 0 0 3px;
}

.exp-card {
  position: relative;
}

/* Space-style section labels */
.section-label {
  color: var(--green);
  text-shadow: 0 0 12px rgba(87, 240, 176, 0.4);
}

/* Glowing navbar logo */
.navbar__logo-bracket {
  color: var(--green);
  text-shadow: 0 0 10px rgba(87, 240, 176, 0.5);
}

/* Star dots on hero background - enhanced */
.hero__bg-grid {
  background-image:
    radial-gradient(1px 1px at 20% 30%, rgba(139,124,248,0.6) 0%, transparent 100%),
    radial-gradient(1px 1px at 80% 10%, rgba(255,255,255,0.4) 0%, transparent 100%),
    radial-gradient(1px 1px at 50% 60%, rgba(87,240,176,0.4) 0%, transparent 100%),
    radial-gradient(1px 1px at 10% 80%, rgba(255,255,255,0.3) 0%, transparent 100%),
    radial-gradient(1px 1px at 90% 70%, rgba(139,124,248,0.5) 0%, transparent 100%),
    linear-gradient(var(--border) 1px, transparent 1px),
    linear-gradient(90deg, var(--border) 1px, transparent 1px);
  background-size: 100% 100%, 100% 100%, 100% 100%, 100% 100%, 100% 100%, 48px 48px, 48px 48px;
}

/* Glowing primary button */
.btn--primary {
  background: linear-gradient(135deg, #7c6aff, #a78bfa);
  box-shadow: 0 0 20px rgba(139,124,248,0.3);
}

.btn--primary:hover {
  box-shadow: 0 0 30px rgba(139,124,248,0.6);
}

/* Twinkling stars animation */
@keyframes twinkle {
  0%, 100% { opacity: 0.3; transform: scale(1); }
  50% { opacity: 1; transform: scale(1.2); }
}

.stat-card__num {
  text-shadow: 0 0 20px rgba(139,124,248,0.5);
}
EOF

echo "✅ Space theme applied, cursor removed, resume fixed!"
