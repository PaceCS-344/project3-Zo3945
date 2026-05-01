#!/bin/bash
mkdir -p src/components src/styles

# App.js
cat > src/App.js << 'EOF'
import React from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import About from './components/About';
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

# styles/App.css
cat > src/styles/App.css << 'EOF'
@import url('https://fonts.googleapis.com/css2?family=Space+Mono:ital,wght@0,400;0,700;1,400&family=DM+Sans:wght@300;400;500;600&display=swap');
:root {
  --bg-primary: #0a0a0f; --bg-secondary: #111118; --bg-card: #16161f; --bg-hover: #1e1e2a;
  --accent: #7c6aff; --accent-dim: rgba(124,106,255,0.15); --accent-glow: rgba(124,106,255,0.35);
  --green: #4ade80; --amber: #fbbf24;
  --text-primary: #f0eeff; --text-secondary: #9090b0; --text-muted: #555570;
  --border: rgba(255,255,255,0.07); --border-accent: rgba(124,106,255,0.3);
  --font-mono: 'Space Mono', monospace; --font-sans: 'DM Sans', sans-serif;
  --radius: 8px; --radius-lg: 14px; --transition: 0.2s ease;
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{background:var(--bg-primary);color:var(--text-primary);font-family:var(--font-sans);font-size:16px;line-height:1.7;-webkit-font-smoothing:antialiased}
.app{min-height:100vh}
.container{max-width:1100px;margin:0 auto;padding:0 2rem}
section{padding:6rem 0}
.section-label{font-family:var(--font-mono);font-size:0.75rem;color:var(--accent);text-transform:uppercase;letter-spacing:0.12em;margin-bottom:0.75rem;display:flex;align-items:center;gap:0.5rem}
.section-label::before{content:'//';opacity:0.5}
.section-title{font-size:clamp(1.8rem,3vw,2.5rem);font-weight:600;color:var(--text-primary);margin-bottom:1rem}
.section-subtitle{color:var(--text-secondary);max-width:540px;margin-bottom:3rem;font-size:1.05rem}
a{color:inherit;text-decoration:none}
button{cursor:pointer;border:none;background:none;font-family:var(--font-sans)}
::-webkit-scrollbar{width:6px}
::-webkit-scrollbar-track{background:var(--bg-primary)}
::-webkit-scrollbar-thumb{background:var(--border-accent);border-radius:3px}
@keyframes fadeUp{from{opacity:0;transform:translateY(24px)}to{opacity:1;transform:translateY(0)}}
@keyframes blink{0%,100%{opacity:1}50%{opacity:0}}
EOF

# Button.js
cat > src/components/Button.js << 'EOF'
import React from 'react';
import './Button.css';

function Button({ variant = 'primary', onClick, href, external, children, disabled }) {
  const cls = `btn btn--${variant}`;
  if (href) return (
    <a className={cls} href={href} target={external?'_blank':undefined} rel={external?'noopener noreferrer':undefined}>
      {children}{external && <span className="btn__external" aria-hidden="true">↗</span>}
    </a>
  );
  return <button className={cls} onClick={onClick} disabled={disabled}>{children}</button>;
}
export default Button;
EOF

cat > src/components/Button.css << 'EOF'
.btn{display:inline-flex;align-items:center;gap:0.4rem;padding:0.65rem 1.4rem;border-radius:var(--radius);font-family:var(--font-mono);font-size:0.82rem;font-weight:700;letter-spacing:0.02em;transition:transform 0.15s ease,box-shadow 0.15s ease,background 0.15s ease;cursor:pointer;border:1px solid transparent;text-decoration:none}
.btn:active{transform:scale(0.97)}
.btn--primary{background:var(--accent);color:#fff;border-color:var(--accent)}
.btn--primary:hover{background:#9080ff;box-shadow:0 0 20px var(--accent-glow);transform:translateY(-1px)}
.btn--ghost{background:transparent;color:var(--text-secondary);border-color:var(--border)}
.btn--ghost:hover{color:var(--text-primary);border-color:rgba(255,255,255,0.2);background:var(--bg-hover)}
.btn--outline{background:transparent;color:var(--accent);border-color:var(--border-accent)}
.btn--outline:hover{background:var(--accent-dim);box-shadow:0 0 12px var(--accent-glow)}
.btn:disabled{opacity:0.4;cursor:not-allowed}
.btn__external{font-size:0.75rem;opacity:0.7}
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
          <span className="navbar__logo-bracket">{'<'}</span>YourName<span className="navbar__logo-bracket">{' />'}</span>
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

cat > src/components/Navbar.css << 'EOF'
.navbar{position:fixed;top:0;left:0;right:0;z-index:100;padding:1.25rem 0;transition:background 0.3s ease,padding 0.3s ease,border-color 0.3s ease;border-bottom:1px solid transparent}
.navbar--scrolled{background:rgba(10,10,15,0.9);backdrop-filter:blur(12px);border-bottom-color:var(--border);padding:0.85rem 0}
.navbar__inner{display:flex;align-items:center;justify-content:space-between}
.navbar__logo{font-family:var(--font-mono);font-size:1rem;font-weight:700;color:var(--text-primary);transition:color var(--transition)}
.navbar__logo:hover{color:var(--accent)}
.navbar__logo-bracket{color:var(--accent)}
.navbar__links{display:flex;align-items:center;gap:0.25rem}
.navbar__link{font-family:var(--font-mono);font-size:0.8rem;color:var(--text-secondary);padding:0.4rem 0.9rem;border-radius:var(--radius);transition:color var(--transition),background var(--transition)}
.navbar__link:hover{color:var(--text-primary);background:var(--bg-hover)}
.navbar__link-num{color:var(--accent);opacity:0.6}
.navbar__hamburger{display:none;flex-direction:column;gap:5px;padding:4px}
.navbar__hamburger span{display:block;width:22px;height:2px;background:var(--text-secondary);border-radius:2px;transition:transform 0.25s ease,opacity 0.25s ease}
.navbar__hamburger--open span:nth-child(1){transform:translateY(7px) rotate(45deg)}
.navbar__hamburger--open span:nth-child(2){opacity:0}
.navbar__hamburger--open span:nth-child(3){transform:translateY(-7px) rotate(-45deg)}
@media(max-width:640px){.navbar__hamburger{display:flex}.navbar__links{display:none;position:absolute;top:100%;left:0;right:0;flex-direction:column;align-items:flex-start;background:var(--bg-secondary);border-bottom:1px solid var(--border);padding:0.75rem 1.5rem 1rem;gap:0.1rem}.navbar__links--open{display:flex}.navbar__link{font-size:0.9rem;padding:0.6rem 0.75rem;width:100%}}
EOF

# Hero.js
cat > src/components/Hero.js << 'EOF'
import React, { useState, useEffect } from 'react';
import Button from './Button';
import './Hero.css';

const NAME = 'Your Name';
const ROLES = ['Software Developer', 'Problem Solver', 'Creative Coder', 'CS Student'];
const TAGLINE = "I build things for the web — and everything around it.";
const GITHUB_URL = 'https://github.com/yourusername';
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
  name: "${NAME}",
  role: "Software Developer",
  focus: [
    "Web Development",
    "Data & AI",
    "Clean Code",
  ],
  currentlyLearning: [
    "React",
    "Node.js",
    "System Design",
  ],
  funFact: "I debug with
    console.log and no shame",
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

cat > src/components/Hero.css << 'EOF'
.hero{min-height:100vh;display:flex;flex-direction:column;justify-content:center;padding:8rem 0 4rem;position:relative;overflow:hidden}
.hero__bg-grid{position:absolute;inset:0;background-image:linear-gradient(var(--border) 1px,transparent 1px),linear-gradient(90deg,var(--border) 1px,transparent 1px);background-size:48px 48px;mask-image:radial-gradient(ellipse 80% 60% at 50% 50%,black 30%,transparent 100%);-webkit-mask-image:radial-gradient(ellipse 80% 60% at 50% 50%,black 30%,transparent 100%);pointer-events:none}
.hero__inner{display:grid;grid-template-columns:1fr 1fr;align-items:center;gap:4rem;position:relative;z-index:1}
.hero__content{animation:fadeUp 0.7s ease both}
.hero__greeting{font-family:var(--font-mono);font-size:0.9rem;color:var(--text-secondary);margin-bottom:0.75rem}
.hero__prompt{color:var(--green)}
.hero__name{font-size:clamp(2.5rem,5vw,4rem);font-weight:600;letter-spacing:-0.03em;line-height:1.1;margin-bottom:0.5rem;background:linear-gradient(135deg,var(--text-primary) 60%,var(--accent));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;animation:fadeUp 0.7s 0.15s ease both}
.hero__role{font-family:var(--font-mono);font-size:1.15rem;color:var(--accent);margin-bottom:1.25rem;min-height:1.7em;animation:fadeUp 0.7s 0.2s ease both}
.hero__cursor{animation:blink 0.9s step-end infinite;color:var(--accent);font-weight:300}
.hero__tagline{font-size:1.1rem;color:var(--text-secondary);max-width:420px;margin-bottom:2.5rem;animation:fadeUp 0.7s 0.25s ease both}
.hero__actions{display:flex;gap:1rem;flex-wrap:wrap;animation:fadeUp 0.7s 0.3s ease both}
.hero__terminal{animation:fadeUp 0.8s 0.35s ease both}
.terminal{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-lg);overflow:hidden;box-shadow:0 24px 60px rgba(0,0,0,0.5)}
.terminal__bar{background:var(--bg-secondary);padding:0.65rem 1rem;display:flex;align-items:center;gap:6px;border-bottom:1px solid var(--border)}
.terminal__dot{width:12px;height:12px;border-radius:50%}
.terminal__dot--red{background:#ff5f57}
.terminal__dot--yellow{background:#ffbd2e}
.terminal__dot--green{background:#28ca41}
.terminal__title{font-family:var(--font-mono);font-size:0.72rem;color:var(--text-muted);margin:0 auto}
.terminal__body{padding:1.5rem}
.terminal__code{font-family:var(--font-mono);font-size:0.82rem;line-height:1.8;color:var(--text-secondary);white-space:pre-wrap;word-break:break-word}
.hero__scroll-hint{position:absolute;bottom:2rem;left:50%;transform:translateX(-50%);display:flex;flex-direction:column;align-items:center;gap:6px;font-family:var(--font-mono);font-size:0.65rem;color:var(--text-muted);letter-spacing:0.1em;text-transform:uppercase;animation:fadeUp 1s 1s both}
.hero__scroll-arrow{width:1px;height:40px;background:linear-gradient(to bottom,var(--text-muted),transparent)}
@media(max-width:800px){.hero__inner{grid-template-columns:1fr;gap:3rem}.hero__terminal{display:none}}
EOF

# About.js
cat > src/components/About.js << 'EOF'
import React from 'react';
import Button from './Button';
import './About.css';

const BIO_PARAGRAPHS = [
  "I'm a Computer Science student passionate about building software that solves real problems. Whether it's a full-stack web app, a data pipeline, or an AI-powered tool — I love getting deep into a problem and crafting something that works well.",
  "When I'm not coding, you'll find me exploring new technologies, contributing to projects, or collaborating with others who care about quality work. I'm always looking for opportunities to learn and grow.",
];

const HIGHLIGHTS = [
  { label: 'CS Student', icon: '🎓' },
  { label: 'Open Source Fan', icon: '⚡' },
  { label: 'Quick Learner', icon: '🚀' },
  { label: 'Team Player', icon: '🤝' },
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
            {BIO_PARAGRAPHS.map((p, i) => <p key={i} className="about__para">{p}</p>)}
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
            <StatCard number="10+" label="Projects Built" />
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

cat > src/components/About.css << 'EOF'
.about{background:var(--bg-secondary);border-top:1px solid var(--border);border-bottom:1px solid var(--border)}
.about__grid{display:grid;grid-template-columns:1.4fr 1fr;gap:5rem;align-items:start}
.about__para{color:var(--text-secondary);margin-bottom:1.1rem;font-size:1.05rem;line-height:1.8}
.about__tags{display:flex;flex-wrap:wrap;gap:0.6rem;margin-top:1.75rem}
.about__tag{display:inline-flex;align-items:center;gap:0.4rem;padding:0.35rem 0.85rem;background:var(--bg-card);border:1px solid var(--border);border-radius:100px;font-size:0.82rem;color:var(--text-secondary);font-family:var(--font-mono);transition:border-color var(--transition),color var(--transition)}
.about__tag:hover{border-color:var(--border-accent);color:var(--text-primary)}
.about__stats{display:grid;grid-template-columns:1fr 1fr;gap:1rem;padding-top:0.5rem}
.stat-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-lg);padding:1.5rem 1.25rem;display:flex;flex-direction:column;gap:0.25rem;transition:border-color var(--transition),transform var(--transition)}
.stat-card:hover{border-color:var(--border-accent);transform:translateY(-2px)}
.stat-card__num{font-family:var(--font-mono);font-size:2rem;font-weight:700;color:var(--accent);line-height:1}
.stat-card__label{font-size:0.8rem;color:var(--text-muted);font-family:var(--font-mono)}
@media(max-width:800px){.about__grid{grid-template-columns:1fr;gap:3rem}}
EOF

# Skills.js
cat > src/components/Skills.js << 'EOF'
import React from 'react';
import './Skills.css';

const SKILL_CATEGORIES = [
  {
    title: 'Languages',
    skills: [
      { name: 'JavaScript', level: 80 },
      { name: 'Python', level: 75 },
      { name: 'Java', level: 70 },
      { name: 'HTML / CSS', level: 90 },
      { name: 'SQL', level: 65 },
    ],
  },
  {
    title: 'Frameworks & Libraries',
    skills: [
      { name: 'React', level: 70 },
      { name: 'Node.js', level: 60 },
      { name: 'Express', level: 55 },
      { name: 'Pandas', level: 65 },
    ],
  },
  {
    title: 'Tools & Platforms',
    skills: [
      { name: 'Git / GitHub', level: 85 },
      { name: 'VS Code', level: 90 },
      { name: 'Linux / CLI', level: 70 },
      { name: 'Figma', level: 50 },
    ],
  },
  {
    title: 'Concepts',
    skills: [
      { name: 'Data Structures & Algorithms', level: 75 },
      { name: 'REST APIs', level: 70 },
      { name: 'OOP', level: 80 },
      { name: 'Agile / Scrum', level: 60 },
    ],
  },
];

function SkillBar({ name, level }) {
  return (
    <div className="skill-bar">
      <div className="skill-bar__header">
        <span className="skill-bar__name">{name}</span>
        <span className="skill-bar__pct">{level}%</span>
      </div>
      <div className="skill-bar__track">
        <div className="skill-bar__fill" style={{ '--level': `${level}%` }} />
      </div>
    </div>
  );
}

function Skills() {
  return (
    <section id="skills" className="skills">
      <div className="container">
        <p className="section-label">Skills</p>
        <h2 className="section-title">What I Work With</h2>
        <p className="section-subtitle">A snapshot of the tools, languages, and concepts I use to build things.</p>
        <div className="skills__grid">
          {SKILL_CATEGORIES.map(cat => (
            <div key={cat.title} className="skills__category">
              <h3 className="skills__cat-title">{cat.title}</h3>
              <div className="skills__bars">
                {cat.skills.map(s => <SkillBar key={s.name} name={s.name} level={s.level} />)}
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
.skills__grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:2rem}
.skills__category{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-lg);padding:1.75rem;transition:border-color var(--transition)}
.skills__category:hover{border-color:var(--border-accent)}
.skills__cat-title{font-family:var(--font-mono);font-size:0.78rem;font-weight:700;color:var(--accent);text-transform:uppercase;letter-spacing:0.1em;margin-bottom:1.25rem;padding-bottom:0.75rem;border-bottom:1px solid var(--border)}
.skills__bars{display:flex;flex-direction:column;gap:0.9rem}
.skill-bar__header{display:flex;justify-content:space-between;margin-bottom:0.35rem}
.skill-bar__name{font-size:0.85rem;color:var(--text-secondary)}
.skill-bar__pct{font-family:var(--font-mono);font-size:0.72rem;color:var(--text-muted)}
.skill-bar__track{height:4px;background:var(--bg-hover);border-radius:2px;overflow:hidden}
.skill-bar__fill{height:100%;width:var(--level);background:linear-gradient(90deg,var(--accent) 0%,#a78bfa 100%);border-radius:2px;transform-origin:left;animation:growBar 1s cubic-bezier(0.4,0,0.2,1) both}
@keyframes growBar{from{transform:scaleX(0)}to{transform:scaleX(1)}}
EOF

# Projects.js
cat > src/components/Projects.js << 'EOF'
import React, { useState } from 'react';
import Button from './Button';
import './Projects.css';

const PROJECTS = [
  {
    title: 'Portfolio Website',
    description: 'This site! Built with React, featuring smooth-scroll navigation, animated components, and a modular component architecture.',
    tags: ['React', 'CSS', 'JavaScript'],
    github: 'https://github.com/yourusername/portfolio',
    live: null,
    featured: true,
  },
  {
    title: 'Unicode Grid Decoder',
    description: 'Python script that parses a Google Doc table of Unicode characters with x/y coordinates and renders them as a 2D grid to reveal a hidden message. Uses BeautifulSoup for reliable HTML parsing.',
    tags: ['Python', 'BeautifulSoup', 'HTML Parsing'],
    github: 'https://github.com/yourusername/unicode-grid',
    live: null,
    featured: true,
  },
  {
    title: 'FastAPI REST Service',
    description: 'A RESTful API built with FastAPI and Python. Includes authentication, CRUD endpoints, and auto-generated OpenAPI docs.',
    tags: ['Python', 'FastAPI', 'REST API'],
    github: 'https://github.com/yourusername/fastapi-service',
    live: null,
    featured: false,
  },
  {
    title: 'Data Analysis Dashboard',
    description: 'Interactive dashboard for exploring and visualizing datasets. Built with Python and Pandas for data wrangling.',
    tags: ['Python', 'Pandas', 'Data Viz'],
    github: 'https://github.com/yourusername/dashboard',
    live: null,
    featured: false,
  },
  {
    title: 'CLI Task Manager',
    description: 'A command-line task management tool built in Python. Supports priorities, due dates, tags, and persistent storage.',
    tags: ['Python', 'CLI', 'JSON'],
    github: 'https://github.com/yourusername/cli-tasks',
    live: null,
    featured: false,
  },
  {
    title: 'Web Scraper Toolkit',
    description: 'Modular web scraping utilities for collecting structured data from various sources. Includes rate limiting and retry logic.',
    tags: ['Python', 'Requests', 'BeautifulSoup'],
    github: 'https://github.com/yourusername/scraper',
    live: null,
    featured: false,
  },
];

const FILTERS = ['All', 'React', 'Python', 'JavaScript'];

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
        <p className="section-subtitle">A selection of projects I'm proud of — click GitHub to see the full source.</p>
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

cat > src/components/Projects.css << 'EOF'
.projects{background:var(--bg-secondary);border-top:1px solid var(--border);border-bottom:1px solid var(--border)}
.projects__filters{display:flex;gap:0.5rem;flex-wrap:wrap;margin-bottom:2.5rem}
.projects__filter{font-family:var(--font-mono);font-size:0.78rem;padding:0.4rem 1rem;border-radius:100px;border:1px solid var(--border);color:var(--text-muted);background:transparent;cursor:pointer;transition:all var(--transition)}
.projects__filter:hover{color:var(--text-secondary);border-color:rgba(255,255,255,0.15)}
.projects__filter--active{background:var(--accent-dim);border-color:var(--border-accent);color:var(--accent)}
.projects__grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:1.25rem}
.project-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-lg);padding:1.75rem;display:flex;flex-direction:column;gap:0.75rem;position:relative;transition:border-color var(--transition),transform var(--transition),box-shadow var(--transition)}
.project-card:hover{border-color:var(--border-accent);transform:translateY(-3px);box-shadow:0 12px 40px rgba(0,0,0,0.3)}
.project-card--featured{border-color:rgba(124,106,255,0.2)}
.project-card__badge{position:absolute;top:1.25rem;right:1.25rem;font-family:var(--font-mono);font-size:0.65rem;text-transform:uppercase;letter-spacing:0.08em;color:var(--accent);background:var(--accent-dim);border:1px solid var(--border-accent);padding:0.2rem 0.6rem;border-radius:100px}
.project-card__title{font-size:1.1rem;font-weight:600;color:var(--text-primary);padding-right:5rem}
.project-card__desc{font-size:0.88rem;color:var(--text-secondary);line-height:1.7;flex:1}
.project-card__tags{display:flex;flex-wrap:wrap;gap:0.4rem}
.project-card__tag{font-family:var(--font-mono);font-size:0.7rem;padding:0.2rem 0.6rem;background:var(--bg-hover);border-radius:4px;color:var(--text-muted);border:1px solid var(--border)}
.project-card__actions{display:flex;gap:0.6rem;padding-top:0.5rem}
EOF

# Contact.js
cat > src/components/Contact.js << 'EOF'
import React from 'react';
import Button from './Button';
import './Contact.css';

const EMAIL = 'yourname@email.com';
const GITHUB = 'https://github.com/yourusername';
const LINKEDIN = 'https://linkedin.com/in/yourprofile';
const LOCATION = 'New York, NY';
const TWITTER = null;

const CONTACT_LINKS = [
  { label: 'Email', value: EMAIL, href: `mailto:${EMAIL}`, icon: '✉', show: true },
  { label: 'GitHub', value: 'yourusername', href: GITHUB, icon: '⌥', show: true, external: true },
  { label: 'LinkedIn', value: 'yourprofile', href: LINKEDIN, icon: '◈', show: true, external: true },
  { label: 'Twitter / X', value: '@yourhandle', href: TWITTER, icon: '◇', show: !!TWITTER, external: true },
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
        <p className="section-subtitle">I'm always open to new opportunities, collaborations, or just a good tech conversation.</p>
        <div className="contact__layout">
          <div className="contact__links">
            {CONTACT_LINKS.filter(c => c.show).map(c => <ContactCard key={c.label} {...c} />)}
          </div>
          <div className="contact__cta">
            <div className="contact__cta-inner">
              <p className="contact__cta-label">// open to opportunities</p>
              <h3 className="contact__cta-heading">Looking for a developer?</h3>
              <p className="contact__cta-text">I'm currently open to internship and entry-level software developer roles. Let's build something together.</p>
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

cat > src/components/Contact.css << 'EOF'
.contact__layout{display:grid;grid-template-columns:1fr 1.2fr;gap:3rem;align-items:start}
.contact__links{display:flex;flex-direction:column;gap:0.75rem}
.contact-card{display:flex;align-items:center;gap:1rem;background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-lg);padding:1.1rem 1.25rem;text-decoration:none;transition:border-color var(--transition),transform var(--transition),background var(--transition)}
.contact-card:hover{border-color:var(--border-accent);background:var(--bg-hover);transform:translateX(4px)}
.contact-card:hover .contact-card__arrow{opacity:1;transform:translateX(4px)}
.contact-card__icon{font-size:1.2rem;width:2.2rem;height:2.2rem;display:flex;align-items:center;justify-content:center;background:var(--accent-dim);border:1px solid var(--border-accent);border-radius:var(--radius);color:var(--accent);flex-shrink:0}
.contact-card__text{flex:1;display:flex;flex-direction:column;gap:0.1rem}
.contact-card__label{font-family:var(--font-mono);font-size:0.68rem;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.08em}
.contact-card__value{font-size:0.9rem;color:var(--text-secondary)}
.contact-card__arrow{font-size:1rem;color:var(--text-muted);opacity:0;transition:opacity var(--transition),transform var(--transition)}
.contact__cta{position:sticky;top:7rem}
.contact__cta-inner{background:var(--bg-card);border:1px solid var(--border-accent);border-radius:var(--radius-lg);padding:2.25rem;display:flex;flex-direction:column;gap:1rem}
.contact__cta-label{font-family:var(--font-mono);font-size:0.72rem;color:var(--accent);opacity:0.7}
.contact__cta-heading{font-size:1.45rem;font-weight:600;color:var(--text-primary);line-height:1.3}
.contact__cta-text{font-size:0.92rem;color:var(--text-secondary);line-height:1.7}
.contact__location{font-family:var(--font-mono);font-size:0.75rem;color:var(--text-muted);display:flex;align-items:center;gap:0.4rem;padding-top:0.25rem}
@media(max-width:800px){.contact__layout{grid-template-columns:1fr}.contact__cta{position:static}}
EOF

# Footer.js
cat > src/components/Footer.js << 'EOF'
import React from 'react';
import './Footer.css';

const YEAR = new Date().getFullYear();
const NAME = 'Your Name';

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

cat > src/components/Footer.css << 'EOF'
.footer{background:var(--bg-secondary);border-top:1px solid var(--border);padding:1.5rem 0}
.footer__inner{display:flex;align-items:center;justify-content:space-between;gap:1rem;flex-wrap:wrap}
.footer__copy{font-size:0.82rem;color:var(--text-muted)}
.footer__mono{font-family:var(--font-mono)}
.footer__top{font-family:var(--font-mono);font-size:0.75rem;color:var(--text-muted);cursor:pointer;background:none;border:none;transition:color var(--transition);letter-spacing:0.05em}
.footer__top:hover{color:var(--accent)}
EOF

echo "✅ All files created successfully!"
