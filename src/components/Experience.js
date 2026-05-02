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
