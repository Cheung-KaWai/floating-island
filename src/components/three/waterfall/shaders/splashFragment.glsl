uniform sampler2D uTexture;
uniform float vUv;
varying float vTextureIndex;

void main() {
  vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

  vec4 textureColor = texture2D(uTexture, gl_PointCoord); 
  color *= textureColor;
  

  csm_FragColor = color;

  #include <tonemapping_fragment>
  #include <colorspace_fragment>
}
