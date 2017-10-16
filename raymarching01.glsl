const float pi = 3.141592653589793;
const float eps = 1.0E-6;

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

/*
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

mat4 ortho(in float left, in float right, in float bottom, in float top, in float near, in float far)
{
    float x = 1.0 / (left - right);
    float y = 1.0 / (bottom - top);
    float z = 1.0 / (near - far);
    return mat4(vec4(-2.0 * x, 0.0, 0.0, 0.0),
        vec4(0.0, -2.0 * y, 0.0, 0.0),
        vec4(0.0, 0.0, -2.0 * z, 0.0, 0.0),
        vec4(0.0, 0.0, 0.0, 1.0));
}
*/

float distanceSphere(in vec3 center, in float radius, in vec3 p)
{
    return distance(p, center) - radius;
}

vec4 calcColor(in vec3 center, in vec3 p, in vec3 light)
{
    vec3 normal = normalize(center - p);
    float diffuse = clamp(dot(light, normal), 0.1, 1.0);
    return vec4(vec3(diffuse), 1.0);
}

vec4 rayMarchingSphere(in vec3 center, in float radius, in vec3 rayOrigin, in vec3 rayDest, in vec3 light)
{
    vec3 direction = normalize(rayDest - rayOrigin);

    vec3 p = rayOrigin;
    float d = 1.0;
    for (int i = 0; i < 128; ++i) {
        d = distanceSphere(center, radius, p);
        if (d <= eps) break;

        p = p + direction * d;
    }

    return (d <= eps) ? calcColor(center, p, light) : vec4(1.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 p = (fragCoord - 0.5 * iResolution) / iResolution;
    float radius = 0.4;
    vec3 center = vec3(0.0, 0.0, 0.0);
    vec3 up = vec3(0.0, 1.0, 0.0);
    vec3 rayOrigin = vec3(0.0, 0.0, 10.0);

    float fovy = 120.0 * pi / 180.0;
    float aspect = iResolution.x / iResolution.y;
    float near = 0.0;
    float far = 10.0;

    mat4 m = invPerspective(fovy, aspect, near, far);
    mat4 n = invLookAt(rayOrigin, center, up);
    vec4 v = n * m * vec4(p, 0.0, 1.0);
    vec3 light = normalize(vec3(1.0, 1.0, -2.0));

    fragColor = rayMarchingSphere(center, radius, rayOrigin, v.xyz, light);
}
