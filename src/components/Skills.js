import React from 'react';
import { useScrollAnimation } from './useScrollAnimation';
import './Skills.css';

const SKILL_CATEGORIES = [
  { title: 'Languages', skills: ['Python', 'Java', 'Kotlin', 'JavaScript', 'HTML / CSS', 'SQL'] },
  { title: 'Frameworks & Libraries', skills: ['React', 'Android SDK', 'Jetpack Compose', 'Node.js'] },
  { title: 'Tools & Platforms', skills: ['Git / GitHub', 'Android Studio', 'VS Code', 'Linux / CLI'] },
  { title: 'Concepts', skills: ['Object-Oriented Programming', 'REST APIs', 'Data Structures & Algorithms', 'Mobile Development'] },
];

function Skills() {
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
              style={{
                opacity: visible ? 1 : 0,
                transform: visible ? 'translateY(0)' : 'translateY(40px)',
                transition: `opacity 0.6s ease ${i * 0.12}s, transform 0.6s ease ${i * 0.12}s`
              }}>
              <h3 className="skills__cat-title">{cat.title}</h3>
              <div className="skills__tags">
                {cat.skills.map((s, j) => (
                  <span key={s} className="skills__tag"
                    style={{
                      opacity: visible ? 1 : 0,
                      transform: visible ? 'scale(1)' : 'scale(0.8)',
                      transition: `opacity 0.4s ease ${i * 0.12 + j * 0.05}s, transform 0.4s ease ${i * 0.12 + j * 0.05}s`
                    }}>{s}</span>
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
