function clone(tab)
	local ins={}
	for key,var in pairs(tab) do
		ins[key]=var
	end
	return ins
end

keyFrame={
	img='',
	x=0,
	y=0,
	cx=0,
	cy=0,
	rot=0,
	vs=1,
	hs=1,
	a=255,
	frame_at=0,
	blend='',
	frame_type=0
}
keyFrame.new=function()
	local self=clone(keyFrame)
	return self
end
keyFrame.copy=function(tab)
	local ins={}
	ins.img=tab.img
	ins.x=tab.x
	ins.y=tab.y
	ins.cx=tab.cx
	ins.cy=tab.cy
	ins.rot=tab.rot
	ins.vs=tab.vs
	ins.hs=tab.hs
	ins.a=tab.a
	ins.frame_at=tab.frame_at
	ins.blend=tab.blend
	ins.frame_type=tab.frame_type
	return ins
end

layers=Class(object)
function layers:init(list)
	self.Prio=list[1]
	self.renderFlag=list[2]
	self.keyFrames={}
	for k,v in pairs(list[3]) do
		local t=keyFrame.copy(v)
		table.insert(self.keyFrames,t)
	end
end
function layers:render()
	if self.renderFlag then
		
	end
end
function layers:frame()
	if self.timer==self.Prio*4 then
		Print(self.Prio)
		Print(self.renderFlag)
		for k,v in pairs(self.keyFrames) do
			PrintSimpleTable(v)
		end
	end
end
function layers:save()
	local t={}
	table.insert(t,self.Prio)
	table.insert(t,self.renderFlag)
	table.insert(t,self.keyFrames)
	return t
end

exani=Class(object)
function exani:init(dir)
	self.name=dir
	self.path="Thlib\\exani\\exani_data\\"..dir.."\\"
	self.Prio_in_dev=0
	self.mode=''
	self.coor_3d={}
	self.layerList=lstg.LoadExaniConfig(self.path)
	self.picList={}
	self.imgList={}
	for k,v in pairs(self.layerList) do
		table.insert(self.picList,New(layers,v))
	end
	table.sort(self.picList,function(a,b) return a.Prio<b.Prio end)
	--exani.save(self)
	exani.LoadImgSources(self)
	PrintSimpleTable(self.imgList) --测试用
end
function exani:save()
	local tab={}
	for k,v in pairs(self.picList) do
		table.insert(tab,layers.save(v))
	end
	lstg.SaveExaniConfig(tab,self.path)
end
function exani:LoadImgSources()
	local pngs=lstg.FindFiles(self.path,"png","")
	for k,v in pairs(pngs) do
		local imgname=string.sub(v[1],string.len(self.path)+1,-5)
		--Print(imgname)  --测试用
		table.insert(self.imgList,string.sub(v[1],string.len(self.path)+1,-1))
		LoadImageFromFile(imgname,v[1])
	end
	local jpgs=lstg.FindFiles(self.path,"jpg","")
	for k,v in pairs(jpgs) do
		local imgname=string.sub(v[1],string.len(self.path)+1,-5)
		--Print(imgname)  --测试用
		table.insert(self.imgList,string.sub(v[1],string.len(self.path)+1,-1))
		LoadImageFromFile(imgname,v[1])
	end
end