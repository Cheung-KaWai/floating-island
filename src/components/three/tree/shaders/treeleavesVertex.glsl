varying vec2 vUv;
varying vec3 vNormal2;

uniform float uTime;

void main() {
  vUv = uv;
  vNormal2 = normalize(csm_Normal);
}