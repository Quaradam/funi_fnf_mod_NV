#pragma header

uniform float iTime;
uniform vec2 resolution;
uniform sampler2D bitmap;

void main() {
    vec2 uv = openfl_TextureCoordv.xy;
    float offset = 0.003;

    vec4 col;
    col.r = texture2D(bitmap, uv + vec2(offset, 0.0)).r;
    col.g = texture2D(bitmap, uv).g;
    col.b = texture2D(bitmap, uv - vec2(offset, 0.0)).b;
    col.a = 1.0;

    gl_FragColor = col;
}