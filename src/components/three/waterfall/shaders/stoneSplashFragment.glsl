uniform sampler2D uTexture;
uniform sampler2D uTexture2;
uniform sampler2D uTexture3;
varying float vTextureIndex;

void main() { 
    vec4 color = vec4(1.0, 1.0, 1.0, 1.0);


    vec4 textureColor = texture2D(uTexture, gl_PointCoord); 
    color *= textureColor;
    if (color.a < 0.1) {
      discard;
    }
  
    csm_FragColor = color;

    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}