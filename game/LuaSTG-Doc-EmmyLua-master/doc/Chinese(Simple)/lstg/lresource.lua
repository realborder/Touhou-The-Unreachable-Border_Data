---=====================================
---luastg 游戏资源
---作者:Xiliusha
---邮箱:Xiliusha@outlook.com
---=====================================

---@type lstg
local m = lstg

---@alias lstg.BlendMode '""' | '"mul+alpha"' | '"mul+add"' | '"mul+rev"' | '"mul+sub"' | '"add+alpha"' | '"add+add"' | '"add+rev"' | '"add+sub"' | '"alpha+bal"' | '"mul+min"' | '"mul+max"' | '"mul+mul"' | '"mul+screen"' | '"add+min"' | '"add+max"' | '"add+mul"' | '"add+screen"'

----------------------------------------
---资源池管理

---激活资源池，
---luastg 提供了 2 个资源池用于存放游戏资源，
---激活的资源池有最高优先级，查找资源优先从激活的资源池内查找，
---否则才会去未激活的资源池查找
---@param respool string | '"global"' | '"stage"'
function m.SetResourceStatus(respool)
end

---返回当前激活的资源池
---@return string | '"global"' | '"stage"' | '"none"' @如果返回值为 "none" 代表**游戏还没有初始化完成**
function m.GetResourceStatus()
end

----------------------------------------
---资源加载

---从文件加载纹理
---@param texname string
---@param filepath string
---@param mipmap boolean @若不提供该参数，则默认为false
function m.LoadTexture(texname, filepath, mipmap)
end

---从纹理加载图片精灵，
---坐标单位和宽度单位为像素，
---类似纹理坐标，左上角为原点，向右为x轴正方向，向下为y轴正方向，
---额外的a、b、rect参数用于lstg.GameObject，
---更改游戏对象的img属性时会同时将图片精灵资源上的a、b、rect应用到该游戏对象上
---@param imgname string
---@param texname string
---@param x number
---@param y number
---@param width number
---@param height number
---@overload fun(resname:string, texres:string, x:number, y:number, width:number, height:number, a:number, b:number, rect:number)
function m.LoadImage(imgname, texname, x, y, width, height)
end

---从纹理加载图片精灵动画
---参考lstg.LoadImage
---@param aniname string
---@param texname string
---@param x number
---@param y number
---@param width number @单张动画宽度
---@param height number @单张动画高度
---@param col number @列数
---@param row number @行数
---@param aniv number @动画播放的间隔(每隔aniv帧播放下一张)
---@overload fun(resname:string, texres:string, x:number, y:number, width:number, height:number, col:number, row:number, aniv:number, a:number, b:number, rect:number)
function m.LoadAnimation(aniname, texname, x, y, width, height, col, row, aniv)
end

---从文件加载HGE粒子，
---额外的a、b、rect参数只影响绑定的游戏对象
---@param psname string
---@param filepath string
---@param imgname string @粒子使用的图片精灵
---@overload fun(psname:string, filepath:string, imgname:string, a:number, b:number, rect:number)
function m.LoadPS(psname, filepath, imgname)
end

---从文件加载音效，支持wav和ogg格式的双声道、44100Hz采样率、16位深音频文件
---@param sndname string
---@param filepath string
function m.LoadSound(sndname, filepath)
end

---从文件加载背景音乐，支持wav和ogg格式的双声道、44100Hz采样率、16位深音频文件，
---支持循环播放
---@param bgmname string
---@param filepath string
---@param loopend number @循环区间的结束位置(秒)
---@param looplength number @循环区间的长度(秒)
function m.LoadMusic(bgmname, filepath, loopend, looplength)
end

---从文件加载HGE纹理字体，另外支持fancy2d纹理字体(如果第三个参数为字符串)，
---加载fancy2d纹理字体时，第三个参数为字体纹理图片的文件名(不包含前面的路径，仅仅是文件名，包含拓展名)，
---该字体纹理图片存放位置必须和字体文件在同一个文件夹下
---@param fntname string
---@param filepath string
---@param mipmap boolean @若不提供该参数，则默认为true
---@overload fun(fntname:string, filepath:string, texfile:string, mipmap:boolean)
function m.LoadFont(fntname, filepath, mipmap)
end

---从文件加载truetype字体
---@param ttfname string
---@param filepath string
---@param width number @宽度(像素)
---@param height number @高度(像素)
function m.LoadTTF(ttfname, filepath, width, height)
end

---从文件加载DirectX 9 Effect文件，只能用于应用全屏后处理特效，只支持像素着色器
---@param fxname string
---@param filepath string
function m.LoadFX(fxname, filepath)
end

---创建一张和游戏当前窗口大小相同的纹理，可用于离屏渲染
---@param rtname string
function m.CreateRenderTarget(rtname)
end

----------------------------------------
---资源状态

---判断一个游戏资源是否为RenderTarget(一般用于区分从文件加载的纹理和CreateRenderTarget创建的纹理)
---@param name string
function m.IsRenderTarget(name)
end

---返回指定纹理资源的像素单位宽度和高度
---@param texname string
---@return number, number
function m.GetTextureSize(texname)
end

---清空指定资源池，
---如果提供额外的restype, resname参数，则清空指定资源池的指定资源，
---资源类型为整数，从 1 到 9 分别代表：
---1. tex 纹理     textrue
---2. img 图片精灵 sprite (image sprite)
---3. ani 动画     animation (image sprite animation, collection of sprite)
---4. bgm 背景音乐 background music
---5. snd 音效     sound effect
---6. ps  HGE粒子  HGE particle system
---7. fnt 纹理字体 HGE or fancy2d sprite font
---8. ttf TTF字体  truetype font
---9. fx  屏幕特效 screen effect (DirectX 9 Effect)
---@param respool string
---@overload fun(respool:string, restype:number, resname:string)
function m.RemoveResource(respool)
end

---判断某个资源处于哪个资源池内，当资源不存在的时候返回值为空
---@param restype number @参考lstg.RemoveResource
---@param resname string
---@return string | '"global"' | '"stage"' | nil
function m.CheckRes(restype, resname)
end

---枚举资源
---@param restype number @参考lstg.RemoveResource
---@return string[], string[] @"global" 资源池和 "stage" 资源池的资源名列表
function m.EnumRes(restype)
end

---全局渲染缩放，初始值为 1 ，影响图片精灵、动画、HGE粒子、纹理字体、TTF字体、曲线激光，
---LuaSTG Plus还会影响游戏对象的碰撞盒，导致逻辑究极混乱
---@param scale number
function m.SetImageScale(scale)
end

---@return number
function m.GetImageScale()
end

---更改图片精灵渲染时使用的混合模式和顶点颜色，
---如果提供4个颜色参数，则对图片精灵的4个顶点分别设置颜色
---@param imgname string
---@param blendmode lstg.BlendMode
---@param color lstg.Color @顶点颜色
---@overload fun(imgname:string, blendmode:lstg.BlendMode, c1:lstg.Color, c2:lstg.Color, c3:lstg.Color, c4:lstg.Color)
function m.SetImageState(imgname, blendmode, color)
end

---更改动画渲染时使用的混合模式和顶点颜色，
---参考lstg.SetImageState
---@param aniname string
---@param blendmode lstg.BlendMode
---@param color lstg.Color @顶点颜色
---@overload fun(aniname:string, blendmode:lstg.BlendMode, c1:lstg.Color, c2:lstg.Color, c3:lstg.Color, c4:lstg.Color)
function m.SetAnimationState(aniname, blendmode, color)
end

---更改纹理字体渲染时使用的混合模式和顶点颜色
---@param fntname string
---@param blendmode lstg.BlendMode
---@param color lstg.Color @顶点颜色
function m.SetFontState(fntname, blendmode, color)
end

---更改图片精灵渲染中心，
---参考lstg.LoadImage
---@param imgname string
---@param x number
---@param y number
function m.SetImageCenter(imgname, x, y)
end

---更改动画渲染中心，
---参考lstg.SetImageCenter
---@param aniname string
---@param x number
---@param y number
function m.SetAnimationCenter(aniname, x, y)
end

---预加载指定字符串内的所有字符的字形，
---如果字形缓存槽被耗尽，则部分字符的字形缓存将会被覆盖
---@param ttfname string
---@param cachestring string
function m.CacheTTFString(ttfname, cachestring)
end
