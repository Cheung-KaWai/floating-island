import { updateNestedStore, useExampleStore } from "@stores/exampleStore";
import { Leva, useControls } from "leva";

export const Debug = () => {
  const { enable, details } = useExampleStore.use.debug();

  useControls("debug", {
    enable: {
      value: enable,
      onChange: (e) => updateNestedStore("debug", { enable: e }),
    },
    "spacing & labels": {
      value: details,
      onChange: (e) => updateNestedStore("debug", { details: e }),
      render: (get) => get("debug.enable"),
    },
  });

  return <Leva collapsed oneLineLabels />;
};
