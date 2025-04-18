
varying vec2 vUv;
varying vec3 vNormal2;

void main() {
  vec3 normal2 = normalize(vNormal2);
  
  if (!gl_FrontFacing) {
    normal2 = -normal2;
  }
  
  csm_FragNormal = normal2;
}
