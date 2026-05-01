#!/bin/bash

# Fix About.js - new bio, remove GitHub profile card (moving to repos)
cat > src/components/About.js << 'EOF'
import React from 'react';
import { useScrollAnimation, useCountUp } from './useScrollAnimation';
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

# Fix GitHubRepos.js - add profile card at top, restore read more, fix glows
cat > src/components/GitHubRepos.js << 'EOF'
import React, { useState } from 'react';
import { useGitHubRepos, useGitHubProfile } from './useGitHub';
import { useScrollAnimation } from './useScrollAnimation';
import './GitHubRepos.css';

const LANG_COLORS = {
  JavaScript: '#f1e05a', Python: '#3572A5', Kotlin: '#A97BFF',
  Java: '#b07219', HTML: '#e34c26', CSS: '#563d7c',
  TypeScript: '#2b7489', Shell: '#89e051',
};

function ProfileCard({ profile }) {
  if (!profile) return null;
  return (
    <div className="github-profile-card">
      <img src={profile.avatar_url} alt="GitHub Avatar" className="github-profile-card__avatar" />
      <div className="github-profile-card__info">
        <span className="github-profile-card__name">{profile.name || profile.login}</span>
        <div className="github-profile-card__stats">
          <span>👥 {profile.followers} followers</span>
          <span>📦 {profile.public_repos} public repos</span>
          {profile.company && <span>🏢 {profile.company}</span>}
        </div>
        {profile.bio && <p className="github-profile-card__bio">{profile.bio}</p>}
        <a href={profile.html_url} target="_blank" rel="noopener noreferrer"
          className="github-profile-card__link">@{profile.login} ↗</a>
      </div>
    </div>
  );
}

function RepoCard({ repo, index, visible }) {
  const [expanded, setExpanded] = useState(false);

  return (
    <div className="repo-card"
      style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateY(0)' : 'translateY(30px)',
        transition: `opacity 0.5s ease ${index * 0.07}s, transform 0.5s ease ${index * 0.07}s`
      }}>
      <div className="repo-card__header">
        <h3 className="repo-card__name">{repo.name}</h3>
        {repo.language && (
          <span className="repo-card__lang">
            <span className="repo-card__lang-dot" style={{ background: LANG_COLORS[repo.language] || '#888' }} />
            {repo.language}
          </span>
        )}
      </div>
      <p className="repo-card__desc">{repo.description || 'No description provided.'}</p>
      <div className="repo-card__stats">
        <span className="repo-card__stat">⭐ {repo.stargazers_count}</span>
        <span className="repo-card__stat">👁 {repo.watchers_count}</span>
        <span className="repo-card__stat">🍴 {repo.forks_count}</span>
      </div>
      <div className="repo-card__actions">
        <a href={repo.html_url} target="_blank" rel="noopener noreferrer" className="repo-card__link">
          View on GitHub ↗
        </a>
        <button className="repo-card__toggle" onClick={() => setExpanded(!expanded)}>
          {expanded ? '↑ Less' : '↓ Details'}
        </button>
      </div>
      {expanded && (
        <div className="repo-card__details">
          <div className="repo-card__detail-row"><span>📅 Updated</span><span>{new Date(repo.updated_at).toLocaleDateString()}</span></div>
          <div className="repo-card__detail-row"><span>🐛 Issues</span><span>{repo.open_issues_count}</span></div>
          <div className="repo-card__detail-row"><span>📦 Size</span><span>{(repo.size / 1024).toFixed(1)} MB</span></div>
          <div className="repo-card__detail-row"><span>🔒 Visibility</span><span>{repo.private ? 'Private' : 'Public'}</span></div>
        </div>
      )}
    </div>
  );
}

function GitHubRepos() {
  const { repos, loading, error } = useGitHubRepos();
  const { profile } = useGitHubProfile();
  const [search, setSearch] = useState('');
  const [langFilter, setLangFilter] = useState('All');
  const [ref, visible] = useScrollAnimation(0.05);

  const languages = ['All', ...new Set(repos.map(r => r.language).filter(Boolean))];
  const filtered = repos.filter(r => {
    const matchSearch = r.name.toLowerCase().includes(search.toLowerCase()) ||
      (r.description || '').toLowerCase().includes(search.toLowerCase());
    const matchLang = langFilter === 'All' || r.language === langFilter;
    return matchSearch && matchLang;
  });

  return (
    <section id="github-repos" className="github-repos">
      <div className="container">
        <p className="section-label">GitHub</p>
        <h2 className="section-title">My Repositories</h2>
        <p className="section-subtitle">Live from GitHub — my public repos.</p>

        <ProfileCard profile={profile} />

        <div className="repos__controls">
          <input type="text" className="repos__search" placeholder="🔍 Search repos..."
            value={search} onChange={e => setSearch(e.target.value)} />
          <div className="repos__langs">
            {languages.map(l => (
              <button key={l}
                className={`repos__lang-btn ${langFilter === l ? 'repos__lang-btn--active' : ''}`}
                onClick={() => setLangFilter(l)}>{l}</button>
            ))}
          </div>
        </div>

        {loading && <div className="repos__loading"><div className="repos__spinner" /><p>Loading repos...</p></div>}
        {error && <p className="repos__error">{error}</p>}
        {!loading && !error && (
          <div className="repos__grid" ref={ref}>
            {filtered.length > 0
              ? filtered.map((repo, i) => <RepoCard key={repo.id} repo={repo} index={i} visible={visible} />)
              : <p className="repos__empty">No repos match your search.</p>}
          </div>
        )}
      </div>
    </section>
  );
}
export default GitHubRepos;
EOF

# Add profile card styles
cat >> src/components/GitHubRepos.css << 'EOF'

.github-profile-card {
  display: flex;
  align-items: center;
  gap: 1.25rem;
  background: var(--bg-card);
  border: 1px solid var(--border-accent);
  border-radius: var(--radius-lg);
  padding: 1.25rem 1.5rem;
  margin-bottom: 2rem;
  transition: border-color var(--transition), box-shadow var(--transition);
}

.github-profile-card:hover {
  border-color: rgba(124,106,255,0.5);
  box-shadow: 0 0 20px rgba(124,106,255,0.12);
}

.github-profile-card__avatar {
  width: 64px; height: 64px;
  border-radius: 50%;
  border: 2px solid var(--border-accent);
  flex-shrink: 0;
}

.github-profile-card__info {
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}

.github-profile-card__name {
  font-size: 1.05rem;
  font-weight: 600;
  color: var(--text-primary);
}

.github-profile-card__stats {
  display: flex;
  gap: 1rem;
  font-family: var(--font-mono);
  font-size: 0.72rem;
  color: var(--text-muted);
  flex-wrap: wrap;
}

.github-profile-card__bio {
  font-size: 0.85rem;
  color: var(--text-secondary);
}

.github-profile-card__link {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  color: var(--accent);
  text-decoration: none;
}
EOF

# Fix Navbar - remove rocket hint, keep 3-click easter egg cleanly
cat > src/components/Navbar.js << 'EOF'
import React, { useState, useEffect, useRef } from 'react';
import EasterEgg from './EasterEgg';
import { useSearch } from './useSearch';
import './Navbar.css';

const NAV_LINKS = [
  { label: 'about',      href: '#about' },
  { label: 'experience', href: '#experience' },
  { label: 'skills',     href: '#skills' },
  { label: 'projects',   href: '#projects' },
  { label: 'repos',      href: '#github-repos' },
  { label: 'contact',    href: '#contact' },
];

function Navbar() {
  const [scrolled, setScrolled]     = useState(false);
  const [menuOpen, setMenuOpen]     = useState(false);
  const [active, setActive]         = useState('');
  const [eggTrigger, setEggTrigger] = useState(0);
  const [clicks, setClicks]         = useState(0);
  const [searchOpen, setSearchOpen] = useState(false);
  const timerRef                    = useRef(null);
  const searchRef                   = useRef(null);
  const { query, setQuery: search } = useSearch();

  useEffect(() => {
    const onScroll = () => {
      setScrolled(window.scrollY > 40);
      const sections = NAV_LINKS.map(l => l.href.replace('#', ''));
      for (let i = sections.length - 1; i >= 0; i--) {
        const el = document.getElementById(sections[i]);
        if (el && window.scrollY >= el.offsetTop - 120) {
          setActive('#' + sections[i]);
          break;
        }
      }
    };
    window.addEventListener('scroll', onScroll);
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  useEffect(() => {
    if (searchOpen && searchRef.current) searchRef.current.focus();
  }, [searchOpen]);

  const handleLogoClick = (e) => {
    e.stopPropagation();
    window.scrollTo({ top: 0, behavior: 'smooth' });
    const newClicks = clicks + 1;
    setClicks(newClicks);
    clearTimeout(timerRef.current);
    if (newClicks >= 3) {
      setEggTrigger(prev => prev + 1);
      setClicks(0);
    }
    timerRef.current = setTimeout(() => setClicks(0), 2000);
  };

  const handleNavClick = (href, e) => {
    e.stopPropagation();
    setMenuOpen(false);
    setActive(href);
    document.querySelector(href)?.scrollIntoView({ behavior: 'smooth' });
  };

  return (
    <>
      <EasterEgg trigger={eggTrigger} />
      <header className={`navbar ${scrolled ? 'navbar--scrolled' : ''}`}>
        <div className="container navbar__inner">
          <button className="navbar__logo" onClick={handleLogoClick}>
            Zoheb Khan
          </button>
          <nav className={`navbar__links ${menuOpen ? 'navbar__links--open' : ''}`}>
            {NAV_LINKS.map(link => (
              <button key={link.href}
                className={`navbar__link ${active === link.href ? 'navbar__link--active' : ''}`}
                onClick={(e) => handleNavClick(link.href, e)}>
                {link.label}
              </button>
            ))}
            <a href="/resume.pdf" download="Zoheb_Khan_Resume.pdf" className="navbar__resume">
              resume ↓
            </a>
          </nav>
          <div className="navbar__search-wrap">
            {searchOpen ? (
              <input ref={searchRef} type="text" className="navbar__search-input"
                placeholder="Search..." value={query}
                onChange={e => search(e.target.value)}
                onBlur={() => { if (!query) setSearchOpen(false); }} />
            ) : (
              <button className="navbar__search-btn" onClick={() => setSearchOpen(true)}>🔍</button>
            )}
          </div>
          <button className={`navbar__hamburger ${menuOpen ? 'navbar__hamburger--open' : ''}`}
            onClick={(e) => { e.stopPropagation(); setMenuOpen(!menuOpen); }}>
            <span /><span /><span />
          </button>
        </div>
      </header>
    </>
  );
}
export default Navbar;
EOF

# Fix Projects.js - restore glow, pop, read more
cat > src/components/Projects.js << 'EOF'
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
EOF

echo "✅ All fixes applied!"
echo "  - New personal bio"
echo "  - GitHub profile moved to repos section"
echo "  - Rocket hint removed from navbar"
echo "  - Read more restored on project cards"
echo "  - Cards glow on hover"
