
varying vec2 vUv;
varying vec3 vNormal2;

uniform sampler2D uAlphaMap;

void main() {
  vec3 normal2 = normalize(vNormal2);
  vec4 alphaMap = texture2D(uAlphaMap, vUv);
  float alpha = alphaMap.r;

  if(alpha < 0.5) {
    discard;
  }
  
  if (!gl_FrontFacing) {
    normal2 = -normal2;
  }
  
  csm_FragNormal = normal2;
}
