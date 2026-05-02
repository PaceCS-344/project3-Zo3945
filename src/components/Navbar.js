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

  const handleLogoClick = () => {
    const newClicks = clicks + 1;
    setClicks(newClicks);
    clearTimeout(timerRef.current);
    if (newClicks >= 3) {
      setEggTrigger(prev => prev + 1);
      setClicks(0);
    } else {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
    timerRef.current = setTimeout(() => setClicks(0), 2000);
  };

  const handleNavClick = (href) => {
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
                onClick={() => handleNavClick(link.href)}>
                {link.label}
              </button>
            ))}
            <a href="/Zoheb-s-website/resume.pdf" download="Zoheb_Khan_Resume.pdf" className="navbar__resume">
              Resume ↓
            </a>
          </nav>

          {/* Search - completely separate from logo */}
          <div className="navbar__search-area">
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
                />
                <button className="navbar__search-clear" onClick={() => {
                  setQuery('');
                  if (onSearch) onSearch('');
                  setSearchOpen(false);
                }}>✕</button>
              </div>
            ) : (
              <button
                className="navbar__search-btn"
                onClick={() => setSearchOpen(true)}
                title="Search site">
                🔍
              </button>
            )}
          </div>

          <button className={`navbar__hamburger ${menuOpen ? 'navbar__hamburger--open' : ''}`}
            onClick={() => setMenuOpen(!menuOpen)}>
            <span /><span /><span />
          </button>
        </div>
      </header>
    </>
  );
}
export default Navbar;
