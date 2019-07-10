//==============================================================================
//动感模糊 code by JanrilW
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
int repeatc < string binding = "repeatc"; > = 6; // 叠加次数，次数越高越模糊
float offset < string binding = "offset"; > = 0.005; // 偏移量

float4 PS_MainPass(float4 position : POSITION, float2 uv : TEXCOORD0):COLOR
{
    float2 center = float2(centerX, centerY); //作用效果中心
	float2 screenSize = float2(screen.z - screen.x, screen.w - screen.y); //获取屏幕大小
	float2 Cuv = center / screenSize; //把作用效果中心向量转为uv
	float2 Deltauv = uv - Cuv; //当前uv值和效果中心uv值的差值
	
	float4 texColor=tex2D(ScreenTextureSampler,uv); //原图采样
	float4 texColortmp;
	for(int i=0; i<repeatc; i++){
		texColortmp = tex2D(ScreenTextureSampler, Cuv + Deltauv *(1 -(i+1)* offset)); texColor += texColortmp;
		texColortmp = tex2D(ScreenTextureSampler, Cuv + Deltauv *(1 +(i+1)* offset)); texColor += texColortmp;
	}
    return texColor /(repeatc * 2 + 1);
}

technique Main
{
    pass MainPass
    {
        PixelShader = compile ps_3_0 PS_MainPass();
    }
}