---======================================
---luastg replay
---======================================

----------------------------------------
---replay

ext.replay={}

local REPLAY_DIR = "replay"

if not plus.DirectoryExists(REPLAY_DIR) then
	plus.CreateDirectory(REPLAY_DIR)
end

local replayManager=nil --replay管理器
local replayFilename=nil--当前打开的Replay文件名称
local replayInfo=nil    --当前打开的Replay文件信息
local replayStageIdx=1  --当前正在播放的关卡
local replayStages={}   --记录所有关卡的录像数据

replayWriter=nil--帧记录器
replayReader=nil--帧读取器

function ext.replay.IsReplay()
	return replayReader ~= nil
end

function ext.replay.IsRecording()
	return replayWriter ~= nil
end

function ext.replay.GetCurrentReplayIdx()
	return replayStageIdx
end

function ext.replay.GetReplayFilename()
	return replayFilename
end

function ext.replay.GetReplayStageName(idx)
	--Print('Index',idx)
	assert(replayInfo ~= nil)
	if not replayInfo.stages[idx] then return '' end
	return replayInfo.stages[idx].stageName
end

function ext.replay.RefreshReplay()
	replayManager:Refresh()
end

function ext.replay.GetSlotCount()
	return replayManager:GetSlotCount()
end

function ext.replay.GetSlot(idx)
	return replayManager:GetRecord(idx)
end

function ext.replay.SaveReplay(stageNames, slot, playerName, finish)
	local stages = {}
	finish=finish or 0
	for _, v in ipairs(stageNames) do
		assert(replayStages[v])
		table.insert(stages, replayStages[v])
	end
	
	-- TODO: gameName和gameVersion可以被用来检查录像文件的合法性
	plus.ReplayManager.SaveReplayInfo(replayManager:MakeReplayFilename(slot),{
		gameName = setting.mod,
		gameVersion = 1,
		userName = playerName,
		group_finish = finish,
		stages = stages,
	})
end

function ext.reload()
	replayManager = plus.ReplayManager(REPLAY_DIR.."\\"..setting.mod)
end

ext.reload()--加载一次replay管理器

----------------------------------------
---关卡切换增强功能
---用于支持replay

---设置场景
---当mode="none"时，参数stage用于表明下一个跳转的场景
---当mode="load"时，参数path有效，指明从path录像文件中加载场景stage的录像数据
---当mode="save"时，参数path无效，使用stage指定场景名称并开始录像
---@param mode string @none, load, save录像模式
---@param path string @录像文件路径（可选）
---@param stageName string @关卡名称
function stage.Set(mode, path, stageName)
	Print('Set',mode,path,stageName)
	if mode == "load" and stage.next_stage then return end --防止放replay时转场两次
	
	ext.pause_menu_order = nil
	
	-- 针对上一个可能的场景保存其数据
	if replayWriter ~= nil then
		local recordStage = replayStages[lstg.var.stage_name]
		recordStage.score = lstg.var.score
		recordStage.stageTime = os.time() - recordStage.stageTime  -- TODO：这个方法只保存了大致时间，包括了暂停
		--recordStage.stageExtendInfo = Serialize(lstg.var)--错误的保存位置
	end
	
	-- 关闭上一个场景的录像读写
	replayWriter = nil
	if replayReader then
		replayReader:Close()
		replayReader = nil
	end
	if mode ~= "load" then
		replayFilename = nil  -- 装载时使用缓存的数据
		replayInfo = nil
		replayStageIdx = 0
	end
	ext.ResetTicker()--重置计数器
	
	-- 刷新最高分
	if (not stage.current_stage.is_menu) and (not ext.replay.IsReplay()) then
		local str = stage.current_stage.stage_name..'@'..tostring(lstg.var.player_name)
		if scoredata.hiscore[str] == nil then
			scoredata.hiscore[str] = 0
		end
		scoredata.hiscore[str] = max(scoredata.hiscore[str], lstg.var.score)
	end
	
	-- 转场
	if mode == "save" then
		assert(stageName == nil)
		stageName = path
		-- 设置随机数种子
		
		lstg.var.ran_seed = ((os.time() % 65536) * 877) % 65536
		if jstg.network.ran_seed then
			lstg.var.ran_seed = ran:GetSeed()
		end
		--由OLC添加，用于录像和切关
		lstg.var.stage_name = stageName
		-- 这里只能构造随机种子，因为当帧有可能会用随机数。在getinput转场里设置随机种子
		--ran:Seed(lstg.var.ran_seed)
		-- 开始执行录像
		local sg=string.match(stageName,'^.+@(.+)$')
		replayWriter = plus.ReplayFrameWriter()
		replayStages[stageName] = {
			stageName = stageName, score = 0, randomSeed = lstg.var.ran_seed,
			stageTime = os.time(), stageDate = os.time(), stagePlayer=lstg.var.rep_player,
			group_num=stage.groups[sg].number,
			cur_stage_num=(stage.current_stage.number or 100),
			frameData = replayWriter,
			stageExtendInfo = Serialize(lstg.var)--by OLC
		}
		
		-- 转场
		--lstg.var.stage_name = stageName
		--stage.next_stage = stage.stages[stageName]
		--replayStages[stageName].stageExtendInfo = Serialize(lstg.var)
		stage.next_stage = stage.stages[stageName]--by OLC
	elseif mode == "load" then
		if path ~= replayFilename then
			replayFilename = path
			replayInfo = plus.ReplayManager.ReadReplayInfo(path)  -- 重新读取录像信息以保证准确性
			assert(#replayInfo.stages > 0)
		end
		
		-- 决定场景顺序
		if stageName then
			replayStageIdx = nil
			for i, v in ipairs(replayInfo.stages) do
				if replayInfo.stages[i].stageName == stageName then
					replayStageIdx = i
					Print(stageName,replayStageIdx)
					break
				end
			end
			assert(replayStageIdx ~= nil)
		else
			replayStageIdx = 1
		end
		
		--加载数据
		local nextRecordStage = replayInfo.stages[replayStageIdx]
		replayReader = plus.ReplayFrameReader(path, nextRecordStage.frameDataPosition, nextRecordStage.frameCount)
		
		--加载数据
		--lstg.var = DeSerialize(nextRecordStage.stageExtendInfo)--不能这么加载，因为场景里还有东西，在下一帧加载
		lstg.nextvar = DeSerialize(nextRecordStage.stageExtendInfo)
		--assert(lstg.var.ran_seed == nextRecordStage.randomSeed)  -- 这两个应该相等
		
		--初始化随机数
		--if lstg.var.ran_seed then
			--ran:Seed(lstg.var.ran_seed)
		--end
		
		--转场
		lstg.var.stage_name = nextRecordStage.stageName
		stage.next_stage = stage.stages[stageName]
	else
		assert(mode == "none")
		assert(stageName == nil)
		stageName = path
		
		-- 转场
		lstg.var.stage_name = stageName
		stage.next_stage = stage.stages[stageName]
	end
end

---重新开始场景
function stage.Restart()
	stage.preserve_res = true  -- 保留资源在转场时不清空
	if ext.replay.IsReplay() then
		stage.Set("load", ext.replay.GetReplayFilename(), lstg.var.stage_name)
		--stage.Set("load", ext.replay.GetReplayStageName(1), lstg.var.stage_name)
	elseif ext.replay.IsRecording() then
		stage.Set("save", lstg.var.stage_name)
	else
		stage.Set("none", lstg.var.stage_name)
	end
end
