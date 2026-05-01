import React, { useState } from 'react';
import Button from './Button';
import { useScrollAnimation } from './useScrollAnimation';
import './Projects.css';

const PROJECTS = [
  {
    title: 'Women in Cybersecurity Website',
    description: 'Designed and developed a responsive website for the WiCyS chapter at Pace University.',
    fullDescription: 'Designed and developed a fully responsive website for the Women in Cybersecurity (WiCyS) chapter at Pace University. Built with HTML, CSS, and JavaScript, the site features event listings, member spotlights, and resource pages. Won the Best Website Award at the Women in Cybersecurity competition.',
    tags: ['HTML', 'CSS', 'JavaScript'],
    github: 'https://github.com/Zo3945',
    live: null, featured: true, award: '🏆 Best Website Award',
  },
  {
    title: 'Snakes & Ladders',
    description: 'A fully interactive Snakes and Ladders board game built in Kotlin using Jetpack Compose.',
    fullDescription: 'Designed and developed a fully interactive Snakes and Ladders board game using Kotlin and Jetpack Compose for Android. Features dynamic board generation, support for multiple players, animated piece movement, and complete game logic including win detection.',
    tags: ['Kotlin', 'Jetpack Compose', 'Android'],
    github: 'https://github.com/Zo3945',
    live: null, featured: true, award: null,
  },
  {
    title: 'Driving Game',
    description: 'An interactive driving game where players control a vehicle and avoid dynamic obstacles.',
    fullDescription: 'Built an interactive driving game for Android where players control a vehicle navigating through dynamically generated obstacles. Implemented real-time collision detection, progressive difficulty scaling, score tracking, and responsive touch controls.',
    tags: ['Java', 'Android', 'Game Dev'],
    github: 'https://github.com/Zo3945',
    live: null, featured: false, award: null,
  },
  {
    title: 'Spotify Playlist Analyzer',
    description: 'A tool that analyzes Spotify playlists and surfaces insights about listening habits.',
    fullDescription: 'A Python tool that connects to the Spotify Web API to analyze playlist data. Features top genre analysis, audio feature breakdowns, listening pattern trends, and exportable reports. Uses OAuth 2.0 for Spotify authentication.',
    tags: ['Python', 'API', 'Data'],
    github: 'https://github.com/Zo3945',
    live: null, featured: false, award: null,
  },
  {
    title: 'Android Calendar App',
    description: 'A calendar-style Android app with event scheduling and a clean material design interface.',
    fullDescription: 'A full-featured calendar application for Android built in Java. Users can create, edit, and delete events with custom reminders, set recurring events, and view schedules in day, week, or month views.',
    tags: ['Java', 'Android', 'Android Studio'],
    github: 'https://github.com/Zo3945',
    live: null, featured: false, award: null,
  },
  {
    title: 'Candy Crush–Style Game',
    description: 'A match-3 puzzle game for Android inspired by Candy Crush.',
    fullDescription: 'A match-3 puzzle game for Android built with Java and the Android SDK. Features a fully animated tile-matching engine, combo detection, score multipliers, level progression, and particle effects.',
    tags: ['Java', 'Android', 'Game Dev'],
    github: 'https://github.com/Zo3945',
    live: null, featured: false, award: null,
  },
];

const FILTERS = ['All', 'Python', 'Kotlin', 'Java', 'Android', 'JavaScript'];

function ProjectCard({ title, description, fullDescription, tags, github, live, featured, award, index, visible }) {
  const [expanded, setExpanded] = useState(false);

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
      <p className="project-card__desc">{expanded ? fullDescription : description}</p>
      <button className="project-card__expand" onClick={() => setExpanded(!expanded)}>
        {expanded ? '↑ Show less' : '↓ Read more'}
      </button>
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
