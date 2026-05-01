import React, { useState, useEffect, useRef } from 'react';

function EasterEgg({ trigger }) {
  const canvasRef = useRef(null);
  const [show, setShow] = useState(false);

  useEffect(() => {
    if (!trigger) return;
    setShow(true);
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    const particles = Array.from({ length: 120 }, (_, i) => ({
      x: canvas.width / 2, y: canvas.height / 2,
      angle: (i / 120) * Math.PI * 2,
      speed: Math.random() * 8 + 2,
      radius: Math.random() * 4 + 1,
      color: ['#7c6aff','#57f0b0','#a78bfa','#ffffff','#fbbf24'][Math.floor(Math.random() * 5)],
      life: 1, decay: Math.random() * 0.02 + 0.015,
    }));

    let animId;
    const draw = () => {
      ctx.fillStyle = 'rgba(4,4,13,0.15)';
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      let alive = false;
      particles.forEach(p => {
        p.x += Math.cos(p.angle) * p.speed;
        p.y += Math.sin(p.angle) * p.speed;
        p.speed *= 0.97; p.life -= p.decay;
        if (p.life > 0) {
          alive = true;
          ctx.beginPath();
          ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
          ctx.fillStyle = p.color;
          ctx.globalAlpha = p.life;
          ctx.fill();
          ctx.globalAlpha = 1;
        }
      });
      if (alive) animId = requestAnimationFrame(draw);
      else { setShow(false); ctx.clearRect(0, 0, canvas.width, canvas.height); }
    };
    draw();
    return () => cancelAnimationFrame(animId);
  }, [trigger]);

  if (!show) return null;
  return <canvas ref={canvasRef} style={{ position: 'fixed', inset: 0, width: '100%', height: '100%', pointerEvents: 'none', zIndex: 9999 }} />;
}

export default EasterEgg;
