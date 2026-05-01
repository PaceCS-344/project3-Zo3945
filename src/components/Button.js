import React from 'react';
import './Button.css';

function Button({ variant = 'primary', onClick, href, external, download, children, disabled }) {
  const cls = `btn btn--${variant}`;
  if (href) return (
    <a className={cls} href={href}
      target={external ? '_blank' : undefined}
      rel={external ? 'noopener noreferrer' : undefined}
      download={download || undefined}>
      {children}{external && <span className="btn__external" aria-hidden="true">↗</span>}
    </a>
  );
  return <button className={cls} onClick={onClick} disabled={disabled}>{children}</button>;
}
export default Button;
