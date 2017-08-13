float random(vec2 st) {
    return 2.0 * (fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123) - 0.5);
}

float cubic(float x, float e)
{
    x = x / e;
    float i = floor(x);
    float f = fract(x);
    float a = 10.0;
    float p = random(vec2(i)) * a;
    float q = random(vec2(i + 1.0)) * a;
    float y = (((p + q) * f - (2.0 * p + q)) * f + p) * f;
    return y;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    float unit = iResolution.x / 10.0;
    vec2 o = iResolution.xy * 0.5;
    float height = unit * 0.5;
    float y = cubic(fragCoord.x, unit) * height + o.y;
    vec4 c = (fragCoord.y <= y) ? vec4(0.0, 0.0, 0.0, 1.0) : vec4(1.0, 1.0, 1.0, 1.0);
    fragColor = c;
}

// x座標を単位長さで区切り
// 区切り上ではy = 0で傾きが乱数で求めた値になるように三次方程式を作り
// 三次曲線を描画
