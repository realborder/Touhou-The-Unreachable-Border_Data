---=====================================
---luastg screen
---=====================================

----------------------------------------
---screen

---@class screen
screen={}

function ResetScreen()
	if setting.resx>setting.resy then
		screen.width=640
		screen.height=480
		screen.scale=setting.resy/screen.height
		screen.dx=(setting.resx-screen.scale*screen.width)*0.5
		screen.dy=0
		lstg.scale_3d=0.007*screen.scale
		ResetWorld()
	else
		--用于启动器
		screen.width=396
		screen.height=528
		screen.scale=setting.resx/screen.width
		screen.dx=0
		screen.dy=(setting.resy-screen.scale*screen.height)*0.5
		lstg.scale_3d=0.007*screen.scale
		lstg.world={l=-192,r=192,b=-224,t=224,boundl=-224,boundr=224,boundb=-256,boundt=256,scrl=6,scrr=390,scrb=16,scrt=464,pl=-192,pr=192,pb=-224,pt=224}
		SetBound(lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt)
	end
end

function ResetScreen2()
	if setting.resx>setting.resy then
		screen.width=640
		screen.height=480
		screen.scale=setting.resy/screen.height
		screen.dx=(setting.resx-screen.scale*screen.width)*0.5
		screen.dy=0
		lstg.scale_3d=0.007*screen.scale
	else
		--用于启动器
		screen.width=396
		screen.height=528
		screen.scale=setting.resx/screen.width
		screen.dx=0
		screen.dy=(setting.resy-screen.scale*screen.height)*0.5
		lstg.scale_3d=0.007*screen.scale
	end
end

local RAW_DEFAULT_WORLD={--默认的world参数，只读
	l=-192,r=192,b=-224,t=224,
	boundl=-224,boundr=224,boundb=-256,boundt=256,
	scrl=32,scrr=416,scrb=16,scrt=464,
	pl=-192,pr=192,pb=-224,pt=224,
	world=15,
}
local DEFAULT_WORLD={--默认的world参数，可更改
	l=-192,r=192,b=-224,t=224,
	boundl=-224,boundr=224,boundb=-256,boundt=256,
	scrl=32,scrr=416,scrb=16,scrt=464,
	pl=-192,pr=192,pb=-224,pt=224,
	world=15,
}

---用于设置默认world参数
function OriginalSetDefaultWorld(l,r,b,t,bl,br,bb,bt,sl,sr,sb,st,pl,pr,pb,pt,m)
	local w={}
	w.l=l
	w.r=r
	w.b=b
	w.t=t
	w.boundl=bl
	w.boundr=br
	w.boundb=bb
	w.boundt=bt
	w.scrl=sl
	w.scrr=sr
	w.scrb=sb
	w.scrt=st
	w.pl=pl
	w.pr=pr
	w.pb=pb
	w.pt=pt
	w.world=m
	DEFAULT_WORLD=w
end

function SetDefaultWorld(l,b,w,h,bound,m)
	OriginalSetDefaultWorld(
		--l,r,b,t,
		(-w/2),(w/2),(-h/2),(h/2),
		--bl,br,bb,bt,
		(-w/2)-bound,(w/2)+bound,(-h/2)-bound,(h/2)+bound,
		--sl,sr,sb,st,
		(l),(l+w),(b),(b+h),
		--pl,pr,pb,pt
		(-w/2),(w/2),(-h/2),(h/2),
		--world mask
		m
	)
end

---用于重置world参数
function RawGetDefaultWorld()
	local w={}
	for k,v in pairs(RAW_DEFAULT_WORLD) do
		w[k]=v
	end
	return w
end

function GetDefaultWorld()
	local w={}
	for k,v in pairs(DEFAULT_WORLD) do
		w[k]=v
	end
	return w
end

function RawResetWorld()
	local w={}
	for k,v in pairs(RAW_DEFAULT_WORLD) do
		w[k]=v
	end
	lstg.world=w
	DEFAULT_WORLD=w
	SetBound(lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt)
end

function ResetWorld()
	local w={}
	for k,v in pairs(DEFAULT_WORLD) do
		w[k]=v
	end
	lstg.world=w
	SetBound(lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt)
end

---用于设置world参数
function OriginalSetWorld(l,r,b,t,bl,br,bb,bt,sl,sr,sb,st,pl,pr,pb,pt,m)
	local w=lstg.world
	w.l=l
	w.r=r
	w.b=b
	w.t=t
	w.boundl=bl
	w.boundr=br
	w.boundb=bb
	w.boundt=bt
	w.scrl=sl
	w.scrr=sr
	w.scrb=sb
	w.scrt=st
	w.pl=pl
	w.pr=pr
	w.pb=pb
	w.pt=pt
	w.world=m
end

function SetWorld(l,b,w,h,bound,m)
	bound=bound or 32
	m = m or 15
	OriginalSetWorld(
		--l,r,b,t,
		(-w/2),(w/2),(-h/2),(h/2),
		--bl,br,bb,bt,
		(-w/2)-bound,(w/2)+bound,(-h/2)-bound,(h/2)+bound,
		--sl,sr,sb,st,
		(l),(l+w),(b),(b+h),
		--pl,pr,pb,pt
		(-w/2),(w/2),(-h/2),(h/2),
		--world mask
		m
	)
	SetBound(lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt)
end

ResetScreen()--先初始化一次，！！！注意不能漏掉这一步

----------------------------------------
---3d

lstg.view3d={
	eye={0,0,-1},
	at={0,0,0},
	up={0,1,0},
	fovy=PI_2,
	z={0,2},
	fog={0,0,Color(0x00000000)},
}

function Reset3D()
	lstg.view3d.eye={0,0,-1}
	lstg.view3d.at={0,0,0}
	lstg.view3d.up={0,1,0}
	lstg.view3d.fovy=PI_2
	lstg.view3d.z={1,2}
	lstg.view3d.fog={0,0,Color(0x00000000)}
end

function Set3D(key,a,b,c)
	if key=='fog' then
		a=tonumber(a or 0)
		b=tonumber(b or 0)
		lstg.view3d.fog={a,b,c}
		return
	end
	a=tonumber(a or 0)
	b=tonumber(b or 0)
	c=tonumber(c or 0)
	if key=='eye' then lstg.view3d.eye={a,b,c}
	elseif key=='at' then lstg.view3d.at={a,b,c}
	elseif key=='up' then lstg.view3d.up={a,b,c}
	elseif key=='fovy' then lstg.view3d.fovy=a
	elseif key=='z' then lstg.view3d.z={a,b}
	end
end

----------------------------------------
---视口、投影等的转换和坐标映射

function SetViewMode(mode)
	lstg.viewmode=mode
	--lstg.scale_3d=((((lstg.view3d.eye[1]-lstg.view3d.at[1])^2+(lstg.view3d.eye[2]-lstg.view3d.at[2])^2+(lstg.view3d.eye[3]-lstg.view3d.at[3])^2)^0.5)*2*math.tan(lstg.view3d.fovy*0.5))/(lstg.world.scrr-lstg.world.scrl)
	if mode=='3d' then
		SetViewport(lstg.world.scrl*screen.scale+screen.dx,lstg.world.scrr*screen.scale+screen.dx,lstg.world.scrb*screen.scale+screen.dy,lstg.world.scrt*screen.scale+screen.dy)
		SetPerspective(
			lstg.view3d.eye[1],lstg.view3d.eye[2],lstg.view3d.eye[3],
			lstg.view3d.at[1],lstg.view3d.at[2],lstg.view3d.at[3],
			lstg.view3d.up[1],lstg.view3d.up[2],lstg.view3d.up[3],
			lstg.view3d.fovy,(lstg.world.r-lstg.world.l)/(lstg.world.t-lstg.world.b),
			lstg.view3d.z[1],lstg.view3d.z[2]
		)
		SetFog(lstg.view3d.fog[1],lstg.view3d.fog[2],lstg.view3d.fog[3])
		SetImageScale(((((lstg.view3d.eye[1]-lstg.view3d.at[1])^2+(lstg.view3d.eye[2]-lstg.view3d.at[2])^2+(lstg.view3d.eye[3]-lstg.view3d.at[3])^2)^0.5)*2*math.tan(lstg.view3d.fovy*0.5))/(lstg.world.scrr-lstg.world.scrl))
	elseif mode=='world' then
		SetViewport(lstg.world.scrl*screen.scale+screen.dx,lstg.world.scrr*screen.scale+screen.dx,lstg.world.scrb*screen.scale+screen.dy,lstg.world.scrt*screen.scale+screen.dy)
		SetOrtho(lstg.world.l,lstg.world.r,lstg.world.b,lstg.world.t)
		SetFog()
		SetImageScale((lstg.world.r-lstg.world.l)/(lstg.world.scrr-lstg.world.scrl)/2)
	elseif mode=='ui' then
		--SetOrtho(0.5,screen.width+0.5,-0.5,screen.height-0.5)--f2d底层已经有修正
		SetOrtho(0,screen.width,0,screen.height)
		SetViewport(screen.dx,screen.width*screen.scale+screen.dx,screen.dy,screen.height*screen.scale+screen.dy)
		SetFog()
		SetImageScale(1)
	else error('Invalid arguement.') end
end

function WorldToUI(x,y)
	local w=lstg.world
	return w.scrl+(w.scrr-w.scrl)*(x-w.l)/(w.r-w.l),w.scrb+(w.scrt-w.scrb)*(y-w.b)/(w.t-w.b)
end

function WorldToScreen(x,y)
	local w=lstg.world
	if setting.resx>setting.resy then
		return (setting.resx-setting.resy*screen.width/screen.height)/2/screen.scale+w.scrl+(w.scrr-w.scrl)*(x-w.l)/(w.r-w.l),w.scrb+(w.scrt-w.scrb)*(y-w.b)/(w.t-w.b)
	else
		return w.scrl+(w.scrr-w.scrl)*(x-w.l)/(w.r-w.l),(setting.resy-setting.resx*screen.height/screen.width)/2/screen.scale+w.scrb+(w.scrt-w.scrb)*(y-w.b)/(w.t-w.b)
	end
end

function ScreenToWorld(x,y)--该功能并不完善
	local dx,dy=WorldToScreen(0,0)
	return x-dx,y-dy
end
