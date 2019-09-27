
--------------------------------------------
---添加面板，为了方便阅读相关内容全部放在这里
function TUO_Developer_Tool_kit:AddPanels()
	
	---全输入监测（已完成）（键盘、鼠标、手柄）---------------------------------------------------------
	self.hud.NewPanel('Input Monitor',	
		function ()
			local t={}
			for k,v in pairs(KeyState) do
				table.insert(t,{name=k,v=KeyTrigger(k)})
			end
			return t
		end,nil,
		function(panel) 
			
			panel.OriginalJoyState={}
			for i=1,32 do
				table.insert(panel.OriginalJoyState,{name='JOY1_'..i,v=lstg.GetKeyState(KEY['JOY1_'..i])})
			end
			-- 在只插入一个手柄的情况下joy1和joy2是重复的

			panel.joystick_detailed_state={}
			local t=panel.joystick_detailed_state
			t.leftX,t.leftY,t.ringtX,t.ringtY=lstg.XInputManager.GetThumbState(1)
			t.leftT,t.rightT=lstg.XInputManager.GetTriggerState(1)  

			--鼠标部分
			local x,y=GetMousePosition()
			local ux,uy=ScreenToUI(lstg.GetMousePosition())
			if not panel.MouseState then panel.MouseState={} end
			panel.MouseState['MouseX']=x
			panel.MouseState['MouseY']=y
			panel.MouseState['WheelDelta']=MouseState.WheelDelta
			panel.MouseState['MouseX_in_UI']=string.format('%.1f',ux)
			panel.MouseState['MouseY_in_UI']=string.format('%.1f',uy)
			for i=0,7 do panel.MouseState['MouseButton'..i]=lstg.GetMouseState(i) end
		end,
		function (panel)
			TUO_Developer_HUD.DisplayValue(panel,'Table:KeyState',80,KeyState)
			-- TUO_Developer_HUD.DisplayValue(panel,'Table:KeyStatePre',80,KeyStatePre)		
			TUO_Developer_HUD.DisplayValue(panel,'Table:setting.keys',80,setting.keys)
			TUO_Developer_HUD.DisplayValue(panel,'Table:JoyState',260,JoyState)
			-- TUO_Developer_HUD.DisplayValue(panel,'Table:JoyStatePre',80,JoyStatePre)
			TUO_Developer_HUD.DisplayValue(panel,'JoyStickState',260,panel.joystick_detailed_state)
			-- TUO_Developer_HUD.DisplayValue(panel,'JoyStickTrigger',260,panel.JoyTrigger)
			TUO_Developer_HUD.DisplayValue(panel,'Table:setting.joysticks',260,setting.joysticks)
			TUO_Developer_HUD.DisplayValue(panel,'MouseState',440,panel.MouseState)


		end)
	
	---游戏变量监测---------------------------------------------------------
	--包括以下数值的显示和修改：
	--------（游戏基本数值）分数，残机，奖残计数，符卡，符卡奖励计数，灵力，灵力上限，最大得点，擦弹，擦弹计数，每个单位的hp
	--------（特殊系统数值）梦现指针值，连击数，玩家对每个单位的DPS
	--------（关卡debug）设置和快速重启关卡并跳转到指定部分，设置和跳过boss符卡，（以多种模式）查看、输出和调整判定
	local var={'pointrate','bonusflag','player_names','rep_player','ran_seed','rep_players'}
	for __k,__V in pairs(var) do var[__k]='lstg.var.'..__V end
	var.use_G=true
	-- self.hud.NewPanel('Basic Variable',var)
	self.hud.NewPanel('Basic Variable',{use_G=true,'lstg.var','lstg.tmpvar'})
	self.hud.NewPanel('Dream & Reality')
	self.hud.NewPanel('Stage & Boss','debugPoint')


	---资源列表显示和快速重载（可能需要修改loadImage等等的定义）---------------------------------------------------------

	self.hud.NewPanel('Resource')
	

	---使用脚本列表显示和快速重载---------------------------------------------------------
	---相关代码：Include定义

	self.hud.NewPanel('Included Scripts',lstg.included)

	---实时脚本载入------------------------------------------------------------------------
	self.hud.NewPanel('Quick Loader')


	---背景脚本的3D参数显示，可直接在游戏内调整和写入3D背景参数---------------------------------------------------------

	self.hud.NewPanel('3D Background')

	---临时变量监测（支持在外部动态添加）---------------------------------------------------------

	self.hud.NewPanel('Quick Monitor',{use_G=true,'lstg.world','screen'})
	-- self.hud.NewPanel('Quick Monitor','lstg')

	---一些杂项和设置

	self.hud.NewPanel('Misc Option')
end