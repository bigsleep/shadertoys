void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 textureCoord = fragCoord / iResolution;
    float x = texture2D(iChannel0, textureCoord).r;
    fragColor = (x < 0.5) ? vec4(0.0, 0.0, 0.0, 1.0) : vec4(1.0, 1.0, 1.0, 1.0);
}
