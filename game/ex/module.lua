-- luastg module loader for editor

--local old={}
--old._LoadImageFromFile=_LoadImageFromFile
--old._LoadImageGroupFromFile=_LoadImageGroupFromFile

current_module_name=nil
current_module=nil
current_dir=nil

modules={}

local new={}
function new._LoadImageFromFile(teximgname,filename,mipmap,a,b,rect,edge)
	local a={}
	a.src=filename
	current_module.textures[teximgname]=a
end
function new._LoadImageFromFileE(teximgname,filename,mipmap,a,b,rect,edge)
	LoadTexture(teximgname,filename,mipmap)
	local w,h=GetTextureSize(teximgname)
	LoadImage(teximgname,teximgname,edge,edge,w-edge*2,h-edge*2,a,b,rect)
end


function LoadLuaModule(path)
	_LoadImageFromFile=new._LoadImageFromFile
	_LoadImageGroupFromFile=new._LoadImageGroupFromFile
	current_module_name=wx.wxFileName(path):GetName()
	current_module={}
	current_module.textures={}
	
	current_dir=wx.wxFileName(path):GetHomeDir()
	modules[current_module_name]=current_module
	dofile(path)
end