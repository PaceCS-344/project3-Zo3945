#!/bin/bash

# Copy resume to public folder
cp ~/Downloads/Cs_Resume___1_.pdf public/resume.pdf 2>/dev/null || echo "⚠️  Resume PDF not found in Downloads - add it manually to the public/ folder"

# About.js - remove GPA everywhere, clean bio, fix resume URL
cat > src/components/About.js << 'EOF'
import React from 'react';
import Button from './Button';
import { useScrollAnimation, useCountUp } from './useScrollAnimation';
import './About.css';

const BIO = "I'm a Computer Science rising senior at Pace University who learns best by building things. I've optimized SQL databases, automated Python workflows, and integrated third-party APIs on real teams shipping real code. I'm actively looking for a software engineering internship where I can keep growing and contribute to meaningful projects.";

const HIGHLIGHTS = [
  { label: 'Pace University', icon: '🎓' },
  { label: 'SWE Intern Experience', icon: '💼' },
  { label: 'Best Website Award — WiCyS', icon: '🏆' },
  { label: 'Android Developer', icon: '📱' },
];

const RESUME_URL = '/resume.pdf';

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
              <Button href={RESUME_URL} variant="outline" external>Download Resume</Button>
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

# Experience.js - remove Friedwald
cat > src/components/Experience.js << 'EOF'
import React from 'react';
import { useScrollAnimation } from './useScrollAnimation';
import './Experience.css';

const EXPERIENCES = [
  {
    company: 'Stellar Digital Strategies LLC',
    role: 'Software Engineering Intern',
    period: 'May 2025 – Sep 2025',
    location: 'Raritan, NJ',
    bullets: [
      'Wrote 200+ lines of Python automation scripts, reducing manual data processing effort by 6+ hours weekly',
      'Designed and executed 25+ email marketing campaigns using AI prompt engineering, increasing customer acquisition by 10% per campaign',
      'Analyzed expenses and revenue forecasts using Excel, resulting in a 15% increase in operational efficiency',
      'Improved client retention by 10% by analyzing feedback and implementing targeted process improvements',
    ],
    tags: ['Python', 'AI Prompt Engineering', 'Excel', 'Data Analysis'],
    current: true,
  },
  {
    company: '73rd Solution',
    role: 'Software Engineering Intern',
    period: 'Jan 2025 – May 2025',
    location: 'Princeton, NJ',
    bullets: [
      'Reduced system response time by 30% through SQL database query optimization across 3 database tables',
      'Integrated 3+ third-party APIs (Google Analytics, Mailchimp, Stripe) using Python, consolidating data into a unified reporting system',
      'Collaborated with a team of 3 developers using Git, conducting code reviews for 10+ pull requests weekly',
      'Achieved 85% unit test coverage and documented 12 technical processes for internal tools',
      'Participated in agile sprints, delivering features within 2-week cadences',
    ],
    tags: ['Python', 'SQL', 'REST APIs', 'Git', 'Agile'],
    current: false,
  },
];

function ExperienceCard({ company, role, period, location, bullets, tags, current, index, visible }) {
  return (
    <div className={`exp-card ${current ? 'exp-card--current' : ''}`}
      style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateY(0)' : 'translateY(40px)',
        transition: `opacity 0.6s ease ${index * 0.15}s, transform 0.6s ease ${index * 0.15}s`
      }}>
      <div className="exp-card__header">
        <div>
          <h3 className="exp-card__company">{company}</h3>
          <p className="exp-card__role">{role}</p>
        </div>
        <div className="exp-card__meta">
          {current && <span className="exp-card__badge">Current</span>}
          <span className="exp-card__period">{period}</span>
          <span className="exp-card__location">{location}</span>
        </div>
      </div>
      <ul className="exp-card__bullets">
        {bullets.map((b, i) => <li key={i}>{b}</li>)}
      </ul>
      <div className="exp-card__tags">
        {tags.map(t => <span key={t} className="exp-card__tag">{t}</span>)}
      </div>
    </div>
  );
}

function Experience() {
  const [ref, visible] = useScrollAnimation(0.05);

  return (
    <section id="experience" className="experience">
      <div className="container">
        <p className="section-label">Experience</p>
        <h2 className="section-title">Where I've Worked</h2>
        <p className="section-subtitle">Real teams, real code, real impact.</p>
        <div className="exp-list" ref={ref}>
          {EXPERIENCES.map((e, i) => (
            <ExperienceCard key={e.company} {...e} index={i} visible={visible} />
          ))}
        </div>
      </div>
    </section>
  );
}
export default Experience;
EOF

# Hero.js - no GPA, clean tagline
cat > src/components/Hero.js << 'EOF'
import React, { useState, useEffect } from 'react';
import Button from './Button';
import './Hero.css';

const NAME = 'Zoheb Khan';
const ROLES = ['Software Engineer Intern', 'Android Developer', 'CS Rising Senior', 'Problem Solver'];
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
      setSubIndex(prev => prev + (deleting ? -1 : 1));
      setText(words[index].substring(0, subIndex));
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
      <div className="container hero__inner">
        <div className="hero__content">
          <p className="hero__greeting"><span className="hero__prompt">$ </span>Hello, world. I'm</p>
          <h1 className="hero__name">{NAME}</h1>
          <p className="hero__role">
            <span className="hero__role-text">{role}</span>
            <span className="hero__cursor" aria-hidden="true">|</span>
          </p>
          <p className="hero__tagline">{TAGLINE}</p>
          <div className="hero__actions">
            <Button onClick={scrollToProjects} variant="primary">View My Work</Button>
            <Button href={GITHUB_URL} variant="ghost" external>GitHub Profile</Button>
          </div>
        </div>
        <div className="hero__terminal" aria-hidden="true">
          <div className="terminal">
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
      <div className="hero__scroll-hint" aria-hidden="true">
        <span>scroll</span>
        <div className="hero__scroll-arrow" />
      </div>
    </section>
  );
}
export default Hero;
EOF

echo "✅ All final changes applied!"
