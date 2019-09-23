---------------------------------------
---启动器
---------------------------------------

Include'THlib\\THlib.lua'

local GetLastKey=lstg.GetLastKey--_GetLastKey

local _key_code_to_name=KeyCodeToName()--Linput
local setting_item={'resx','resy','windowed','vsync','sevolume','bgmvolume','res'}
local Resolution={{1280,720},{1600,900},{1920,1080}}
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
-- LoadImageFromFile('UI_gameInit','THlib\\UI\\UI_gameInit.jpg')
InitRenderFlag=true

-- InitRender=Class(object)
-- function InitRender:init()
-- 	self.layer=LAYER_TOP+20
-- end

-- function InitRender:render()
-- 	if InitRenderFlag then Render('UI_gameInit',320,240) end
-- end


stage_init=stage.New('init',true,true)
function stage_init:init()
    New(mask_fader,'open')
    jstg.enable_player=true
    LoadTexture('UI_gameInit','THlib\\UI\\UI_gameInit.jpg')
	LoadImage('UI_gameInit','UI_gameInit',0,0,1920,1080)
	self.load_process=0

end
function stage_init:frame()
	if self.timer==30 then
		SetResourceStatus'global'
		LoadTTF('menuttfs','THlib\\UI\\font\\default_ttf',40)
		self.load_process=0.1
	elseif self.timer==31 then
		--沙雕加载资源，以后再改
		dialogsys_sub.Init()
		local STAGE={'player','st1','st2','st3'--[[,'st4','st5','st6a','st6b','ex']]} --未制作的关卡暂时屏蔽
		for _,v in pairs(STAGE) do
			dialogsys_sub.LoadImage(v)
		end
		self.load_process=0.35
	elseif self.timer==32 then
		exani_player_manager.LoadAllResource()
		self.load_process=0.45
	elseif self.timer==33 then
		do
			local f,msg
			f,msg=io.open(settingfile,'r')
			if f==nil then
				cur_setting=DeSerialize(Serialize(default_setting))
			else
				cur_setting=DeSerialize(f:read('*a'))
				f:close()
			end
			LoadTexture('UI_gameInit','THlib\\UI\\UI_gameInit.jpg')
			LoadImage('UI_gameInit','UI_gameInit',0,0,1920,1080)
		
			New(exani_player_manager)	
			player_menu=New(special_player)
			
			diff_menu=New(special_difficulty)
			RawDel(diff_menu)
			stage_menu=New(base_menu,'stage_menu','',{
					{'ChooseStage_item_Stage1','diff_menu','',true},
					{'ChooseBoss_item_Boss1','diff_menu',function() debugPoint=4 end,true},
					{'ChooseStage_item_Stage2','diff_menu','',true},
					{'ChooseBoss_item_Boss2','diff_menu',function() debugPoint=4 end,true},
					{'ChooseStage_item_Stage3','diff_menu','',true},
					{'ChooseBoss_item_Boss3','diff_menu',function() debugPoint=5 end,true},
				},
				'start_menu',
				true
			)
			
			start_menu=New(base_menu,'start_menu','Title_Menu_item_Start',{
					{'ChooseMode_item_StoryMode','diff_menu',function() practice=nil diff_menu.menu_back=1 debugPoint=0 end,true},
					{'ChooseMode_item_StagePrac','stage_menu',function() practice='stage' diff_menu.menu_back=2 end,true},
					{'ChooseMode_item_SpellCardPrac','','',false},
					{'ChooseMode_item_NightmareEcli','','',false},
				},
				'main_menu',
				true
			)
			
			replay_menu=New(special_replay)
			
			manual_menu=New(special_manual)
			menu_other=New(other_setting_menu,'Other Settings',{
				{'Resolution X',function() menu_other.edit=true menu_other.setting_backup=cur_setting.res end},
				{'Resolution Y',function() menu_other.edit=true menu_other.setting_backup=cur_setting.res end},
				{'Windowed',function() cur_setting.windowed=not cur_setting.windowed end},
				{'Vsync',function() cur_setting.vsync=not cur_setting.vsync end},
				{'Sound Volume',function() end},
				{'Music Volume',function() end},
				{'Return To Title',function()
					menu.FlyOut(menu_other,'right')
					save_setting()
					loadConfigure()
					ChangeVideoMode(setting.resx,setting.resy,setting.windowed,setting.vsync)
					SetSEVolume(setting.sevolume/100)
					SetBGMVolume(setting.bgmvolume/100)
					ResetScreen()
					base_menu.ChangeLocked(menus['main_menu'])
				end},
				{'exit',function()
					if menu_other.pos~=7 then
						menu_other.pos=7
					else
						menu.FlyOut(menu_other,'right')
						save_setting()
						base_menu.ChangeLocked(menus['main_menu'])
					end
				end},
			})
			main_menu=New(base_menu,'main_menu','',{
					{'Title_Menu_item_Start','start_menu','',true},
					{'Title_Menu_item_Replay','replay_menu',function() menu.FadeIn2(replay_menu,'right') end,true},
					{'Title_Menu_item_PlayerData','','',false},
					{'Title_Menu_item_Musicroom','','',false},
					{'Title_Menu_item_Manual','manual_menu','',true},
					{'Title_Menu_item_Gallery','','',false},
					{'Title_Menu_item_Option','',function() menu.FlyIn(menu_other,'right') menu_other.pos=1 end,true},
					{'Title_Menu_item_Exit','',ExitGame,true}
				},
				'',
				true
			)
			
		end
		self.load_process=0.55
	elseif self.timer==34 then
		LoadMusic('menu',music_list.menu[1],music_list.menu[2],music_list.menu[3])
		start_game()
		Print('游戏已启动')
		self.load_process=1
    elseif self.timer==35 then
        New(mask_fader,'')
    elseif self.timer>=67 then 
		stage.Set('none', 'menu') 
	end
    -- if self.timer>=1 then stage.Set('none', 'menu') end
end
function stage_init:render()
	if self.timer>=66 then return end --阻止
	SetViewMode'ui'
    Render('UI_gameInit',320,240,0,0.5)
	SetImageState('white','',Color(0xFFFFFFFF))
	local extra=107
	RenderRect('white',0-extra,(screen.width+2*extra)*self.load_process,0,3)
end


stage_main_menu=stage.New('menu',false,true)

function stage_main_menu:init()
	-- LoadTTF('menuttfs','THlib\\UI\\font\\default_ttf',40)
	-- --
	-- local f,msg
	-- f,msg=io.open(settingfile,'r')
	-- if f==nil then
	-- 	cur_setting=DeSerialize(Serialize(default_setting))
	-- else
	-- 	cur_setting=DeSerialize(f:read('*a'))
	-- 	f:close()
	-- end
	-- --
	local function ExitGame()
		task.New(self,function()
			task.Wait(30)
			stage.QuitGame()
		end)
	end
	-- --
	-- LoadTexture('UI_gameInit','THlib\\UI\\UI_gameInit.jpg')
	-- LoadImage('UI_gameInit','UI_gameInit',0,0,1920,1080)

	New(exani_player_manager)	
	player_menu=New(special_player)
	
	diff_menu=New(special_difficulty)
	
	stage_menu=New(base_menu,'stage_menu','',{
			{'ChooseStage_item_Stage1','diff_menu','',true},
			{'ChooseBoss_item_Boss1','diff_menu',function() debugPoint=4 end,true},
			{'ChooseStage_item_Stage2','diff_menu','',true},
			{'ChooseBoss_item_Boss2','diff_menu',function() debugPoint=4 end,true},
			{'ChooseStage_item_Stage3','diff_menu','',true},
			{'ChooseBoss_item_Boss3','diff_menu',function() debugPoint=5 end,true},
		},
		'start_menu',
		true
	)
	
	start_menu=New(base_menu,'start_menu','Title_Menu_item_Start',{
			{'ChooseMode_item_StoryMode','diff_menu',function() practice=nil diff_menu.menu_back=1 debugPoint=0 end,true},
			{'ChooseMode_item_StagePrac','stage_menu',function() practice='stage' diff_menu.menu_back=2 end,true},
			{'ChooseMode_item_SpellCardPrac','','',false},
			{'ChooseMode_item_NightmareEcli','','',false},
		},
		'main_menu',
		true
	)
	
	replay_menu=New(special_replay)
	
	manual_menu=New(special_manual)
	menu_other=New(other_setting_menu,'Other Settings',{
		{'Resolution X',function() menu_other.edit=true menu_other.setting_backup=cur_setting.res end},
		{'Resolution Y',function() menu_other.edit=true menu_other.setting_backup=cur_setting.res end},
		{'Windowed',function() cur_setting.windowed=not cur_setting.windowed end},
		{'Vsync',function() cur_setting.vsync=not cur_setting.vsync end},
		{'Sound Volume',function() end},
		{'Music Volume',function() end},
		{'Return To Title',function()
			menu.FlyOut(menu_other,'right')
			save_setting()
			loadConfigure()
			ChangeVideoMode(setting.resx,setting.resy,setting.windowed,setting.vsync)
			SetSEVolume(setting.sevolume/100)
			SetBGMVolume(setting.bgmvolume/100)
			ResetScreen()
			base_menu.ChangeLocked(menus['main_menu'])
		end},
		{'exit',function()
			if menu_other.pos~=7 then
				menu_other.pos=7
			else
				menu.FlyOut(menu_other,'right')
				save_setting()
				base_menu.ChangeLocked(menus['main_menu'])
			end
		end},
	})
	main_menu=New(base_menu,'main_menu','',{
			{'Title_Menu_item_Start','start_menu','',true},
			{'Title_Menu_item_Replay','replay_menu',function() menu.FadeIn2(replay_menu,'right') end,true},
			{'Title_Menu_item_PlayerData','','',false},
			{'Title_Menu_item_Musicroom','','',false},
			{'Title_Menu_item_Manual','manual_menu','',true},
			{'Title_Menu_item_Gallery','','',false},
			{'Title_Menu_item_Option','',function() menu.FlyIn(menu_other,'right') menu_other.pos=1 end,true},
			{'Title_Menu_item_Exit','',ExitGame,true}
		},
		'',
		true
	)
	LoadMusic('menu',music_list.menu[1],music_list.menu[2],music_list.menu[3])

	-- New(mask_fader,'open')
	-- InitRenderFlag=false
	New(mask_fader,'open')
		
	base_menu.ChangeLocked(menus['main_menu'])
	exani_player_manager.ExecuteExaniPredefine(play_manager,'Title_Menu_bg','init')
	exani_player_manager.SetExaniAttribute(play_manager,'Title_Menu_bg',nil,nil,nil,'ui')
	
	PlayMusic('menu')
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
				elseif last_key==setting.keys.shoot or lstg.GetKeyState(KEY.ENTER) then self.edit=false PlaySound('select00',0.3)
				elseif last_key==setting.keys.spell or lstg.GetKeyState(KEY.ESCAPE) then self.edit=false
					if menu_other.setting_backup then cur_setting.res=menu_other.setting_backup end
					cur_setting.resx=Resolution[cur_setting.res][1]
					cur_setting.resy=Resolution[cur_setting.res][2]
					PlaySound('cancel00',0.3)
				end
				self.posx=max(1,min(self.posx,#Resolution))
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
	if self.locked then return end
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
	if not(lfs.attributes('Library\\'..setting.mod..'_pw.zip')==nil) then
		LoadPackSub('Library\\'..setting.mod..'_pw.zip')--正常加载加密mod
	elseif not(lfs.attributes('Library\\'..setting.mod..'.zip')==nil) then
		LoadPack('Library\\'..setting.mod..'.zip')--正常加载mod
	else
		--找不到，不加载mod
	end
	-- SetSplash(false)
	-- SetTitle(setting.mod)
	SetTitle('东方梦无垠 ~ The Unreachabe Oneiroborder')

	-- if not ChangeVideoMode(setting.resx,setting.resy,setting.windowed,setting.vsync) then
	-- 	if lfs.attributes('.\\LuaSTGPlus.dev.exe')~=nil then
	-- 		os.execute('start /b .\\LuaSTGPlus.dev.exe "start_game=true"')
	-- 	else
	-- 		os.execute('start /b .\\LuaSTGPlus.exe "start_game=true"')
	-- 	end
	-- 	stage.QuitGame()
	-- 	return
	-- end
	SetSEVolume(setting.sevolume/100)
	SetBGMVolume(setting.bgmvolume/100)
	-- ResetScreen()--Lscreen
	-- SetResourceStatus'global'
	ResetUI()
	Include("root.lua")
	SetResourceStatus'stage'
	InitAllClass()--Lobject
	InitScoreData()--initialize score data--Lscoredata
	jstg.ChangeInput() --20180516 bind new keys
	ext.reload()
end