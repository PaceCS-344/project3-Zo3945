#!/bin/bash
sed -i '' 's/.navbar__logo {/.navbar__logo_TEMP {/' src/components/Navbar.css
cat >> src/components/Navbar.css << 'CSSEOF'

.navbar__logo {
  font-family: var(--font-mono);
  font-size: 0.9rem;
  font-weight: 700;
  color: var(--text-primary);
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  background: linear-gradient(135deg, rgba(124,106,255,0.12), rgba(87,240,176,0.06));
  border: 1px solid rgba(124,106,255,0.35);
  padding: 0.45rem 1.1rem;
  border-radius: 100px;
  box-shadow: 0 0 20px rgba(124,106,255,0.15), inset 0 1px 0 rgba(255,255,255,0.05);
  backdrop-filter: blur(8px);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.navbar__logo::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, rgba(124,106,255,0.08), rgba(87,240,176,0.04));
  border-radius: 100px;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.navbar__logo:hover::before {
  opacity: 1;
}

.navbar__logo:hover {
  border-color: rgba(124,106,255,0.6);
  box-shadow: 0 0 30px rgba(124,106,255,0.3), 0 0 60px rgba(87,240,176,0.1);
  color: var(--text-primary);
}

.navbar__logo-bracket {
  color: var(--green);
  text-shadow: 0 0 10px rgba(87,240,176,0.6);
  font-size: 1rem;
}
CSSEOF
sed -i '' 's/.navbar__logo_TEMP {/.navbar__logo_OLD {/' src/components/Navbar.css
echo "✅ Logo pill style applied!"
