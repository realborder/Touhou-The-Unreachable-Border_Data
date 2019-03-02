---=====================================
---core
---所有基础的东西都会在这里定义
---=====================================

---@class lstg @内建函数库
lstg=lstg or {}

----------------------------------------
---各个模块

lstg.DoFile("lib\\Llog.lua")--简单的log系统
lstg.DoFile("lib\\Ldebug.lua")--简单的debug库
lstg.DoFile("lib\\Lglobal.lua")--用户全局变量
lstg.DoFile("lib\\Lmath.lua")--数学常量、数学函数、随机数系统
lstg.DoFile("plus\\plus.lua")--CHU神的plus库，replay系统、行走图系统、plusClass、NativeAPI
lstg.DoFile("ex\\ex.lua")--ESC神的ex库，多玩家支持、网络连接、多world、多输入槽位
lstg.DoFile("lib\\Lobject.lua")--Luastg的Class、object
lstg.DoFile("lib\\Lresources.lua")--资源的加载函数、资源枚举和判断
lstg.DoFile("lib\\Lscreen.lua")--world、3d、viewmode的参数设置
lstg.DoFile("lib\\Linput.lua")--按键状态更新
lstg.DoFile("lib\\Ltask.lua")--task
lstg.DoFile("lib\\Lstage.lua")--stage关卡系统
lstg.DoFile("lib\\Ltext.lua")--文字渲染
lstg.DoFile("lib\\Lscoredata.lua")--玩家存档
lstg.DoFile("lib\\Lplugin.lua")--用户插件

----------------------------------------
---用户定义的一些函数

---设置标题
function ChangeGameTitle()
	local title=setting.mod..' | FPS='..GetFPS()..' | Objects='..GetnObj()..' | Luastg Ex Plus'
	if jstg.network.status>0 then
		title=title..' | '..jstg.NETSTATES[jstg.network.status]
		if jstg.network.status>4 then
			title=title..'('..jstg.network.delay..')'
		end
	end
	SetTitle(title)
end

---切关处理
function ChangeGameStage()
	jstg.ResetWorlds()--by ETC，重置所有world参数
	
	lstg.ResetLstgtmpvar()--重置lstg.tmpvar
	ex.Reset()--重置ex全局变量
	
	if lstg.nextvar then
		lstg.var=lstg.nextvar
		lstg.nextvar =nil
	end
	
	-- 初始化随机数
	if lstg.var.ran_seed then
		--Print('RanSeed',lstg.var.ran_seed)
		ran:Seed(lstg.var.ran_seed)
	end
	
	--刷新最高分
	if not stage.next_stage.is_menu then
		if scoredata.hiscore == nil then
			scoredata.hiscore = {}
		end
		lstg.tmpvar.hiscore = scoredata.hiscore[stage.next_stage.stage_name..'@'..tostring(lstg.var.player_name)]
	end
	
	jstg.enable_player=false
	
	--切换关卡
	stage.current_stage=stage.next_stage
	stage.next_stage=nil
	stage.current_stage.timer=0
	stage.current_stage:init()
	
	if not jstg.enable_player then
		jstg.Compatible()--创建自机，支持旧版本mod
	end
	
	RunSystem('on_stage_init')
end

---行为帧动作(和游戏循环的帧更新分开)
function DoFrame()
	--标题设置
	ChangeGameTitle()
	--切关处理
	if stage.next_stage then ChangeGameStage() end
	--刷新输入
	jstg.GetInputEx()
	--stage和object逻辑
	SetPlayer()--清除jstg.current_player指向的自机
	if GetCurrentSuperPause()<=0 or stage.nopause then
		ex.Frame()
		task.Do(stage.current_stage)
		stage.current_stage:frame()
		stage.current_stage.timer=stage.current_stage.timer+1
	end
	ObjFrame()
	if GetCurrentSuperPause()<=0 or stage.nopause then
		for i=1,jstg.GetWorldCount() do
			jstg.SwitchWorld(i)
			SetWorldFlag(jstg.worlds[i].world)
			BoundCheck()
		end
	end
	if GetCurrentSuperPause()<=0 then
		CollisionCheck(GROUP_PLAYER,GROUP_ENEMY_BULLET)
		CollisionCheck(GROUP_PLAYER,GROUP_ENEMY)
		CollisionCheck(GROUP_PLAYER,GROUP_INDES)
		CollisionCheck(GROUP_ENEMY,GROUP_PLAYER_BULLET)
		CollisionCheck(GROUP_NONTJT,GROUP_PLAYER_BULLET)
		CollisionCheck(GROUP_ITEM,GROUP_PLAYER)
		--由OLC添加，可用于自机bomb
		CollisionCheck(GROUP_SPELL,GROUP_ENEMY)
		CollisionCheck(GROUP_SPELL,GROUP_NONTJT)
		CollisionCheck(GROUP_SPELL,GROUP_ENEMY_BULLET)
		CollisionCheck(GROUP_SPELL,GROUP_INDES)
	end
	UpdateXY()
	AfterFrame()
	--切关时清空资源和回收对象
	if stage.next_stage and stage.current_stage then
		stage.current_stage:del()
		task.Clear(stage.current_stage)
		if stage.preserve_res then
			stage.preserve_res=nil
		else
			RemoveResource'stage'
		end
		ResetPool()
	end
end

function BeforeRender() end

function AfterRender() end

function GameExit() end

----------------------------------------
---全局回调函数，底层调用

function GameInit()
	--加载mod包
	if setting.mod~='launcher' then
		Include 'root.lua'
	else
		Include 'launcher.lua'
	end
	if setting.mod~='launcher' then
		_mod_version=_mod_version or 0
		if _mod_version>_luastg_version or _mod_version<_luastg_min_support then
			error(string.format(
				"Mod version and engine version mismatch. Mod version is %.2f, LuaSTG version is %.2f.",
				_mod_version/100,
				_luastg_version/100
			))
		end
	end
	--最后的准备
	InitAllClass()--对所有class的回调函数进行整理，给底层调用
	InitScoreData()--装载玩家存档
	
	SetViewMode("world")
	if stage.next_stage==nil then
		error('Entrance stage not set.')
	end
	SetResourceStatus("stage")
end

function FrameFunc()
	DoFrame(true,true)
	if lstg.quit_flag then GameExit() end
	return lstg.quit_flag
end

function RenderFunc()
	if stage.current_stage.timer>1 and stage.next_stage==nil then
		BeginScene()
		BeforeRender()
		stage.current_stage:render()
		ObjRender()
		AfterRender()
		EndScene()
	end
end

function FocusLoseFunc() end

function FocusGainFunc() end
