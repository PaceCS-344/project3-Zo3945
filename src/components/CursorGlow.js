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
