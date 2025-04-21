uniform vec4 uGrassParams;
varying vec3 vNormal;
varying vec3 vWorldPosition;
#define PI 3.14159265358979323846
uniform float uTime;
uniform sampler2D uGrassData;

// return a value between 0 and 1 based on the given value and the min and max range
float inverseLerp(float v,float minValue,float maxValue){
  return(v-minValue)/(maxValue-minValue);
}

// remap values to a min and max range
float remap(float v,float inMin,float inMax,float outMin,float outMax){
  float t=inverseLerp(v,inMin,inMax);
  return mix(outMin,outMax,t);
}


float test(float x) {
  return clamp(x, 0.0, 1.0);
}

vec2 quickHash(float p){

  vec2 r = vec2(dot(vec2(p), vec2(17.43267,23.8934543)),dot(vec2(p), vec2(13.98342,37.2435232)));

  return fract(sin(r) * 1743.543224); 
}

vec3 hash(vec3 p) // replace this by something better
{
    p = vec3(
        dot(p, vec3(127.1, 311.7, 74.7)),
        dot(p, vec3(269.5, 183.3, 246.1)),
        dot(p, vec3(113.5, 271.9, 124.6))
    );

    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

uvec2 murmurHash21(uint src) {
  const uint M = 0x5bd1e995u;
  uvec2 h = uvec2(1190494759u, 2147483647u);
  src *= M;
  src ^= src>>24u;
  src *= M;
  h *= M;
  h ^= src;
  h ^= h>>13u;
  h *= M;
  h ^= h>>15u;
  return h;
}

vec2 hash21(float src) {
  uvec2 h = murmurHash21(floatBitsToUint(src));
  return uintBitsToFloat(h & 0x007fffffu | 0x3f800000u) - 1.0;
}



float easeOut(float x, float t) {
    return 1.0 - pow(1.0 - x, t);
}

vec3 bezier(vec3 p0, vec3 p1, vec3 p2, vec3 p3, float t) {
  return (1.- t) * (1.- t) * (1.- t) * p0 + 3. * (1.- t) * (1.- t) * t * p1 + 3. * (1.- t) * t * t * p2 + t * t * t * p3;
}

vec3 bezierGradient(vec3 p0, vec3 p1, vec3 p2, vec3 p3, float t) {
  return 3. * (1.- t) * (1.- t) * (p1 - p0) + 6. * (1.- t) * t * (p2 - p1) + 3. * t * t * (p3 - p2);
}

mat3 rotateY(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(c, 0, s),
        vec3(0, 1, 0),
        vec3(-s, 0, c)
    );
}

mat3 rotateAxis(vec3 axis, float angle) {
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat3(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c
  );
}

float noise( in vec3 p )
{
  vec3 i = floor( p );
  vec3 f = fract( p );
	
	vec3 u = f*f*(3.0-2.0*f);

  return mix( mix( mix( dot( hash( i + vec3(0.0,0.0,0.0) ), f - vec3(0.0,0.0,0.0) ), 
                        dot( hash( i + vec3(1.0,0.0,0.0) ), f - vec3(1.0,0.0,0.0) ), u.x),
                   mix( dot( hash( i + vec3(0.0,1.0,0.0) ), f - vec3(0.0,1.0,0.0) ), 
                        dot( hash( i + vec3(1.0,1.0,0.0) ), f - vec3(1.0,1.0,0.0) ), u.x), u.y),
              mix( mix( dot( hash( i + vec3(0.0,0.0,1.0) ), f - vec3(0.0,0.0,1.0) ), 
                        dot( hash( i + vec3(1.0,0.0,1.0) ), f - vec3(1.0,0.0,1.0) ), u.x),
                   mix( dot( hash( i + vec3(0.0,1.0,1.0) ), f - vec3(0.0,1.0,1.0) ), 
                        dot( hash( i + vec3(1.0,1.0,1.0) ), f - vec3(1.0,1.0,1.0) ), u.x), u.y), u.z );
}

const vec3 BASE_COLOUR = vec3(0.1,0.4,0.04);
const vec3 TIP_COLOUR = vec3(0.5,0.7,0.3);

varying vec3 vColour;
varying vec4 vGrassData;

void main(){
  int segments = int(uGrassParams.x);
  int vertices = int(segments +1) * 2;
  float patchSize = uGrassParams.y;
  float grassWidth = uGrassParams.z;
  float grassHeight = uGrassParams.w;
  float stiffness = 1.;

  vec2 hashedInstanceID = hash21(float(gl_InstanceID)) * 2. - 1.;
  vec3 grassOffset = vec3(hashedInstanceID.x, 0.,hashedInstanceID.y) * patchSize;
  vec3 grassBladeWorldPos = (modelMatrix * vec4(grassOffset,1.0)).xyz;
  vec3 hashVal = hash(grassBladeWorldPos);
  vec2 tilDataUV =vec2(-grassBladeWorldPos.x, grassBladeWorldPos.z)  / patchSize * 0.5 + 0.5;
  vec4 grassAlpha = texture(uGrassData, tilDataUV);


  float angle = remap(hashVal.x,-1., 1., -PI, PI);

  // grassOffset = vec3(float(gl_InstanceID) * 0.5 - 8.0, 0.0, 0.0);
  // angle = float(gl_InstanceID) * 0.2;

  int vertFB_ID = gl_VertexID % (vertices * 2);
  int vertID = vertFB_ID % vertices;

  int xTest = vertID & 0x1;
  int zTest = (vertFB_ID >= vertices) ? 1 : -1;

  float xSide = float(xTest);
  float zSide = float(zTest);
  float heightPercent = float(vertID - xTest) / (float(segments) * 2.);
  float width = grassWidth * easeOut(1.-heightPercent, 4.) * grassAlpha.r;
  float height = grassHeight * grassAlpha.r;


  float x = (xSide - 0.5) * width;
  float y = heightPercent * height;
  float z = 0.;


  float windStrength = noise(vec3(grassBladeWorldPos.xz * 0.05,0.) + uTime);
  float windAngle = 0.;
  vec3 windAxis = vec3(cos(windAngle),0.,sin(windAngle));
  float windLeanAngle = windStrength * 1.5 * heightPercent * stiffness;

  float randomLeanAnimation =noise(vec3(grassBladeWorldPos.xz, uTime * 4.)) * (windStrength * 0.5 + 0.125);
  float leanFactor = remap(hashVal.y,-1., 1., -0.5,0.5) + randomLeanAnimation;
  // leanFactor = 1.0;
  vec3 p1 = vec3(0.,0.,0.);
  vec3 p2 = vec3(0.,0.33,0.);
  vec3 p3 = vec3(0.,0.66,0.);
  vec3 p4 = vec3(0.,cos(leanFactor),sin(leanFactor));
  vec3 curve = bezier(p1,p2,p3,p4,heightPercent);

  vec3 curveGrad = bezierGradient(p1,p2,p3,p4,heightPercent);;
  mat2 curveRot90 = mat2(0.,1.,-1.,0.) * -zSide;


  y = curve.y * height;
  z = curve.z * height;

  mat3 grassMat = rotateAxis(windAxis, windLeanAngle) * rotateY(angle);


  vec3 grassLocalPosition = grassMat * vec3(x,y,z) + grassOffset;
  vec3 grassLocalNormal = grassMat * vec3(0.,curveRot90 * curveGrad.yz);

  float distanceBlend = smoothstep(0.0, 10.0, distance(cameraPosition, grassBladeWorldPos));
  grassLocalNormal = mix(grassLocalNormal, vec3(0.,1.,0.), distanceBlend*0.5);
  grassLocalNormal = normalize(grassLocalNormal);

  vec4 mvPosition = modelViewMatrix * vec4(grassLocalPosition,1.0);
  vec3 viewDir = normalize(cameraPosition - grassBladeWorldPos);
  vec3 grassFaceNormal = grassMat * vec3(0.,0.,-zSide);

  float viewDotNormal = test(dot(grassFaceNormal, viewDir));
  float viewSpaceThickenFactor = easeOut(1. - viewDotNormal, 4.) * smoothstep(0.,0.2,viewDotNormal);

  mvPosition.x += viewSpaceThickenFactor* (xSide - 0.5 ) * width* 0.5 * -zSide;

  gl_Position	 = projectionMatrix * mvPosition;
  // vColour = mix(BASE_COLOUR,TIP_COLOUR,heightPercent);

  vec3 c1 = mix(BASE_COLOUR, TIP_COLOUR, heightPercent);
  vec3 c2 = mix(vec3(0.6, 0.6, 0.4), vec3(0.88, 0.87, 0.52), heightPercent);
  float noiseValue = noise(grassBladeWorldPos * 0.1);
  vColour = mix(c1, c2, smoothstep(-1.0, 1.0, noiseValue));
  // vColour = grassLocalNormal;
  vGrassData = vec4(x,heightPercent,xSide,0.);
  vNormal = normalize((modelMatrix * vec4(grassLocalNormal,0.0)).xyz);
  vWorldPosition = (modelMatrix * vec4(grassLocalPosition,1.0)).xyz;
}