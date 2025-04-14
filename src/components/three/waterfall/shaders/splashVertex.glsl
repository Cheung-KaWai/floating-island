uniform float uTime;
uniform float uPixelRatio;

attribute float speed;
attribute float start;
attribute float splashSize;
attribute float offset;
attribute float textureIndex;

varying float vTextureIndex;

void main() {
  vec4 modelViewPosition = modelViewMatrix * vec4(position, 1.0);
  csm_PointSize = splashSize * 0.05;

  // Calculate time-based movement
  float t = fract(uTime + start);
  
  // Add horizontal sway using sine wave
  float sway = sin(t * 2.0 + start) * 0.1;
  
  // Add acceleration to vertical movement
  float verticalSpeed = speed * (1.0 + t * 0.5);
  
  // Apply movement
  csm_Position.x += offset;
  csm_Position.x += sway;
  csm_Position.y -= t * verticalSpeed;

  vTextureIndex = textureIndex;
}
