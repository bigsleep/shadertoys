const float pi = 3.141592653589793;
const float eps = 1.0E-7;
const int range = 2;

mat4 invPerspective(in float fovy, in float aspect, in float near, in float far)
{
    float t = tan(0.5 * fovy);
    float a = aspect * t;
    float b = t;
    float c = 0.5 / (near - far);
    float d = 0.5 / (near + far);
    return mat4(
        vec4(a, 0.0, 0.0, 0.0),
        vec4(0.0, b, 0.0, 0.0),
        vec4(0.0, 0.0, 0.0, c),
        vec4(0.0, 0.0, -1.0, d));
}

mat4 invLookAt(in vec3 eye, in vec3 center, in vec3 up) {
    vec3 za = normalize(eye - center);
    vec3 xa = normalize(cross(up, za));
    vec3 ya = cross(xa, za);
    float xd = dot(xa, eye);
    float yd = dot(ya, eye);
    float zd = dot(za, eye);
    return mat4(
        vec4(xa, 0.0),
        vec4(ya, 0.0),
        vec4(za, 0.0),
        vec4(xd, yd, zd, 1.0));
}

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float distance(in float waveHeight, in float waveLength, in float t, in vec3 p)
{
    float r = length(p.xy);
    float y = waveHeight * sin(r / waveLength + t);
    float d = p.z - y;
    return d;
}

vec4 color(in float waveHeight, in float waveLength, in float t, in vec3 p, vec3 light)
{
    float r = length(p.xy);
    float a = - waveHeight * cos(r / waveLength + t) / (waveLength * r);
    vec3 normal = normalize(vec3(a * p.x, a * p.y, 1.0));
    float diffuse = clamp(dot(-light, normal), 0.05, 1.0);
    return vec4(vec3(diffuse), 1.0);
    // float c = (0.5 * (waveHeight * sin(r / waveLength) + waveHeight) / waveHeight);
    // return vec4(vec3(c), 1.0);
}

vec4 rayMarching(in float waveHeight, in float waveLength, in float t, in vec3 rayOrigin, in vec3 rayDest, in vec3 light)
{
    vec3 direction = normalize(rayDest - rayOrigin);

    vec3 p = rayOrigin;
    float d = 1.0;
    for (int i = 0; i < 64; ++i) {
        d = distance(waveHeight, waveLength, t, p);
        if (abs(d) <= eps) break;

        p = p + direction * d;
    }

    return color(waveHeight, waveLength, t, p, light);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 p = (fragCoord - 0.5 * iResolution) / iResolution;
    vec3 center = vec3(0.0, 0.0, 0.0);
    vec3 up = vec3(0.0, 0.0, 1.0);
    vec3 rayOrigin = vec3(100.0, 50.0, 50.0);
    vec3 light = normalize(vec3(-2.0, -0.5, -0.2));

    float fovy = 120.0 * pi / 180.0;
    float aspect = iResolution.x / iResolution.y;
    float near = 0.0;
    float far = 100.0;

    mat4 m = invPerspective(fovy, aspect, near, far);
    mat4 n = invLookAt(rayOrigin, center, up);
    vec4 dest = n * m * vec4(vec3(p, 0.0), near);
    vec3 rayDirection = normalize(dest.xyz - rayOrigin);

    float waveHeight = 0.0003;
    float waveLength = 0.0003;

    float t = - iTime * 10.0;

    fragColor = rayMarching(waveHeight, waveLength, t, rayOrigin, rayDirection, light);
}
