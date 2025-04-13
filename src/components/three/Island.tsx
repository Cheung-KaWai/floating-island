import * as THREE from "three";
import { useGLTF } from "@react-three/drei";
import { GLTF } from "three-stdlib";

type GLTFResult = GLTF & {
  nodes: {
    Icosphere001: THREE.Mesh;
  };
  materials: object;
};

export function Island(props: JSX.IntrinsicElements["group"]) {
  const { nodes } = useGLTF("/island-transformed.glb") as GLTFResult;
  return (
    <group {...props} dispose={null}>
      <mesh geometry={nodes.Icosphere001.geometry} material={nodes.Icosphere001.material} />
    </group>
  );
}

useGLTF.preload("/island-transformed.glb");
