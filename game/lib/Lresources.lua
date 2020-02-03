---=====================================
---luastg resources
---=====================================

----------------------------------------
---脚本载入

lstg.included={}
lstg.current_script_path={''}

function Include(filename)
	filename=tostring(filename)
	if string.sub(filename,1,1)=='~' then
		filename=lstg.current_script_path[#lstg.current_script_path]..string.sub(filename,2)
	end
	if not lstg.included[filename] then
		local i,j=string.find(filename,'^.+[\\/]+')
		if i then
			table.insert(lstg.current_script_path,string.sub(filename,i,j))
		else
			table.insert(lstg.current_script_path,'')
		end
		lstg.included[filename]=true
		lstg.DoFile(filename)
		lstg.current_script_path[#lstg.current_script_path]=nil
	end
end

----------------------------------------
---资源载入

ImageList = {}
ImageSize = {}--由OLC添加，用于储存加载的图片的大小
OriginalLoadImage = LoadImage

function LoadImage(img,...)
	local arg = {...}
	ImageList[img] = arg
	ImageSize[img] = {arg[4],arg[5]}--由OLC添加，储存加载的图片的大小
	OriginalLoadImage(img,...)
end

---由OLC添加，获得加载的图片的大小
function GetImageSize(img) return unpack(ImageSize[img]) end

function CopyImage(newname,img)
	if ImageList[img] then
		LoadImage(newname,unpack(ImageList[img]))
	elseif img then
		error("The image \""..img.."\" can't be copied.")
	else
		error("Wrong argument #2 (expect string get nil)")
	end
end

function LoadImageGroup(prefix,texname,x,y,w,h,cols,rows,a,b,rect)
	for i=0,cols*rows-1 do
		LoadImage(prefix..(i+1),texname,x+w*(i%cols),y+h*(int(i/cols)),w,h,a or 0,b or 0,rect or false)
	end
end

function LoadImageFromFile(teximgname,filename,mipmap,a,b,rect)
	LoadTexture(teximgname,filename,mipmap)
	local w,h=GetTextureSize(teximgname)
	LoadImage(teximgname,teximgname,0,0,w,h,a or 0,b or 0,rect)
end

function LoadAniFromFile(texaniname,filename,mipmap,n,m,intv,a,b,rect)
	LoadTexture(texaniname,filename,mipmap)
	local w,h=GetTextureSize(texaniname)
	LoadAnimation(texaniname,texaniname,0,0,w/n,h/m,n,m,intv,a,b,rect)
end

function LoadImageGroupFromFile(texaniname,filename,mipmap,n,m,a,b,rect)
	LoadTexture(texaniname,filename,mipmap)
	local w,h=GetTextureSize(texaniname)
	LoadImageGroup(texaniname,texaniname,0,0,w/n,h/m,n,m,a,b,rect)
end

function LoadTTF(ttfname,filename,size) lstg.LoadTTF(ttfname,filename,0,size) end

--资源卸载 由云绝添加
local pool --用于记录资源池参数，复用变量以节省性能
function UnloadTexture(tex)
	pool=lstg.CheckRes(1,tex)
	if pool then
		lstg.RemoveResource(pool,1,tex)
	end
end
function UnloadImage(img)
	pool=lstg.CheckRes(2,tex)
	if pool then
		lstg.RemoveResource(pool,2,img)
	end
	ImageList[img] = nil
end

function UnloadImageGroup(imgprefix,n)
	for i=1,n do
		UnloadImage(imgprefix..i)
	end
end
function UnloadImageFromFile(teximgname)
	UnloadImage(teximgname)
	UnloadTexture(teximgname)
end
function UnloadImageGroupFromFile(teximgname,n)
	UnloadImageGroup(teximgname,n)
	UnloadTexture(teximgname)
end
function UnloadAnimation(ani)
	pool=lstg.CheckRes(3,tex)
	if pool then
		lstg.RemoveResource(pool,3,ani)
	end
end
UnloadAni=UnloadAnimation

function UnloadAniFromFile(texaniname)
	UnloadAnimation(texaniname)
	UnloadTexture(texaniname)
end
function UnloadBGM(bgm)
	pool=lstg.CheckRes(4,tex)
	if pool then
		lstg.RemoveResource(pool,4,bgm)

	end
end
UnloadMusic=UnloadBGM
function UnloadSound(sfx)
	pool=lstg.CheckRes(5,tex)
	if pool then
		lstg.RemoveResource(pool,5,sfx)
	end
end
UnloadSFX=UnloadSound
function UnloadPSI(psi)
	pool=lstg.CheckRes(6,tex)
	if pool then
		lstg.RemoveResource(pool,6,psi)
	end
end
function UnloadFNT(fnt)
	pool=lstg.CheckRes(7,tex)
	if pool then
		lstg.RemoveResource(pool,7,fnt)
	end
end
function UnloadTTF(ttfname)
	pool=lstg.CheckRes(8,tex)
	if pool then
		lstg.RemoveResource(pool,8,ttfname)
	end
end
function UnloadFX(fx)
	pool=lstg.CheckRes(9,tex)
	if pool then
		lstg.RemoveResource(pool,9,fx)
	end
end

----------------------------------------
---资源判断和枚举

ENUM_RES_TYPE={tex=1,img=2,ani=3,bgm=4,snd=5,psi=6,fnt=7,ttf=8,fx=9}

function CheckRes(typename,resname)
	local t=ENUM_RES_TYPE[typename]
	if t==nil then error('Invalid resource type name.')
	else return lstg.CheckRes(t,resname) end
end

function EnumRes(typename)
	local t=ENUM_RES_TYPE[typename]
	if t==nil then
		error('Invalid resource type name.')
	else
		return lstg.EnumRes(t)
	end
end
--TODO: lfs对压缩包无效，记得之后改成 lstg file manager 的实现
function FileExist(filename) return not (lfs.attributes(filename)==nil) end
