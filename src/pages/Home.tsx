import { Scene } from "@components/three/Scene";
import { Debug } from "@components/ui/atoms/Debug";
import { Layout } from "@components/ui/atoms/Layout";
import { SidePanel } from "@components/ui/organisms/SidePanel";

export const Home = () => {
  return (
    <Layout>
      <Scene />
      <SidePanel />
      <Debug />
    </Layout>
  );
};
