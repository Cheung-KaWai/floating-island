import * as THREE from "three";
import { useGLTF } from "@react-three/drei";
import { GLTF } from "three-stdlib";

type GLTFResult = GLTF & {
  nodes: {
    Icosphere001_1: THREE.Mesh;
    Icosphere001_2: THREE.Mesh;
  };
  materials: {
    ISLAND: THREE.MeshStandardMaterial;
    GROUND: THREE.MeshStandardMaterial;
  };
};

export function Island(props: JSX.IntrinsicElements["group"]) {
  const { nodes, materials } = useGLTF("/island-transformed.glb") as GLTFResult;
  return (
    <group {...props} dispose={null}>
      <mesh geometry={nodes.Icosphere001_1.geometry} material={materials.ISLAND} />
      <mesh geometry={nodes.Icosphere001_2.geometry} material={materials.GROUND} />
    </group>
  );
}

useGLTF.preload("/island-transformed.glb");
