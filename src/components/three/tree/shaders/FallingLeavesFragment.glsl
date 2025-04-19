uniform vec3 uColor;
uniform vec3 uColor2; 
uniform sampler2D uLeaf;
uniform float uTime;
varying float vNoise;
vec2 rotate(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(c, s, -s, c);
	return m * v;
}

varying float vDistance;
void main() {
  vec4 leaf = texture2D(uLeaf, rotate(gl_PointCoord, abs(sin(vNoise) * 0.5)));
  if(leaf.r <= 0.9) {
    discard;
  }

  float mixColor = clamp(vDistance, 0.0, 1.0);

  vec3 color = mix(uColor, uColor2, mixColor);
  csm_FragColor = vec4(color * color, leaf.r);
   #include <tonemapping_fragment>
   #include <colorspace_fragment>
}