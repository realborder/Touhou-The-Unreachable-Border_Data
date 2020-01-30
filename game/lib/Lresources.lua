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
function UnloadTexture(tex)
	lstg.RemoveResource(lstg.CheckRes(1,tex),1,tex)
end
function UnloadImage(img)
	lstg.RemoveResource(lstg.CheckRes(2,img),2,img)
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
	lstg.RemoveResource(lstg.CheckRes(3,ani),3,ani)
end
UnloadAni=UnloadAnimation

function UnloadAniFromFile(texaniname)
	UnloadAnimation(texaniname)
	UnloadTexture(texaniname)
end
function UnloadBGM(bgm)
	lstg.RemoveResource(lstg.CheckRes(4,bgm),4,bgm)
end
UnloadMusic=UnloadBGM
function UnloadSound(sfx)
	lstg.RemoveResource(lstg.CheckRes(5,sfx),5,sfx)
end
UnloadSFX=UnloadSound
function UnloadPSI(psi)
	lstg.RemoveResource(lstg.CheckRes(6,psi),6,psi)
end
function UnloadFNT(fnt)
	lstg.RemoveResource(lstg.CheckRes(7,fnt),7,fnt)
end
function UnloadTTF(ttfname)
	lstg.RemoveResource(lstg.CheckRes(8,ttfname),8,ttfname)
end
function UnloadFX(fx)
	lstg.RemoveResource(lstg.CheckRes(9,fx),9,fx)
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
