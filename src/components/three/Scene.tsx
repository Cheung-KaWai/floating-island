import { Container } from "@components/ui/atoms/Container";
import { CameraControls } from "@react-three/drei";
import { Canvas } from "@react-three/fiber";
import { Waterfall } from "./waterfall/Waterfall";
export const Scene = () => {
  return (
    <Container $width="70svw">
      <Canvas>
        <Waterfall />
        <CameraControls camera-position={[30, 10, 0]} />
      </Canvas>
    </Container>
  );
};
