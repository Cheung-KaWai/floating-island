varying vec2 vUv;
varying vec3 vNormal2;
varying vec3 vPosition;

uniform float uTime;

attribute vec4 tangent;

// Simplex noise functions
vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(((x*34.0)+1.0)*x); }

float snoise(vec2 v) {
    const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                        0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                        -0.577350269189626,  // -1.0 + 2.0 * C.x
                        0.024390243902439); // 1.0 / 41.0
    vec2 i  = floor(v + dot(v, C.yy));
    vec2 x0 = v -   i + dot(i, C.xx);
    vec2 i1;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = mod289(i);
    vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0)) + i.x + vec3(0.0, i1.x, 1.0));
    vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
    m = m*m;
    m = m*m;
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * (a0*a0 + h*h);
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

float getWave(vec3 position){
    // Wave parameters
  float waveHeight = 0.1;  // Increased base height
  float waveSpeed = 1.;
  
  // Create multiple layers of noise with different scales and speeds
  float noise1 = snoise(vec2(position.x * 0.5 + uTime * waveSpeed, position.z * 0.5));
  float noise2 = snoise(vec2(position.x * 1.0 - uTime * waveSpeed * 0.7, position.z * 1.0));
  
  // Combine the noise layers with different weights
  float combinedNoise = (
    noise1 * 0.4 +  // Large waves
    noise2 * 0.3 
  );

  float elevation = combinedNoise * waveHeight;

  return elevation;
}

void main() {
  vUv = uv;

  vec3 biTangent = cross(normal, tangent.xyz);
  float shift = 0.01;

  vec3 pos1 = csm_Position + tangent.xyz * shift;
  vec3 pos2 = csm_Position + biTangent * shift;

  float elevation = getWave(csm_Position);
  
  // Apply the wave effect
  csm_Position.yx += elevation;
  pos1.yx += getWave(pos1);
  pos2.yx += getWave(pos2);

  //compute the normal
  vec3 toA = normalize(pos1 - csm_Position);
  vec3 toB = normalize(pos2 - csm_Position);
  csm_Normal = normalize(cross(toA, toB));

  vPosition = csm_Position.xyz;
  vNormal2 = normalize(cross(toA, toB));
}
