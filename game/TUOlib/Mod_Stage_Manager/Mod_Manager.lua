tuolib.mod_manager={}
local m=tuolib.mod_manager
local self=m
local PATH='mod'
function m:init()
    self.modlist=self.modlist or {} 
    self:RefreshModList()
    self.protect_mode=true
end
function m:DoFile(path,arch)
    if self.protect_mode then
        if not(lfs.attributes(path) == nil) then 
            local r,err=xpcall(lstg.DoFile,debug.traceback,path,arch)
            if r then 
                Print('成功重载脚本：'..path,2)
                return true
            else
                Print('重载脚本：'..path..' 的时候发生错误\n\t错误详细信息:\n\t\t'..err,1)
                return r,err
            end
        else
            Print('脚本 '..path..' 不存在',1) 
            return false,('脚本 '..path..' 不存在')
        end
    else
        lstg.DoFile(path,arch)
        return true
    end
end
function m:RefreshModList()
    if lfs.attributes(PATH)==nil then return false end 
    local old_mod_list=self.modlist
    self.modlist={}
    local mods=plus.EnumFiles(PATH)
	for i,v in pairs(mods) do
        local flag
        flag=not v.isDirectory
        flag=flag and string.find(v.name,'.zip',1,true)
        if flag then
            self.modlist[PATH..'\\'..v.name]=false
            if old_mod_list[PATH..'\\'..v.name] then self.modlist[PATH..'\\'..v.name]=true end
            -- table.insert(self.modlist,{name=PATH..'\\'..v.name,is_stage=flag2})
        end
    end
    return true
end

function m:GetModList()
    return self.modlist
end
function m.LoadMod(path)
    local hasPassWord=string.find(path,'pw',1,true)
    if hasPassWord then LoadPackSub(path) else LoadPack(path) end
    return self:DoFile("root.lua",path)
end
function m.UnloadMod(path)
    UnloadPack(path)
end
function m.ReloadMod(path)
    UnloadPack(path)
    local hasPassWord=string.find(path,'pw',1,true)
    if hasPassWord then LoadPackSub(path) else LoadPack(path) end
    self:DoFile("root.lua",path)
end
function m.LoadAllStageMod()
    local ret={}
    local result=true
    for k,v in pairs(self.modlist) do
        if string.find(k,'STAGE',1,true)~=nil then
            local hasPassWord=string.find(k,'pw',1,true)
            if not v then 
                if hasPassWord then LoadPackSub(k) else LoadPack(k) end
                local r,e=self:DoFile("root.lua",k)
                table.insert(ret,{ret=r,err=e})
                result=result and r
            end
        end
    end
    return result,ret
end
function m.ReloadAllStageMod()
    local ret={}
    local result=true
    for k,v in pairs(self.modlist) do
        if string.find(k,'STAGE',1,true)~=nil then
            local hasPassWord=string.find(k,'pw',1,true)
            if not v then 
                UnloadPack(k)
                if hasPassWord then LoadPackSub(k) else LoadPack(k) end
                local r,e=self:DoFile("root.lua",k)
                table.insert(ret,{ret=r,err=e})
                result=result and r
            end
        end
    end
    return result,ret
end
function m.ReloadAllMod()
    local ret={}
    local result=true
    for k,v in pairs(self.modlist) do
        local hasPassWord=string.find(k,'pw',1,true)
        if not v then 
            UnloadPack(k)
            if hasPassWord then LoadPackSub(k) else LoadPack(k) end
            local r,e=self:DoFile("root.lua",k)
            table.insert(ret,{ret=r,err=e})
            result=result and r
        end
    end
    return result,ret
end
m:init()