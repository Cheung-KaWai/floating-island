import { Container } from "@components/ui/atoms/Container";
import { CameraControls } from "@react-three/drei";
import { Canvas } from "@react-three/fiber";
import { Flag } from "./Flag";

export const Scene = () => {
  return (
    <Container $width="70svw">
      <Canvas>
        <Flag />
        <CameraControls />
      </Canvas>
    </Container>
  );
};
