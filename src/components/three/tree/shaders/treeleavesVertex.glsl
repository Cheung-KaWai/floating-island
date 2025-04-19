varying vec2 vUv;
varying vec3 vNormal2;
varying vec3 vPosition;
varying float vDistance;
uniform float uTime;
uniform sampler2D uNoise;


// return a value between 0 and 1 based on the given value and the min and max range
float inverseLerp(float v,float minValue,float maxValue){
  return(v-minValue)/(maxValue-minValue);
}

// remap values to a min and max range
float remap(float v,float inMin,float inMax,float outMin,float outMax){
  float t=inverseLerp(v,inMin,inMax);
  return mix(outMin,outMax,t);
}

void main() {
  vUv = uv;
  vNormal2 = normalize(csm_Normal);

  float posZ = remap(csm_Position.z,3.,-8., 0., 1.);
  float posX = remap(csm_Position.x,5.,-10., 0., 1.);
  float posY = remap(csm_Position.y,9.,20., 0., 1.);

  float noiseV1 = texture2D(uNoise, vec2(0.3, abs(sin(uTime*0.1)))).r;
  float noiseV2 = texture2D(uNoise, vec2(posX, posY)).r;

  csm_Position.z -= (0.1 + posY) * noiseV1*3.;
  

  csm_Position.z   += (0.1 + posY) * sin(uTime *5.+ noiseV2 * 15.) * 0.4;
  csm_Position.x   += (0.1 + posY) * sin(uTime * 5. + noiseV2 * 20.) * 0.3;

  float distanceCenter = distance(csm_Position, vec3(0., 11., 0.));
  float distanceRight = distance(csm_Position, vec3(-10., 0.,-10.));
  distanceCenter = remap(distanceCenter, 0., 12., 0., 1.);
  distanceRight = remap(distanceRight, 0., 20., 0., 1.);
  distanceRight = pow(distanceRight, 2.);

  vPosition = csm_Position;
  vDistance = distanceRight * distanceCenter;

}