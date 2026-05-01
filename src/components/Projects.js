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
