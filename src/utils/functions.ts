export const getRandomColor = () => {
  const randomHex = () => Math.floor(Math.random() * 256);
  return `${randomHex()}, ${randomHex()}, ${randomHex()}`;
};
