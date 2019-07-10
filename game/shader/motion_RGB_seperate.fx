//==============================================================================
//指定中心RGB分离效果 code by JanrilW
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
float intensity < string binding = "intensity"; > = 0.01; //作用效果强度


float4 PS_MainPass(float4 position : POSITION, float2 uv : TEXCOORD0):COLOR
{
    float2 center = float2(centerX, centerY);
	float2 screenSize = float2(screen.z - screen.x, screen.w - screen.y);
	float2 Cuv = center / screenSize;
	float2 Deltauv = uv - Cuv;
	
	float4 texColor=tex2D(ScreenTextureSampler,uv);
	float4 texColorG=tex2D(ScreenTextureSampler,Cuv+Deltauv*(1+intensity));
    float4 texColorB=tex2D(ScreenTextureSampler,uv*(1+2*intensity));
    texColor.g = texColorG.g;
	texColor.b = texColorB.b;
    return texColor;
}

technique Main
{
    pass MainPass
    {
        PixelShader = compile ps_3_0 PS_MainPass();
    }
}