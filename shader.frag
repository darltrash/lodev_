uniform Image vignette;
uniform float intensity = 1.0;
uniform float time = 1.0;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
/*vec4 effect(vec4 c, Image tex, vec2 tc, vec2 sc)
{
    vec4 color = Texel(tex, tc) * c;
    color.a *= (1-Texel(vignette, sc / love_ScreenSize.xy).a);
    vec2 offset = tc/love_ScreenSize.xy;
    float intensity = Texel(vignette, sc / love_ScreenSize.xy).a;

    color += Texel(tex, tc + intensity*vec2(-offset.x, offset.y));
    color += Texel(tex, tc + intensity*vec2(0.0, offset.y));
    color += Texel(tex, tc + intensity*vec2(offset.x, offset.y));

    color += Texel(tex, tc + intensity*vec2(-offset.x, 0.0));
    color += Texel(tex, tc + intensity*vec2(0.0, 0.0));
    color += Texel(tex, tc + intensity*vec2(offset.x, 0.0));

    color += Texel(tex, tc + intensity*vec2(-offset.x, -offset.y));
    color += Texel(tex, tc + intensity*vec2(0.0, -offset.y));
    color += Texel(tex, tc + intensity*vec2(offset.x, -offset.y));

    return color;
}*/

vec4 effect(vec4 c, Image tex, vec2 tc, vec2 pc) {
    vec2 offset = vec2(1.0)/love_ScreenSize.xy;
    vec4 color = Texel(tex, tc);
    float intensity = Texel(vignette, pc/love_ScreenSize.xy).a * 2.;

    color += Texel(tex, tc + intensity*vec2(-offset.x, offset.y));
    color += Texel(tex, tc + intensity*vec2(0.0, offset.y));
    color += Texel(tex, tc + intensity*vec2(offset.x, offset.y));

    color += Texel(tex, tc + intensity*vec2(-offset.x, 0.0));
    color += Texel(tex, tc + intensity*vec2(0.0, 0.0));
    color += Texel(tex, tc + intensity*vec2(offset.x, 0.0));

    color += Texel(tex, tc + intensity*vec2(-offset.x, -offset.y));
    color += Texel(tex, tc + intensity*vec2(0.0, -offset.y));
    color += Texel(tex, tc + intensity*vec2(offset.x, -offset.y));

    color.a *= (1-(intensity/6.));
    color.g *= (1-(intensity/4.));

    return ((color/9.0) * (c * (1-(intensity/9.))));
}
#endif