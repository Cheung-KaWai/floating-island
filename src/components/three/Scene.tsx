import { Container } from "@components/ui/atoms/Container";
import { CameraControls, Environment } from "@react-three/drei";
import { Canvas } from "@react-three/fiber";
import { Splash } from "./waterfall/Splash";
import { Island } from "./Island";
import { Waterfall } from "./waterfall/Waterfall";
export const Scene = () => {
  return (
    <Container $width="100svw">
      <Canvas>
        <Waterfall />
        <Island />
        <Splash />
        <CameraControls camera-position={[30, 10, 0]} />
        <Environment preset="sunset" />
      </Canvas>
    </Container>
  );
};
