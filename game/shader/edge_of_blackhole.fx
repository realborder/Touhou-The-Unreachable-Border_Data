//==============================================================================
// edge of blackhole  黑洞边缘 code by JanrilW
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
float radius < string binding = "rad"; > = 75.0; // 黑洞边缘半径(以480p窗口大小为准)
float ColorB = float4(0.0,0.0,0.0,0.0);

float4 PS_MainPass(float4 position : POSITION, float2 uv : TEXCOORD0):COLOR
{
    float2 center = float2(centerX, centerY); //作用效果中心
	float2 screenSize = float2(screen.z - screen.x, screen.w - screen.y); //获取屏幕大小
	float2 Delta = uv * screenSize - center; //当前uv值和效果中心差值
	float2 Luv = uv;
	
	float rad = radius * screenSize.y / 480.0; // 防止不同分辨率大小不同
	
	float l = length(Delta);
	float ang = atan2(Delta.y, Delta.x);
	float r2 = rad * 1.7;
	float k = (l - rad)/(r2 - rad);
	k = 1-k;
	k = 1-k*k;//平方一下来平滑边缘

	if(l < rad) return ColorB;
	else if(l <= r2){
		l = k * r2;
		ang += sin(6.283185 * (1-k)); //用sin来搞极坐标角度扭曲
		Delta.x = l * cos(ang);
		Delta.y = l * sin(ang);
		Delta += center;
		Luv = Delta / screenSize;
	}
	float4 texColor=tex2D(ScreenTextureSampler,Luv); //变换坐标后再采样
	texColor.a = 1.0;
    return texColor;
}

technique Main
{
    pass MainPass
    {
        PixelShader = compile ps_3_0 PS_MainPass();
    }
}