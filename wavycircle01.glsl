void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float radius = iResolution.y * 0.4;
    float frequency = 20.0;
    float waveHeight = radius * 0.1;
    vec2 v = fragCoord.xy - (0.5 * iResolution.xy);
    float a = atan(v.y, v.x);
    float inside = (length(v) <= radius + waveHeight * sin(a * frequency)) ? 1.0 : 0.0;
    fragColor = mix(vec4(1.0, 1.0, 1.0, 1.0), vec4(0.0, 0.0, 0.0, 1.0), inside);
}
