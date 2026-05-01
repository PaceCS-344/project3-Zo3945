import React from 'react';
import { useScrollAnimation } from './useScrollAnimation';
import Button from './Button';
import './Resume.css';

const RESUME_SUMMARY = "A Computer Science rising senior at Pace University who builds full-stack apps, mobile experiences, and automation tools. I'm seeking a software engineering internship where I can continue growing through real development work.";

const EDUCATION = [
  { title: 'Pace University', detail: 'B.S. in Computer Science, expected 2026' },
];

const RESUME_SECTIONS = [
  {
    title: 'Experience',
    items: [
      'Software Engineering Intern at Stellar Digital Strategies LLC — automation, AI-assisted reporting, business process improvements',
      'Software Engineering Intern at 73rd Solution — SQL optimization, API integration, testing, and Agile delivery',
    ],
  },
  {
    title: 'Relevant Projects',
    items: [
      'WiCyS Chapter Website — award-winning responsive site built with HTML/CSS/JavaScript',
      'Android Apps — Snakes & Ladders, Driving Game, Calendar App with modern UI and interaction',
      'Spotify Playlist Analyzer — data insights tool using the Spotify API',
    ],
  },
  {
    title: 'Skills',
    items: [
      'Python, Java, Kotlin, JavaScript, SQL, HTML/CSS',
      'React, Android SDK, Jetpack Compose, Node.js',
      'Git, APIs, Agile workflows, debugging, automation',
    ],
  },
];

function Resume() {
  const [ref, visible] = useScrollAnimation(0.12);
  return (
    <section id="resume" className="resume" ref={ref}>
      <div className="container">
        <p className="section-label">Resume</p>
        <h2 className="section-title">My Resume</h2>
        <p className="section-subtitle">A quick overview of education, experience, and the skills I bring.</p>
        <div className="resume__content"
          style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(40px)', transition: 'opacity 0.7s ease, transform 0.7s ease' }}>
          <div className="resume__summary">
            <h3>Summary</h3>
            <p>{RESUME_SUMMARY}</p>
          </div>
          <div className="resume__details">
            <div className="resume__column">
              <div className="resume__card">
                <h4>Education</h4>
                {EDUCATION.map(item => (
                  <div key={item.title} className="resume__item">
                    <strong>{item.title}</strong>
                    <span>{item.detail}</span>
                  </div>
                ))}
              </div>
            </div>
            <div className="resume__column">
              <div className="resume__card">
                <h4>Need a copy?</h4>
                <p>Reach out via email or LinkedIn and I can send you a full resume PDF.</p>
                <Button href="mailto:Zohebk3945@gmail.com" variant="primary">
                  Request Resume
                </Button>
              </div>
            </div>
          </div>
          <div className="resume__sections">
            {RESUME_SECTIONS.map(section => (
              <div key={section.title} className="resume__section">
                <h4>{section.title}</h4>
                <ul>
                  {section.items.map(item => <li key={item}>{item}</li>)}
                </ul>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

export default Resume;
