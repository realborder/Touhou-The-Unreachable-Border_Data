ph3_runtime={}

function ph3_runtime:init()
	self.scripts=[]
	
end

function ph3_runtime:frame()
	local i
	for i=1,#self.scripts do
		if script.state == 1 then
			if script.atMainLoop then script.atMainLoop() end
		end
	end
end

function ph3_runtime:loadscript()
	local new_G=[]
	for i,v in pairs(_G) do
		new_G[i]=v
	end
	for i,v in pairs(ph3) do
		new_G[i]=v
	end
	atLoading=nil
	atInitialize=nil
	atMainLoop=nil
	local script=[]
	local old_G=_G
	_G=new_G
	DoFile("dnh.lua")
	script.atLoading = atLoading
	script.atInitialize = atInitialize
	script.atMainLoop = atMainLoop
	script.atEvent = atEvent
	script.state = 0
	script.global = new_G
	_G=old_G
	local i=#self.scripts
	self.scripts[i]=script
	return i
end