#!/bin/bash

# Hero.js
cat > src/components/Hero.js << 'EOF'
import React, { useState, useEffect } from 'react';
import Button from './Button';
import './Hero.css';

const NAME = 'Zoheb Khan';
const ROLES = ['Software Developer', 'CS Rising Senior', 'Android Developer', 'Problem Solver'];
const TAGLINE = "I'm a Computer Science rising senior at Pace University who learns best by building things.";
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
  graduation: "Spring 2026",
  focus: [
    "Android Development",
    "Web Development",
    "Problem Solving",
  ],
  currentlyLearning: [
    "React",
    "Node.js",
    "Jetpack Compose",
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

# Navbar.js
cat > src/components/Navbar.js << 'EOF'
import React, { useState, useEffect } from 'react';
import './Navbar.css';

const NAV_LINKS = [
  { label: 'about', href: '#about' },
  { label: 'skills', href: '#skills' },
  { label: 'projects', href: '#projects' },
  { label: 'contact', href: '#contact' },
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

# About.js
cat > src/components/About.js << 'EOF'
import React from 'react';
import Button from './Button';
import './About.css';

const BIO = "I'm a Computer Science rising senior at Pace University who learns best by building things. I've worked with Python, Java, Kotlin, SQL, and Android development, and what I enjoy most is solving problems one fix at a time. I'm actively looking for a software engineering internship where I can contribute to real projects and keep growing.";

const HIGHLIGHTS = [
  { label: 'Pace University', icon: '🎓' },
  { label: 'Android Developer', icon: '📱' },
  { label: 'Quick Learner', icon: '🚀' },
  { label: 'Open to Internships', icon: '💼' },
];

const RESUME_URL = '#';

function StatCard({ number, label }) {
  return (
    <div className="stat-card">
      <span className="stat-card__num">{number}</span>
      <span className="stat-card__label">{label}</span>
    </div>
  );
}

function About() {
  return (
    <section id="about" className="about">
      <div className="container">
        <p className="section-label">About Me</p>
        <div className="about__grid">
          <div className="about__text">
            <h2 className="section-title">Who I Am</h2>
            <p className="about__para">{BIO}</p>
            <div className="about__tags">
              {HIGHLIGHTS.map(h => (
                <span key={h.label} className="about__tag">
                  <span aria-hidden="true">{h.icon}</span> {h.label}
                </span>
              ))}
            </div>
            <div style={{ marginTop: '2rem' }}>
              <Button href={RESUME_URL} variant="outline" external>Download Resume</Button>
            </div>
          </div>
          <div className="about__stats">
            <StatCard number="6+" label="Projects Built" />
            <StatCard number="5+" label="Languages Used" />
            <StatCard number="3+" label="Years Coding" />
            <StatCard number="∞" label="Bugs Fixed" />
          </div>
        </div>
      </div>
    </section>
  );
}
export default About;
EOF

# Skills.js - no percentages, tag style
cat > src/components/Skills.js << 'EOF'
import React from 'react';
import './Skills.css';

const SKILL_CATEGORIES = [
  {
    title: 'Languages',
    skills: ['Python', 'Java', 'Kotlin', 'JavaScript', 'HTML / CSS', 'SQL'],
  },
  {
    title: 'Frameworks & Libraries',
    skills: ['React', 'Android SDK', 'Jetpack Compose', 'Node.js'],
  },
  {
    title: 'Tools & Platforms',
    skills: ['Git / GitHub', 'Android Studio', 'VS Code', 'Linux / CLI'],
  },
  {
    title: 'Concepts',
    skills: ['Object-Oriented Programming', 'REST APIs', 'Data Structures & Algorithms', 'Mobile Development'],
  },
];

function Skills() {
  return (
    <section id="skills" className="skills">
      <div className="container">
        <p className="section-label">Skills</p>
        <h2 className="section-title">What I Work With</h2>
        <p className="section-subtitle">The tools, languages, and concepts I use to build things.</p>
        <div className="skills__grid">
          {SKILL_CATEGORIES.map(cat => (
            <div key={cat.title} className="skills__category">
              <h3 className="skills__cat-title">{cat.title}</h3>
              <div className="skills__tags">
                {cat.skills.map(s => (
                  <span key={s} className="skills__tag">{s}</span>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
export default Skills;
EOF

cat > src/components/Skills.css << 'EOF'
.skills__grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:1.5rem}
.skills__category{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-lg);padding:1.75rem;transition:border-color var(--transition)}
.skills__category:hover{border-color:var(--border-accent)}
.skills__cat-title{font-family:var(--font-mono);font-size:0.78rem;font-weight:700;color:var(--accent);text-transform:uppercase;letter-spacing:0.1em;margin-bottom:1.25rem;padding-bottom:0.75rem;border-bottom:1px solid var(--border)}
.skills__tags{display:flex;flex-wrap:wrap;gap:0.5rem}
.skills__tag{font-family:var(--font-mono);font-size:0.78rem;padding:0.35rem 0.8rem;background:var(--bg-hover);border:1px solid var(--border);border-radius:100px;color:var(--text-secondary);transition:border-color var(--transition),color var(--transition)}
.skills__tag:hover{border-color:var(--border-accent);color:var(--text-primary)}
EOF

# Projects.js
cat > src/components/Projects.js << 'EOF'
import React, { useState } from 'react';
import Button from './Button';
import './Projects.css';

const PROJECTS = [
  {
    title: 'Spotify Playlist Analyzer',
    description: 'A tool that analyzes Spotify playlists and surfaces insights about listening habits, top genres, and audio features using the Spotify API.',
    tags: ['Python', 'API', 'Data'],
    github: 'https://github.com/Zo3945',
    live: null,
    featured: true,
  },
  {
    title: 'WiCyS Pace Chapter Website',
    description: 'Designed and built the website for the Women in Cybersecurity chapter at Pace University. A real, live site used by the organization.',
    tags: ['HTML', 'CSS', 'JavaScript'],
    github: 'https://github.com/Zo3945',
    live: null,
    featured: true,
  },
  {
    title: 'Snakes & Ladders',
    description: 'A fully functional Snakes & Ladders board game built in Kotlin using Jetpack Compose for the UI. Supports multiplayer on a single device.',
    tags: ['Kotlin', 'Jetpack Compose', 'Android'],
    github: 'https://github.com/Zo3945',
    live: null,
    featured: false,
  },
  {
    title: 'Android Calendar App',
    description: 'A calendar-style Android app with event scheduling, reminders, and a clean material design interface built in Java.',
    tags: ['Java', 'Android', 'Android Studio'],
    github: 'https://github.com/Zo3945',
    live: null,
    featured: false,
  },
  {
    title: 'Candy Crush–Style Game',
    description: 'A match-3 puzzle game for Android inspired by Candy Crush. Built with Java and the Android SDK, featuring animations and score tracking.',
    tags: ['Java', 'Android', 'Game Dev'],
    github: 'https://github.com/Zo3945',
    live: null,
    featured: false,
  },
  {
    title: 'Driving Simulation',
    description: 'A driving simulation project built to explore physics-based movement and real-time rendering concepts.',
    tags: ['Java', 'Simulation'],
    github: 'https://github.com/Zo3945',
    live: null,
    featured: false,
  },
];

const FILTERS = ['All', 'Python', 'Kotlin', 'Java', 'Android', 'JavaScript'];

function ProjectCard({ title, description, tags, github, live, featured }) {
  return (
    <div className={`project-card ${featured ? 'project-card--featured' : ''}`}>
      {featured && <span className="project-card__badge">Featured</span>}
      <h3 className="project-card__title">{title}</h3>
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
        <div className="projects__grid">
          {filtered.map(p => <ProjectCard key={p.title} {...p} />)}
        </div>
      </div>
    </section>
  );
}
export default Projects;
EOF

# Contact.js
cat > src/components/Contact.js << 'EOF'
import React from 'react';
import Button from './Button';
import './Contact.css';

const EMAIL = 'Zohebk3945@gmail.com';
const GITHUB = 'https://github.com/Zo3945';
const LINKEDIN = 'https://www.linkedin.com/in/zoheb-khan123/';
const LOCATION = 'New York, NY';

const CONTACT_LINKS = [
  { label: 'Email', value: 'Zohebk3945@gmail.com', href: `mailto:${EMAIL}`, icon: '✉', show: true },
  { label: 'GitHub', value: 'Zo3945', href: GITHUB, icon: '⌥', show: true, external: true },
  { label: 'LinkedIn', value: 'zoheb-khan123', href: LINKEDIN, icon: '◈', show: true, external: true },
];

function ContactCard({ label, value, href, icon, external }) {
  return (
    <a className="contact-card" href={href}
      target={external ? '_blank' : undefined}
      rel={external ? 'noopener noreferrer' : undefined}>
      <span className="contact-card__icon" aria-hidden="true">{icon}</span>
      <div className="contact-card__text">
        <span className="contact-card__label">{label}</span>
        <span className="contact-card__value">{value}</span>
      </div>
      <span className="contact-card__arrow" aria-hidden="true">→</span>
    </a>
  );
}

function Contact() {
  return (
    <section id="contact" className="contact">
      <div className="container">
        <p className="section-label">Contact</p>
        <h2 className="section-title">Let's Connect</h2>
        <p className="section-subtitle">I'm always open to new opportunities, internships, or just a good tech conversation.</p>
        <div className="contact__layout">
          <div className="contact__links">
            {CONTACT_LINKS.filter(c => c.show).map(c => <ContactCard key={c.label} {...c} />)}
          </div>
          <div className="contact__cta">
            <div className="contact__cta-inner">
              <p className="contact__cta-label">// open to opportunities</p>
              <h3 className="contact__cta-heading">Looking for a developer?</h3>
              <p className="contact__cta-text">I'm actively looking for a software engineering internship where I can contribute to real projects and keep growing. Let's talk!</p>
              <div style={{ display: 'flex', gap: '0.75rem', flexWrap: 'wrap' }}>
                <Button href={`mailto:${EMAIL}`} variant="primary">Say Hello</Button>
                <Button href={LINKEDIN} variant="ghost" external>View LinkedIn</Button>
              </div>
              <p className="contact__location"><span aria-hidden="true">◎</span> {LOCATION}</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
export default Contact;
EOF

# Footer.js
cat > src/components/Footer.js << 'EOF'
import React from 'react';
import './Footer.css';

const YEAR = new Date().getFullYear();
const NAME = 'Zoheb Khan';

function Footer() {
  const scrollToTop = () => window.scrollTo({ top: 0, behavior: 'smooth' });
  return (
    <footer className="footer">
      <div className="container footer__inner">
        <p className="footer__copy"><span className="footer__mono">© {YEAR}</span> {NAME} — Built with React</p>
        <button className="footer__top" onClick={scrollToTop} aria-label="Back to top">↑ back to top</button>
      </div>
    </footer>
  );
}
export default Footer;
EOF

echo "✅ Portfolio personalized for Zoheb Khan!"
