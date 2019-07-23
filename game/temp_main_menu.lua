---------------------------------------
---启动器
---------------------------------------

Include'THlib\\THlib.lua'

local GetLastKey=lstg.GetLastKey--_GetLastKey

local _key_code_to_name=KeyCodeToName()--Linput
local setting_item={'resx','resy','windowed','vsync','sevolume','bgmvolume','res'}
local Resolution={{640,480},{800,600},{960,720},{1024,768},{1280,960}}

local settingfile="Library\\setting"

local function format_json(str)
	local ret = ''
	local indent = '	'
	local level = 0
	local in_string = false
	for i = 1, #str do
		local s = string.sub(str, i, i)
		if s == '{' and (not in_string) then
			level = level + 1
			ret = ret .. '{\n' .. string.rep(indent, level)
		elseif s == '}' and (not in_string) then
			level = level - 1
			ret = string.format(
					'%s\n%s}', ret, string.rep(indent, level))
		elseif s == '"' then
			in_string = not in_string
			ret = ret .. '"'
		elseif s == ':' and (not in_string) then
			ret = ret .. ': '
		elseif s == ',' and (not in_string) then
			ret = ret .. ',\n'
			ret = ret .. string.rep(indent, level)
		elseif s == '[' and (not in_string) then
			level = level + 1
			ret = ret .. '[\n' .. string.rep(indent, level)
		elseif s == ']' and (not in_string) then
			level = level - 1
			ret = string.format(
					'%s\n%s]', ret, string.rep(indent, level))
		else
			ret = ret .. s
		end
	end
	return ret
end

function save_setting()
	local f,msg
	f,msg=io.open(settingfile,'w')
	if f==nil then
		error(msg)
	else
		--f:write(Serialize(cur_setting))--旧方法，但是比较稳定
		f:write(format_json(Serialize(cur_setting)))--新方法by Xrysnow
		f:close()
	end
end

function setting_keys_default()
	cur_setting.keys.up=default_setting.keys.up
	cur_setting.keys.down=default_setting.keys.down
	cur_setting.keys.left=default_setting.keys.left
	cur_setting.keys.right=default_setting.keys.right
	cur_setting.keys.slow=default_setting.keys.slow
	cur_setting.keys.shoot=default_setting.keys.shoot
	cur_setting.keys.special=default_setting.keys.special
	cur_setting.keys.spell=default_setting.keys.spell
	cur_setting.keys2.up=default_setting.keys2.up
	cur_setting.keys2.down=default_setting.keys2.down
	cur_setting.keys2.left=default_setting.keys2.left
	cur_setting.keys2.right=default_setting.keys2.right
	cur_setting.keys2.slow=default_setting.keys2.slow
	cur_setting.keys2.shoot=default_setting.keys2.shoot
	cur_setting.keys2.special=default_setting.keys2.special
	cur_setting.keys2.spell=default_setting.keys2.spell
	cur_setting.keysys.repfast=default_setting.keysys.repfast
	cur_setting.keysys.repslow=default_setting.keysys.repslow
	cur_setting.keysys.menu=default_setting.keysys.menu
	cur_setting.keysys.snapshot=default_setting.keysys.snapshot
	cur_setting.keysys.retry=default_setting.keysys.retry
end

---------------------------------------

stage_launcher=stage.New('settings',true,true)

function stage_launcher:init()
		LoadTTF('menuttfs','THlib\\UI\\font\\default_ttf',40)
	--
	local f,msg
	f,msg=io.open(settingfile,'r')
	if f==nil then
		cur_setting=DeSerialize(Serialize(default_setting))
	else
		cur_setting=DeSerialize(f:read('*a'))
		f:close()
	end
	--
	local function ExitGame()
		task.New(self,function()
			task.Wait(30)
			stage.QuitGame()
		end)
	end
	--
	New(mask_fader,'open')
	New(exani_player_manager)
	start_menu=New(base_menu,'start_menu','Title_Menu_item_Start',{
			{'ChooseMode_item_StoryMode','','',true},
			{'ChooseMode_item_StagePrac','stage_menu','',true},
			{'ChooseMode_item_SpellCardPrac','','',false},
			{'ChooseMode_item_NightmareEcli','','',false},
		},
		'main_menu',
		true
	)
	
	reply_menu=New(base_menu,'reply_menu','Replay_titleAndTable',{
			{'Replay_tablePointer','','',true}
		},
		'main_menu'
	)
	
	manual_menu=New(special_manual)
	
	menu_other=New(other_setting_menu,'Other Settings',{
		{'Resolution X',function() menu_other.edit=true menu_other.setting_backup=cur_setting.res end},
		{'Resolution Y',function() menu_other.edit=true menu_other.setting_backup=cur_setting.res end},
		{'Windowed',function() cur_setting.windowed=not cur_setting.windowed end},
		{'Vsync',function() cur_setting.vsync=not cur_setting.vsync end},
		{'Sound Volume',function() end},
		{'Music Volume',function() end},
		{'Return To Title',function() menu.FlyIn(menu_title,'left') menu.FlyOut(menu_other,'right') save_setting() end},
		{'exit',function()
			if menu_other.pos~=7 then
				menu_other.pos=7
			else
				menu.FlyIn(menu_title,'left')
				menu.FlyOut(menu_other,'right')
				save_setting()
				base_menu.ChangeLocked(menus['main_menu'])
			end
		end},
	})
	
	main_menu=New(base_menu,'main_menu','',{
			{'Title_Menu_item_Start','start_menu','',true},
			{'Title_Menu_item_Replay','reply_menu','',true},
			{'Title_Menu_item_PlayerData','','',false},
			{'Title_Menu_item_Musicroom','','',false},
			{'Title_Menu_item_Gallery','','',false},
			{'Title_Menu_item_Manual','manual_menu','',true},
			{'Title_Menu_item_Option','',function() menu.FlyIn(menu_other,'right') menu_other.pos=1 end,true},
			{'Title_Menu_item_Exit','',ExitGame(),true}
		},
		'',
		true
	)
	base_menu.ChangeLocked(menus['main_menu'])
	
	exani_player_manager.ExecuteExaniPredefine(play_manager,'Title_Menu_bg','init')
	exani_player_manager.SetExaniAttribute(play_manager,'Title_Menu_bg',nil,nil,nil,'ui')
	
	exani_player_manager.ExecuteExaniPredefine(play_manager,'Title_Menu_LOGO','init')
	exani_player_manager.SetExaniAttribute(play_manager,'Title_Menu_LOGO',nil,nil,nil,'ui')
	
end

function stage_launcher:render()
	--执行exani动画,主要是背景
	--然后发现不是在这里运行的
end

---------------------------------------

other_setting_menu=Class(simple_menu)

function other_setting_menu:init(title,content)
	simple_menu.init(self,title,content)
	self.w=24
	self.posx=cur_setting.res
end

function other_setting_menu:frame()
	task.Do(self)
	if self.locked then return end
	local last_key=GetLastKey()
	if last_key~=KEY.NULL then
		local item=setting_item[self.pos]
		if self.pos>=5 and self.pos<=6 then
			if last_key==setting.keys.left then cur_setting[item]=max(0,cur_setting[item]-1) PlaySound('select00',0.003*cur_setting[item])
			elseif last_key==setting.keys.right then cur_setting[item]=min(100,cur_setting[item]+1) PlaySound('select00',0.003*cur_setting[item]) end
			elseif self.pos<=2 then
			if self.edit then
				if last_key==setting.keys.down then
					self.posx=self.posx-1
					PlaySound('select00',0.3)
				elseif last_key==setting.keys.up then
					self.posx=self.posx+1
					PlaySound('select00',0.3)
				elseif last_key==setting.keys.shoot then self.edit=false PlaySound('select00',0.3)
				elseif last_key==setting.keys.spell then self.edit=false
					cur_setting.res=menu_other.setting_backup
					cur_setting.resx=Resolution[cur_setting.res][1]
					cur_setting.resy=Resolution[cur_setting.res][2]
					PlaySound('cancel00',0.3)
				end
				self.posx=max(1,min(self.posx,5))
				cur_setting.res=self.posx
				cur_setting.resx=Resolution[cur_setting.res][1]
				cur_setting.resy=Resolution[cur_setting.res][2]
				return
			end
		elseif self.pos>2 and self.pos<5 then
			if last_key==setting.keys.left or last_key==setting.keys.right then
				cur_setting[item]=not cur_setting[item]
				PlaySound('select00',0.3)
			end
		end
	end
	if not self.edit then simple_menu.frame(self) end
end

function other_setting_menu:render()
	SetFontState('menu','',Color(self.alpha*255,unpack(ui.menu.title_color)))
	RenderText('menu',self.title,self.x,self.y+ui.menu.line_height*4,ui.menu.font_size,'centerpoint')
	if self.pos<=2 and self.edit then
		if self.timer%30<15 then
			RenderText('menu','____',self.x+128-(1-1)*ui.menu.num_width,self.y+ui.menu.line_height*(3.5-1),ui.menu.font_size,'right')
			RenderText('menu','____',self.x+128-(1-1)*ui.menu.num_width,self.y+ui.menu.line_height*(3.5-2),ui.menu.font_size,'right')
		end
	end
	ui.DrawMenu('',self.text,self.pos,self.x-128,self.y-ui.menu.line_height,self.alpha,self.timer,self.pos_changed,'left')
	local setting_text={}
	for i=1,6 do
		setting_text[i]=tostring(cur_setting[setting_item[i]])
	end
	setting_text[7]=''
	ui.DrawMenu('',setting_text,self.pos,self.x+128,self.y-ui.menu.line_height,self.alpha,self.timer,self.pos_changed,'right')
end

---------------------------------------

function start_game()
	loadConfigure()
	LoadPack('mod\\'..setting.mod..'.zip')
	SetSplash(false)
	SetTitle(setting.mod)
	if not ChangeVideoMode(setting.resx,setting.resy,setting.windowed,setting.vsync) then
		if lfs.attributes('.\\LuaSTGPlus.dev.exe')~=nil then
			os.execute('start /b .\\LuaSTGPlus.dev.exe "start_game=true"')
		else
			os.execute('start /b .\\LuaSTGPlus.exe "start_game=true"')
		end
		stage.QuitGame()
		return
	end
	SetSEVolume(setting.sevolume/100)
	SetBGMVolume(setting.bgmvolume/100)
	ResetScreen()--Lscreen
	SetResourceStatus'global'
	ResetUI()
	Include("root.lua")
	SetResourceStatus'stage'
	InitAllClass()--Lobject
	InitScoreData()--initialize score data--Lscoredata
	jstg.ChangeInput() --20180516 bind new keys
	ext.reload()
	stage.Set('none','init')
end