import { Container } from "@components/ui/atoms/Container";
import { CameraControls, Environment } from "@react-three/drei";
import { Canvas } from "@react-three/fiber";
import { Splash } from "./waterfall/Splash";
import { Island } from "./island/Island";
import { Waterfall } from "./waterfall/Waterfall";
import { Rock } from "./waterfall/Rock";
import { Tree } from "./tree/Tree";
import { Grass } from "./grass/Grass";
export const Scene = () => {
  return (
    <Container $width="100svw">
      <Canvas>
        <Waterfall />
        <Island />
        <Rock />
        <Splash />
        <CameraControls camera-position={[25, 13, -10]} />
        <Environment preset="sunset" />
        <Tree />
        <Grass />
      </Canvas>
    </Container>
  );
};
