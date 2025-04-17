uniform sampler2D uTexture;
uniform vec3 uColor;
varying vec2 vUv;
void main() {
  vec4 color = texture2D(uTexture, vUv);
  
  color.rgb *= uColor;
  csm_DiffuseColor = color;
}
