import { Container } from "../atoms/Container";

export const SidePanel = () => {
  return (
    <Container $flexGrow={1}>
      <Container>element1</Container>
      <Container>element2</Container>
    </Container>
  );
};
