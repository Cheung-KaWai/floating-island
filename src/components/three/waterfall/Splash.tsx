import { useMemo } from "react";
import * as THREE from "three";
export const Splash = () => {
  const geometry = useMemo(() => {
    const positionsArray = new Float32Array(30);

    for (let i = 0; i < 10; i++) {
      const i3 = i * 3;
      positionsArray[i3] = Math.random() - 0.5;
      positionsArray[i3 + 1] = Math.random() - 0.5;
      positionsArray[i3 + 2] = Math.random() - 0.5;
    }

    const geometry = new THREE.BufferGeometry();
    geometry.setAttribute("position", new THREE.BufferAttribute(positionsArray, 3));
    return geometry;
  }, []);

  return (
    <points geometry={geometry}>
      <pointsMaterial />
    </points>
  );
};
