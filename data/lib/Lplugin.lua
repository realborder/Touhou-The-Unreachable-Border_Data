---=====================================
---luastg plugin helper
---=====================================

local LOG_MODULE_NAME="[lstg][plugin]"

----------------------------------------
---插件包辅助

---@class plugin @插件包辅助
lstg.plugin={}

local PLUGIN_PATH="Library\\plugins\\"    --插件路径
local PLUGIN_PATH_1="Library\\"           --插件路径一级路径
local PLUGIN_PATH_2="Library\\plugins\\"  --插件路径二级路径
local ENTRY_POINT_SCRIPT_PATH=""          --入口点文件路径
local ENTRY_POINT_SCRIPT="__init__.lua"   --入口点文件

---罗列插件目录下所有的插件
---该方法没有对插件包合法性进行检测，即使插件中没有入口点脚本也会罗列出来
---@return table @{string, string, ... }
function lstg.plugin.ListPlugins()
	local fs=lstg.FindFiles(PLUGIN_PATH, "zip", "")
	local rs={}
	for _,v in pairs(fs) do
		local filename=string.sub(v[1],string.len(PLUGIN_PATH)+1,-5)
		table.insert(rs,filename)
	end
	return rs
end

---检查一个已加载的插件包是否合法（有入口点文件）
---@param pluginpath string @插件包路径
---@return boolean
function lstg.plugin.CheckValidity(pluginpath)
	local fs=lstg.FindFiles("", "lua", pluginpath)
	for _,v in pairs(fs) do
		local filename=string.sub(v[1],string.len(ENTRY_POINT_SCRIPT_PATH)+1,-1)
		if filename==ENTRY_POINT_SCRIPT then
			return true
		end
	end
	lstg.Log(3,LOG_MODULE_NAME,"插件\""..pluginpath.."\"不是有效的插件，没有入口点文件\""..ENTRY_POINT_SCRIPT.."\"")
	return false
end

---检查一个插件包是否合法（有入口点文件）
---该函数会装载插件包，然后进行检查，如果不是合法的插件包，将会卸载掉
---@param pluginpath string @插件包路径
---@return boolean
function lstg.plugin.LoadAndCheckValidity(pluginpath)
	lstg.LoadPack(pluginpath)
	local fs=lstg.FindFiles("", "lua", pluginpath)
	for _,v in pairs(fs) do
		local filename=string.sub(v[1],string.len(ENTRY_POINT_SCRIPT_PATH)+1,-1)
		if filename==ENTRY_POINT_SCRIPT then
			return true
		end
	end
	lstg.UnloadPack(pluginpath)
	lstg.Log(4,LOG_MODULE_NAME,"插件\""..pluginpath.."\"不是有效的插件，没有入口点文件\""..ENTRY_POINT_SCRIPT.."\"")
	return false
end

---装载一个插件包，然后执行入口点脚本
---失败则返回false
---@param pluginpath string @插件包路径
---@return boolean
function lstg.plugin.LoadPlugin(pluginpath)
	local ret=lstg.plugin.LoadAndCheckValidity(pluginpath)
	if ret then
		lstg.DoFile(ENTRY_POINT_SCRIPT, pluginpath)
	end
	return ret
end

---根据一个列表，按照顺序加载插件
---列表的形式如下：{string, string, ... }
---每一个单位为一段字符串，为插件的文件名（不带后缀）
---@param list table @{string, string, ... }
function lstg.plugin.LoadPluginsByList(list)
	for _,v in ipairs(list) do
		local pluginpath=PLUGIN_PATH..v..".zip"
		local ret=lstg.plugin.LoadAndCheckValidity(pluginpath)
		if ret then
			lstg.DoFile(ENTRY_POINT_SCRIPT, pluginpath)
		end
	end
end

----------------------------------------
---配置文件存储

local CONFIG_FILE="PluginConfig"

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

---检查目录是否存在，不存在则创建
local function check_directory()
	if not plus.DirectoryExists(PLUGIN_PATH_1) then
		plus.CreateDirectory(PLUGIN_PATH_1)
	end
	if not plus.DirectoryExists(PLUGIN_PATH_2) then
		plus.CreateDirectory(PLUGIN_PATH_2)
	end
end

---加载配置文件
---@return table @{{PluginName,PluginPath,Enable}, ... }
function lstg.plugin.LoadConfig()
	check_directory()
	local f,msg
	f,msg=io.open(PLUGIN_PATH..CONFIG_FILE,"r")
	if f==nil then
		return {}
	else
		local ret=cjson.decode(f:read('*a'))
		f:close()
		return ret
	end
end

---保存配置文件
---@param cfg table @{{PluginName,PluginPath,Enable}, ... }
function lstg.plugin.SaveConfig(cfg)
	check_directory()
	local f,msg
	f,msg=io.open(PLUGIN_PATH..CONFIG_FILE,"w")
	if f==nil then
		error(msg)
	else
		f:write(format_json(cjson.encode(cfg)))
		f:close()
	end
end

---遍历插件目录下所有的插件，来获得一个配置表
---如果传入了一个配置表，则对传入的配置表进行刷新
---该方法没有对插件包合法性进行检测，即使插件中没有入口点脚本也会罗列出来
---@param cfg table @{{PluginName,PluginPath,Enable}, ... }
---@return table @{string, string, ... }
function lstg.plugin.FreshConfig(cfg)
	local fs=lstg.FindFiles(PLUGIN_PATH, "zip", "")
	local rs={}
	for _,v in pairs(fs) do
		local filename=string.sub(v[1],string.len(PLUGIN_PATH)+1,-5)
		table.insert(rs,{filename,v[1],false})
	end
	if type(cfg)=="table" then
		local ret={}
		--读取已有的配置表的enable属性
		--同时去除无效的插件
		for _,i in ipairs(cfg) do
			for _,v in ipairs(rs) do
				if v[1]==i[1] and v[2]==i[2] then
					v[3]=i[3]
					table.insert(ret,v)
					break
				end
			end
		end
		local oldn=#ret
		--将新增的插件排在后面
		for _,v in ipairs(rs) do
			local flag=true
			--查重，如果重复跳过
			for i=1,oldn do
				if v[1]==ret[i][1] and v[2]==ret[i][2] then
					flag=false
					break
				end
			end
			if flag then
				table.insert(ret,v)
			end
		end
		return ret
	else
		return rs
	end
end

---根据一个配置表，按照顺序加载插件
---@param cfg table @{{PluginName,PluginPath,Enable}, ... }
function lstg.plugin.LoadPluginsByConfig(cfg)
	for _,v in ipairs(cfg) do
		--跳过禁用的插件
		if v[3] then
			local pluginpath=v[2]
			local ret=lstg.plugin.LoadAndCheckValidity(pluginpath)
			if ret then
				lstg.DoFile(ENTRY_POINT_SCRIPT, pluginpath)
			end
		end
	end
end

----------------------------------------
---接口

---加载所有插件包
function lstg.plugin.LoadPlugins()
	local cfg=lstg.plugin.LoadConfig()
	local tcfg=lstg.plugin.FreshConfig(cfg)
	lstg.plugin.SaveConfig(tcfg)
	lstg.plugin.LoadPluginsByConfig(tcfg)
end
