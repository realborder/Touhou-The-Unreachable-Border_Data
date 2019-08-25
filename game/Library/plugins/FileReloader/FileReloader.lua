------------------------------------------------

--F10重载指定文件

local KeyDown121
FileReloader = {}
local PATH='Library\\plugins\\filereloadlist.lua'
function FileReloader.init()
    KeyDown121 = false
	Print('[FileReloader]初始化完毕')
end
function FileReloader.frame()
    if lstg.GetKeyState(121) then
        if not KeyDown121 then
            KeyDown121 = true
			Print('[FileReloader]尝试重载脚本')
			-- if not lfs.attributes(PATH)==nil then 
				FileReloader.list=lstg.DoFile(PATH) 
				for k,v in pairs(FileReloader.list) do
					-- if not lfs.attributes(v)== nil then 
						Print('[FileReloader]重载脚本：'..v)
						lstg.DoFile(v)
					-- end				
				end
				InitAllClass()
			-- end
        end
    else
        KeyDown121 = false
    end
end

FileReloader.init()