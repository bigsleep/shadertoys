const float pi = 3.1415926535897932384626433832795;
const float epsilon = 1.0E-3;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float atan2(in float y, in float x)
{
    return abs(x) < epsilon ? sign(y) * pi * 0.5 : atan(y, x);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    float radius = iResolution.y * 0.2;
    float frequency = 20.0;
    float waveHeight = radius * 0.1;
    vec2 v = fragCoord.xy - (0.5 * iResolution.xy);
    float a = atan2(v.y, v.x);
    a = (a < 0.0) ? a + pi * 2.0 : a;
	a = a * frequency;
    float b = 0.5 * a / pi;
    float index = floor(b);
    float stepHeight = radius * 0.2;
    float startStep = random(vec2(index));
    float endStep = random(vec2((index + 1.0 >= frequency - epsilon) ? 0.0 : index + 1.0));
    float r = radius + waveHeight * sin(a) + stepHeight * (startStep + (endStep - startStep) * smoothstep(0.0, 1.0, fract(b)));
    float inside = (length(v) <= r) ? 1.0 : 0.0;
    fragColor = mix(vec4(1.0, 1.0, 1.0, 1.0), vec4(0.0, 0.0, 0.0, 1.0), inside);
}
