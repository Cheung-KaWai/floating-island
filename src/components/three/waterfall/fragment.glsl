varying vec2 vUv;

uniform float uTime;
uniform float uVeronoiScale;
uniform vec3 uWaterColor;
uniform vec3 uWaterAccentColor;

// Function to generate random value
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// Function to generate noise
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

// Function to generate Voronoi pattern
vec3 voronoi(vec2 x) {
    vec2 n = floor(x);
    vec2 f = fract(x);

    vec2 m = vec2(8.0);
    for(int j = -1; j <= 1; j++) {
        for(int i = -1; i <= 1; i++) {
            vec2 g = vec2(float(i), float(j));
            vec2 o = vec2(random(n + g)) * 0.5 + 0.5;
            // Add time-based variation to the offset
            o += vec2(sin(uTime * 0.5 + random(n + g) * 6.28) * 0.1);
            vec2 r = g + o - f;
            float d = dot(r, r);
            if(d < m.x) {
                m.y = m.x;
                m.x = d;
            } else if(d < m.y) {
                m.y = d;
            }
        }
    }
    return vec3(sqrt(m.x), sqrt(m.y), m.y - m.x);
}


void main() {
    // Scale the UV coordinates and add time-based vertical movement
    vec2 uv = vUv * 10.0;
    
    // Add some noise-based distortion to the UV coordinates
    vec2 distortion = vec2(
        noise(uv + uTime * 0.2) * 0.5,
        noise(uv + uTime * 0.3) * 0.5
    );

    uv += distortion;
    uv.y -= uTime * 2.0;
    uv.x *=2.;
    
    // Generate Voronoi pattern
    vec3 c = voronoi(uv);

    c = pow(c, vec3(uVeronoiScale));
    
    // Create a color based on the Voronoi pattern with some noise variation
    float color = c.x * 0.8 + c.y * 0.2;
    color += noise(uv * 2.0 + uTime) * 0.1;

    vec3 waterColor = mix(uWaterColor, uWaterAccentColor, color);
    
    csm_FragColor = vec4(waterColor, 1.0);
}
