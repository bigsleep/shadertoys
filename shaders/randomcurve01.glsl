const float K0 = 0.5;
const float K1 = 0.5;
const float K4 = 0.0;
const float K5 = 0.0;
const float zr = 0.2;
const float dr = 0.8;
const float ddr = 0.1;

float random(vec2 st) {
    return -1.0 + 2.0 * fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 random2(vec2 st){
    st = vec2(dot(st,vec2(127.1,311.7)), dot(st,vec2(269.5,183.3)));
    return vec2(-1.0) + 2.0 * fract(sin(st) * 43758.5453123);
}

float curve(vec2 st) {
    vec2 i = floor(st);
    vec2 j = i + vec2(0.1, 0.1);
    vec2 k = i + vec2(0.2, 0.2);
    vec2 l = i + vec2(0.3, 0.3);
    vec2 f = fract(st);

    float x, x1, x2, x3, x4, x5, x6, y, y2, y3, y4, y5, y6, z;
    float k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13, k14, k15, k16, k17, k18, k19, k20, k21, k22, k23, k24, k25, k26, k27;
    float z0, z1, z2, z3, dx0, dx1, dx2, dx3, dy0, dy1, dy2, dy3, ddx0, ddx1, ddx2, ddx3, ddy0, ddy1, ddy2, ddy3, ddxy0, ddxy1, ddxy2, ddxy3;
    vec2 d0, d1, d2, d3, dd0, dd1, dd2, dd3;

    x = f[0];
    x2 = x * x;
    x3 = x2 * x;
    x4 = x3 * x;
    x5 = x4 * x;
    x6 = x5 * x;
    y = f[1];
    y2 = y * y;
    y3 = y2 * y;
    y4 = y3 * y;
    y5 = y4 * y;
    y6 = y5 * y;
    z0 = 0.5 + zr * random(i);
    z1 = 0.5 + zr * random(i + vec2(0.0, 1.0));
    z2 = 0.5 + zr * random(i + vec2(1.0, 0.0));
    z3 = 0.5 + zr * random(i + vec2(1.0, 1.0));
    d0 = dr * random2(j);
    d1 = dr * random2(j + vec2(0.0, 1.0));
    d2 = dr * random2(j + vec2(1.0, 0.0));
    d3 = dr * random2(j + vec2(1.0, 1.0));
    dd0 = ddr * random2(k);
    dd1 = ddr * random2(k + vec2(0.0, 1.0));
    dd2 = ddr * random2(k + vec2(1.0, 0.0));
    dd3 = ddr * random2(k + vec2(1.0, 1.0));
    dx0 = d0[0];
    dx1 = d1[0];
    dx2 = d2[0];
    dx3 = d3[0];
    dy0 = d0[1];
    dy1 = d1[1];
    dy2 = d2[1];
    dy3 = d3[1];
    ddx0 = dd0[0];
    ddx1 = dd1[0];
    ddx2 = dd2[0];
    ddx3 = dd3[0];
    ddy0 = dd0[1];
    ddy1 = dd1[1];
    ddy2 = dd2[1];
    ddy3 = dd3[1];
    ddxy0 = ddr * random(l);
    ddxy1 = ddr * random(l + vec2(0.0, 1.0));
    ddxy2 = ddr * random(l + vec2(1.0, 0.0));
    ddxy3 = ddr * random(l + vec2(1.0, 1.0));

    k0 = K0;
    k1 = K1;
    k2 = (12.0 * z3 - 12.0 * z2 - 12.0 * z1 + 12.0 * z0 - 6.0 * dx3 + 6.0 * dx2 - 6.0 * dx1 + 6.0 * dx0 + ddx3 - ddx2 - ddx1 + ddx0)/2.0;
    k3 = (12.0 * z3 - 12.0 * z2 - 12.0 * z1 + 12.0 * z0 - 6.0 * dy3 - 6.0 * dy2 + 6.0 * dy1 + 6.0 * dy0 + ddy3 - ddy2 - ddy1 + ddy0)/2.0;
    k4 = K4;
    k5 = K5;
    k6 = 4.0 * z3 - 4.0 * z2 - 4.0 * z1 + 4.0 * z0 - 2.0 * dy3 - 2.0 * dy2 + 2.0 * dy1 + 2.0 * dy0 - 2.0 * dx3 + 2.0 * dx2 - 2.0 * dx1 + 2.0 * dx0 + ddxy3 + ddxy2 + ddxy1 + ddxy0;
    k7 =  - ((- 12.0 * z2) + 12.0 * z0 + 6.0 * dx2 + 6.0 * dx0 - ddx2 + ddx0 + 6.0 * K0)/2.0;
    k8 =  - ((- 12.0 * z1) + 12.0 * z0 + 6.0 * dy1 + 6.0 * dy0 - ddy1 + ddy0 + 6.0 * K1)/2.0;
    k9 =  - (30.0 * z3 - 30.0 * z2 - 30.0 * z1 + 30.0 * z0 - 14.0 * dx3 + 14.0 * dx2 - 16.0 * dx1 + 16.0 * dx0 + 2.0 * ddx3 - 2.0 * ddx2 - 3.0 * ddx1 + 3.0 * ddx0 + 2.0 * K4)/2.0;
    k10 =  - (30.0 * z3 - 30.0 * z2 - 30.0 * z1 + 30.0 * z0 - 14.0 * dy3 - 16.0 * dy2 + 14.0 * dy1 + 16.0 * dy0 + 2.0 * ddy3 - 3.0 * ddy2 - 2.0 * ddy1 + 3.0 * ddy0 + 2.0 * K5)/2.0;
    k11 = (- 6.0 * z3) + 6.0 * z2 + 6.0 * z1 - 6.0 * z0 + 2.0 * dy3 + 4.0 * dy2 - 2.0 * dy1 - 4.0 * dy0 + 3.0 * dx3 - 3.0 * dx2 + 3.0 * dx1 - 3.0 * dx0 - ddxy3 - 2.0 * ddxy2 - ddxy1 - 2.0 * ddxy0 - 2.0 * K4;
    k12 = (- 6.0 * z3) + 6.0 * z2 + 6.0 * z1 - 6.0 * z0 + 3.0 * dy3 + 3.0 * dy2 - 3.0 * dy1 - 3.0 * dy0 + 2.0 * dx3 - 2.0 * dx2 + 4.0 * dx1 - 4.0 * dx0 - ddxy3 - ddxy2 - 2.0 * ddxy1 - 2.0 * ddxy0 - 2.0 * K5;
    k13 = ((- 30.0 * z2) + 30.0 * z0 + 14.0 * dx2 + 16.0 * dx0 - 2.0 * ddx2 + 3.0 * ddx0 + 6.0 * K0)/2.0;
    k14 = ((- 30.0 * z1) + 30.0 * z0 + 14.0 * dy1 + 16.0 * dy0 - 2.0 * ddy1 + 3.0 * ddy0 + 6.0 * K1)/2.0;
    k15 = (24.0 * z3 - 24.0 * z2 - 24.0 * z1 + 24.0 * z0 - 4.0 * dy2 + 4.0 * dy0 - 10.0 * dx3 + 10.0 * dx2 - 14.0 * dx1 + 14.0 * dx0 + 2.0 * ddxy2 + 2.0 * ddxy0 + ddx3 - ddx2 - 3.0 * ddx1 + 3.0 * ddx0 + 4.0 * K4)/2.0;
    k16 = (24.0 * z3 - 24.0 * z2 - 24.0 * z1 + 24.0 * z0 - 10.0 * dy3 - 14.0 * dy2 + 10.0 * dy1 + 14.0 * dy0 - 4.0 * dx1 + 4.0 * dx0 + ddy3 - 3.0 * ddy2 - ddy1 + 3.0 * ddy0 + 2.0 * ddxy1 + 2.0 * ddxy0 + 4.0 * K5)/2.0;
    k17 = 9.0 * z3 - 9.0 * z2 - 9.0 * z1 + 9.0 * z0 - 3.0 * dy3 - 6.0 * dy2 + 3.0 * dy1 + 6.0 * dy0 - 3.0 * dx3 + 3.0 * dx2 - 6.0 * dx1 + 6.0 * dx0 + ddxy3 + 2.0 * ddxy2 + 2.0 * ddxy1 + 4.0 * ddxy0 + K5 + K4;
    k18 =  - ((- 20.0 * z2) + 20.0 * z0 + 8.0 * dx2 + 12.0 * dx0 - ddx2 + 3.0 * ddx0 + 2.0 * K0)/2.0;
    k19 =  - ((- 20.0 * z1) + 20.0 * z0 + 8.0 * dy1 + 12.0 * dy0 - ddy1 + 3.0 * ddy0 + 2.0 * K1)/2.0;
    k20 =  - (6.0 * z3 - 6.0 * z2 - 6.0 * z1 + 6.0 * z0 - 6.0 * dy2 + 6.0 * dy0 - 2.0 * dx3 + 2.0 * dx2 - 4.0 * dx1 + 4.0 * dx0 + 2.0 * ddxy2 + 4.0 * ddxy0 - ddx1 + ddx0 + 2.0 * K4)/2.0;
    k21 =  - (6.0 * z3 - 6.0 * z2 - 6.0 * z1 + 6.0 * z0 - 2.0 * dy3 - 4.0 * dy2 + 2.0 * dy1 + 4.0 * dy0 - 6.0 * dx1 + 6.0 * dx0 - ddy2 + ddy0 + 2.0 * ddxy1 + 4.0 * ddxy0 + 2.0 * K5)/2.0;
    k22 = ddx0/2.0;
    k23 = ddy0/2.0;
    k24 = ddxy0;
    k25 = dx0;
    k26 = dy0;
    k27 = z0;

    z = k0 * x6 + k1 * y6 + k2 * x5 * y + k3 * x * y5 + k4 * x4 * y2 + k5 * x2 * y4 + k6 * x3 * y3 + k7 * x5 + k8 * y5 + k9 * x4 * y + k10 * x * y4 + k11 * x3 * y2 + k12 * x2 * y3 + k13 * x4 + k14 * y4 + k15 * x3 * y + k16 * x * y3 + k17 * x2 * y2 + k18 * x3 + k19 * y3 + k20 * x2 * y + k21 * x * y2 + k22 * x2 + k23 * y2 + k24 * x * y + k25 * x + k26 * y + k27;
    return z;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    float unitLength = iResolution.y / 8.0;
    vec2 v = fragCoord / unitLength;
	float c = curve(v);
    fragColor = vec4(vec3(c), 1.0);
}

/*

// calculated by Maxima

display2d:false;
z(x,y) := k0 * x^6 + k1 * y^6 + k2 * x^5 * y + k3 * x * y^5 + k4 * x^4 * y^2 + k5 * x^2 * y^4 + k6 * x^3 * y^3 + k7 * x^5 + k8 * y^5 + k9 * x^4 * y + k10 * x * y^4 + k11 * x^3 * y^2 + k12 * x^2 * y^3 + k13 * x^4 + k14 * y^4 + k15 * x^3 * y + k16 * x * y^3 + k17 * x^2 * y^2 + k18 * x^3 + k19 * y^3 + k20 * x^2 * y + k21 * x * y^2 + k22 * x^2 + k23 * y^2 + k24 * x * y + k25 * x + k26 * y + k27;
dx(x,y) := diff(z(x,y),x);
dy(x,y) := diff(z(x,y),y);
ddx(x,y) := diff(dx(x,y),x);
ddy(x,y) := diff(dy(x,y),y);
ddxy(x,y) := diff(dx(x,y),y);
solve([
k0 = K0,
k1 = K1,
k4 = K4,
k5 = K5,
z0 = sublis([x=0,y=0], z(x,y)),
z1 = sublis([x=0,y=1], z(x,y)),
z2 = sublis([x=1,y=0], z(x,y)),
z3 = sublis([x=1,y=1], z(x,y)),
dx0 = sublis([x=0,y=0], dx(x,y)),
dx1 = sublis([x=0,y=1], dx(x,y)),
dx2 = sublis([x=1,y=0], dx(x,y)),
dx3 = sublis([x=1,y=1], dx(x,y)),
dy0 = sublis([x=0,y=0], dy(x,y)),
dy1 = sublis([x=0,y=1], dy(x,y)),
dy2 = sublis([x=1,y=0], dy(x,y)),
dy3 = sublis([x=1,y=1], dy(x,y)),
ddx0 = sublis([x=0,y=0], ddx(x,y)),
ddx1 = sublis([x=0,y=1], ddx(x,y)),
ddx2 = sublis([x=1,y=0], ddx(x,y)),
ddx3 = sublis([x=1,y=1], ddx(x,y)),
ddy0 = sublis([x=0,y=0], ddy(x,y)),
ddy1 = sublis([x=0,y=1], ddy(x,y)),
ddy2 = sublis([x=1,y=0], ddy(x,y)),
ddy3 = sublis([x=1,y=1], ddy(x,y)),
ddxy0 = sublis([x=0,y=0], ddxy(x,y)),
ddxy1 = sublis([x=0,y=1], ddxy(x,y)),
ddxy2 = sublis([x=1,y=0], ddxy(x,y)),
ddxy3 = sublis([x=1,y=1], ddxy(x,y))
],
[k0,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,k17,k18,k19,k20,k21,k22,k23,k24,k25,k26,k27]);
*/
