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
