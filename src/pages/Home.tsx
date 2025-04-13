import { Scene } from "@components/three/Scene";
import { Debug } from "@components/ui/atoms/Debug";
import { Layout } from "@components/ui/atoms/Layout";

export const Home = () => {
  return (
    <Layout>
      <Scene />
      <Debug />
    </Layout>
  );
};
