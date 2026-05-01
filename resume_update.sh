#!/bin/bash

# Updated Hero with real summary
cat > src/components/Hero.js << 'EOF'
import React, { useState, useEffect } from 'react';
import Button from './Button';
import './Hero.css';

const NAME = 'Zoheb Khan';
const ROLES = ['Software Engineer Intern', 'Android Developer', 'CS Rising Senior', 'Problem Solver'];
const TAGLINE = "CS student at Pace University with 2 internships, a 3.4 GPA, and a passion for building things that actually work.";
const GITHUB_URL = 'https://github.com/Zo3945';
const RESUME_URL = '#';

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
  gpa: 3.4,
  internships: 2,
  focus: [
    "Android Development",
    "Python Automation",
    "Web Development",
  ],
  awards: [
    "Best Website Award @ WiCyS",
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

# Updated About with real bio + stats
cat > src/components/About.js << 'EOF'
import React from 'react';
import Button from './Button';
import { useScrollAnimation, useCountUp } from './useScrollAnimation';
import './About.css';

const BIO = "I'm a Computer Science rising senior at Pace University (GPA: 3.4) who learns best by building things. With 2 software engineering internships under my belt, I've optimized SQL databases, automated Python workflows, and integrated third-party APIs — all on real teams, shipping real code. I'm actively looking for a software engineering internship where I can keep growing and contribute to meaningful projects.";

const HIGHLIGHTS = [
  { label: 'Pace University — 3.4 GPA', icon: '🎓' },
  { label: '2 SWE Internships', icon: '💼' },
  { label: 'Best Website Award — WiCyS', icon: '🏆' },
  { label: 'Android Developer', icon: '📱' },
];

const RESUME_URL = '#';

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
            <StatCard number="2" label="Internships" visible={visible} />
            <StatCard number="6+" label="Projects Built" visible={visible} />
            <StatCard number="3.4" label="GPA" visible={visible} />
            <StatCard number="∞" label="Bugs Fixed" visible={visible} />
          </div>
        </div>
      </div>
    </section>
  );
}
export default About;
EOF

# New Experience section
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
  {
    company: 'Friedwald Medical Center',
    role: 'IT Tech-Support',
    period: 'May 2022 – Dec 2023',
    location: 'New City, NY',
    bullets: [
      'Troubleshot hardware and software issues for medical staff',
      'Assisted staff with EHR systems and ensured smooth daily operations',
      'Prepared accurate documentation while maintaining strict confidentiality',
    ],
    tags: ['IT Support', 'EHR Systems', 'Troubleshooting'],
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

cat > src/components/Experience.css << 'EOF'
.experience {
  background: var(--bg-primary);
}

.exp-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.exp-card {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  padding: 2rem;
  transition: border-color var(--transition), transform var(--transition), box-shadow var(--transition);
}

.exp-card:hover {
  border-color: var(--border-accent);
  transform: translateY(-2px);
  box-shadow: 0 8px 32px rgba(124, 106, 255, 0.12);
}

.exp-card--current {
  border-color: rgba(124, 106, 255, 0.25);
}

.exp-card__header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1rem;
  margin-bottom: 1.25rem;
  flex-wrap: wrap;
}

.exp-card__company {
  font-size: 1.15rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 0.2rem;
}

.exp-card__role {
  font-family: var(--font-mono);
  font-size: 0.82rem;
  color: var(--accent);
}

.exp-card__meta {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 0.3rem;
}

.exp-card__badge {
  font-family: var(--font-mono);
  font-size: 0.65rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--green);
  background: rgba(74, 222, 128, 0.1);
  border: 1px solid rgba(74, 222, 128, 0.3);
  padding: 0.2rem 0.6rem;
  border-radius: 100px;
}

.exp-card__period {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  color: var(--text-muted);
}

.exp-card__location {
  font-size: 0.75rem;
  color: var(--text-muted);
}

.exp-card__bullets {
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
  margin-bottom: 1.25rem;
}

.exp-card__bullets li {
  font-size: 0.9rem;
  color: var(--text-secondary);
  line-height: 1.6;
  padding-left: 1.1rem;
  position: relative;
}

.exp-card__bullets li::before {
  content: '▸';
  position: absolute;
  left: 0;
  color: var(--accent);
  font-size: 0.7rem;
  top: 0.3rem;
}

.exp-card__tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
}

.exp-card__tag {
  font-family: var(--font-mono);
  font-size: 0.7rem;
  padding: 0.2rem 0.6rem;
  background: var(--bg-hover);
  border-radius: 4px;
  color: var(--text-muted);
  border: 1px solid var(--border);
}

@media (max-width: 640px) {
  .exp-card__header {
    flex-direction: column;
  }
  .exp-card__meta {
    align-items: flex-start;
  }
}
EOF

# Update App.js to include Experience section
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
import './styles/App.css';

function App() {
  return (
    <div className="app">
      <Navbar />
      <main>
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

# Update Navbar to include experience link
cat > src/components/Navbar.js << 'EOF'
import React, { useState, useEffect } from 'react';
import './Navbar.css';

const NAV_LINKS = [
  { label: 'about',      href: '#about' },
  { label: 'experience', href: '#experience' },
  { label: 'skills',     href: '#skills' },
  { label: 'projects',   href: '#projects' },
  { label: 'contact',    href: '#contact' },
];

function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 40);
    window.addEventListener('scroll', onScroll);
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  const handleClick = (href) => {
    setMenuOpen(false);
    document.querySelector(href)?.scrollIntoView({ behavior: 'smooth' });
  };

  return (
    <header className={`navbar ${scrolled ? 'navbar--scrolled' : ''}`}>
      <div className="container navbar__inner">
        <a className="navbar__logo" href="#hero" onClick={() => handleClick('#hero')}>
          <span className="navbar__logo-bracket">{'<'}</span>ZohebKhan<span className="navbar__logo-bracket">{' />'}</span>
        </a>
        <nav className={`navbar__links ${menuOpen ? 'navbar__links--open' : ''}`}>
          {NAV_LINKS.map(link => (
            <button key={link.href} className="navbar__link" onClick={() => handleClick(link.href)}>
              <span className="navbar__link-num">~/ </span>{link.label}
            </button>
          ))}
        </nav>
        <button className={`navbar__hamburger ${menuOpen ? 'navbar__hamburger--open' : ''}`}
          onClick={() => setMenuOpen(!menuOpen)} aria-label="Toggle menu">
          <span /><span /><span />
        </button>
      </div>
    </header>
  );
}
export default Navbar;
EOF

# Updated Projects with real resume data
cat > src/components/Projects.js << 'EOF'
import React, { useState } from 'react';
import Button from './Button';
import { useScrollAnimation } from './useScrollAnimation';
import './Projects.css';

const PROJECTS = [
  {
    title: 'Women in Cybersecurity Website',
    description: 'Designed and developed a responsive website for the WiCyS chapter at Pace University using HTML, CSS, and JavaScript. Won the Best Website Award at the Women in Cybersecurity competition.',
    tags: ['HTML', 'CSS', 'JavaScript'],
    github: 'https://github.com/Zo3945',
    live: null,
    featured: true,
    award: '🏆 Best Website Award',
  },
  {
    title: 'Snakes & Ladders',
    description: 'Designed and developed a fully interactive Snakes and Ladders board game using Kotlin and Jetpack Compose, featuring dynamic board generation, multiple players, and integrated game logic.',
    tags: ['Kotlin', 'Jetpack Compose', 'Android'],
    github: 'https://github.com/Zo3945',
    live: null,
    featured: true,
    award: null,
  },
  {
    title: 'Driving Game',
    description: 'Built an interactive driving game where players control a vehicle and avoid dynamic obstacles, implementing collision detection, score tracking, and responsive controls.',
    tags: ['Java', 'Android', 'Game Dev'],
    github: 'https://github.com/Zo3945',
    live: null,
    featured: false,
    award: null,
  },
  {
    title: 'Spotify Playlist Analyzer',
    description: 'A tool that analyzes Spotify playlists and surfaces insights about listening habits, top genres, and audio features using the Spotify API.',
    tags: ['Python', 'API', 'Data'],
    github: 'https://github.com/Zo3945',
    live: null,
    featured: false,
    award: null,
  },
  {
    title: 'Android Calendar App',
    description: 'A calendar-style Android app with event scheduling and a clean material design interface built in Java.',
    tags: ['Java', 'Android', 'Android Studio'],
    github: 'https://github.com/Zo3945',
    live: null,
    featured: false,
    award: null,
  },
  {
    title: 'Candy Crush–Style Game',
    description: 'A match-3 puzzle game for Android inspired by Candy Crush. Built with Java and the Android SDK, featuring animations and score tracking.',
    tags: ['Java', 'Android', 'Game Dev'],
    github: 'https://github.com/Zo3945',
    live: null,
    featured: false,
    award: null,
  },
];

const FILTERS = ['All', 'Python', 'Kotlin', 'Java', 'Android', 'JavaScript'];

function ProjectCard({ title, description, tags, github, live, featured, award, index, visible }) {
  return (
    <div className={`project-card ${featured ? 'project-card--featured' : ''}`}
      style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateY(0)' : 'translateY(40px)',
        transition: `opacity 0.6s ease ${index * 0.08}s, transform 0.6s ease ${index * 0.08}s`
      }}>
      {featured && <span className="project-card__badge">Featured</span>}
      <h3 className="project-card__title">{title}</h3>
      {award && <p className="project-card__award">{award}</p>}
      <p className="project-card__desc">{description}</p>
      <div className="project-card__tags">
        {tags.map(t => <span key={t} className="project-card__tag">{t}</span>)}
      </div>
      <div className="project-card__actions">
        {github && <Button href={github} variant="ghost" external>GitHub</Button>}
        {live && <Button href={live} variant="outline" external>Live Demo</Button>}
      </div>
    </div>
  );
}

function Projects() {
  const [active, setActive] = useState('All');
  const [ref, visible] = useScrollAnimation(0.05);
  const filtered = active === 'All' ? PROJECTS : PROJECTS.filter(p => p.tags.some(t => t === active));

  return (
    <section id="projects" className="projects">
      <div className="container">
        <p className="section-label">Projects</p>
        <h2 className="section-title">Things I've Built</h2>
        <p className="section-subtitle">A selection of projects I'm proud of.</p>
        <div className="projects__filters">
          {FILTERS.map(f => (
            <button key={f} className={`projects__filter ${active === f ? 'projects__filter--active' : ''}`}
              onClick={() => setActive(f)}>{f}</button>
          ))}
        </div>
        <div className="projects__grid" ref={ref}>
          {filtered.map((p, i) => <ProjectCard key={p.title} {...p} index={i} visible={visible} />)}
        </div>
      </div>
    </section>
  );
}
export default Projects;
EOF

# Add award style to Projects.css
cat >> src/components/Projects.css << 'EOF'
.project-card__award {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  color: var(--amber);
  margin-top: -0.25rem;
}
EOF

echo "✅ Resume data fully integrated!"
