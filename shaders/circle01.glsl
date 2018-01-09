void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float radius = iResolution.y * 0.4;
    float rr = radius * radius;
	vec2 v = fragCoord.xy - (0.5 * iResolution.xy);
    float inside = (dot(v, v) <= rr) ? 1.0 : 0.0;
    fragColor = mix(vec4(1.0, 1.0, 1.0, 1.0), vec4(0.0, 0.0, 0.0, 1.0), inside);
}
