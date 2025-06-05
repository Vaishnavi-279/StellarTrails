import * as THREE from 'three';

export function mountStarScene(containerId) {
  // Add debug logging
  console.log('mountStarScene called with containerId:', containerId);
  console.log('Available diaries:', window.diaries);

  const container = document.getElementById(containerId);
  if (!container) {
    console.error(`Container "${containerId}" not found!`);
    return;
  }

  const scene = new THREE.Scene();
  scene.background = new THREE.Color(0x000000);

  const camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000);
  camera.position.z = 5;

  const renderer = new THREE.WebGLRenderer();
  renderer.setSize(window.innerWidth, window.innerHeight);
  container.appendChild(renderer.domElement);

  const diaries = window.diaries || [];
  console.log(`Creating ${diaries.length} stars`);

  if (diaries.length === 0) {
    console.warn('No diaries found - creating test stars');
    for (let i = 0; i < 10; i++) {
      const geometry = new THREE.SphereGeometry(0.1, 16, 16);
      const material = new THREE.MeshBasicMaterial({ color: 0xffffff });
      const star = new THREE.Mesh(geometry, material);
      star.position.x = (Math.random() - 0.5) * 10;
      star.position.y = (Math.random() - 0.5) * 10;
      star.position.z = (Math.random() - 0.5) * 10;
      scene.add(star);
      console.log(`Test star ${i} at:`, star.position);
    }
  } else {
    diaries.forEach((diary, index) => {
      const geometry = new THREE.SphereGeometry(0.1, 16, 16);
      const material = new THREE.MeshBasicMaterial({ color: 0xffffff });
      const star = new THREE.Mesh(geometry, material);
      star.position.x = (Math.random() - 0.5) * 10;
      star.position.y = (Math.random() - 0.5) * 10;
      star.position.z = (Math.random() - 0.5) * 10;
      scene.add(star);
      console.log(`Star ${index} for "${diary.title}" at:`, star.position);
    });
  }

  console.log('Total objects in scene:', scene.children.length);

  function animate() {
    requestAnimationFrame(animate);
    renderer.render(scene, camera);
  }
  animate();

  window.addEventListener('resize', () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
  });

  document.addEventListener('keydown', (event) => {
    switch(event.key) {
      case 'ArrowUp': camera.position.z -= 0.5; break;
      case 'ArrowDown': camera.position.z += 0.5; break;
      case 'ArrowLeft': camera.position.x -= 0.5; break;
      case 'ArrowRight': camera.position.x += 0.5; break;
    }
    console.log('Camera position:', camera.position);
  });
}
