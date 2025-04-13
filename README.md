# Boilerplate R3F

This template provides a minimal setup to create a react-three-fiber application. Following features are included:

- [zustand](https://zustand-demo.pmnd.rs/) a store for keeping global states, this store is accessible in the react-devtools
- [shaders](https://blog.maximeheckel.com/posts/the-study-of-shaders-with-react-three-fiber/) a basic shader example with importing separate glsl files and passing uniforms props
- [leva](https://github.com/pmndrs/leva) a GUI for development, a debug toggle has been setup to help visualy debugging the UI of the application
- [styled-components](https://styled-components.com/) this is used for the styling, a reusable Container and Layout component are provided which can be extended with extra props

Future enhancements:

- [react-scan](https://react-scan.com/) a tool for finding performance issues, currently still has a bug with r3f [#175](https://github.com/aidenybai/react-scan/issues/175). Will be added when the new version is released

Last update 29/12/2024
