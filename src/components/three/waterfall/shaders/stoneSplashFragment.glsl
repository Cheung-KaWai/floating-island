uniform sampler2D uTexture;
uniform sampler2D uTexture2;
uniform sampler2D uTexture3;
varying float vTextureIndex;

void main() { 
    vec4 color = vec4(1.0, 1.0, 1.0, 1.0);


    if (vTextureIndex == 0.0) {
      vec4 textureColor = texture2D(uTexture, gl_PointCoord); 
      color *= textureColor;
      if (color.a < 0.1) {
        discard;
      }
    }
    else if (vTextureIndex == 1.0) {
      vec4 textureColor2 = texture2D(uTexture2, gl_PointCoord);
      color *= textureColor2;
      if (color.a < 0.1) {
        discard;
      }
    } else if (vTextureIndex == 2.0) {  
      vec4 textureColor3 = texture2D(uTexture3, gl_PointCoord);
      color *= textureColor3;
      if (color.a < 0.1) {
        discard;
      }
    }
    csm_FragColor = color;

    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}