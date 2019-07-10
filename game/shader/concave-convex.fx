//==============================================================================
// 屏幕凸起或凹陷 code by JanrilW
// concave-convex 
//==============================================================================
texture2D ScreenTexture:POSTEFFECTTEXTURE;
sampler2D ScreenTextureSampler = sampler_state {
    texture = <ScreenTexture>;
    AddressU  = BORDER;
    AddressV = BORDER;
    Filter = MIN_MAG_LINEAR_MIP_POINT;
};

float4 screen : SCREENSIZE;
float4 viewport : VIEWPORT;

float centerX < string binding = "centerX"; > = 0.0;  // 指定效果的中心坐标X
float centerY < string binding = "centerY"; > = 0.0;  // 指定效果的中心坐标Y
float offset < string binding = "offset"; > = 1; // 作用效果强度，1为原地不动，大于1则使画面收缩，小于1则使画面膨胀

float4 PS_MainPass(float4 position : POSITION, float2 uv : TEXCOORD0):COLOR
{
    float2 center = float2(centerX, centerY); //作用效果中心
	float2 screenSize = float2(screen.z - screen.x, screen.w - screen.y); //获取屏幕大小
	float2 Cuv = center / screenSize; //把作用效果中心向量转为uv
	float2 Deltauv = uv - Cuv; //当前uv值和效果中心uv值的差值
	float4 texColor=tex2D(ScreenTextureSampler,Deltauv*offset+Cuv); //变换坐标后采样
    return texColor;
}

technique Main
{
    pass MainPass
    {
        PixelShader = compile ps_3_0 PS_MainPass();
    }
}