
--------------------------------------------
---添加面板，为了方便阅读相关内容全部放在这里
function TUO_Developer_Tool_kit:AddPanels()
	---全输入监测（已完成）（键盘、鼠标、手柄）---------------------------------------------------------
		self.hud.NewPanel('Input Monitor',	
		nil,
		function(panel)
			TUO_Developer_HUD:NewWidget(panel,'slot1','value_displayer',{title='table:KeyState',monitoring_value=KeyState})
			TUO_Developer_HUD:NewWidget(panel,'slot1','value_displayer',{title='table:setting.keys',monitoring_value=setting.keys})
			TUO_Developer_HUD:NewWidget(panel,260,'value_displayer',{title='table:JoyState',monitoring_value=JoyState})
			TUO_Developer_HUD:NewWidget(panel,260,'value_displayer',{title='Detailed JoyState',
				monitoring_value=function(widget)
					local t={}
					local leftX,leftY,rightX,rightY=lstg.XInputManager.GetThumbState(1)
					local leftT,rightT=lstg.XInputManager.GetTriggerState(1) 
					table.insert(t,{name='leftThumb_X',v=leftX})
					table.insert(t,{name='leftThumb_Y',v=leftY})
					table.insert(t,{name='rightThumb_X',v=rightX})
					table.insert(t,{name='rightThumb_Y',v=rightY})
					table.insert(t,{name='leftTrigger',v=leftT})
					table.insert(t,{name='rightTrigger',v=rightT})
					return t
				end
				})
			TUO_Developer_HUD:NewWidget(panel,260,'value_displayer',{title='Original JoyState',
				monitoring_value=function(widget)
					-- 在只插入一个手柄的情况下joy1和joy2是重复的
					local t={}
					for i=1,32 do
						table.insert(t,{name='JOY1_'..i,v=lstg.GetKeyState(KEY['JOY1_'..i])})
					end
					return t
				end
				})
			TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{title='MouseState',
				monitoring_value=function(widget)
					local t={}
					local x,y=GetMousePosition()
					local ux,uy=ScreenToUI(lstg.GetMousePosition())
					if not panel.MouseState then panel.MouseState={} end
					table.insert(t,{name='MouseX',v=x})
					table.insert(t,{name='MouseY',v=y})
					table.insert(t,{name='WheelDelta',v=MouseState.WheelDelta})
					table.insert(t,{name='MouseX_in_UI',v=string.format('%.1f',ux)})
					table.insert(t,{name='MouseY_in_UI',v=string.format('%.1f',uy)})
					for i=0,7 do table.insert(t,{name='MouseButton'..i,v=lstg.GetMouseState(i)}) end
					return t
				end})
			TUO_Developer_HUD:NewWidget(panel,'slot2','value_displayer',{title='KeyTrigger',
				monitoring_value=function(widget)
					local t={}
					for k,v in pairs(KeyState) do
						table.insert(t,{name=k,v=KeyTrigger(k)})
					end
					return t
				end})

		end)
	
	
	---游戏变量监测---------------------------------------------------------
		--包括以下数值的显示和修改：
		--------（游戏基本数值）分数，残机，奖残计数，符卡，符卡奖励计数，灵力，灵力上限，最大得点，擦弹，擦弹计数，每个单位的hp
		--------（特殊系统数值）梦现指针值，连击数，玩家对每个单位的DPS
		--------（关卡debug）设置和快速重启关卡并跳转到指定部分，设置和跳过boss符卡，（以多种模式）查看、输出和调整判定
		local var={--'score','lifeleft','chip','bomb','bombchip','power','faith','pointrate','graze',
			'missed_in_chapter','spelled_in_chapter','ccced_in_chapter',
			'block_spell','is_practice','ran_seed'}
		for __k,__V in pairs(var) do var[__k]='lstg.var.'..__V end

		self.hud.NewPanel('STG System',nil,
		function(panel)
			--显示分数
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{title='Basic STG Variable',monitoring_value='lstg.var.score'})
			--残机和碎片
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.lifeleft'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_gauge',{monitoring_value='lstg.var.lifeleft',max_value=11})
				TUO_Developer_HUD:NewWidget(panel,440,'button',{text='Set life to 0',
				_event_mouseclick=function(widget)
					lstg.var.lifeleft=0
				end
				})
				for i=1,11 do
					TUO_Developer_HUD:NewWidget(panel,440,'button',{
						text=tostring(i),
						width=12,
						x_pos2=12*i+112,
						_lifeleft=i,
						_event_mouseclick=function(widget) lstg.var.lifeleft=widget._lifeleft end
					})
				end
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.chip'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_slider',{monitoring_value='lstg.var.chip',max_value=300})
			--显示符卡和碎片
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.bomb'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_gauge',{monitoring_value='lstg.var.bomb',max_value=3})
				TUO_Developer_HUD:NewWidget(panel,440,'button',{text='Set Bomb to 0',
				_event_mouseclick=function(widget)
					lstg.var.bomb=0
				end
				})
				for i=1,3 do
					TUO_Developer_HUD:NewWidget(panel,440,'button',{
						text=tostring(i),
						width=24,
						x_pos2=24*i+100,
						_bomb=i,
						_event_mouseclick=function(widget) lstg.var.bomb=widget._bomb end
					})
				end
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.bombchip'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_slider',{monitoring_value='lstg.var.bombchip',max_value=300})
			--抛瓦
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.power'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_gauge',{monitoring_value='lstg.var.power',max_value=600})
				TUO_Developer_HUD:NewWidget(panel,440,'button',{text='Set power to 0',
				_event_mouseclick=function(widget)
					lstg.var.power=0
				end
				})
				for i=1,6 do
					TUO_Developer_HUD:NewWidget(panel,440,'button',{
						text=tostring(i),
						width=24,
						x_pos2=24*i+100,
						_power=i*100,
						_event_mouseclick=function(widget) lstg.var.power=widget._power end
					})
				end
			--绿点和擦弹
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.faith'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.pointrate'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.graze'})


			--梦现指针系统
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{title='Dream & Reality',monitoring_value='lstg.var.dr',})
				TUO_Developer_HUD:NewWidget(panel,440,'value_slider',{monitoring_value='lstg.var.dr',min_value=-5,max_value=5})
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.cp',})
				TUO_Developer_HUD:NewWidget(panel,440,'value_slider',{monitoring_value='lstg.var.cp',max_value=5})
			--其他信息
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{title='Basic STG Info',monitoring_value='lstg.var.player_name',})
				for i,v in pairs(var) do
					TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value=var[i]})
				end



			
			
		end)
		-- self.hud.NewPanel('Stage & Boss',nil)


	---资源列表显示和快速重载（可能需要修改loadImage等等的定义）---------------------------------------------------------

		-- self.hud.NewPanel('Resource')
		

	---使用脚本列表显示和快速重载---------------------------------------------------------
	---相关代码：Include定义

		self.hud.NewPanel('Included Scripts',nil,function(panel)
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{title='Operation',text='Reload',
				_event_mouseclick=function(widget)  
					local list=widget.panel.list
					local dis=list.display_value
					local v_tmp={}
					for i,v in pairs(dis) do
						if list.selection[i] then table.insert(v_tmp,v.name) end
					end
					self.ReloadFiles(v_tmp)
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='Reload Game',
				_event_mouseclick=function(widget) 
					ResetPool()
					lstg.included={}
					stage.Set('none', 'init') 
					lstg.DoFile('core.lua')
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='Select All',
				_event_mouseclick=function(widget) 
					widget.panel.list.selection={}
					for i=1,#widget.panel.list.display_value do
						widget.panel.list.selection[i]=true
					end
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='Deselect All',
				_event_mouseclick=function(widget) 
					widget.panel.list.selection={}
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='save1',width=55,
				_event_mouseclick=function(widget) 
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='load1',x_pos2=65,width=55,
				_event_mouseclick=function(widget) 
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='save2',width=55,
				_event_mouseclick=function(widget) 
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='load2',x_pos2=65,width=55,
				_event_mouseclick=function(widget) 
				end
				})
			panel.list=TUO_Developer_HUD:NewWidget(panel,'slot1','list_box',{
				title='Included File List',
				monitoring_value=lstg.included
			})

		end)

	---实时脚本载入------------------------------------------------------------------------
	-- self.hud.NewPanel('Quick Loader')


	---背景脚本的3D参数显示，可直接在游戏内调整和写入3D背景参数---------------------------------------------------------

	self.hud.NewPanel('3D Background')

	---临时变量监测（支持在外部动态添加）---------------------------------------------------------

	-- self.hud.NewPanel('Quick Monitor',nil)

	---一些杂项和设置

	self.hud.NewPanel('Misc Option',nil,function(panel)
		TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
			title='Misc',
			text='Lock the tool again.'
		})
		TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
			text='Lock it',
			_event_mousclick=function(widget)
				TUO_Developer_Tool_kit.visiable=false 
				TUO_Developer_Tool_kit.locked=true
				TUO_Developer_Tool_kit.unlock_time_limit=0
				TUO_Developer_Tool_kit.unlock_count=0
			end
		})
		TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
			text='Reload overall arrangement.'
		})
		TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
			text='Reload',
			_event_mouseclick=function(widget)
				TUO_Developer_Tool_kit:RefreshPanels()
			end
		})
		TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
			text='Reload everything of this tool.'
		})
		TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
			text='Reload All'
		})
		__well_you_can_never_find_it=233333
		TUO_Developer_HUD:NewWidget(panel,'slot1','value_displayer',{
			title='Hello LuaSTG!',
			monitoring_value='__well_you_can_never_find_it'
		})
		TUO_Developer_HUD:NewWidget(panel,'slot1','value_gauge',{
			monitoring_value='__well_you_can_never_find_it',
			max_value=233333*2
		})
		TUO_Developer_HUD:NewWidget(panel,'slot1','value_slider',{
			monitoring_value='__well_you_can_never_find_it',
			max_value=233333*2
		})
		TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
			text='Hello LuaSTG!',
			_event_mouseclick=function()  end}
		)
		TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
			text='Hello LuaSTG'
		})

		TUO_Developer_HUD:NewWidget(panel,'slot1','switch',{
			text_on='Ohhhh man!',
			text_off='Creeper?'
		})
		TUO_Developer_HUD:NewWidget(panel,'slot1','list_box',{
			monitoring_value='lstg',
		})
	end)
end

function TUO_Developer_Tool_kit:RefreshPanels()
	self.hud.panel={}
	self:AddPanels()
end