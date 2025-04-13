import { create } from "zustand";
import { mountStoreDevtool } from "simple-zustand-devtools";
import { createSelectors } from "./selectors";
import { FilterObjectKeys } from "@customTypes/helpers";

interface ExampleState {
  debug: {
    enable: boolean;
    details: boolean;
  };
  foo: number;
  bar: string;
  list: {
    param1: string;
    param2: string;
  };
}

const initState = {
  debug: {
    enable: import.meta.env.MODE === "development",
    details: true,
  },
  foo: 0,
  bar: "example",
  list: {
    param1: "param1",
    param2: "param2",
  },
};

// createSelectors function for easy access of props: useExampleStore.use.prop()
export const useExampleStore = createSelectors(
  create<ExampleState>()(() => ({
    ...initState,
  }))
);

// seperate actions from the store for easy import and usage
export const resetStore = () => useExampleStore.setState(initState);
export const updateStore = (updates: Partial<ExampleState>) => useExampleStore.setState(() => updates);
export const updateNestedStore = <K extends FilterObjectKeys<ExampleState>>(key: K, updates: Partial<ExampleState[K]>) => {
  useExampleStore.setState((state) => ({
    [key]: { ...state[key], ...updates },
  }));
};

// show store in devtools
if (import.meta.env.MODE === "development") mountStoreDevtool("store", useExampleStore);
