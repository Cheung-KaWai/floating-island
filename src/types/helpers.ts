export type FilterObjectKeys<T> = {
  [K in keyof T]: T[K] extends object ? K : never;
}[keyof T];
