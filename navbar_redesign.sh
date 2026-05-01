#!/bin/bash

cat > src/components/Navbar.js << 'EOF'
import React, { useState, useEffect } from 'react';
import './Navbar.css';

const NAV_LINKS = [
  { label: 'about',      href: '#about' },
  { label: 'experience', href: '#experience' },
  { label: 'skills',     href: '#skills' },
  { label: 'projects',   href: '#projects' },
  { label: 'contact',    href: '#contact' },
];

function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const [active, setActive] = useState('');

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

  const handleClick = (href) => {
    setMenuOpen(false);
    setActive(href);
    document.querySelector(href)?.scrollIntoView({ behavior: 'smooth' });
  };

  return (
    <header className={`navbar ${scrolled ? 'navbar--scrolled' : ''}`}>
      <div className="container navbar__inner">
        <a className="navbar__logo" href="#hero" onClick={() => handleClick('#hero')}>
          <span className="navbar__logo-bracket">{'<'}</span>
          ZohebKhan
          <span className="navbar__logo-bracket">{' />'}</span>
        </a>

        <nav className={`navbar__links ${menuOpen ? 'navbar__links--open' : ''}`}>
          {NAV_LINKS.map(link => (
            <button
              key={link.href}
              className={`navbar__link ${active === link.href ? 'navbar__link--active' : ''}`}
              onClick={() => handleClick(link.href)}>
              {link.label}
            </button>
          ))}
          <a
            href="/resume.pdf"
            download="Zoheb_Khan_Resume.pdf"
            className="navbar__resume">
            resume ↓
          </a>
        </nav>

        <button
          className={`navbar__hamburger ${menuOpen ? 'navbar__hamburger--open' : ''}`}
          onClick={() => setMenuOpen(!menuOpen)}
          aria-label="Toggle menu">
          <span /><span /><span />
        </button>
      </div>
    </header>
  );
}

export default Navbar;
EOF

cat > src/components/Navbar.css << 'EOF'
.navbar {
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 100;
  padding: 1.25rem 0;
  transition: background 0.3s ease, padding 0.3s ease, border-color 0.3s ease;
  border-bottom: 1px solid transparent;
}

.navbar--scrolled {
  background: rgba(4, 4, 13, 0.85);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-bottom-color: rgba(139, 124, 248, 0.1);
  padding: 0.75rem 0;
}

.navbar__inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

/* Logo */
.navbar__logo {
  font-family: var(--font-mono);
  font-size: 1rem;
  font-weight: 700;
  color: var(--text-primary);
  transition: color var(--transition);
  text-decoration: none;
}

.navbar__logo:hover { color: var(--accent); }

.navbar__logo-bracket {
  color: var(--green);
  text-shadow: 0 0 10px rgba(87, 240, 176, 0.5);
}

/* Nav links */
.navbar__links {
  display: flex;
  align-items: center;
  gap: 0.4rem;
}

.navbar__link {
  font-family: var(--font-mono);
  font-size: 0.78rem;
  color: var(--text-muted);
  padding: 0.4rem 0.9rem;
  border-radius: 100px;
  border: 1px solid transparent;
  background: transparent;
  cursor: pointer;
  transition: all 0.2s ease;
  position: relative;
  letter-spacing: 0.03em;
}

.navbar__link:hover {
  color: var(--accent);
  border-color: rgba(139, 124, 248, 0.3);
  background: rgba(139, 124, 248, 0.08);
  box-shadow: 0 0 12px rgba(139, 124, 248, 0.15);
}

.navbar__link--active {
  color: var(--accent);
  border-color: rgba(139, 124, 248, 0.4);
  background: rgba(139, 124, 248, 0.12);
  box-shadow: 0 0 16px rgba(139, 124, 248, 0.2), inset 0 0 8px rgba(139, 124, 248, 0.05);
}

/* Resume button - green glowing pill */
.navbar__resume {
  font-family: var(--font-mono);
  font-size: 0.78rem;
  color: var(--green);
  padding: 0.4rem 0.9rem;
  border-radius: 100px;
  border: 1px solid rgba(87, 240, 176, 0.35);
  background: rgba(87, 240, 176, 0.08);
  cursor: pointer;
  transition: all 0.2s ease;
  text-decoration: none;
  margin-left: 0.4rem;
  box-shadow: 0 0 10px rgba(87, 240, 176, 0.1);
}

.navbar__resume:hover {
  background: rgba(87, 240, 176, 0.15);
  border-color: rgba(87, 240, 176, 0.6);
  box-shadow: 0 0 20px rgba(87, 240, 176, 0.25);
  color: var(--green);
}

/* Hamburger */
.navbar__hamburger {
  display: none;
  flex-direction: column;
  gap: 5px;
  padding: 4px;
  background: none;
  border: none;
  cursor: pointer;
}

.navbar__hamburger span {
  display: block;
  width: 22px; height: 2px;
  background: var(--text-secondary);
  border-radius: 2px;
  transition: transform 0.25s ease, opacity 0.25s ease;
}

.navbar__hamburger--open span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
.navbar__hamburger--open span:nth-child(2) { opacity: 0; }
.navbar__hamburger--open span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }

@media (max-width: 700px) {
  .navbar__hamburger { display: flex; }
  .navbar__links {
    display: none;
    position: absolute;
    top: 100%; left: 0; right: 0;
    flex-direction: column;
    align-items: flex-start;
    background: rgba(4, 4, 13, 0.95);
    backdrop-filter: blur(16px);
    border-bottom: 1px solid rgba(139,124,248,0.1);
    padding: 1rem 1.5rem;
    gap: 0.4rem;
  }
  .navbar__links--open { display: flex; }
  .navbar__link, .navbar__resume {
    font-size: 0.9rem;
    width: 100%;
    text-align: left;
    margin-left: 0;
  }
}
EOF

echo "✅ Navbar redesigned — glowing pills, active state, green resume button!"
