import React, { useState, useEffect } from 'react';
import Button from './Button';
import SearchHighlight from './SearchHighlight';
import './Hero.css';

const NAME = 'Zoheb Khan';
const ROLES = ['Software Engineer', 'Android Developer', 'CS Rising Senior', 'Problem Solver'];
const TAGLINE = "Pace University Computer Science student who turns ideas into real, scalable products with meaningful impact.";
const GITHUB_URL = 'https://github.com/Zo3945';

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
      const next = subIndex + (deleting ? -1 : 1);
      setSubIndex(next);
      setText(words[index].substring(0, next));
    }, deleting ? speed / 2 : speed);
    return () => clearTimeout(t);
  }, [subIndex, deleting, index, words, speed, pause]);

  return text;
}

function Hero({ searchQuery }) {
  const role = useTypewriter(ROLES);
  const scrollToProjects = () => document.querySelector('#projects')?.scrollIntoView({ behavior: 'smooth' });

  return (
    <section id="hero" className="hero">
      <div className="hero__bg-grid" aria-hidden="true" />
      <div className="hero__orb hero__orb--1" aria-hidden="true" />
      <div className="hero__orb hero__orb--2" aria-hidden="true" />
      <div className="container hero__inner">
        <div className="hero__content">
          <div className="hero__eyebrow">
            <span className="hero__dot" />
            <span>Available for internships</span>
          </div>
          <h1 className="hero__name">
            <span className="hero__name-line"><SearchHighlight text="Zoheb" query={searchQuery} /></span>
            <span className="hero__name-line hero__name-line--accent"><SearchHighlight text="Khan" query={searchQuery} /></span>
          </h1>
          <div className="hero__role-wrap">
            <span className="hero__role-label">~/ </span>
            <span className="hero__role-text">{role}</span>
            <span className="hero__cursor" aria-hidden="true">|</span>
          </div>
          <p className="hero__tagline"><SearchHighlight text={TAGLINE} query={searchQuery} /></p>
          <div className="hero__actions">
            <Button onClick={scrollToProjects} variant="primary">View My Work</Button>
            <Button href={GITHUB_URL} variant="ghost" external>GitHub Profile</Button>
            <a href="https://www.linkedin.com/in/zoheb-khan123/" target="_blank" rel="noopener noreferrer" className="btn btn--linkedin">LinkedIn ↗</a>
          </div>
        </div>
        <div className="hero__right">
          <div className="hero__card-wrap">
            <div className="hero__card-border" />
            <div className="hero__card">
              <div className="terminal__bar">
                <span className="terminal__dot terminal__dot--red" />
                <span className="terminal__dot terminal__dot--yellow" />
                <span className="terminal__dot terminal__dot--green" />
                <span className="terminal__title">about-me.js</span>
              </div>
              <div className="terminal__body">
                <pre className="terminal__code">{`const developer = {
  name: "Zoheb Khan",
  school: "Pace University",
  experience: "SWE Intern",
  focus: [
    "AI & Machine Learning",
    "Android Development",
    "Full Stack Dev",
    "Python Automation",
    "Web Development",
  ],
  awards: [
    "Best Website @ WiCyS",
  ],
  lookingFor: "SWE Internship",
};`}</pre>
              </div>
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
