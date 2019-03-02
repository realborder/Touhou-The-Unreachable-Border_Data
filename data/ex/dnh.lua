-- api for danmakufu ph3
ph3={}
-- Math Functions
ph3.log = math.log

local _log10 = 1/log(10)
function ph3.log10(a)
	return log(a)*_log10
end
function ph3.rand(vmin,vmax)
	return ran:Float(vmin,vmax)
end
function ph3.truncate(v)
	if v>=0 then
		return math.floor(v)
	else
		return math.ceil(v)
	end
end
ph3.ceil=math.ceil
ph3.floor=math.floor
ph3.trunc=ph3.truncate
ph3.absolute=math.abs
ph3.modc=math.mod
-- Text Functions
local ph3fontmanager={}
function ph3.InstallFont(path)
	ph3fontmanager[path]={}
end
function ph3.ToString(any)
	return ''..any
end
function ph3.IntToString(any)
	return ''..ph3.trunc(any)
end
function ph3.itoa(ivalue)
	local a=ph3.IntToString(ivalue)
	local b=[]
	local c=string.len(a)
	for i=1,c do
		b[i]=tonumber(string.sub(a,i,i))
	end
	return b
end

-- Common Data Functions

function ph3.SetCommonData(name,value)
	lstg.var[name]=value
end
function ph3.GetCommonData(name,value)
	return lstg.var[name] or value
end
-- Player Functions

-- Script Functions
function ph3.LoadScript(scriptpath)
	
end