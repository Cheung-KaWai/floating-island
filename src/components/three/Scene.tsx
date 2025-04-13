import { Container } from "@components/ui/atoms/Container";
import { CameraControls, Environment } from "@react-three/drei";
import { Canvas } from "@react-three/fiber";
import { Waterfall } from "./waterfall/Waterfall";
import { Island } from "./Island";
export const Scene = () => {
  return (
    <Container $width="70svw">
      <Canvas>
        <Waterfall />
        <Island />
        <CameraControls camera-position={[30, 10, 0]} />
        <Environment preset="sunset" />
      </Canvas>
    </Container>
  );
};
