tuolib.mod_manager={}
local m=tuolib.mod_manager
local self=m
local PATH='mod'
function m:init()
    self.modlist=self.modlist or {} 
    self:RefreshModList()
    self.protect_mode=true
    local result,ret = self:LoadAllStageMod() 
    if not result then
        for k,v in pairs(ret) do
            if not v.ret then
                Print('Mod出错'..err)
            end
        end
    end    
end
function m:DoFile(path,arch)
    if self.protect_mode then
        -- local fs=lstg.FindFiles("", "lua", arch)
        -- for _,v in pairs(fs) do
        --     local fileflag=string.find(v[1],path)
        --     local archflag=(arch==v[2])
        --     if fileflag and archflag then
                local r,err=xpcall(lstg.DoFile,debug.traceback,path,arch)
                if r then 
                    Print('成功重载脚本：'..path,2)
                    return true
                else
                    Print('重载脚本：'..path..' 的时候发生错误\n\t错误详细信息:\n\t\t'..err,1)
                    return r,err
                end
            -- else
        --         return false,'压缩包内脚本不存在'
        --     end
        -- end
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
function m.LoadMod(arch)
    local hasPassWord=string.find(arch,'pw',1,true)
    if hasPassWord then lstg.LoadPackSub(arch) else lstg.LoadPack(arch) end
    local r,err=self:DoFile("_editor_output.lua",arch)
    if r then
        self.modlist[arch]=true
    else
        self.UnloadMod(arch)
        self.modlist[arch]=false
    end
    return r,err
end
function m.UnloadMod(arch)
    UnloadPack(arch)
    self.modlist[arch]=false
end
function m.LoadAllStageMod()
    local ret={}
    local result=true
    for k,v in pairs(self.modlist) do
        if string.find(k,'STAGE',1,true)~=nil then
            local hasPassWord=string.find(k,'pw',1,true)
            if not v then 
                local r,e=self.LoadMod(v)
                table.insert(ret,{ret=r,err=e})
                result=result and r
            end
        end
    end
    return result,ret
end
m:init()