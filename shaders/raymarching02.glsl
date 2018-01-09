const float eps = 1.0E-6;

mat4 lookAt(in vec3 eye, in vec3 center, in vec3 up) {
    vec3 za = normalize(eye - center);
    vec3 xa = normalize(cross(up, za));
    vec3 ya = cross(xa, za);
    float xd = - dot(xa, eye);
    float yd = - dot(ya, eye);
    float zd = - dot(za, eye);
    return mat4(
        vec4(xa.x, ya.x, za.x, 0.0),
        vec4(xa.y, ya.y, za.y, 0.0),
        vec4(xa.z, ya.z, za.z, 0.0),
        vec4(xd, yd, zd, 1.0));
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

float distanceSquare(in float width, in float height, in vec3 p)
{
    return length(max(abs(p) - vec3(width * 0.5, height * 0.5, 0.0), vec3(0.0)));
}

vec4 rayMarchingSquare(in float width, in float height, in vec3 rayOrigin, in vec3 rayDest)
{
    vec3 direction = normalize(rayDest - rayOrigin);

    vec3 p = rayOrigin;
    float d = 1.0;
    for (int i = 0; i < 32; ++i) {
        d = distanceSquare(width, height, p);
        if (d <= eps) break;

        p = p + direction * d;
    }

    return (d <= eps) ? vec4(vec3(0.0), 1.0) : vec4(1.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    float width = 0.8 * iResolution.x / iResolution.y;
    float height = 0.8;
    vec2 p = (fragCoord - 0.5 * iResolution) / iResolution.y;
    vec3 center = vec3(0.0, 0.0, 0.0);
    vec3 up = vec3(0.0, 1.0, 0.0);
    vec3 rayOrigin = vec3(0.0, 0.0, 10.0);
    vec4 v = vec4(p, 0.0, 1.0);

    fragColor = rayMarchingSquare(width, height, rayOrigin, v.xyz);
}
