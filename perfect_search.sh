#!/bin/bash

# SearchHighlight component - clean and reliable
cat > src/components/SearchHighlight.js << 'EOF'
import React from 'react';

function SearchHighlight({ text, query }) {
  if (!query || !query.trim() || !text) return <span>{text}</span>;
  
  const escaped = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const regex = new RegExp(`(${escaped})`, 'gi');
  const parts = text.split(regex);
  
  return (
    <span>
      {parts.map((part, i) =>
        part.toLowerCase() === query.toLowerCase()
          ? <mark key={i} className="search-highlight">{part}</mark>
          : <span key={i}>{part}</span>
      )}
    </span>
  );
}

export default SearchHighlight;
EOF

# App.js - passes searchQuery to all components
cat > src/App.js << 'EOF'
import React, { useState } from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import About from './components/About';
import Experience from './components/Experience';
import Skills from './components/Skills';
import Projects from './components/Projects';
import GitHubRepos from './components/GitHubRepos';
import Contact from './components/Contact';
import Footer from './components/Footer';
import ParticleBackground from './components/ParticleBackground';
import './styles/App.css';

function App() {
  const [searchQuery, setSearchQuery] = useState('');
  return (
    <div className="app">
      <ParticleBackground />
      <Navbar onSearch={setSearchQuery} />
      <main style={{ position: 'relative', zIndex: 1 }}>
        <Hero searchQuery={searchQuery} />
        <About searchQuery={searchQuery} />
        <Experience searchQuery={searchQuery} />
        <Skills searchQuery={searchQuery} />
        <Projects searchQuery={searchQuery} />
        <GitHubRepos searchQuery={searchQuery} />
        <Contact searchQuery={searchQuery} />
      </main>
      <Footer />
    </div>
  );
}
export default App;
EOF

# Navbar - clean search with hover, focus, Enter to jump
cat > src/components/Navbar.js << 'EOF'
import React, { useState, useEffect, useRef } from 'react';
import EasterEgg from './EasterEgg';
import './Navbar.css';

const NAV_LINKS = [
  { label: 'About',      href: '#about' },
  { label: 'Experience', href: '#experience' },
  { label: 'Skills',     href: '#skills' },
  { label: 'Projects',   href: '#projects' },
  { label: 'Repos',      href: '#github-repos' },
  { label: 'Contact',    href: '#contact' },
];

function Navbar({ onSearch }) {
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const [active, setActive] = useState('');
  const [eggTrigger, setEggTrigger] = useState(0);
  const [clicks, setClicks] = useState(0);
  const [searchOpen, setSearchOpen] = useState(false);
  const [query, setQuery] = useState('');
  const timerRef = useRef(null);
  const searchRef = useRef(null);

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
    if (searchOpen && searchRef.current) {
      setTimeout(() => searchRef.current?.focus(), 50);
    }
  }, [searchOpen]);

  const handleLogoClick = (e) => {
    e.stopPropagation();
    window.scrollTo({ top: 0, behavior: 'smooth' });
    const newClicks = clicks + 1;
    setClicks(newClicks);
    clearTimeout(timerRef.current);
    if (newClicks >= 3) { setEggTrigger(prev => prev + 1); setClicks(0); }
    timerRef.current = setTimeout(() => setClicks(0), 2000);
  };

  const handleNavClick = (href, e) => {
    e.stopPropagation();
    e.preventDefault();
    setMenuOpen(false);
    setActive(href);
    document.querySelector(href)?.scrollIntoView({ behavior: 'smooth' });
  };

  const handleSearchChange = (e) => {
    const val = e.target.value;
    setQuery(val);
    if (onSearch) onSearch(val);
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter') {
      const first = document.querySelector('.search-highlight');
      if (first) first.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
    if (e.key === 'Escape') {
      setQuery('');
      if (onSearch) onSearch('');
      setSearchOpen(false);
    }
  };

  const openSearch = (e) => {
    e.stopPropagation();
    setSearchOpen(true);
  };

  const clearSearch = () => {
    setQuery('');
    if (onSearch) onSearch('');
    setSearchOpen(false);
  };

  return (
    <>
      <EasterEgg trigger={eggTrigger} />
      <header className={`navbar ${scrolled ? 'navbar--scrolled' : ''}`}>
        <div className="container navbar__inner">
          <button className="navbar__logo" onClick={handleLogoClick}>Zoheb Khan</button>
          <nav className={`navbar__links ${menuOpen ? 'navbar__links--open' : ''}`}>
            {NAV_LINKS.map(link => (
              <button key={link.href}
                className={`navbar__link ${active === link.href ? 'navbar__link--active' : ''}`}
                onClick={(e) => handleNavClick(link.href, e)}>
                {link.label}
              </button>
            ))}
            <a href="/Zoheb-s-website/resume.pdf" download="Zoheb_Khan_Resume.pdf" className="navbar__resume">
              Resume ↓
            </a>
          </nav>
          <div className="navbar__search-wrap" onClick={e => e.stopPropagation()}>
            {searchOpen ? (
              <div className="navbar__search-container">
                <input
                  ref={searchRef}
                  type="text"
                  className="navbar__search-input"
                  placeholder="Search... (Enter to jump)"
                  value={query}
                  onChange={handleSearchChange}
                  onKeyDown={handleKeyDown}
                  onClick={e => e.stopPropagation()}
                />
                {query && (
                  <button className="navbar__search-clear" onClick={clearSearch}>✕</button>
                )}
              </div>
            ) : (
              <button className="navbar__search-btn" onClick={openSearch} title="Search">🔍</button>
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

# Add search styles to Navbar.css
cat >> src/components/Navbar.css << 'EOF'

.navbar__search-container {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.navbar__search-clear {
  font-size: 0.7rem;
  color: var(--text-muted);
  background: none;
  border: none;
  cursor: pointer;
  padding: 0.2rem 0.4rem;
  border-radius: 50%;
  transition: color var(--transition), background var(--transition);
}

.navbar__search-clear:hover {
  color: var(--text-primary);
  background: var(--bg-hover);
}
EOF

# Add search highlight to global CSS
cat >> src/styles/App.css << 'EOF'

mark.search-highlight {
  background: rgba(124, 106, 255, 0.4);
  color: var(--text-primary);
  border-radius: 3px;
  padding: 0 2px;
  font-style: normal;
}
EOF

# About.js with SearchHighlight
cat > src/components/About.js << 'EOF'
import React from 'react';
import { useScrollAnimation, useCountUp } from './useScrollAnimation';
import SearchHighlight from './SearchHighlight';
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

function About({ searchQuery }) {
  const [ref, visible] = useScrollAnimation(0.1);
  return (
    <section id="about" className="about">
      <div className="container">
        <p className="section-label">About Me</p>
        <div className="about__grid" ref={ref}
          style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(40px)', transition: 'opacity 0.7s ease, transform 0.7s ease' }}>
          <div className="about__text">
            <h2 className="section-title">Who I Am</h2>
            <p className="about__para"><SearchHighlight text={BIO} query={searchQuery} /></p>
            <div className="about__tags">
              {HIGHLIGHTS.map((h, i) => (
                <span key={h.label} className="about__tag"
                  style={{ transitionDelay: `${i * 0.08}s`, opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(12px)', transition: 'opacity 0.5s ease, transform 0.5s ease' }}>
                  <span aria-hidden="true">{h.icon}</span> <SearchHighlight text={h.label} query={searchQuery} />
                </span>
              ))}
            </div>
            <div style={{ marginTop: '2rem' }}>
              <a href="/Zoheb-s-website/resume.pdf" download="Zoheb_Khan_Resume.pdf" className="btn btn--outline">Download Resume</a>
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

# Experience.js with SearchHighlight
cat > src/components/Experience.js << 'EOF'
import React from 'react';
import { useScrollAnimation } from './useScrollAnimation';
import SearchHighlight from './SearchHighlight';
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

function ExperienceCard({ company, role, period, location, bullets, tags, badge, index, visible, searchQuery }) {
  return (
    <div className={`exp-card ${badge ? 'exp-card--current' : ''}`}
      style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(40px)', transition: `opacity 0.6s ease ${index * 0.15}s, transform 0.6s ease ${index * 0.15}s` }}>
      <div className="exp-card__header">
        <div>
          <h3 className="exp-card__company"><SearchHighlight text={company} query={searchQuery} /></h3>
          <p className="exp-card__role"><SearchHighlight text={role} query={searchQuery} /></p>
        </div>
        <div className="exp-card__meta">
          {badge && <span className="exp-card__badge">{badge}</span>}
          <span className="exp-card__period">{period}</span>
          <span className="exp-card__location">{location}</span>
        </div>
      </div>
      <ul className="exp-card__bullets">
        {bullets.map((b, i) => <li key={i}><SearchHighlight text={b} query={searchQuery} /></li>)}
      </ul>
      <div className="exp-card__tags">
        {tags.map(t => <span key={t} className="exp-card__tag"><SearchHighlight text={t} query={searchQuery} /></span>)}
      </div>
    </div>
  );
}

function Experience({ searchQuery }) {
  const [ref, visible] = useScrollAnimation(0.05);
  return (
    <section id="experience" className="experience">
      <div className="container">
        <p className="section-label">Experience</p>
        <h2 className="section-title">Where I've Worked</h2>
        <p className="section-subtitle">Real teams, real code, real impact.</p>
        <div className="exp-list" ref={ref}>
          {EXPERIENCES.map((e, i) => <ExperienceCard key={e.company} {...e} index={i} visible={visible} searchQuery={searchQuery} />)}
        </div>
      </div>
    </section>
  );
}
export default Experience;
EOF

# Skills.js with SearchHighlight
cat > src/components/Skills.js << 'EOF'
import React from 'react';
import { useScrollAnimation } from './useScrollAnimation';
import SearchHighlight from './SearchHighlight';
import './Skills.css';

const SKILL_CATEGORIES = [
  { title: 'Languages', skills: ['Python', 'Java', 'Kotlin', 'JavaScript', 'HTML / CSS', 'SQL'] },
  { title: 'Frameworks & Libraries', skills: ['React', 'Android SDK', 'Jetpack Compose', 'Node.js'] },
  { title: 'Tools & Platforms', skills: ['Git / GitHub', 'Android Studio', 'VS Code', 'Linux / CLI'] },
  { title: 'Concepts', skills: ['Object-Oriented Programming', 'REST APIs', 'Data Structures & Algorithms', 'Mobile Development'] },
];

function Skills({ searchQuery }) {
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
              style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(40px)', transition: `opacity 0.6s ease ${i * 0.12}s, transform 0.6s ease ${i * 0.12}s` }}>
              <h3 className="skills__cat-title"><SearchHighlight text={cat.title} query={searchQuery} /></h3>
              <div className="skills__tags">
                {cat.skills.map((s, j) => (
                  <span key={s} className="skills__tag"
                    style={{ opacity: visible ? 1 : 0, transform: visible ? 'scale(1)' : 'scale(0.8)', transition: `opacity 0.4s ease ${i * 0.12 + j * 0.05}s, transform 0.4s ease ${i * 0.12 + j * 0.05}s` }}>
                    <SearchHighlight text={s} query={searchQuery} />
                  </span>
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

# Projects.js with SearchHighlight
cat > src/components/Projects.js << 'EOF'
import React, { useState } from 'react';
import Button from './Button';
import { useScrollAnimation } from './useScrollAnimation';
import SearchHighlight from './SearchHighlight';
import './Projects.css';

const PROJECTS = [
  { title: 'Women in Cybersecurity Website', description: 'Designed and developed a responsive website for the WiCyS chapter at Pace University.', fullDescription: 'Designed and developed a fully responsive website for the Women in Cybersecurity (WiCyS) chapter at Pace University. Built with HTML, CSS, and JavaScript. Won the Best Website Award at the Women in Cybersecurity competition.', tags: ['HTML', 'CSS', 'JavaScript'], github: 'https://github.com/Zo3945', live: 'https://pacewicys.pace.edu/', featured: true, award: '🏆 Best Website Award' },
  { title: 'Snakes & Ladders', description: 'A fully interactive Snakes and Ladders board game built in Kotlin using Jetpack Compose.', fullDescription: 'Designed and developed a fully interactive Snakes and Ladders board game using Kotlin and Jetpack Compose for Android. Features dynamic board generation, multiple players, and complete game logic.', tags: ['Kotlin', 'Jetpack Compose', 'Android'], github: 'https://github.com/Zo3945', live: null, featured: true, award: null },
  { title: 'Driving Game', description: 'An interactive driving game where players control a vehicle and avoid dynamic obstacles.', fullDescription: 'Built an interactive driving game for Android with collision detection, progressive difficulty, score tracking, and responsive touch controls.', tags: ['Java', 'Android', 'Game Dev'], github: 'https://github.com/Zo3945', live: null, featured: false, award: null },
  { title: 'Spotify Playlist Analyzer', description: 'A tool that analyzes Spotify playlists and surfaces insights about listening habits.', fullDescription: 'A Python tool that connects to the Spotify Web API to analyze playlist data, top genres, audio features, and listening trends.', tags: ['Python', 'API', 'Data'], github: 'https://github.com/Zo3945', live: null, featured: false, award: null },
  { title: 'Android Calendar App', description: 'A calendar-style Android app with event scheduling and a clean material design interface.', fullDescription: 'A full-featured calendar app for Android built in Java with event creation, reminders, and day/week/month views.', tags: ['Java', 'Android', 'Android Studio'], github: 'https://github.com/Zo3945', live: null, featured: false, award: null },
  { title: 'Candy Crush Style Game', description: 'A match-3 puzzle game for Android inspired by Candy Crush.', fullDescription: 'A match-3 puzzle game for Android with animated tile-matching, combo detection, score multipliers, and level progression.', tags: ['Java', 'Android', 'Game Dev'], github: 'https://github.com/Zo3945', live: null, featured: false, award: null },
];

const FILTERS = ['All', 'Python', 'Kotlin', 'Java', 'Android', 'JavaScript'];

function ProjectCard({ title, description, fullDescription, tags, github, live, featured, award, index, visible, searchQuery }) {
  const [expanded, setExpanded] = useState(false);
  return (
    <div className={`project-card ${featured ? 'project-card--featured' : ''}`}
      style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(40px)', transition: `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s` }}>
      {featured && <span className="project-card__badge">Featured</span>}
      <h3 className="project-card__title"><SearchHighlight text={title} query={searchQuery} /></h3>
      {award && <p className="project-card__award">{award}</p>}
      <p className="project-card__desc"><SearchHighlight text={expanded ? fullDescription : description} query={searchQuery} /></p>
      <button className="project-card__expand" onClick={() => setExpanded(!expanded)}>{expanded ? '↑ Show less' : '↓ Read more'}</button>
      <div className="project-card__tags">{tags.map(t => <span key={t} className="project-card__tag"><SearchHighlight text={t} query={searchQuery} /></span>)}</div>
      <div className="project-card__actions">
        {github && <Button href={github} variant="ghost" external>GitHub</Button>}
        {live && <Button href={live} variant="outline" external>Visit Website</Button>}
      </div>
    </div>
  );
}

function Projects({ searchQuery }) {
  const [active, setActive] = useState('All');
  const [ref, visible] = useScrollAnimation(0.05);
  const filtered = active === 'All' ? PROJECTS : PROJECTS.filter(p => p.tags.some(t => t === active));
  return (
    <section id="projects" className="projects">
      <div className="container">
        <p className="section-label">Projects</p>
        <h2 className="section-title">Things I've Built</h2>
        <p className="section-subtitle">A selection of projects I'm proud of.</p>
        <div className="projects__filters">{FILTERS.map(f => <button key={f} className={`projects__filter ${active === f ? 'projects__filter--active' : ''}`} onClick={() => setActive(f)}>{f}</button>)}</div>
        <div className="projects__grid" ref={ref}>{filtered.map((p, i) => <ProjectCard key={p.title} {...p} index={i} visible={visible} searchQuery={searchQuery} />)}</div>
      </div>
    </section>
  );
}
export default Projects;
EOF

# GitHubRepos.js with SearchHighlight
cat > src/components/GitHubRepos.js << 'EOF'
import React, { useState } from 'react';
import { useGitHubRepos, useGitHubProfile } from './useGitHub';
import { useScrollAnimation } from './useScrollAnimation';
import SearchHighlight from './SearchHighlight';
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
        </div>
        <a href={profile.html_url} target="_blank" rel="noopener noreferrer" className="github-profile-card__link">@{profile.login} ↗</a>
      </div>
    </div>
  );
}

function RepoCard({ repo, index, visible, searchQuery }) {
  const [expanded, setExpanded] = useState(false);
  return (
    <div className="repo-card"
      style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(30px)', transition: `opacity 0.5s ease ${index * 0.07}s, transform 0.5s ease ${index * 0.07}s` }}>
      <div className="repo-card__header">
        <h3 className="repo-card__name"><SearchHighlight text={repo.name} query={searchQuery} /></h3>
        {repo.language && (
          <span className="repo-card__lang">
            <span className="repo-card__lang-dot" style={{ background: LANG_COLORS[repo.language] || '#888' }} />
            <SearchHighlight text={repo.language} query={searchQuery} />
          </span>
        )}
      </div>
      <p className="repo-card__desc"><SearchHighlight text={repo.description || 'No description provided.'} query={searchQuery} /></p>
      <div className="repo-card__stats">
        <span className="repo-card__stat">⭐ {repo.stargazers_count}</span>
        <span className="repo-card__stat">👁 {repo.watchers_count}</span>
        <span className="repo-card__stat">🍴 {repo.forks_count}</span>
      </div>
      <div className="repo-card__actions">
        <a href={repo.html_url} target="_blank" rel="noopener noreferrer" className="repo-card__link">View on GitHub ↗</a>
        <button className="repo-card__toggle" onClick={() => setExpanded(!expanded)}>{expanded ? '↑ Less' : '↓ Details'}</button>
      </div>
      {expanded && (
        <div className="repo-card__details">
          <div className="repo-card__detail-row"><span>📅 Updated</span><span>{new Date(repo.updated_at).toLocaleDateString()}</span></div>
          <div className="repo-card__detail-row"><span>🐛 Issues</span><span>{repo.open_issues_count}</span></div>
          <div className="repo-card__detail-row"><span>📦 Size</span><span>{(repo.size / 1024).toFixed(1)} MB</span></div>
        </div>
      )}
    </div>
  );
}

function GitHubRepos({ searchQuery }) {
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
              <button key={l} className={`repos__lang-btn ${langFilter === l ? 'repos__lang-btn--active' : ''}`}
                onClick={() => setLangFilter(l)}>{l}</button>
            ))}
          </div>
        </div>
        {loading && <div className="repos__loading"><div className="repos__spinner" /><p>Loading repos...</p></div>}
        {error && <p className="repos__error">{error}</p>}
        {!loading && !error && (
          <div className="repos__grid" ref={ref}>
            {filtered.length > 0
              ? filtered.map((repo, i) => <RepoCard key={repo.id} repo={repo} index={i} visible={visible} searchQuery={searchQuery} />)
              : <p className="repos__empty">No repos match your search.</p>}
          </div>
        )}
      </div>
    </section>
  );
}
export default GitHubRepos;
EOF

# Contact.js with SearchHighlight and LinkedIn glow
cat > src/components/Contact.js << 'EOF'
import React from 'react';
import Button from './Button';
import { useScrollAnimation } from './useScrollAnimation';
import SearchHighlight from './SearchHighlight';
import './Contact.css';

const EMAIL = 'Zohebk3945@gmail.com';
const GITHUB = 'https://github.com/Zo3945';
const LINKEDIN = 'https://www.linkedin.com/in/zoheb-khan123/';
const LOCATION = 'New York, NY';

const CONTACT_LINKS = [
  { label: 'Email', value: 'Zohebk3945@gmail.com', href: `mailto:${EMAIL}`, icon: '✉', show: true },
  { label: 'GitHub', value: 'Zo3945', href: GITHUB, icon: '⌥', show: true, external: true },
  { label: 'LinkedIn', value: 'zoheb-khan123', href: LINKEDIN, icon: 'in', show: true, external: true },
];

function ContactCard({ label, value, href, icon, external, index, visible, searchQuery }) {
  const isLinkedIn = label === 'LinkedIn';
  return (
    <a className={`contact-card ${isLinkedIn ? 'contact-card--linkedin' : ''}`} href={href}
      target={external ? '_blank' : undefined}
      rel={external ? 'noopener noreferrer' : undefined}
      style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateX(0)' : 'translateX(-30px)', transition: `opacity 0.5s ease ${index * 0.12}s, transform 0.5s ease ${index * 0.12}s` }}>
      <span className={`contact-card__icon ${isLinkedIn ? 'contact-card__icon--linkedin' : ''}`} aria-hidden="true">{icon}</span>
      <div className="contact-card__text">
        <span className="contact-card__label"><SearchHighlight text={label} query={searchQuery} /></span>
        <span className="contact-card__value"><SearchHighlight text={value} query={searchQuery} /></span>
      </div>
      <span className="contact-card__arrow" aria-hidden="true">→</span>
    </a>
  );
}

function Contact({ searchQuery }) {
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
              <ContactCard key={c.label} {...c} index={i} visible={visible} searchQuery={searchQuery} />
            ))}
          </div>
          <div className="contact__cta"
            style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(30px)', transition: 'opacity 0.6s ease 0.35s, transform 0.6s ease 0.35s' }}>
            <div className="contact__cta-inner">
              <p className="contact__cta-label">// open to opportunities</p>
              <h3 className="contact__cta-heading">Looking for a developer?</h3>
              <p className="contact__cta-text">I'm actively looking for a software engineering internship where I can contribute to real projects and keep growing. Let's talk!</p>
              <div style={{ display: 'flex', gap: '0.75rem', flexWrap: 'wrap' }}>
                <Button href={`mailto:${EMAIL}`} variant="primary">Say Hello</Button>
                <Button href={LINKEDIN} variant="ghost" external>View LinkedIn</Button>
              </div>
              <p className="contact__location"><span aria-hidden="true">◎</span> <SearchHighlight text={LOCATION} query={searchQuery} /></p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
export default Contact;
EOF

echo "✅ Search fully implemented across ALL sections!"
