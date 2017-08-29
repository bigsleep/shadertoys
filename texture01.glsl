void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 textureCoord = fragCoord / iResolution;
    fragColor = texture2D(iChannel0, textureCoord);
}
