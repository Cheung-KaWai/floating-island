varying vec2 vUv;
varying vec3 vNormal2;

uniform float uTime;

// Noise functions
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main() {
  vUv = uv;
  vNormal2 = normalize(csm_Normal);

  // Create noise-based movement
  float noiseZ = noise(vec2(csm_Position.y * 0.1, uTime + 20.0));
  
  // Combine noise with existing sine wave for more natural movement
  float sway = sin(csm_Position.y * 0.5 + uTime *3.0) * 0.5;
  
  csm_Position.z += (csm_Position.x + csm_Position.z) * (sway + noiseZ) * 0.03;
}