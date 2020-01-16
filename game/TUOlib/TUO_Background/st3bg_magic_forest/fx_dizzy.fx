//==============================================================================
//三面道中的RGB通道错位效果 By Janril
//借鉴了ETC的texture_BoxBlur.fx
//==============================================================================

texture2D ScreenTexture:POSTEFFECTTEXTURE;
sampler2D ScreenTextureSampler = sampler_state {
    texture = <ScreenTexture>;
    AddressU  = BORDER;
    AddressV = BORDER;
    Filter = MIN_MAG_LINEAR_MIP_POINT;
};

float inner = 1.0f;//边沿缩进

float4 screen : SCREENSIZE;
float4 viewport : VIEWPORT;

float radiu < string binding = "radiu"; > = 0.0f;//三色分离半径(单位：游戏内单位长度，即和游戏坐标系相关)
float angle < string binding = "angle"; > = 0.0f;//原位置指向红色通道位置的向量角度

//对纹理周围3个点进行采样，然后混合
float4 hueSeparateSampler3(float2 uv, float r, float an)
{
	float2 screenSize = float2(screen.z - screen.x, screen.w - screen.y);
	float2 xy = uv * screenSize;
	
	float4 TexColor = float4(0.0f,0.0f,0.0f,0.0f);
	float4 TexColor2 = float4(0.0f,0.0f,0.0f,0.0f);
	float2 SamplerPoint[4];
	float2 Lxy = float2(0.0f, 0.0f);
	float2 Luv = float2(0.0f, 0.0f);

	//获得原点指向三个采样点的向量，三个向量两两相差120度
	for (int i2 = 1; i2 <= 3; i2 = i2 + 1)
		SamplerPoint[i2] = float2(r * cos(an + 120 * (i2 - 1)), r * sin(an + 120 * (i2 - 1)));
    
	for (int i3 = 1; i3 <= 3; i3 = i3 + 1)
    {
		Lxy = xy + SamplerPoint[i3]; //获得采样点坐标
		Lxy.x = clamp(Lxy.x, viewport.x + inner, viewport.z - inner); //限制采样点x坐标
		Lxy.y = clamp(Lxy.y, viewport.y + inner, viewport.w - inner); //限制采样点y坐标
		Luv = Lxy / screenSize; //获得采样点uv坐标
		TexColor2 = tex2D(ScreenTextureSampler, Luv);
		if (i3 == 1) 
			TexColor.r = TexColor.r + TexColor2.r;
		else if (i3 == 2) 
			TexColor.g = TexColor.g + TexColor2.g;
		else 
			TexColor.b = TexColor.b + TexColor2.b;
    }
	TexColor.a=255.0f;
	//TexColor.r=255.0f;
	return TexColor;
}

float4 PS_MainPass(float4 position : POSITION, float2 uv : TEXCOORD0):COLOR
{
    float scale=(screen.w-screen.y)/480.0f;//保证画面效果在不同分辨率下相同，除以的数为游戏基础坐标系的y(小海鸽建议改为960)
    float4 texColor = hueSeparateSampler3(uv,radiu*scale,angle);//获得均值颜色，9点
    return texColor;
}

technique Main
{
    pass MainPass
    {
        PixelShader = compile ps_3_0 PS_MainPass();
    }
}