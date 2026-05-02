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
