#!/bin/bash

# ── 1. GitHub API hook ───────────────────────────────────────────
cat > src/components/useGitHub.js << 'EOF'
import { useState, useEffect } from 'react';

const USERNAME = 'Zo3945';

// Hook to fetch GitHub repos
export function useGitHubRepos() {
  const [repos, setRepos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch(`https://api.github.com/users/${USERNAME}/repos?sort=updated&per_page=20`)
      .then(res => res.json())
      .then(data => {
        if (Array.isArray(data)) {
          setRepos(data);
        } else {
          setError('Could not load repos');
        }
        setLoading(false);
      })
      .catch(() => {
        setError('Failed to fetch repos');
        setLoading(false);
      });
  }, []);

  return { repos, loading, error };
}

// Hook to fetch GitHub profile
export function useGitHubProfile() {
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch(`https://api.github.com/users/${USERNAME}`)
      .then(res => res.json())
      .then(data => {
        setProfile(data);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

  return { profile, loading };
}
EOF

# ── 2. Search hook ───────────────────────────────────────────────
cat > src/components/useSearch.js << 'EOF'
import { useState, useEffect, useCallback } from 'react';

export function useSearch() {
  const [query, setQuery] = useState('');
  const [matches, setMatches] = useState([]);

  const search = useCallback((q) => {
    setQuery(q);
    if (!q.trim()) {
      // Clear all highlights
      document.querySelectorAll('.search-highlight').forEach(el => {
        el.outerHTML = el.innerHTML;
      });
      setMatches([]);
      return;
    }

    // Remove old highlights first
    document.querySelectorAll('.search-highlight').forEach(el => {
      el.outerHTML = el.innerHTML;
    });

    const walker = document.createTreeWalker(
      document.querySelector('main') || document.body,
      NodeFilter.SHOW_TEXT,
      null,
      false
    );

    const found = [];
    let node;
    const regex = new RegExp(`(${q})`, 'gi');

    while ((node = walker.nextNode())) {
      if (node.nodeValue.match(regex)) {
        const span = document.createElement('span');
        span.innerHTML = node.nodeValue.replace(regex, '<mark class="search-highlight">$1</mark>');
        node.parentNode.replaceChild(span, node);
        found.push(node);
      }
    }

    setMatches(found);

    // Scroll to first match
    const first = document.querySelector('.search-highlight');
    if (first) {
      first.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  }, []);

  // Clear on empty
  useEffect(() => {
    if (!query) {
      document.querySelectorAll('.search-highlight').forEach(el => {
        const parent = el.parentNode;
        if (parent) {
          parent.replaceChild(document.createTextNode(el.textContent), el);
          parent.normalize();
        }
      });
    }
  }, [query]);

  return { query, setQuery: search, matches };
}
EOF

# ── 3. GitHub Repos section ──────────────────────────────────────
cat > src/components/GitHubRepos.js << 'EOF'
import React, { useState } from 'react';
import { useGitHubRepos } from './useGitHub';
import { useScrollAnimation } from './useScrollAnimation';
import './GitHubRepos.css';

const LANG_COLORS = {
  JavaScript: '#f1e05a',
  Python: '#3572A5',
  Kotlin: '#A97BFF',
  Java: '#b07219',
  HTML: '#e34c26',
  CSS: '#563d7c',
  TypeScript: '#2b7489',
  Shell: '#89e051',
};

function RepoCard({ repo, index, visible }) {
  const [expanded, setExpanded] = useState(false);

  return (
    <div className={`repo-card ${expanded ? 'repo-card--expanded' : ''}`}
      style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateY(0)' : 'translateY(30px)',
        transition: `opacity 0.5s ease ${index * 0.07}s, transform 0.5s ease ${index * 0.07}s`
      }}>
      <div className="repo-card__header">
        <h3 className="repo-card__name">{repo.name}</h3>
        {repo.language && (
          <span className="repo-card__lang">
            <span className="repo-card__lang-dot"
              style={{ background: LANG_COLORS[repo.language] || '#888' }} />
            {repo.language}
          </span>
        )}
      </div>

      <p className="repo-card__desc">
        {repo.description || 'No description provided.'}
      </p>

      <div className="repo-card__stats">
        <span className="repo-card__stat">⭐ {repo.stargazers_count}</span>
        <span className="repo-card__stat">👁 {repo.watchers_count}</span>
        <span className="repo-card__stat">🍴 {repo.forks_count}</span>
      </div>

      <div className="repo-card__actions">
        <a href={repo.html_url} target="_blank" rel="noopener noreferrer"
          className="repo-card__link">
          View on GitHub ↗
        </a>
        <button className="repo-card__toggle" onClick={() => setExpanded(!expanded)}>
          {expanded ? '↑ Less' : '↓ Details'}
        </button>
      </div>

      {expanded && (
        <div className="repo-card__details">
          <div className="repo-card__detail-row">
            <span>📅 Updated</span>
            <span>{new Date(repo.updated_at).toLocaleDateString()}</span>
          </div>
          <div className="repo-card__detail-row">
            <span>🐛 Issues</span>
            <span>{repo.open_issues_count}</span>
          </div>
          <div className="repo-card__detail-row">
            <span>📦 Size</span>
            <span>{(repo.size / 1024).toFixed(1)} MB</span>
          </div>
          <div className="repo-card__detail-row">
            <span>🔒 Visibility</span>
            <span>{repo.private ? 'Private' : 'Public'}</span>
          </div>
        </div>
      )}
    </div>
  );
}

function GitHubRepos() {
  const { repos, loading, error } = useGitHubRepos();
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

        {/* Search + filter bar */}
        <div className="repos__controls">
          <input
            type="text"
            className="repos__search"
            placeholder="🔍 Search repos..."
            value={search}
            onChange={e => setSearch(e.target.value)}
          />
          <div className="repos__langs">
            {languages.map(l => (
              <button key={l}
                className={`repos__lang-btn ${langFilter === l ? 'repos__lang-btn--active' : ''}`}
                onClick={() => setLangFilter(l)}>
                {l}
              </button>
            ))}
          </div>
        </div>

        {loading && (
          <div className="repos__loading">
            <div className="repos__spinner" />
            <p>Loading repos from GitHub...</p>
          </div>
        )}

        {error && <p className="repos__error">{error}</p>}

        {!loading && !error && (
          <div className="repos__grid" ref={ref}>
            {filtered.length > 0 ? (
              filtered.map((repo, i) => (
                <RepoCard key={repo.id} repo={repo} index={i} visible={visible} />
              ))
            ) : (
              <p className="repos__empty">No repos match your search.</p>
            )}
          </div>
        )}
      </div>
    </section>
  );
}

export default GitHubRepos;
EOF

cat > src/components/GitHubRepos.css << 'EOF'
.github-repos {
  background: var(--bg-primary);
  border-top: 1px solid var(--border);
}

.repos__controls {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-bottom: 2.5rem;
}

.repos__search {
  width: 100%;
  max-width: 480px;
  padding: 0.65rem 1rem;
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  color: var(--text-primary);
  font-family: var(--font-mono);
  font-size: 0.85rem;
  transition: border-color var(--transition), box-shadow var(--transition);
  outline: none;
}

.repos__search:focus {
  border-color: var(--border-accent);
  box-shadow: 0 0 0 3px var(--accent-dim);
}

.repos__langs {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
}

.repos__lang-btn {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  padding: 0.3rem 0.8rem;
  border-radius: 100px;
  border: 1px solid var(--border);
  color: var(--text-muted);
  background: transparent;
  cursor: pointer;
  transition: all var(--transition);
}

.repos__lang-btn:hover {
  color: var(--text-secondary);
  border-color: rgba(255,255,255,0.15);
}

.repos__lang-btn--active {
  background: var(--accent-dim);
  border-color: var(--border-accent);
  color: var(--accent);
}

.repos__grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.25rem;
}

.repo-card {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  transition: border-color var(--transition), box-shadow var(--transition);
}

.repo-card:hover {
  border-color: var(--border-accent);
  box-shadow: 0 0 20px rgba(124,106,255,0.15);
}

.repo-card__header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 0.5rem;
}

.repo-card__name {
  font-size: 0.95rem;
  font-weight: 600;
  color: var(--text-primary);
  font-family: var(--font-mono);
  word-break: break-word;
}

.repo-card__lang {
  display: flex;
  align-items: center;
  gap: 0.3rem;
  font-family: var(--font-mono);
  font-size: 0.7rem;
  color: var(--text-muted);
  white-space: nowrap;
}

.repo-card__lang-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  flex-shrink: 0;
}

.repo-card__desc {
  font-size: 0.85rem;
  color: var(--text-secondary);
  line-height: 1.6;
  flex: 1;
}

.repo-card__stats {
  display: flex;
  gap: 1rem;
}

.repo-card__stat {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  color: var(--text-muted);
}

.repo-card__actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 0.25rem;
}

.repo-card__link {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  color: var(--accent);
  text-decoration: none;
  transition: opacity var(--transition);
}

.repo-card__link:hover { opacity: 0.7; }

.repo-card__toggle {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  color: var(--text-muted);
  background: none;
  border: none;
  cursor: pointer;
  transition: color var(--transition);
}

.repo-card__toggle:hover { color: var(--accent); }

.repo-card__details {
  border-top: 1px solid var(--border);
  padding-top: 0.75rem;
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}

.repo-card__detail-row {
  display: flex;
  justify-content: space-between;
  font-size: 0.78rem;
  color: var(--text-secondary);
  font-family: var(--font-mono);
}

.repos__loading {
  display: flex;
  align-items: center;
  gap: 1rem;
  color: var(--text-muted);
  font-family: var(--font-mono);
  font-size: 0.85rem;
}

.repos__spinner {
  width: 20px;
  height: 20px;
  border: 2px solid var(--border);
  border-top-color: var(--accent);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin { to { transform: rotate(360deg); } }

.repos__error { color: var(--text-muted); font-family: var(--font-mono); font-size: 0.85rem; }
.repos__empty { color: var(--text-muted); font-family: var(--font-mono); font-size: 0.85rem; }
EOF

# ── 4. Update About with GitHub profile ─────────────────────────
cat > src/components/About.js << 'EOF'
import React from 'react';
import { useScrollAnimation, useCountUp } from './useScrollAnimation';
import { useGitHubProfile } from './useGitHub';
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
  const { profile } = useGitHubProfile();

  return (
    <section id="about" className="about">
      <div className="container">
        <p className="section-label">About Me</p>
        <div className="about__grid" ref={ref}
          style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(40px)', transition: 'opacity 0.7s ease, transform 0.7s ease' }}>
          <div className="about__text">
            {/* GitHub Avatar + profile */}
            {profile && (
              <div className="about__github-profile">
                <img src={profile.avatar_url} alt="GitHub Avatar" className="about__avatar" />
                <div className="about__github-info">
                  <span className="about__github-name">{profile.name || profile.login}</span>
                  <div className="about__github-stats">
                    <span>👥 {profile.followers} followers</span>
                    <span>📦 {profile.public_repos} repos</span>
                    {profile.company && <span>🏢 {profile.company}</span>}
                  </div>
                  <a href={profile.html_url} target="_blank" rel="noopener noreferrer"
                    className="about__github-link">
                    @{profile.login} ↗
                  </a>
                </div>
              </div>
            )}

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

# Add avatar styles to About.css
cat >> src/components/About.css << 'EOF'

.about__github-profile {
  display: flex;
  align-items: center;
  gap: 1rem;
  background: var(--bg-card);
  border: 1px solid var(--border-accent);
  border-radius: var(--radius-lg);
  padding: 1rem 1.25rem;
  margin-bottom: 1.5rem;
  transition: border-color var(--transition);
}

.about__github-profile:hover {
  border-color: rgba(124,106,255,0.5);
}

.about__avatar {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  border: 2px solid var(--border-accent);
}

.about__github-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.about__github-name {
  font-size: 1rem;
  font-weight: 600;
  color: var(--text-primary);
}

.about__github-stats {
  display: flex;
  gap: 1rem;
  font-family: var(--font-mono);
  font-size: 0.72rem;
  color: var(--text-muted);
  flex-wrap: wrap;
}

.about__github-link {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  color: var(--accent);
  text-decoration: none;
}

.about__github-link:hover { opacity: 0.7; }
EOF

# ── 5. Search bar in Navbar ──────────────────────────────────────
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
  const [hint, setHint]             = useState('');
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
    if (searchOpen && searchRef.current) {
      searchRef.current.focus();
    }
  }, [searchOpen]);

  const handleLogoClick = (e) => {
    e.stopPropagation();
    window.scrollTo({ top: 0, behavior: 'smooth' });
    const newClicks = clicks + 1;
    setClicks(newClicks);
    clearTimeout(timerRef.current);
    if (newClicks === 1) setHint('2 more...');
    else if (newClicks === 2) setHint('1 more...');
    else if (newClicks >= 3) {
      setEggTrigger(prev => prev + 1);
      setHint('🚀💥');
      setClicks(0);
    }
    timerRef.current = setTimeout(() => { setClicks(0); setHint(''); }, 2000);
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
            {hint && <span className="navbar__egg-hint">{hint}</span>}
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
              <input
                ref={searchRef}
                type="text"
                className="navbar__search-input"
                placeholder="Search..."
                value={query}
                onChange={e => search(e.target.value)}
                onBlur={() => { if (!query) setSearchOpen(false); }}
              />
            ) : (
              <button className="navbar__search-btn" onClick={() => setSearchOpen(true)}
                aria-label="Search">
                🔍
              </button>
            )}
          </div>

          <button className={`navbar__hamburger ${menuOpen ? 'navbar__hamburger--open' : ''}`}
            onClick={(e) => { e.stopPropagation(); setMenuOpen(!menuOpen); }}
            aria-label="Toggle menu">
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

.navbar__search-wrap {
  display: flex;
  align-items: center;
}

.navbar__search-btn {
  font-size: 0.9rem;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0.4rem;
  border-radius: var(--radius);
  transition: background var(--transition);
  color: var(--text-muted);
}

.navbar__search-btn:hover {
  background: var(--bg-hover);
  color: var(--text-primary);
}

.navbar__search-input {
  width: 180px;
  padding: 0.35rem 0.75rem;
  background: var(--bg-card);
  border: 1px solid var(--border-accent);
  border-radius: 100px;
  color: var(--text-primary);
  font-family: var(--font-mono);
  font-size: 0.75rem;
  outline: none;
  transition: box-shadow var(--transition);
}

.navbar__search-input:focus {
  box-shadow: 0 0 12px var(--accent-glow);
}

/* Search highlight style */
mark.search-highlight {
  background: rgba(124,106,255,0.35);
  color: var(--text-primary);
  border-radius: 2px;
  padding: 0 2px;
}
EOF

# ── 6. Update App.js to include GitHubRepos ─────────────────────
cat > src/App.js << 'EOF'
import React from 'react';
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
        <GitHubRepos />
        <Contact />
      </main>
      <Footer />
    </div>
  );
}
export default App;
EOF

echo "✅ All hooks features added!"
echo "  1. Search bar in navbar — highlights matching text as you type"
echo "  2. GitHub repos section — live from API with search + language filter"
echo "  3. GitHub profile in About — avatar, followers, repo count"
