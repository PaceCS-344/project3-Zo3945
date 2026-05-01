#!/bin/bash

# 1. Particle/star background component
cat > src/components/ParticleBackground.js << 'EOF'
import React, { useEffect, useRef } from 'react';

function ParticleBackground() {
  const canvasRef = useRef(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    let animId;

    const resize = () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    };
    resize();
    window.addEventListener('resize', resize);

    const particles = Array.from({ length: 80 }, () => ({
      x: Math.random() * canvas.width,
      y: Math.random() * canvas.height,
      r: Math.random() * 1.5 + 0.3,
      dx: (Math.random() - 0.5) * 0.3,
      dy: (Math.random() - 0.5) * 0.3,
      opacity: Math.random() * 0.5 + 0.1,
    }));

    const mouse = { x: null, y: null };
    window.addEventListener('mousemove', e => {
      mouse.x = e.clientX;
      mouse.y = e.clientY;
    });

    const draw = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      particles.forEach(p => {
        p.x += p.dx;
        p.y += p.dy;
        if (p.x < 0 || p.x > canvas.width) p.dx *= -1;
        if (p.y < 0 || p.y > canvas.height) p.dy *= -1;

        ctx.beginPath();
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(124, 106, 255, ${p.opacity})`;
        ctx.fill();
      });

      // Draw lines between nearby particles
      particles.forEach((a, i) => {
        particles.slice(i + 1).forEach(b => {
          const dist = Math.hypot(a.x - b.x, a.y - b.y);
          if (dist < 120) {
            ctx.beginPath();
            ctx.moveTo(a.x, a.y);
            ctx.lineTo(b.x, b.y);
            ctx.strokeStyle = `rgba(124, 106, 255, ${0.12 * (1 - dist / 120)})`;
            ctx.lineWidth = 0.5;
            ctx.stroke();
          }
        });
      });

      // React to mouse
      if (mouse.x && mouse.y) {
        particles.forEach(p => {
          const dist = Math.hypot(p.x - mouse.x, p.y - mouse.y);
          if (dist < 100) {
            ctx.beginPath();
            ctx.moveTo(p.x, p.y);
            ctx.lineTo(mouse.x, mouse.y);
            ctx.strokeStyle = `rgba(124, 106, 255, ${0.2 * (1 - dist / 100)})`;
            ctx.lineWidth = 0.5;
            ctx.stroke();
          }
        });
      }

      animId = requestAnimationFrame(draw);
    };

    draw();
    return () => {
      cancelAnimationFrame(animId);
      window.removeEventListener('resize', resize);
    };
  }, []);

  return (
    <canvas ref={canvasRef} style={{
      position: 'fixed', top: 0, left: 0,
      width: '100%', height: '100%',
      pointerEvents: 'none', zIndex: 0,
      opacity: 0.6,
    }} />
  );
}

export default ParticleBackground;
EOF

# 2. Cursor glow trail
cat > src/components/CursorGlow.js << 'EOF'
import React, { useEffect, useRef } from 'react';

function CursorGlow() {
  const dotRef = useRef(null);
  const glowRef = useRef(null);
  let mouseX = 0, mouseY = 0;
  let dotX = 0, dotY = 0;

  useEffect(() => {
    const dot = dotRef.current;
    const glow = glowRef.current;

    const onMove = (e) => {
      mouseX = e.clientX;
      mouseY = e.clientY;
      dot.style.left = mouseX + 'px';
      dot.style.top = mouseY + 'px';
    };

    const animate = () => {
      dotX += (mouseX - dotX) * 0.08;
      dotY += (mouseY - dotY) * 0.08;
      glow.style.left = dotX + 'px';
      glow.style.top = dotY + 'px';
      requestAnimationFrame(animate);
    };

    window.addEventListener('mousemove', onMove);
    animate();
    return () => window.removeEventListener('mousemove', onMove);
  }, []);

  return (
    <>
      <div ref={dotRef} style={{
        position: 'fixed', width: '6px', height: '6px',
        borderRadius: '50%', background: '#7c6aff',
        pointerEvents: 'none', zIndex: 9999,
        transform: 'translate(-50%, -50%)',
        transition: 'opacity 0.3s',
      }} />
      <div ref={glowRef} style={{
        position: 'fixed', width: '32px', height: '32px',
        borderRadius: '50%',
        border: '1px solid rgba(124,106,255,0.5)',
        pointerEvents: 'none', zIndex: 9998,
        transform: 'translate(-50%, -50%)',
      }} />
    </>
  );
}

export default CursorGlow;
EOF

# 3. Animated section titles using IntersectionObserver
cat > src/components/SectionTitle.js << 'EOF'
import React from 'react';
import { useScrollAnimation } from './useScrollAnimation';

function SectionTitle({ label, title, subtitle }) {
  const [ref, visible] = useScrollAnimation(0.2);

  return (
    <div ref={ref}>
      <p className="section-label" style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateY(0)' : 'translateY(20px)',
        transition: 'opacity 0.5s ease, transform 0.5s ease',
      }}>{label}</p>
      <h2 className="section-title" style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateY(0)' : 'translateY(20px)',
        transition: 'opacity 0.5s ease 0.1s, transform 0.5s ease 0.1s',
      }}>{title}</h2>
      {subtitle && (
        <p className="section-subtitle" style={{
          opacity: visible ? 1 : 0,
          transform: visible ? 'translateY(0)' : 'translateY(20px)',
          transition: 'opacity 0.5s ease 0.2s, transform 0.5s ease 0.2s',
        }}>{subtitle}</p>
      )}
    </div>
  );
}

export default SectionTitle;
EOF

# 4. Update App.js to include ParticleBackground and CursorGlow
cat > src/App.js << 'EOF'
import React from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import About from './components/About';
import Experience from './components/Experience';
import Skills from './components/Skills';
import Projects from './components/Projects';
import Contact from './components/Contact';
import Footer from './components/Footer';
import ParticleBackground from './components/ParticleBackground';
import CursorGlow from './components/CursorGlow';
import './styles/App.css';

function App() {
  return (
    <div className="app">
      <ParticleBackground />
      <CursorGlow />
      <Navbar />
      <main style={{ position: 'relative', zIndex: 1 }}>
        <Hero />
        <About />
        <Experience />
        <Skills />
        <Projects />
        <Contact />
      </main>
      <Footer />
    </div>
  );
}

export default App;
EOF

# 5. Add extra CSS animations to App.css
cat >> src/styles/App.css << 'EOF'

/* Glowing text effect on hover for section titles */
.section-title:hover {
  background: linear-gradient(135deg, var(--text-primary) 40%, var(--accent));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  transition: all 0.3s ease;
}

/* Shimmer effect on skill tags */
.skills__tag {
  position: relative;
  overflow: hidden;
}
.skills__tag::after {
  content: '';
  position: absolute;
  top: -50%; left: -75%;
  width: 50%; height: 200%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.08), transparent);
  transform: skewX(-20deg);
  transition: left 0.4s ease;
}
.skills__tag:hover::after {
  left: 125%;
}

/* Floating animation on stat cards */
.stat-card:nth-child(1) { animation: float 4s ease-in-out infinite; }
.stat-card:nth-child(2) { animation: float 4s ease-in-out infinite 0.5s; }
.stat-card:nth-child(3) { animation: float 4s ease-in-out infinite 1s; }
.stat-card:nth-child(4) { animation: float 4s ease-in-out infinite 1.5s; }

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-6px); }
}

/* Glowing border pulse on featured project cards */
.project-card--featured {
  animation: borderPulse 3s ease-in-out infinite;
}

@keyframes borderPulse {
  0%, 100% { border-color: rgba(124,106,255,0.2); box-shadow: none; }
  50% { border-color: rgba(124,106,255,0.5); box-shadow: 0 0 20px rgba(124,106,255,0.15); }
}

/* Smooth page load fade in */
.app {
  animation: appFadeIn 0.5s ease both;
}

@keyframes appFadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
EOF

echo "✅ Cool animations added — particles, cursor glow, floating cards, shimmer effects!"
