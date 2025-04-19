varying float vDistance;
uniform float uTime;
attribute float speed;
attribute float delayStart;
attribute float randomAngle;
uniform sampler2D uNoise;
varying float vNoise;
varying float vRandomAngle;
float inverseLerp(float v,float minValue,float maxValue){
  return(v-minValue)/(maxValue-minValue);
}

// remap values to a min and max range
float remap(float v,float inMin,float inMax,float outMin,float outMax){
  float t=inverseLerp(v,inMin,inMax);
  return mix(outMin,outMax,t);
}

void main() {

  float distanceCenter = distance(csm_Position, vec3(0., 11., 0.));
  float distanceRight = distance(csm_Position, vec3(-10., 0.,-10.));
  distanceCenter = remap(distanceCenter, 0., 12., 0., 1.);
  distanceRight = remap(distanceRight, 0., 20., 0., 1.);
  distanceRight = pow(distanceRight, 2.);

  float posY = remap(csm_Position.y, 7., 17., 0., 1.);
  float noise = texture2D(uNoise, vec2(posY,abs(sin(uTime* 0.1)))).r;

  vDistance = distanceRight * distanceCenter;

  float t = fract((uTime + delayStart) * 0.7 +  (speed * 0.5));
  csm_Position.y -=noise* 15. * speed * t;
  csm_Position.z -= 15. * speed * t;

  gl_PointSize *= 1.+noise;

  vNoise = noise;
  vRandomAngle = randomAngle;


}