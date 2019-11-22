---------------------------
--code by janrilw
---------------------------
local PATH='TUOlib/TUO_Background/shader_test/'
shader_test=Class(object)
--------------------------------
---加载资源
function shader_test.load_res()
	local res_list={
		{'surface','surface.png'},
		{'vision','vision.png'},
	}
	for _,v in pairs(res_list) do
		--移除旧的并加载新的，仅调试用（也就调试的时候有机会卸载资源）
		local pool=CheckRes("tex", v[1])
		if pool then
			RemoveResource(pool, 1, v[1])
			RemoveResource(pool, 2, v[1])
		end
		local ret,err = xpcall(_LoadImageFromFile,debug.traceback,v[1],PATH..v[2],true,0,0,false,0)
		if not ret then
			TUO_Developer_Flow:ErrorWindow(err)
		end
	end
	do
		local pool=CheckRes("fx", 'water_wave')
		if pool then
			RemoveResource(pool, 9, 'water_wave')
		end
		local ret,err = xpcall(LoadFX,debug.traceback,'water_wave',"shader\\water_wave.fx")
		if not ret then
			TUO_Developer_Flow:ErrorWindow(err)
		end
	end

end
---------------------------------
---设置每个phase的属性
---算法说明：
---phaseinfo表用来记录所有的phase固有属性
---stt表用来记录当前3d参数的起始点，
---cur表用来记录当前3d参数
function shader_test:InitPhaseInfo(phase)
	self.phaseinfo=lstg.DoFile(PATH..'_phase_info.lua')
	tuolib.BGHandler.DoPhaseLogic(self,1)
end

function shader_test:init(phase)
	--
	background.init(self,false)
	shader_test.load_res()
	self.speed=0.005--即行走速度
	self.xpos=0.001--等效的摄像机x轴位置,x轴方向向前
	shader_test.InitPhaseInfo(self,phase)
	SetImageState('surface','mul+add',Color(0x50FFFFFF))
	CreateRenderTarget('rt_shader_test')
end

function shader_test:frame()
	self.xpos=self.xpos-self.speed

	tuolib.BGHandler.DoPhaseLogic(self)
	task.Do(self)
end

function shader_test:render()
	SetViewMode'3d'
	tuolib.BGHandler.Apply3DParamater(self)
	local showboss = IsValid(_boss)
	local shader_avalible=CheckRes("fx", 'water_wave')

	RenderClear(Color(0xFF000000))
	if showboss then background.WarpEffectCapture() end
	if shader_avalible then PushRenderTarget('rt_shader_test') end
	RenderClear(Color(0xFF000000))
	--以上是固定要放进去的代码
	--下面是渲染
	-- local x=self.xpos%1
	for _,speed in ipairs({1.18,1.387,0.9128}) do
		local x=(self.xpos*speed)%1
		local z=-0.1+speed*0.1
		for dx=12,-1,-1 do
			for y=5+speed*0.2,-5+speed*0.2,-1 do
				Render4V('surface',x+dx+1,y,z,x+dx+1,y+1,z,x+dx,y+1,z,x+dx,y,z)
			end
		end
	end
	if shader_avalible then
		PopRenderTarget('rt_shader_test')
		PostEffect('rt_shader_test','water_wave','mul+add',{
			a=0.9,
			da=0.6,
			r1 = 245/255,
			g1 = 255/255,
			b1 = 245/255,
			r2 = 120/255,
			g2 = 255/255,
			b2 = 24/255,
			tex_vision='vision',
			})
	end
	if showboss then background.WarpEffectApply() end
	--恢复viewmode至正常
	SetViewMode'world'
end

