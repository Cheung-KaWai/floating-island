import { useMemo } from "react";
import * as THREE from "three";
import CustomShaderMaterial from "three-custom-shader-material";
import vertex from "./shaders/splashVertex.glsl";
import fragment from "./shaders/splashFragment.glsl";
import { useFrame } from "@react-three/fiber";
import { Uniform } from "three";
import { useTexture } from "@react-three/drei";
export const Splash = () => {
  const waterTexture = useTexture("/textures/water.png");
  const waterTexture2 = useTexture("/textures/water2.png");
  const waterTexture3 = useTexture("/textures/water3.png");

  const geometry = useMemo(() => {
    const count = 1000;
    const positionsArray = new Float32Array(count * 3);
    const speedArray = new Float32Array(count);
    const splashSizeArray = new Float32Array(count);
    const startArray = new Float32Array(count);
    const offsetArray = new Float32Array(count);
    const textureIndexArray = new Float32Array(count);
    for (let i = 0; i < count; i++) {
      const i3 = i * 3;
      positionsArray[i3] = 0;
      positionsArray[i3 + 1] = 0;
      positionsArray[i3 + 2] = Math.random() * 7;
      speedArray[i] = 5 + Math.random() * 20;
      splashSizeArray[i] = Math.random() * 5;
      startArray[i] = Math.random();
      offsetArray[i] = (Math.random() - 0.5) * 2;
      textureIndexArray[i] = Math.floor(Math.random() * 3);
    }

    const geometry = new THREE.BufferGeometry();
    geometry.setAttribute("position", new THREE.BufferAttribute(positionsArray, 3));
    geometry.setAttribute("speed", new THREE.BufferAttribute(speedArray, 1));
    geometry.setAttribute("splashSize", new THREE.BufferAttribute(splashSizeArray, 1));
    geometry.setAttribute("start", new THREE.BufferAttribute(startArray, 1));
    geometry.setAttribute("offset", new THREE.BufferAttribute(offsetArray, 1));
    geometry.setAttribute("textureIndex", new THREE.BufferAttribute(textureIndexArray, 1));

    console.log(geometry.attributes.textureIndex);
    return geometry;
  }, []);

  const uniforms = useMemo(() => {
    return {
      uTime: new Uniform(0),
      uPixelRatio: new Uniform(Math.min(window.devicePixelRatio, 2)),
      uTexture: new Uniform(waterTexture),
      uTexture2: new Uniform(waterTexture2),
      uTexture3: new Uniform(waterTexture3),
    };
  }, [waterTexture, waterTexture2, waterTexture3]);

  useFrame((state) => {
    uniforms.uTime.value = state.clock.getElapsedTime();
  });

  return (
    <points geometry={geometry} position={[15, 5, -4]}>
      <CustomShaderMaterial
        baseMaterial={THREE.PointsMaterial}
        vertexShader={vertex}
        fragmentShader={fragment}
        uniforms={uniforms}
        transparent
        blending={THREE.AdditiveBlending}
      />
    </points>
  );
};
