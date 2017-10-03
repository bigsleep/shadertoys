const float pi = 3.141592653589793;
const float eps = 1.0E-4;
const int range = 2;

mat4 perspective(in float fovy, in float aspect, in float near, in float far)
{
    float tanHalfFovy = tan(0.5 * fovy);
    float x = 1.0 / (aspect * tanHalfFovy);
    float y = 1.0 / tanHalfFovy;
    float fpn = far + near;
    float fmn = far - near;
    float oon = 0.5 / near;
    float oof = 0.5 / far;
    float z = -fpn / fmn;
    float w = 1.0 / (oof - oon);
    return mat4(vec4(x, 0.0, 0.0, 0.0),
        vec4(0.0, y, 0.0, 0.0),
        vec4(0.0, 0.0, z, w),
        vec4(0.0, 0.0, -1.0, 0.0));
}

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

mat4 lookAtInv(in vec3 eye, in vec3 center, in vec3 up) {
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

float distance(in float size, in float maxZ, in vec3 p)
{
    vec2 base = floor(p.xy / size);
    vec2 corner = base * size;
    vec2 v = 0.5 * vec2(size, size);
    vec2 center = corner + v;
    float z = random(corner) * maxZ;

    float dist = max(p.z - z, 0.0);
    for (int i = -range; i <= range; ++i) {
        for (int j = -range; j <= range; ++j) {
            vec2 a = corner + size * vec2(i, j);
            float h = random(a) * maxZ;
            if (h > z - eps) {
                vec2 b = a + v;
                float d = length(max(abs(p - vec3(b, h)) - 0.5 * vec3(size, size, size), vec3(0.0, 0.0, 0.0)));
                dist = min(dist, d);
            }
        }
    }
    return dist;
}

vec4 color(in float size, in vec3 p)
{
    vec2 base = floor(p.xy / size);
    vec2 corner = base * size;
    vec3 color = vec3(random(corner));

    if (abs(p.y - corner.y) <= eps) {
        color = vec3(0.8, 0.1, 0.1);
    }

    if (abs(p.x - corner.x) <= eps) {
        color = vec3(0.1, 0.8, 0.1);
    }

    if (abs(p.y - corner.y - size) <= eps) {
        color = vec3(0.1, 0.1, 0.8);
    }

    if (abs(p.x - corner.x - size) <= eps) {
        color = vec3(0.1, 0.6, 0.5);
    }

    return vec4(color, 1.0);
}

vec4 rayMarching(in float size, in float maxZ, in vec3 rayOrigin, in vec3 rayDirection)
{
    vec3 p = rayOrigin;
    float d = 1.0;
    for (int i = 0; i < 32; ++i) {
        d = distance(size, maxZ, p);
        if (d <= eps) break;

        p = p + rayDirection * d;
    }

    return color(size, p);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    float size = 0.2;
    float maxZ = 0.2;
    vec2 p = (fragCoord - 0.5 * iResolution) / iResolution;
    vec3 center = vec3(0.0, 0.0, 0.0);
    vec3 up = vec3(0.0, 1.0, 0.0);
    vec3 rayOrigin = vec3(5.0, 5.0, 5.0);

    float fovy = 120.0 * pi / 180.0;
    float aspect = iResolution.x / iResolution.y;
    float near = 0.0;
    float far = 10.0;

    mat4 m = invPerspective(fovy, aspect, near, far);
    mat4 n = lookAtInv(rayOrigin, center, up);
    vec4 dest = n * m * vec4(vec3(p, 0.0), 1.0);
    vec3 rayDirection = normalize(dest.xyz - rayOrigin);

    fragColor = rayMarching(size, maxZ, rayOrigin, rayDirection);
}
