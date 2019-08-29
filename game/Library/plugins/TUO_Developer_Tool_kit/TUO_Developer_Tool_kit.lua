------------------------------------------------
--开发工具
--F3可以开关调试界面
--F9：
-----如果boss不存在，则跳过一个chapter（推荐在关卡开头使用）
-----如果boss存在则杀掉boss一身
--F10重载指定文件（filereloadlist.lua），如果同时按住shift则直接全部重载（也就是返回stageinit）

local _KeyDown,_var_list
local PATH='Library\\plugins\\filereloadlist.lua'

local ReloadFiles = function ()
	Print('[TUO_Developer_Tool_kit]尝试重载脚本')
	if not(lfs.attributes(PATH)==nil) then 
		local list=lstg.DoFile(PATH) 
		for k,v in pairs(list) do
			-- if not lfs.attributes(v)== nil then 
				Print('[TUO_Developer_Tool_kit]重载脚本：'..v)
				lstg.DoFile(v)
			-- end				
		end
		InitAllClass()
	else
		Print('[TUO_Developer_Tool_kit]重载列表不存在，请检查Library\\plugins\\filereloadlist.lua')
	end		
end
local CheckKeyState= function (k)
	if lstg.GetKeyState(k) then
		if not _KeyDown[k] then
			_KeyDown[k] = true
			return true
		end
	else
		_KeyDown[k] = false
	end
	return false
end



TUO_Developer_Tool_kit = {}
function TUO_Developer_Tool_kit.init()
	local self=TUO_Developer_Tool_kit
	_KeyDown={
		[KEY.F3]=false,
		[KEY.F9]=false,
		[KEY.F10]=false

	}
	LoadTTF('f3_word','THlib\\exani\\times.ttf',26)
	self.visiable=false
	Print('[TUO_Developer_Tool_kit]初始化完毕')
end
function TUO_Developer_Tool_kit.frame()
	local self=TUO_Developer_Tool_kit

	if CheckKeyState(KEY.F10) then 
		if lstg.GetKeyState(KEY.SHIFT) then 
			ResetPool()
			lstg.included={}
			stage.Set('none', 'init') 
		else ReloadFiles() end
	end
	if CheckKeyState(KEY.F9) then
		if IsValid(_boss) and (not lstg.GetKeyState(KEY.SHIFT)) then 
			Kill(_boss) 
		elseif debugPoint then
			if lstg.GetKeyState(KEY.SHIFT) then 
				debugPoint=debugPoint-1
			else 
				debugPoint=debugPoint+1 end
		end
		
	end
	if CheckKeyState(KEY.F3) then
		self.visiable = not self.visiable
	end
end
function TUO_Developer_Tool_kit.render()
--这里用exanieditor的字体了
	local self=TUO_Developer_Tool_kit
	if self.visible then
		SetViewMode'ui'
		SetImageState('white','',Color(0x70FFFFFF))
		RenderRect('white',-500,1000,0,640)
		local text=string.format([[debugPoint:%d]],debugPoint)
		RenderTTF('f3_word',text,0,0,480,480,Color(0xFF000000),'left','top')
	end
	
end
TUO_Developer_Tool_kit.init()


