

varying vec2 vUv;
varying vec3 vNormal2;
varying vec3 vPosition;
varying float vDistance;
uniform sampler2D uAlphaMap;
uniform sampler2D uMatcap;
uniform vec3 uColor;
uniform vec3 uColor2;

vec3 directionalLight(vec3 lightColor, float lightIntensity, vec3 normal, vec3 lightPosition, vec3 viewDirection, float specularPower)
{
    vec3 lightDirection = normalize(lightPosition);
    vec3 lightReflection = reflect(- lightDirection, normal);

    // Shading
    float shading = dot(normal, lightDirection);
    shading = max(0.0, shading);

    // Specular
    float specular = - dot(lightReflection, viewDirection);
    specular = max(0.0, specular);
    specular = pow(specular, specularPower);

    return lightColor * lightIntensity * (shading + specular);
}

void main() {
  vec3 matcapV2 = texture2D(uMatcap, vPosition.xy).rgb;
  vec3 normal2 = normalize(vNormal2);

  vec4 alphaMap = texture2D(uAlphaMap, vUv);
  float alpha = alphaMap.r;

  if(alpha < 0.5) {
    discard;
  }
  
  if (!gl_FrontFacing) {
    normal2 = -normal2;
  }
  
  csm_FragNormal = normal2;
  float mixColor = clamp(vDistance, 0.0, 1.0);

  vec3 color = mix(uColor, uColor2, mixColor);
  csm_DiffuseColor = vec4(color, 1.0);
   #include <tonemapping_fragment>
   #include <colorspace_fragment>
}
