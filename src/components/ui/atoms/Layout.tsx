import { Debug } from "@customTypes/types";
import { useExampleStore } from "@stores/exampleStore";
import { getRandomColor } from "@utils/functions";
import { FC, PropsWithChildren } from "react";
import styled, { css } from "styled-components";

interface LayoutProps extends Debug {
  $flexDirection: "row" | "row-reverse" | "column" | "column-reverse";
  $justifyContent: "flex-start" | "flex-end" | "center" | "space-between" | "space-around" | "space-evenly";
  $alignItems: "stretch" | "flex-start" | "flex-end" | "center" | "baseline";
  $gap: number;
}

export const Layout: FC<PropsWithChildren & Partial<LayoutProps>> = ({ children, ...rest }) => {
  const { enable, details } = useExampleStore.use.debug();

  return (
    <LayoutContainer $debug={enable} $debugDetails={details} $debugColor={getRandomColor()} {...rest}>
      {children}
    </LayoutContainer>
  );
};

const LayoutContainer = styled.div<Partial<LayoutProps>>`
  position: relative;
  display: flex;
  height: 100%;
  width: 100%;
  flex-direction: ${(props) => props.$flexDirection};
  align-items: ${(props) => props.$alignItems};
  justify-content: ${(props) => props.$justifyContent};
  gap: ${(props) => (props.$gap ? props.$gap + "rem" : null)};
  ${(props) =>
    props.$debug &&
    css`
      padding: ${props.$debugDetails ? "0.8rem" : null};
      border: 1px dashed rgba(${props.$debugColor});
      background-color: rgba(${props.$debugColor}, 0.1);

      &::after {
        content: "${props.$debugDetails ? "Layout" : ""}";
        text-transform: uppercase;
        display: block;
        position: absolute;
        bottom: 0;
        right: 0px;
        font-size: 6px;
        color: red;
        letter-spacing: 1px;
        font-weight: 800;
      }
    `}
`;
