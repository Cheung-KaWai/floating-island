attribute float splashSize;
attribute vec3 offset;
attribute float start;
attribute float textureIndex;
uniform float uTime;
uniform float uPixelRatio;

varying float vTextureIndex;

void main() {
  csm_Position += offset * 0.5;
  csm_PointSize = splashSize * 0.4 * fract(uTime + start) * uPixelRatio;
  vTextureIndex = textureIndex;
}