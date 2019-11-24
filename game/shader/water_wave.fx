//==============================================================================
//主菜单界面的水波效果 code by JanrilW
//==============================================================================

texture2D ScreenTexture:POSTEFFECTTEXTURE;//液体表面法向信息纹理
sampler2D ScreenTextureSampler = sampler_state {
    texture = <ScreenTexture>;
    AddressU  = BORDER;
    AddressV = BORDER;
    Filter = MIN_MAG_LINEAR_MIP_POINT;
};

float4 screen : SCREENSIZE;
float4 viewport : VIEWPORT;


float angle < string binding = "a"; > = 0.9;//中心值
float delta_angle < string binding = "da"; > = 0.5; //容差
float trend_color1_r < string binding = "r1"; > = 1.0;
float trend_color1_g < string binding = "g1"; > = 1.0;
float trend_color1_b < string binding = "b1"; > = 1.0;
float trend_color2_r < string binding = "r2"; > = 0.95;
float trend_color2_g < string binding = "g2"; > = 0.2;
float trend_color2_b < string binding = "b2"; > = 0.8;
texture2D Texture2 < string binding = "tex_vision"; >;//视野范围
sampler2D ScreenTextureSampler2 = sampler_state {
    texture = <Texture2>;
    AddressU = BORDER;
    AddressV = BORDER;
    Filter = MIN_MAG_LINEAR_MIP_POINT;
};

float4 PS_MainPass(float4 position : POSITION, float2 uv : TEXCOORD0):COLOR
{
    float4 texColor = float4(0.0, 0.0, 0.0, 0.0);
    float4 trend_color1 = float4(trend_color1_r, trend_color1_g, trend_color1_b, 1.0);
    float4 trend_color2 = float4(trend_color2_r, trend_color2_g, trend_color2_b, 1.0);
    float4 texColor_surface = tex2D(ScreenTextureSampler, uv);
    float4 texColor_vision = tex2D(ScreenTextureSampler2, uv);

    //取得差值
    float da = abs(texColor_surface.r - angle);
    float _da = da;
    float alphav = (texColor_vision.r + texColor_vision.g + texColor_vision.b) / 3.0;
    float cut = 1.0 - alphav;

    da *= 1 / delta_angle;
    //限制差值到[0,1]
    da = saturate(da);
    da = 1 - da;
    da = max(cut, da) - cut;
    da /= cut;
    da *= alphav;
    da = saturate(da);
    _da = 1 - da;
    texColor.a = da;
    texColor.rgb = trend_color1.rgb * da + trend_color2.rgb * (1.0 - da);
    return texColor;
}

technique Main
{
    pass MainPass
    {
        PixelShader = compile ps_3_0 PS_MainPass();
    }
}