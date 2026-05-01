#!/bin/bash

# Fix resume download in Button.js - add download attribute support
cat > src/components/Button.js << 'EOF'
import React from 'react';
import './Button.css';

function Button({ variant = 'primary', onClick, href, external, download, children, disabled }) {
  const cls = `btn btn--${variant}`;
  if (href) return (
    <a className={cls} href={href}
      target={external ? '_blank' : undefined}
      rel={external ? 'noopener noreferrer' : undefined}
      download={download || undefined}>
      {children}{external && <span className="btn__external" aria-hidden="true">↗</span>}
    </a>
  );
  return <button className={cls} onClick={onClick} disabled={disabled}>{children}</button>;
}
export default Button;
EOF

# Fix About.js resume button to use download prop
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
              <Button href={RESUME_URL} variant="outline" download>Download Resume</Button>
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

# Skills with scroll animations
cat > src/components/Skills.js << 'EOF'
import React from 'react';
import { useScrollAnimation } from './useScrollAnimation';
import './Skills.css';

const SKILL_CATEGORIES = [
  { title: 'Languages', skills: ['Python', 'Java', 'Kotlin', 'JavaScript', 'HTML / CSS', 'SQL'] },
  { title: 'Frameworks & Libraries', skills: ['React', 'Android SDK', 'Jetpack Compose', 'Node.js'] },
  { title: 'Tools & Platforms', skills: ['Git / GitHub', 'Android Studio', 'VS Code', 'Linux / CLI'] },
  { title: 'Concepts', skills: ['Object-Oriented Programming', 'REST APIs', 'Data Structures & Algorithms', 'Mobile Development'] },
];

function Skills() {
  const [ref, visible] = useScrollAnimation(0.1);
  return (
    <section id="skills" className="skills">
      <div className="container">
        <p className="section-label">Skills</p>
        <h2 className="section-title">What I Work With</h2>
        <p className="section-subtitle">The tools, languages, and concepts I use to build things.</p>
        <div className="skills__grid" ref={ref}>
          {SKILL_CATEGORIES.map((cat, i) => (
            <div key={cat.title} className="skills__category"
              style={{
                opacity: visible ? 1 : 0,
                transform: visible ? 'translateY(0)' : 'translateY(40px)',
                transition: `opacity 0.6s ease ${i * 0.12}s, transform 0.6s ease ${i * 0.12}s`
              }}>
              <h3 className="skills__cat-title">{cat.title}</h3>
              <div className="skills__tags">
                {cat.skills.map((s, j) => (
                  <span key={s} className="skills__tag"
                    style={{
                      opacity: visible ? 1 : 0,
                      transform: visible ? 'scale(1)' : 'scale(0.8)',
                      transition: `opacity 0.4s ease ${i * 0.12 + j * 0.05}s, transform 0.4s ease ${i * 0.12 + j * 0.05}s`
                    }}>{s}</span>
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

# Projects with scroll animations
cat > src/components/Projects.js << 'EOF'
import React, { useState } from 'react';
import Button from './Button';
import { useScrollAnimation } from './useScrollAnimation';
import './Projects.css';

const PROJECTS = [
  {
    title: 'Women in Cybersecurity Website',
    description: 'Designed and developed a responsive website for the WiCyS chapter at Pace University. Won the Best Website Award at the Women in Cybersecurity competition.',
    tags: ['HTML', 'CSS', 'JavaScript'],
    github: 'https://github.com/Zo3945',
    live: null, featured: true, award: '🏆 Best Website Award',
  },
  {
    title: 'Snakes & Ladders',
    description: 'A fully interactive Snakes and Ladders board game built in Kotlin using Jetpack Compose, featuring dynamic board generation and multiplayer support.',
    tags: ['Kotlin', 'Jetpack Compose', 'Android'],
    github: 'https://github.com/Zo3945',
    live: null, featured: true, award: null,
  },
  {
    title: 'Driving Game',
    description: 'An interactive driving game where players control a vehicle and avoid dynamic obstacles, with collision detection, score tracking, and responsive controls.',
    tags: ['Java', 'Android', 'Game Dev'],
    github: 'https://github.com/Zo3945',
    live: null, featured: false, award: null,
  },
  {
    title: 'Spotify Playlist Analyzer',
    description: 'A tool that analyzes Spotify playlists and surfaces insights about listening habits, top genres, and audio features using the Spotify API.',
    tags: ['Python', 'API', 'Data'],
    github: 'https://github.com/Zo3945',
    live: null, featured: false, award: null,
  },
  {
    title: 'Android Calendar App',
    description: 'A calendar-style Android app with event scheduling and a clean material design interface built in Java.',
    tags: ['Java', 'Android', 'Android Studio'],
    github: 'https://github.com/Zo3945',
    live: null, featured: false, award: null,
  },
  {
    title: 'Candy Crush–Style Game',
    description: 'A match-3 puzzle game for Android inspired by Candy Crush, featuring animations and score tracking.',
    tags: ['Java', 'Android', 'Game Dev'],
    github: 'https://github.com/Zo3945',
    live: null, featured: false, award: null,
  },
];

const FILTERS = ['All', 'Python', 'Kotlin', 'Java', 'Android', 'JavaScript'];

function ProjectCard({ title, description, tags, github, live, featured, award, index, visible }) {
  return (
    <div className={`project-card ${featured ? 'project-card--featured' : ''}`}
      style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateY(0)' : 'translateY(40px)',
        transition: `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`
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

# Contact with scroll animations
cat > src/components/Contact.js << 'EOF'
import React from 'react';
import Button from './Button';
import { useScrollAnimation } from './useScrollAnimation';
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

function ContactCard({ label, value, href, icon, external, index, visible }) {
  return (
    <a className="contact-card" href={href}
      target={external ? '_blank' : undefined}
      rel={external ? 'noopener noreferrer' : undefined}
      style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateX(0)' : 'translateX(-30px)',
        transition: `opacity 0.5s ease ${index * 0.12}s, transform 0.5s ease ${index * 0.12}s`
      }}>
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
  const [ref, visible] = useScrollAnimation(0.1);
  return (
    <section id="contact" className="contact">
      <div className="container">
        <p className="section-label">Contact</p>
        <h2 className="section-title">Let's Connect</h2>
        <p className="section-subtitle">I'm always open to new opportunities, internships, or just a good tech conversation.</p>
        <div className="contact__layout" ref={ref}>
          <div className="contact__links">
            {CONTACT_LINKS.filter(c => c.show).map((c, i) => (
              <ContactCard key={c.label} {...c} index={i} visible={visible} />
            ))}
          </div>
          <div className="contact__cta"
            style={{
              opacity: visible ? 1 : 0,
              transform: visible ? 'translateY(0)' : 'translateY(30px)',
              transition: 'opacity 0.6s ease 0.35s, transform 0.6s ease 0.35s'
            }}>
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

# Experience with scroll animations + "Most Recent" badge
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
    badge: 'Most Recent',
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
    badge: null,
  },
];

function ExperienceCard({ company, role, period, location, bullets, tags, badge, index, visible }) {
  return (
    <div className={`exp-card ${badge ? 'exp-card--current' : ''}`}
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
          {badge && <span className="exp-card__badge">{badge}</span>}
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

echo "✅ Scroll animations added + resume download fixed!"
