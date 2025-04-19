/* eslint-disable react-hooks/exhaustive-deps */
import { useFrame } from "@react-three/fiber";
import { useControls } from "leva";
import { useMemo } from "react";
import { BufferAttribute, BufferGeometry, Color, PointsMaterial, Uniform, Vector3 } from "three";
import { useTexture } from "@react-three/drei";
import CustomShaderMaterial from "three-custom-shader-material";
import vertexShader from "./shaders/FallingLeavesVertex.glsl";
import fragmentShader from "./shaders/FallingLeavesFragment.glsl";

export const FallingLeaves = () => {
  useControls("falling leaves", {
    uColor: {
      value: "#2ee7ff",
      label: "Primary Color",
      onChange: (value) => {
        uniforms.uColor.value = new Color(value);
      },
    },
    uColor2: {
      value: "#ff84ca",
      label: "Secondary Color",
      onChange: (value) => {
        uniforms.uColor2.value = new Color(value);
      },
    },
  });

  const noise = useTexture("/textures/noise.png");
  const leaf = useTexture("/textures/singleSakura.png");
  leaf.flipY = false;

  const uniforms = useMemo(() => {
    return {
      uColor: new Uniform(new Color("#ffb8e0")),
      uColor2: new Uniform(new Color("#ffb8e0")),
      uTime: new Uniform(0),
      uNoise: new Uniform(noise),
      uLeaf: new Uniform(leaf),
    };
  }, []);

  useFrame(({ clock }) => {
    uniforms.uTime.value = clock.getElapsedTime();
  });

  const geometry = useMemo(() => {
    const geometry = new BufferGeometry();

    const count = 400;
    const center = new Vector3(-1, 14, 4);
    const spread = 9;
    const positionsArray = new Float32Array(count * 3);
    const speedArray = new Float32Array(count);
    const delayStartArray = new Float32Array(count);
    const randomAngleArray = new Float32Array(count);
    for (let i = 0; i < count; i++) {
      positionsArray[i * 3] = center.x + (Math.random() - 0.5) * spread;
      positionsArray[i * 3 + 1] = center.y + (Math.random() - 0.5) * spread * 0.5;
      positionsArray[i * 3 + 2] = center.z + (Math.random() - 0.5) * spread;
      speedArray[i] = 0.1 + Math.random();
      delayStartArray[i] = Math.random();
      randomAngleArray[i] = (Math.random() - 0.5) * 2 * 360;
    }

    geometry.setAttribute("position", new BufferAttribute(positionsArray, 3));
    geometry.setAttribute("speed", new BufferAttribute(speedArray, 1));
    geometry.setAttribute("delayStart", new BufferAttribute(delayStartArray, 1));
    geometry.setAttribute("randomAngle", new BufferAttribute(randomAngleArray, 1));
    return geometry;
  }, []);

  return (
    <points geometry={geometry}>
      <CustomShaderMaterial baseMaterial={PointsMaterial} vertexShader={vertexShader} fragmentShader={fragmentShader} uniforms={uniforms} />
    </points>
  );
};
