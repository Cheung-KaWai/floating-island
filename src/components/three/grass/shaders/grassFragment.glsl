varying vec3 vColour;
varying vec4 vGrassData;
varying vec3 vNormal;
varying vec3 vWorldPosition;

float inverseLerp(float v, float minValue, float maxValue) {
  return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
  float t = inverseLerp(v, inMin, inMax);
  return mix(outMin, outMax, t);
}

float test(float x) {
  return clamp(x, 0.0, 1.0);
}

vec3 lambertLight(vec3 normal, vec3 viewDir, vec3 lightDir, vec3 lightColour) {
  float wrap = 0.5;
  float dotNL = test((dot(normal, lightDir) + wrap) / (1.0 + wrap));
  vec3 lighting = vec3(dotNL);
  
  float backlight = test((dot(viewDir, -lightDir) + wrap) / (1.0 + wrap));
  vec3 scatter = vec3(pow(backlight, 2.0));

  lighting += scatter;

  return lighting * lightColour;  
}

vec3 hemiLight(vec3 normal, vec3 groundColour, vec3 skyColour) {
  return mix(groundColour, skyColour, 0.5 * normal.y + 0.5);
}

vec3 phongSpecular(vec3 normal, vec3 lightDir, vec3 viewDir) {
  float dotNL = test(dot(normal, lightDir));
  
  vec3 r = normalize(reflect(-lightDir, normal));
  float phongValue = max(0.0, dot(viewDir, r));
  phongValue = pow(phongValue, 32.0);

  vec3 specular = dotNL * vec3(phongValue);
  return specular;
}

void main(){
  float grassX = vGrassData.x;
  float grassY = vGrassData.y;
  vec3 baseColour = mix(vColour* 0.75, vColour, smoothstep(0.125,0.,abs(grassX)));

  vec2 vUv = vec2(vGrassData.z,vGrassData.y);
  vec3 normal = normalize(vNormal);
  vec3 viewDir = normalize(cameraPosition - vWorldPosition);
  vec3 c1 = vec3(1.,1.,0.75);
  vec3 c2 = vec3(0.05,0.05,0.25);
  vec3 ambientLightning  = hemiLight(normal, c2, c1);

  vec3 lightDir = normalize(vec3(-1.,0.5,1.));
  vec3 lightColour = vec3(1.,1.,1.);
  vec3 diffuseLightning = lambertLight(normal, viewDir, lightDir, lightColour);

  vec3 specular = phongSpecular(normal, lightDir, viewDir);
  float ao = remap(pow(grassY,1.),0.,1.,0.125,1.);
  vec3 lightning = ambientLightning * 0.5 + diffuseLightning * 0.5;

  vec3 color = baseColour * lightning + specular * 0.25;
  color *= ao;
  gl_FragColor = vec4(color,1.0);
}