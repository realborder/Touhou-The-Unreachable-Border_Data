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
	
	--这里创建logo，背景可以考虑放在render里
	
	start_menu=New(base_menu,'start_menu','Title_Menu_item_Start',{
			{'ChooseMode_item_StoryMode','',function () end,true},
			{'ChooseMode_item_StagePrac','stage_menu','',true},
			{'ChooseMode_item_SpellCardPrac','','',false},
			{'ChooseMode_item_NightmareEcli','','',false},
		},
		'main_menu'
	)
	
	manual_menu=New(special_manual)
	
	main_menu=New(base_menu,'main_menu','',{
			{'Title_Menu_item_Start','start_menu','',true},
			{'Title_Menu_item_Reply','reply_menu','',true},
			{'Title_Menu_item_PlayerData','','',false},
			{'Title_Menu_item_Musicroom','','',false},
			{'Title_Menu_item_Gallery','','',false},
			{'Title_Menu_item_Manual','manual_menu','',true},
			{'Title_Menu_item_Option','',function () menu.FlyIn(menu_other,'right'); menu_other.pos=1 end,true},
			{'Title_Menu_item_Exit','',ExitGame(),true}	
		},
		''
	)
	main_menu.locked=false
	
end

function stage_launcher:render()
	--执行exani动画
	--主要是背景
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