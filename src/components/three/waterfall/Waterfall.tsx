import CustomShaderMaterial from "three-custom-shader-material";
import * as THREE from "three";
import { useGLTF } from "@react-three/drei";
import { GLTF } from "three-stdlib";
import { useFrame } from "@react-three/fiber";
import vertex from "./vertex.glsl";
import fragment from "./fragment.glsl";
import { useMemo } from "react";
import { useControls } from "leva";
import { Uniform } from "three";
type GLTFResult = GLTF & {
  nodes: {
    water: THREE.Mesh;
  };
  materials: object;
};

export function Waterfall(props: JSX.IntrinsicElements["group"]) {
  const { nodes } = useGLTF("/waterfall-transformed.glb") as GLTFResult;

  useControls({
    uVeronoiScale: { value: 1.6, min: 0.1, max: 10, step: 0.1, onChange: (value) => (uniforms.uVeronoiScale.value = value) },
    uWaterColor: {
      value: "#0ba6de",
      onChange: (value) => (uniforms.uWaterColor.value = new THREE.Color(value)),
    },
    uWaterAccentColor: {
      value: "#12ebff",
      onChange: (value) => (uniforms.uWaterAccentColor.value = new THREE.Color(value)),
    },
  });

  const uniforms = useMemo(
    () => ({
      uTime: new Uniform(0),
      uVeronoiScale: new Uniform(1.6),
      uWaterColor: new Uniform(new THREE.Color(0.1, 0.1, 0.1)),
      uWaterAccentColor: new Uniform(new THREE.Color(0.1, 0.1, 0.1)),
    }),
    []
  );

  useFrame((state) => {
    uniforms.uTime.value = state.clock.getElapsedTime();
  });

  return (
    <group {...props} dispose={null}>
      <mesh geometry={nodes.water.geometry}>
        <CustomShaderMaterial baseMaterial={THREE.MeshStandardMaterial} vertexShader={vertex} fragmentShader={fragment} uniforms={uniforms} />
      </mesh>
    </group>
  );
}

useGLTF.preload("/waterfall-transformed.glb");
