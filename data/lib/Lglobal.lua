---=====================================
---luastg user global value
---=====================================

local LOG_MODULE_NAME="[lstg][global]"

----------------------------------------
---user  global value

---退出游戏
lstg.quit_flag=false

---暂停
lstg.paused=false

---跨关全局变量表
---@type table
lstg.var={username=setting.username}

---关卡内全局变量表
---@type table
lstg.tmpvar={}

---播放录像时用来临时保存lstg.var的表，默认为nil
---@type nil|table
lstg.nextvar = nil

---设置一个全局变量
---@param k number|string
---@param v any
function lstg.SetGlobal(k,v)
    lstg.var[k]=v
end

---获取一个全局变量
---@param k number|string
---@return any
function lstg.GetGlobal(k)
    return lstg.var[k]
end

SetGlobal=lstg.SetGlobal
GetGlobal=lstg.GetGlobal

---重置关卡内全局变量表
function lstg.ResetLstgtmpvar()
    lstg.tmpvar={}
end

----------------------------------------
---multiplayers' player names

local LSTG_MAX_PLAYER=2

---储存自机类名，用于游戏时创建自机
lstg.var.player_names={}

---获取最大支持的玩家数量
---@return number
function lstg.GetMaxPlayerNumber()
    return LSTG_MAX_PLAYER
end

---获取已设置的自机类名的数量
---@param ignoreblank boolean @忽略空位
---@return number
function lstg.GetPlayerNameNumber(ignoreblank)
    if not(ignoreblank) then
        local n=0
        for i=LSTG_MAX_PLAYER,1,-1 do
            if type(lstg.var.player_names[i])=="string" then
                n=i
                break
            end
        end
        if type(lstg.var.player_name)=="string" then
            n=math.max(n,1)
        end
        if type(lstg.var.player_name2)=="string" then
            n=math.max(n,2)
        end
        do return n end
    else
        local n=0
        for i=LSTG_MAX_PLAYER,1,-1 do
            if type(lstg.var.player_names[i])=="string" then
                n=n+1
            end
        end
        do return n end
    end
end

---设置自机类名，用于游戏时创建自机
---@param classname string @自机类名
---@param slot number|nil @要设置的槽位
---@return boolean
function lstg.SetPlayerName(classname,slot)
    if type(classname)~="string" then
        lstg.Log(4,LOG_MODULE_NAME,"设置自机类名 "..tostring(classname).." 失败，类名应使用字符串")
        do return false end
    end
    if slot then
        if type(slot)~="number" then
            lstg.Log(4,LOG_MODULE_NAME,"设置自机类名失败，槽位不能使用number以外的类型")
            do return false end
        end
        if slot<=LSTG_MAX_PLAYER and slot>0 then
            if type(lstg.var.player_names[slot])=="string" then
                lstg.Log(2,LOG_MODULE_NAME,"尝试设置自机类名，但是槽位 "..slot.." 上已有的自机类名为 "..lstg.var.player_names[slot])
            end
            lstg.var.player_names[slot]=classname
            lstg.Log(2,LOG_MODULE_NAME,"槽位 "..slot.." 上的自机类名已设置为 "..classname)
            --适配旧的
            if slot==1 then
                lstg.var.player_name=classname
            elseif slot==2 then
                lstg.var.player_name2=classname
            end
            do return true end
        else
            lstg.Log(4,LOG_MODULE_NAME,"槽位 "..slot.." 上的自机类名设置失败，超出可设置的槽位范围")
            do return false end
        end
    else
        for i=1,LSTG_MAX_PLAYER do
            if lstg.var.player_names[i]==nil then
                if type(lstg.var.player_names[i])=="string" then
                    lstg.Log(2,LOG_MODULE_NAME,"尝试设置自机类名，但是槽位 "..i.." 上已有的自机类名为 "..lstg.var.player_names[i])
                end
                lstg.var.player_names[i]=classname
                lstg.Log(2,LOG_MODULE_NAME,"槽位 "..i.." 上的自机类名已设置为 "..classname)
                --适配旧的
                if i==1 then
                    lstg.var.player_name=classname
                elseif i==2 then
                    lstg.var.player_name2=classname
                end
                do return true end
            end
        end
        lstg.Log(4,LOG_MODULE_NAME,"已经没有空闲的槽位来设置自机类名")
        do return false end
    end
end

---获取指定槽位的自机类名，用于游戏时创建自机
---@param slot number @要获取的槽位
---@return string|boolean @获取失败时返回false
function lstg.GetPlayerName(slot)
    if type(slot)~="number" then
        lstg.Log(4,LOG_MODULE_NAME,"获取自机类名失败，槽位不能使用number以外的类型")
        do return false end
    end
    if slot>0 and slot<=LSTG_MAX_PLAYER then
        local ret=false
        if type(lstg.var.player_names[slot])=="string" then
            ret=lstg.var.player_names[slot]
            --兼容旧的
        elseif slot==1 and type(lstg.var.player_name)=="string" then
            ret=lstg.var.player_name
        elseif slot==2 and type(lstg.var.player_name2)=="string" then
            ret=lstg.var.player_name2
        else
            lstg.Log(4,LOG_MODULE_NAME,"尝试获取槽位 "..slot.." 上的的自机类名失败，该槽位的自机类名为空")
            do return ret end
        end
        lstg.Log(2,LOG_MODULE_NAME,"尝试获取槽位 "..slot.." 上的的自机类名成功，获取的类名为"..ret)
        do return ret end
    else
        lstg.Log(4,LOG_MODULE_NAME,"槽位 "..slot.." 上的自机类名获取失败，超出范围")
        do return false end
    end
end

---清除自机类名
---@param slot number|nil @要清除的槽位
---@return boolean
function lstg.ClearPlayerName(slot)
    if slot then
        if type(slot)~="number" then
            lstg.Log(4,LOG_MODULE_NAME,"清除自机类名失败，槽位不能使用number以外的类型")
            do return false end
        end
        if slot>0 and slot<=LSTG_MAX_PLAYER then
            lstg.var.player_names[slot]=nil
            --兼容旧的
            if slot==1 then
                lstg.var.player_name=nil
            elseif slot==2 then
                lstg.var.player_name2=nil
            end
            lstg.Log(2,LOG_MODULE_NAME,"槽位 "..slot.." 上的自机类名已清除")
            do return true end
        else
            lstg.Log(4,LOG_MODULE_NAME,"槽位 "..slot.." 上的自机类名清除失败，超出范围")
            do return false end
        end
    else
        lstg.var.player_names={}
        lstg.var.player_name=nil
        lstg.var.player_name2=nil
        lstg.Log(2,LOG_MODULE_NAME,"所有自机类名已清除")
        do return true end
    end
end

----------------------------------------
---multiplayers' rep player names

---储存replay要记录的自机名，用于保存录像
lstg.var.rep_players={}

---设置replay记录的自机名，用于保存录像
---@param rep_playername string|number @自机名
---@param slot number|nil @要设置的槽位
---@return boolean
function lstg.SetRepPlayerName(rep_playername,slot)
    if type(rep_playername)~="string" then
        lstg.Log(4,LOG_MODULE_NAME,"设置自机replay显示名 "..tostring(rep_playername).." 失败，应使用字符串")
        do return false end
    end
    if slot then
        if type(slot)~="number" then
            lstg.Log(4,LOG_MODULE_NAME,"设置自机replay显示名失败，槽位不能使用number以外的类型")
            do return false end
        end
        if slot<=LSTG_MAX_PLAYER and slot>0 then
            if type(lstg.var.rep_players[slot])=="string" then
                lstg.Log(2,LOG_MODULE_NAME,"尝试设置自机replay显示名，但是槽位 "..slot.." 上已有的自机replay显示名为 "..lstg.var.rep_players[slot])
            end
            lstg.var.rep_players[slot]=rep_playername
            lstg.Log(2,LOG_MODULE_NAME,"槽位 "..slot.." 上的自机replay显示名已设置为 "..rep_playername)
            --适配旧的
            if slot==1 then
                lstg.var.rep_player=rep_playername
            elseif slot==2 then
                --lstg.var.player_name2=classname
            end
            do return true end
        else
            lstg.Log(4,LOG_MODULE_NAME,"槽位 "..slot.." 上的自机replay显示名设置失败，超出可设置的槽位范围")
            do return false end
        end
    else
        for i=1,LSTG_MAX_PLAYER do
            if lstg.var.rep_players[i]==nil then
                if type(lstg.var.rep_players[i])=="string" then
                    lstg.Log(2,LOG_MODULE_NAME,"尝试设置自机replay显示名，但是槽位 "..i.." 上已有的自机replay显示名为 "..lstg.var.rep_players[i])
                end
                lstg.var.rep_players[i]=rep_playername
                lstg.Log(2,LOG_MODULE_NAME,"槽位 "..i.." 上的自机replay显示名已设置为 "..rep_playername)
                --适配旧的
                if i==1 then
                    lstg.var.rep_player=rep_playername
                elseif i==2 then
                    --lstg.var.player_name2=classname
                end
                do return true end
            end
        end
        lstg.Log(4,LOG_MODULE_NAME,"已经没有空闲的槽位来设置自机replay显示名")
        do return false end
    end
end

---获取指定槽位的自机replay显示名
---@param slot number @要获取的槽位
---@return string|boolean @获取失败时返回false
function lstg.GetRepPlayerName(slot)
    if type(slot)~="number" then
        lstg.Log(4,LOG_MODULE_NAME,"获取自机replay显示名失败，槽位不能使用number以外的类型")
        do return false end
    end
    if slot>0 and slot<=LSTG_MAX_PLAYER then
        local ret=false
        if type(lstg.var.rep_players[slot])=="string" then
            ret=lstg.var.rep_players[slot]
            --兼容旧的
        elseif slot==1 and type(lstg.var.rep_player)=="string" then
            ret=lstg.var.rep_player
        --elseif slot==2 and type(lstg.var.player_name2)=="string" then
            --ret=lstg.var.player_name2
        else
            lstg.Log(4,LOG_MODULE_NAME,"尝试获取槽位 "..slot.." 上的的自机replay显示名失败，该槽位的自机replay显示名为空")
            do return ret end
        end
        lstg.Log(2,LOG_MODULE_NAME,"尝试获取槽位 "..slot.." 上的的自机replay显示名成功，获取的自机replay显示名为"..ret)
        do return ret end
    else
        lstg.Log(4,LOG_MODULE_NAME,"槽位 "..slot.." 上的自机replay显示名获取失败，超出范围")
        do return false end
    end
end

---清除自机replay显示名
---@param slot number|nil @要清除的槽位
---@return boolean
function lstg.ClearRepPlayerName(slot)
    if slot then
        if type(slot)~="number" then
            lstg.Log(4,LOG_MODULE_NAME,"清除自机replay显示名失败，槽位不能使用number以外的类型")
            do return false end
        end
        if slot>0 and slot<=LSTG_MAX_PLAYER then
            lstg.var.rep_players[slot]=nil
            --兼容旧的
            if slot==1 then
                lstg.var.rep_player=nil
            elseif slot==2 then
                --lstg.var.player_name2=nil
            end
            lstg.Log(2,LOG_MODULE_NAME,"槽位 "..slot.." 上的自机replay显示名已清除")
            do return true end
        else
            lstg.Log(4,LOG_MODULE_NAME,"槽位 "..slot.." 上的自机replay显示名清除失败，超出范围")
            do return false end
        end
    else
        lstg.var.rep_players={}
        lstg.var.rep_player=nil
        --lstg.var.player_name2=nil
        lstg.Log(2,LOG_MODULE_NAME,"所有自机replay显示名已清除")
        do return true end
    end
end
