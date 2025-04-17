/* eslint-disable react-hooks/exhaustive-deps */
import * as THREE from "three";
import { useGLTF, useTexture } from "@react-three/drei";
import { GLTF } from "three-stdlib";
import leavesPositions from "./leaves-position.json";
import { useMemo, useRef, useEffect } from "react";
import CustomShaderMaterial from "three-custom-shader-material";
import { Uniform } from "three";
import treeLeavesVertex from "./shaders/treeleavesVertex.glsl";
import treeLeavesFragment from "./shaders/treeleavesFragment.glsl";
import { useFrame } from "@react-three/fiber";

type GLTFResult = GLTF & {
  nodes: {
    Cube001: THREE.Mesh;
  };
  materials: object;
};

export function Tree(props: JSX.IntrinsicElements["group"]) {
  const { nodes } = useGLTF("/tree-transformed.glb") as GLTFResult;
  const sakuraLeaf = useTexture("/textures/sakura.png");
  const instancedMeshRef = useRef<THREE.InstancedMesh>(null);

  const uniforms = useMemo(() => {
    return {
      uTexture: new Uniform(sakuraLeaf),
      uColor: new Uniform(new THREE.Color("#ffb8e0")),
      uTime: new Uniform(0),
    };
  }, []);

  const instanceCount = leavesPositions.length;
  const randomOffset = 2;

  useEffect(() => {
    if (!instancedMeshRef.current) return;

    const matrix = new THREE.Matrix4();
    const position = new THREE.Vector3();
    const rotation = new THREE.Euler();
    const quaternion = new THREE.Quaternion();
    const scale = new THREE.Vector3(0.6, 0.6, 0.6);

    // Create instance attributes for random offsets and phases
    const randomOffsets = new Float32Array(instanceCount * 3);
    const randomPhases = new Float32Array(instanceCount);

    for (let i = 0; i < instanceCount; i++) {
      // Set position with random offset
      position.set(
        leavesPositions[i][0] + (Math.random() - 0.5) * randomOffset,
        leavesPositions[i][2] + (Math.random() - 0.5),
        -leavesPositions[i][1] + (Math.random() - 0.5) * randomOffset
      );

      // Random rotation for more natural look
      rotation.set(Math.random() * Math.PI, Math.random() * Math.PI, Math.random() * Math.PI);
      quaternion.setFromEuler(rotation);

      // Set the matrix for this instance
      matrix.compose(position, quaternion, scale);
      instancedMeshRef.current.setMatrixAt(i, matrix);

      // Set random offsets and phases for each instance
      randomOffsets[i * 3] = Math.random() * 2.0 - 1.0; // x offset
      randomOffsets[i * 3 + 1] = Math.random() * 2.0 - 1.0; // y offset
      randomOffsets[i * 3 + 2] = Math.random() * 2.0 - 1.0; // z offset
      randomPhases[i] = Math.random() * Math.PI * 2.0; // random phase
    }

    instancedMeshRef.current.instanceMatrix.needsUpdate = true;

    // Add the attributes to the geometry
    const geometry = instancedMeshRef.current.geometry;
    geometry.setAttribute("randomOffset", new THREE.InstancedBufferAttribute(randomOffsets, 3));
    geometry.setAttribute("randomPhase", new THREE.InstancedBufferAttribute(randomPhases, 1));
  }, [instanceCount]);

  useFrame(() => {
    uniforms.uTime.value += 0.01;
  });

  return (
    <>
      <group {...props} dispose={null}>
        <mesh geometry={nodes.Cube001.geometry} material={nodes.Cube001.material} />
      </group>
      <instancedMesh ref={instancedMeshRef} args={[new THREE.PlaneGeometry(0.5, 0.5), undefined, instanceCount]} frustumCulled={false}>
        <CustomShaderMaterial
          baseMaterial={THREE.MeshStandardMaterial}
          uniforms={uniforms}
          vertexShader={treeLeavesVertex}
          fragmentShader={treeLeavesFragment}
          transparent
          side={THREE.DoubleSide}
          depthWrite={false}
        />
      </instancedMesh>
    </>
  );
}

useGLTF.preload("/tree-transformed.glb");
