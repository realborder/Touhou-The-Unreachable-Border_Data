-----------------------------------------------
---一些函数
--简易的日志输出
local ENABLED_LOG_LEVEL=4
local Log=function (text,level) 
	level=level or 4
	if level>ENABLED_LOG_LEVEL then return end
	Print('[TUO_Developer_Tool_kit] '..text) 
end

---------------------------------------------
---重载外部文件或者程序内部指定的单个脚本
---@param path string 脚本的路径
local ReloadSingleFile=function(path)
	-- TUO_Developer_Flow:MsgWindow('尝试重载指定脚本:'..path)

	if not(lfs.attributes(path) == nil) then 
		local r,err=xpcall(lstg.DoFile,debug.traceback,path)
		if r then 
			TUO_Developer_Flow:MsgWindow('成功重载脚本：'..path)
			Log('成功重载脚本：'..path,2)
		else
			Log('载入脚本：'..path..' 的时候发生错误\n    错误详细信息:\n    '..err,1) 
		end
	else
		Log('脚本 '..path..' 不存在',1) 
		TUO_Developer_Flow:ErrorWindow('脚本 '..path..' 不存在')	
end
end
TUO_Developer_Tool_kit.ReloadSingleFile=ReloadSingleFile

---------------------------------------------
---重载指定（多个）脚本
---@param path string 提供具体文件路径以重载，也可以传一个表进去
local ReloadFiles = function (path)
	Log('尝试重载指定脚本')
	-- TUO_Developer_Flow:MsgWindow('尝试重载指定脚本')
	if type(path)=='string' then
		ReloadSingleFile(path)
	elseif type(path)=='table' then
		-- TUO_Developer_Flow:MsgWindow('发现多个文件'..#path)
		for i,v in ipairs(path) do 
			ReloadSingleFile(v)
		end
	end
end
TUO_Developer_Tool_kit.ReloadFiles=ReloadFiles





--独立按键检测
local _KeyDown={}

--------------------------------------------
---独立按键检测函数，这个每帧只能调用一次
---@return boolean 返回键值状态
local CheckKeyState= function (k)
	if not _KeyDown[k] then _KeyDown[k]=false end
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
TUO_Developer_Tool_kit.CheckKeyState=CheckKeyState

--------------------------------------------------
---用文本索引来返回其对应的值
---现在已经能接受类如 'lstg.var'这样的表中表的索引输入
---@param str string 
---@param value any 如果给出这个值那么函数会转而赋值而不是返回值
---@return any
function IndexValueByString(str,value)
	local tmp
	local tmp_k={}
	local i=1
	local pos=string.find(str,".",1,true)
	local pospre
	if not pos then 
		if value~=nil then _G[str]=value return
		else return _G[str] end
	else table.insert(tmp_k,string.sub(str,1,pos-1)) end
	while true do
		pospre=pos+1
		pos=string.find(str,".",pos+1,true)
		if not pos then
			table.insert(tmp_k,string.sub(str,pospre,114514))
			break
		else
		table.insert(tmp_k,string.sub(str,pospre,pos-1)) end
    end
	if type(value)=='nil' then
		for k,v in pairs(tmp_k) do
			if k==1 then tmp=_G[v]
			else 
				if tmp==nil then return 
				else tmp=tmp[v] end
				 
			end
		end
		return tmp
	else
		if #tmp_k == 1 then
			_G[tmp_k[1]]=value
		else
			for k,v in pairs(tmp_k) do
				if k==1 then tmp=_G[v]
				elseif k==#tmp_k then tmp[v]=value
				else tmp=tmp[v] end
			end
		end
	end
end


function WipeOutBossHp()
	--适配多boss
	local boss_list={}
	for _,o in ObjList(GROUP_ENEMY) do
		if o._bosssys then table.insert(boss_list,o) end
	end
	if #boss_list>0 and (not lstg.GetKeyState(KEY.SHIFT)) then 
		for i=1,#boss_list do boss_list[i].hp=0.1 end
	elseif debugPoint then
		if lstg.GetKeyState(KEY.SHIFT) then 
			debugPoint=debugPoint-1
		else 
			debugPoint=debugPoint+1 end
	end
end


function TUO_Developer_UI.GetListSingleSel(widget)
	for i=1,#(widget.display_value) do
		if widget.selection[i] then return i,widget.display_value[i].name,widget.display_value[i].v end
	end
	return nil
end
