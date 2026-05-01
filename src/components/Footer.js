import React from 'react';
import './Footer.css';

const YEAR = new Date().getFullYear();
const NAME = 'Zoheb Khan';

function Footer() {
  const scrollToTop = () => window.scrollTo({ top: 0, behavior: 'smooth' });
  return (
    <footer className="footer">
      <div className="container footer__inner">
        <p className="footer__copy"><span className="footer__mono">© {YEAR}</span> {NAME} — Built with React</p>
        <button className="footer__top" onClick={scrollToTop} aria-label="Back to top">↑ back to top</button>
      </div>
    </footer>
  );
}
export default Footer;
