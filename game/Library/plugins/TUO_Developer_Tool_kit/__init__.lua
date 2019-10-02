local PATH_HEAD='Library\\plugins\\TUO_Developer_Tool_kit\\'
local IncludePlus=function(path)
    if lfs.attributes(path) == nil then
        path=PATH_HEAD..path
    end 
    Include(path)
end

IncludePlus"LinputEX.lua"
IncludePlus'TUO_Dev_Tool_kit.lua'
