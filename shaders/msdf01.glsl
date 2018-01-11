// originated from https://github.com/Chlumsky/msdfgen
#extension GL_OES_standard_derivatives : enable

float median(float r, float g, float b) {
    return max(min(r, g), min(max(r, g), b));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float pxRange = 4.0;
    vec4 bgColor = vec4(1.0, 1.0, 1.0, 1.0);
    vec4 fgColor = vec4(0.0, 0.0, 0.0, 1.0);
    vec2 textureCoord = fragCoord / iResolution;
    vec2 msdfUnit = pxRange / iChannel0Size;
    vec3 sample = texture2D(iChannel0, textureCoord).rgb;
    float sigDist = median(sample.r, sample.g, sample.b) - 0.5;
    sigDist *= dot(msdfUnit, 0.5 / fwidth(textureCoord));
    float opacity = clamp(sigDist + 0.5, 0.0, 1.0);
    fragColor = mix(bgColor, fgColor, opacity);
}
