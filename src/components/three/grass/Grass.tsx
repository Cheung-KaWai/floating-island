/* eslint-disable react-hooks/exhaustive-deps */

import { InstancedBufferGeometry, Sphere, Vector3, Uniform, Vector4, FrontSide } from "three";
import fragment from "./shaders/grassFragment.glsl";
import vertex from "./shaders/grassVertex.glsl";
import { useMemo } from "react";
import { useFrame } from "@react-three/fiber";
import { useTexture } from "@react-three/drei";

export const Grass = () => {
  const numGrass = 100000;
  const segments = 6;
  const vertices = (segments + 1) * 2;
  const patchSize = 20;
  const grassWidth = 0.1;
  const grassHeight = 1;
  const grassData = useTexture("/textures/grassData.png");

  const geometry = useMemo(() => {
    const indices = [];

    for (let i = 0; i < segments; i++) {
      const vi = i * 2;
      indices[i * 12 + 0] = vi + 0;
      indices[i * 12 + 1] = vi + 1;
      indices[i * 12 + 2] = vi + 2;
      indices[i * 12 + 3] = vi + 2;
      indices[i * 12 + 4] = vi + 1;
      indices[i * 12 + 5] = vi + 3;

      const fi = vertices + vi;

      indices[i * 12 + 6] = fi + 2;
      indices[i * 12 + 7] = fi + 1;
      indices[i * 12 + 8] = fi + 0;
      indices[i * 12 + 9] = fi + 3;
      indices[i * 12 + 10] = fi + 1;
      indices[i * 12 + 11] = fi + 2;
    }
    console.log(indices);
    const geo = new InstancedBufferGeometry();
    geo.instanceCount = numGrass;
    geo.setIndex(indices);
    geo.boundingSphere = new Sphere(new Vector3(), 1 + patchSize * 2);

    return geo;
  }, []);

  const uniforms = useMemo(() => {
    return {
      uTime: new Uniform(0),
      uGrassParams: new Uniform(new Vector4(segments, patchSize, grassWidth, grassHeight)),
      uGrassData: new Uniform(grassData),
    };
  }, []);

  console.log(geometry);

  useFrame(({ clock }) => {
    uniforms.uTime.value = clock.getElapsedTime();
  });

  return (
    <mesh geometry={geometry} position={[0, 4.9, 0]} rotation={[0, Math.PI, 0]}>
      <shaderMaterial fragmentShader={fragment} vertexShader={vertex} uniforms={uniforms} side={FrontSide} />
    </mesh>
  );
};
