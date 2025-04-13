varying vec2 vUv;
uniform float uTime;

void main(){
  vec3 newPosition = position;
  newPosition.z += sin(position.x + uTime * 5.);

  vec4 modelPosition=modelMatrix*vec4(newPosition,1.);
  vec4 viewPosition=viewMatrix*modelPosition;
  vec4 projectedPosition=projectionMatrix*viewPosition;
  
  gl_Position=projectedPosition;
  
  vUv=uv;
}