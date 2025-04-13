import vertex from "@shadersFolder/flag/vertex.glsl";
import fragment from "@shadersFolder/flag/fragment.glsl";
import { DoubleSide, Uniform } from "three";
import { useMemo } from "react";
import { useFrame } from "@react-three/fiber";
import { useExampleStore } from "@stores/exampleStore";

export const Flag = () => {
  const uniforms = useMemo(
    () => ({
      uTime: new Uniform(0),
    }),
    []
  );

  useFrame(({ clock }) => {
    uniforms.uTime.value = clock.getElapsedTime();
  });

  return (
    <mesh>
      <planeGeometry args={[1, 1, 10, 10]} />
      <shaderMaterial
        uniforms={uniforms}
        vertexShader={vertex}
        fragmentShader={fragment}
        side={DoubleSide}
        wireframe={useExampleStore.use.debug().enable}
      />
    </mesh>
  );
};
