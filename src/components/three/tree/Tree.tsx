/* eslint-disable react-hooks/exhaustive-deps */
import * as THREE from "three";
import { useGLTF, useTexture } from "@react-three/drei";
import { GLTF } from "three-stdlib";
import leavesPositions from "./leaves-position.json";
import { useMemo } from "react";
import CustomShaderMaterial from "three-custom-shader-material";
import { DoubleSide, Uniform } from "three";
import treeLeavesVertex from "./shaders/treeleavesVertex.glsl";
import treeLeavesFragment from "./shaders/treeleavesFragment.glsl";
import { useFrame } from "@react-three/fiber";
import { mergeGeometries } from "three/examples/jsm/utils/BufferGeometryUtils.js";
import { useControls } from "leva";

type GLTFResult = GLTF & {
  nodes: {
    Cube001: THREE.Mesh;
  };
  materials: object;
};

export function Tree(props: JSX.IntrinsicElements["group"]) {
  const { nodes } = useGLTF("/tree-transformed.glb") as GLTFResult;
  const sakuraLeaf = useTexture("/textures/sakura.png");
  const noise = useTexture("/textures/noise.png");
  const matcap = useTexture("/textures/matcap.png");

  useControls("tree", {
    uColor: {
      value: "#e78fef",
      label: "Primary Color",
      onChange: (value) => {
        uniforms.uColor.value = new THREE.Color(value);
      },
    },
    uColor2: {
      value: "#ff7cc6",
      label: "Secondary Color",
      onChange: (value) => {
        uniforms.uColor2.value = new THREE.Color(value);
      },
    },
  });

  const uniforms = useMemo(() => {
    return {
      uAlphaMap: new Uniform(sakuraLeaf),
      uColor: new Uniform(new THREE.Color("#ffb8e0")),
      uColor2: new Uniform(new THREE.Color("#ffb8e0")),
      uTime: new Uniform(0),
      uNoise: new Uniform(noise),
      uMatcap: new Uniform(matcap),
    };
  }, []);

  const instanceCount = leavesPositions.length;

  useFrame(() => {
    uniforms.uTime.value += 0.01;
  });

  const mergedGeometry = useMemo(() => {
    const count = instanceCount;
    const leaves = [];
    const matrix = new THREE.Matrix4();
    const position = new THREE.Vector3();
    const rotation = new THREE.Euler();
    const quaternion = new THREE.Quaternion();
    const randomOffset = 2;

    for (let i = 0; i < count; i++) {
      const leaf = new THREE.PlaneGeometry(1, 1);
      leaves.push(leaf);

      position.set(
        leavesPositions[i][0] + (Math.random() - 0.5) * randomOffset,
        leavesPositions[i][2] + (Math.random() - 0.5) * randomOffset,
        -leavesPositions[i][1] + (Math.random() - 0.5) * randomOffset
      );

      // Random rotation for more natural look
      rotation.set(Math.random() * Math.PI, Math.random() * Math.PI, Math.random() * Math.PI);
      quaternion.setFromEuler(rotation);

      // Set the matrix for this instance
      matrix.compose(position, quaternion, new THREE.Vector3(0.4, 0.4, 0.4));
      leaf.applyMatrix4(matrix);

      // Normal
      const normal = position.clone().normalize();
      const normalArray = new Float32Array(12);
      for (let i = 0; i < 4; i++) {
        const i3 = i * 3;

        const position = new THREE.Vector3(
          leaf.attributes.position.array[i3],
          leaf.attributes.position.array[i3 + 1],
          leaf.attributes.position.array[i3 + 2]
        );

        position.sub(new THREE.Vector3(0, 10, 0));

        const mixedNormal = position.lerp(normal, 0.4);

        normalArray[i3] = mixedNormal.x;
        normalArray[i3 + 1] = mixedNormal.y;
        normalArray[i3 + 2] = mixedNormal.z;
      }
      leaf.setAttribute("normal", new THREE.BufferAttribute(normalArray, 3));
    }

    const geometry = mergeGeometries(leaves);
    return geometry;
  }, []);

  return (
    <group>
      <mesh geometry={mergedGeometry}>
        <CustomShaderMaterial
          baseMaterial={THREE.MeshStandardMaterial}
          uniforms={uniforms}
          vertexShader={treeLeavesVertex}
          fragmentShader={treeLeavesFragment}
          transparent
          side={DoubleSide}
        />
      </mesh>
      <group {...props} dispose={null}>
        <mesh geometry={nodes.Cube001.geometry} material={nodes.Cube001.material} />
      </group>
    </group>
  );
}

useGLTF.preload("/tree-transformed.glb");
