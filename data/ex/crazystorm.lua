-- crazystorm
crazystorm = {}
crazystorm.debug={0,0,0,0,0,0}
crazystorm.name_condition = {
	'当前帧','X坐标','Y坐标','半径','半径方向','条数','周期','角度','范围','宽比','高比','不透明度','朝向'
}
crazystorm.name_result = {
	'X坐标','Y坐标','半径','半径方向','条数','周期','角度','范围','宽比','高比','不透明度','朝向',
	'速度','速度方向','加速度','加速度方向','生命','类型','R','G','B','子弹速度','子弹速度方向','子弹加速度','子弹加速度方向',
	'横比','纵比','雾化效果','消除效果','高光效果','拖影效果','出屏即消','无敌状态'
}
local _log=Print
crazystorm.name_bullet_shooter = {
'ID',--0
'层ID',--1
'绑定状态',--2
'绑定ID',--3
'相对方向',--4
'（已弃用）',--5
'位置X坐标',--6
'位置Y坐标',--7
'初始',--8
'持续',--9
'发射X坐标',--10
'发射Y坐标',--11
'半径',--12
'半径方向',--13
'半径方向（坐标指定）',--14
'条数',--15
'周期',--16
'发射角度',--17
'发射角度（坐标指定）',--18
'范围',--19
'速度',--20
'速度方向',--21
'速度方向（坐标指定）',--22
'加速度',--23
'加速度方向',--24
'加速度方向（坐标指定）',--25
'子弹生命',--26
'类型',--27
'宽比',--28
'高比',--29
'R',--30
'G',--31
'B',--32
'不透明度',--33
'朝向',--34
'朝向（坐标指定）',--35
'朝向与速度方向相同',--36
'子弹速度',--37
'子弹速度方向',--38
'子弹速度方向（坐标指定）',--39
'子弹加速度',--40
'子弹加速度方向',--41
'子弹加速度方向（坐标指定）',--42
'横比',--43
'纵比',--44
'雾化效果',--45
'消除效果',--46
'高光效果',--47
'拖影效果',--48
'出屏即消',--49
'无敌状态',--50
'发射器事件组',--51
'子弹事件组',--52
'X坐标随机+量',--53
'Y坐标随机+量',--54
'半径随机+量',--55
'半径方向随机+量',--56
'条数随机+量',--57
'周期随机+量',--58
'角度随机+量',--59
'范围随机+量',--60
'速度随机+量',--61
'速度方向随机+量',--62
'加速度随机+量',--63
'加速度方向随机+量',--64
'朝向随机+量',--65
'子弹速度随机+量',--66
'子弹速度方向随机+量',--67
'子弹加速度随机+量',--68
'子弹加速度方向随机+量',--69
'未知1',--70
'未知2',--71
'未知3'--72
}

function crazystorm.LoadFile(filename)
	_log('Load file ',filename)
	local file=io.open(filename,'r')
	local l={}
	local t=1
	while true do
		local s=file:read()
		if s~=nil then
			l[t]=s
			_log(s)
			t=t+1
		else
			break
		end
	end
	io.close(file)
	return l
end

local function split2( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
		table.insert(resultStrList,w)
    end)
    return resultStrList
end

local function split(input, delimiter)
    --input = tostring(input)
    --delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

local function parseCSValue(str)
	if str=='False' then
		return false
	elseif str=='True' then
		return true
	elseif str=='' then
		return nil	
	else
		local k=string.sub(str,1,1)
		if k=='{' then
			k=string.sub(str,2,string.len(str)-1)
			k=split(k,' ')
			local n=#k
			local a={}
			for i=1,n do
				local k2=split(k[i],':')
				a[k2[1]]=parseCSValue(k2[2])
			end
			return a
		end
		k=tonumber(str)
		if k~=nil and ''..k==str then
			return k
		end
		if k~=nil and k~=math.floor(k) then
			return k2
		end
		return str
	end
	return str
end

function crazystorm.Make(stringlist)
	local a={}
	a.Version=stringlist[1]--Crazy Storm Data 1.01
	a.Objects={}
	local current_layer=0
	for i=2,#stringlist do
		local s=stringlist[i]
		local head=string.match(s,'%a+')
		_log(s,head)
		if head=='Center' then
			local p=split(s,':')
			_log('Center',p[2])
			local k=split(p[2],',')
			local b={}
			for j=1,6 do
				b[j]=tonumber(k[j])
			end
			a.Center=b
		elseif head=='Totalframe' then
			local p=split(s,':')
			a.Totalframe=tonumber(p[2])
		elseif head=='Layer' then
			local p=split(s,':')
			local k=split(p[2],',')
			local b={}
			b[1]=k[1]
			for j=2,8 do
				b[j]=tonumber(k[j])
			end
			a.Layer=b
			p[1]=string.gsub(p[1],'Layer','',1)
			b.id=tonumber(p[1])
			current_layer=b.id
		else
			local k=split(s,',')
			local n=#k
			Print(n,s)
			local b={}
			if n>=70 then --shooter
				b.type='shooter'
				for j=1,70 do
					b[crazystorm.name_bullet_shooter[j]]=parseCSValue(k[j])
					Print(crazystorm.name_bullet_shooter[j]..'=',b[crazystorm.name_bullet_shooter[j]])
				end
				if b['发射器事件组']~=nil then
					local s=b['发射器事件组']
					local ss=split(s,'&')
					local evts={}
					for ii=1,#ss-1 do
						local ss1=ss[1]
						local acttemplate=crazystorm.ParseActionGroup(ss1)
						crazystorm.CompileShootEvent(acttemplate)
						Print(ss1)
						Print('\n'..acttemplate[5])
						crazystorm.LinkShootEvent(acttemplate)
						evts[ii]=acttemplate
					end
					b['发射器事件组']=evts
				end
				a.Objects[b['ID']]=b
			end
			
		end
	end
	return a
end

--'新事件组|2|0|当前帧>1：角度增加750，正比，20000帧;&'

function crazystorm._ParseCondition(str,cond,i)
	local s
	_log('ParseCondition ',str)
	if string.find(str,'>') then
		s=split(str,'>')
		cond[i]=s[1]
		cond[i+1]='>'
		cond[i+2]=tonumber(s[2])
	elseif string.find(str,'<') then
		s=split(str,'<')
		cond[i]=s[1]
		cond[i+1]='<'
		cond[i+2]=tonumber(s[2])
	elseif string.find(str,'=') then
		s=split(str,'=')
		cond[i]=s[1]
		cond[i+1]='=='
		cond[i+2]=tonumber(s[2])
	end
end


function crazystorm.ParseActionGroup(str)
	local rt1={}
	_log('Parse split | ',str)
	local a0=split(str,'|')
	rt1[1]=a0[1]
	rt1[2]=tonumber(a0[2])
	rt1[3]=tonumber(a0[3])
	local rt={}
	rt1[4]=rt
	a0=a0[4]
	_log('Parse split ; ',a0)
	a0=split(a0,';')
	if a0[#a0]=='' then a0[#a0]=nil end
	for i=1,#a0 do
		local a1=a0[i]
		local rt1={}
		a1=split(a1,'：')
		local cond=a1[1]
		local cond1={}
		if string.find(cond,'且') then
			cond1[4]='and'
			_log('And ',cond)
			cond=split(cond,'且')
			crazystorm._ParseCondition(cond[1],cond1,1)
			crazystorm._ParseCondition(cond[2],cond1,5)
		elseif string.find(cond,'或') then
			cond1[4]='or'
			_log('Or ',cond)
			cond=split(cond,'或')
			crazystorm._ParseCondition(cond[1],cond1,1)
			crazystorm._ParseCondition(cond[2],cond1,5)
		else
			crazystorm._ParseCondition(cond,cond1,1)
		end
		cond=a1[2]
		rt1[1]=cond1
		rt1[2]=crazystorm.ParseShootAction(cond)
		
		rt[i]=rt1
	end	
	return rt1
end

--角度增加750，正比，20000帧
function crazystorm.ParseShootAction(str)
	local a=split(str,'，')
	local b=a[1]
	local c={}
	local rt={}
	if string.find(b, '增加') then
		c=split(b,'增加')
		rt[2]=0
	elseif string.find(b, '减少') then
		c=split(b,'减少')
		rt[2]=1
	elseif string.find(b, '变化到') then
		c=split(b,'变化到')
		rt[2]=2
	end
	rt[1]=c[1]
	rt[3]=tonumber(c[2])
	if a[2]=='正比' then
	rt[4]=0
	end
	local aa=split(a[3],'帧')
	rt[5]=tonumber(aa[1])
	return rt
end

--'新事件组|2|0|当前帧>1：角度增加750，正比，20000帧;&'
--{新事件组,2,0,{{{当前帧,>,1},{角度,0,750,0,20000}},...}}

function crazystorm._SampleShootAction(obj,act,f,evt) --evt.func
	local frame=f-act.frame
	if frame>evt[2] then
		act[1]=act[1]+evt[3]
	end
	if frame>1 then
		--act[1]
		local constfunc=function()
			ex.SmoothSetValueToEx(evt[4][2][1],evt[4][2][3],evt[4][2][5],evt[4][2][4],nil,0,evt[4][2][2])
		end
		task.New(self,constfunc)
	end
end

--test=loadstring('return function(a) return a+1 end')()
--crazystorm.debug[3]=test(1)

function crazystorm.CompileShootEvent(evt)
	local s1='return function(self,act,f)\n'
	local s2='local frame=f-act.frame\n'
	local s3='if frame>'..evt[2]..' then act.frame=act.frame+'..evt[3]..' end\n'
	if evt[3]==0 then s3='' s2='local frame=f\n' end
	local s={}
	local ss=s1..s2..s3
	for i=1,#evt[4] do
		local evt1=evt[4][i][1]--{当前帧,>,1}
		local evt2=evt[4][i][2]--{角度,0,750,0,20000}
		local cond11=''
		if evt1[1]=='当前帧' then cond11='frame' else cond11='self['..evt1[1]..']' end
		local c1=cond11..evt1[2]..evt1[3]
		if evt1[4]~=nil then
			if evt1[5]=='当前帧' then cond11='frame' else cond11='self['..evt1[5]..']' end
			c1=c1..' '..evt[4]..' '..cond11..evt1[5]..evt1[6]
		end
		s[i]='if '..c1..' then task.New(self,act['..i..']) end\n'
		
		--compile act[2]
		local fs1=evt2[1]
		local fs2=evt2[3]
		local fs3=evt2[5]
		local fs4='MOVE_NORMAL'
		if evt2[4]==0 then
			fs4='MOVE_NORMAL'
		end
		local fs5='MODE_ADD'
		if evt2[2]==0 then
			fs5='MODE_ADD'
		elseif evt2[2]==1 then
			fs5='MODE_ADD'
			fs2='-'..fs2
		elseif evt2[2]==2 then
			fs5='MODE_SET'
		end
		
		if fs1=='角度' then fs1='发射角度' end
		
		local fs='return function()	ex.SmoothSetValueToEx("'..fs1..'",'..fs2..','..fs3..','..fs4..',nil,0,'..fs5..')'
		evt[4][i][3]=fs..'end'
		ss=ss..s[i]
	end	
	evt[5]=ss..'end'
end

function crazystorm.LinkShootEvent(evt)
	evt.func=loadstring(evt[5])()
	for i=1,#evt[4] do
		_log('\n'..evt[4][i][3])
		evt[4][i].func=loadstring(evt[4][i][3])()
	end	
end

function crazystorm.NewShootEvent(evt)
	local a={}
	a.func=evt.func
	a.frame=0
	for i=1,#evt[4] do
		a[i]=evt[4][i].func
	end	
	return a
end

--[[
	action data
	func ..func
	frame frame
	1 act1_func
	2 act1_func
	..
]]--


function crazystorm:GetPositionX(x,obj)
	if x==-99998 then
		return self['位置X坐标']
	elseif x==-99999 then
		return player.x
	elseif x==-100000 then
		return obj.X
	end
	return x
end
function crazystorm:GetPositionY(x,obj)
	if x==-99998 then
		return self['位置Y坐标']
	elseif x==-99999 then
		return player.y
	elseif x==-100000 then
		return obj.Y
	end
	return x
end
function crazystorm:TransLUAtoCS(x,y)
	return x+self.centerx,self.centery-y
end
function crazystorm.TransAngle(a)
	return -a
end
function crazystorm:TransCStoLUA(x,y)
	return x-self.centerx,self.centery-y
end
function crazystorm:GetAngle(a,obj,x,y)
	if a==-99998 then
		return self.rot
	elseif a==-99999 then
		local x1,y1=crazystorm.TransLUAtoCS(self,player.x,player.y)
		return atan2(y1-y,x1-x)
	elseif x==-100000 then
		return atan2(obj.Y-y,obj.X-x)
	end
	return a
end

crazystorm.file=Class(object)
function crazystorm.file:init(template)
	--self.layer=LAYER_ENEMY
	self.group=GROUP_GHOST
	self.Totalframe=template.Totalframe
	self.Totalframe=60000
	self.Center=template.Center
end
function crazystorm.file:frame()
	--task.Do(self)
	crazystorm.debug[4]=self.Totalframe 
	crazystorm.debug[5]=self.timer
	if self.timer>self.Totalframe then
	
		Del(self)
	end	
end
function crazystorm.file:render()
	local y=340
	SetViewMode'ui'
	SetImageState('white','',Color(0xFF000000))
	RenderRect('white',424,632,256,464)
	RenderTTF('sc_pr','crazystorm debugger',528,528,y+4.5*ui.menu.sc_pr_line_height,y+4.5*ui.menu.sc_pr_line_height,Color(255,unpack(ui.menu.title_color)),'centerpoint')
	--ui.DrawMenuTTF('sc_pr','',self.text,self.pos,432,y,1,self.timer,self.pos_changed,'left')
	--local _a,_r,_g,_b=lstg.view3d.fog[3]:ARGB()
	ui.DrawMenuTTF('sc_pr','',{
		_str(crazystorm.debug[1]),
		_str(crazystorm.debug[2]),
		_str(crazystorm.debug[3]),
		_str(crazystorm.debug[4]),
		_str(crazystorm.debug[5]),
		_str(crazystorm.debug[6]),
	},self.pos,496,y,1,self.timer,self.pos_changed,'right')
	SetViewMode'world'
end

crazystorm.shooter=Class(object)
function crazystorm.shooter:init(template,file)
	self.layer=LAYER_ENEMY
	self.group=GROUP_GHOST
	self.file=file
	self.centerx=file.Center[1]
	self.centery=file.Center[2]
	for j=1,70 do
		self[crazystorm.name_bullet_shooter[j]]=template[crazystorm.name_bullet_shooter[j]]
	end
	--local x,y=crazystorm.TransCStoLUA(self,0,0)
	self.x=0
	self.y=0
	self.bound=false
	self.img='leaf'
	if self['发射器事件组'] then
		local s=self['发射器事件组']
		self['发射器事件组']={}
		for i=1,#s do
			self['发射器事件组'][i]=crazystorm.NewShootEvent(s[i])
		end
	end
end
function crazystorm.shooter:frame()
	if not IsValid(self.file) then
		Del(self)
		return
	end
	local t=self.file.timer
	if t<self['初始'] or t>=self['初始']+self['持续'] then
		return
	end
	self.timer=t-self['初始']+1	
	
	--event dispacher
	if self['发射器事件组'] then
		local s=self['发射器事件组']
		crazystorm.debug[2]=#s
		for i=1,#s do
			self['发射器事件组'][i].func(self,self['发射器事件组'][i],self.timer)
		end
	end
	
	task.Do(self)
	
	crazystorm.debug[6]=self.timer

	if (self.timer-1)%self['周期']==0 then
		crazystorm.shooter.do_shoot(self)
	end	
end
function crazystorm.ranf(v)
	return ran:Float(-v,v)
end
function crazystorm.rani(v)
	return ran:Int(-v,v)
end

function crazystorm.shooter:do_shoot()
	--local x,y=crazystorm.TransLUAtoCS(self,self.x,self.y)
	local x,y=self.x,self.y
	x=x+crazystorm.GetPositionX(self,self['发射X坐标'])
	y=y+crazystorm.GetPositionY(self,self['发射Y坐标'])
	x=x+crazystorm.ranf(self['Y坐标随机+量'])
	y=y+crazystorm.ranf(self['Y坐标随机+量'])
	local ra=crazystorm.GetAngle(self,self['半径方向'],self['半径方向（坐标指定）'],x,y)+crazystorm.ranf(self['半径方向随机+量'])
	local r=self['半径']+crazystorm.ranf(self['半径随机+量'])
	local w=self['条数']+crazystorm.rani(self['条数随机+量'])
	local spread=self['范围']+crazystorm.rani(self['范围随机+量'])
	
	local w0=spread/w
	local w1=w0/2
	local w2=spread/2
	local x0=r*cos(ra)+x
	local y0=r*sin(ra)+y
	
	local a=crazystorm.GetAngle(self,self['发射角度'],self['发射角度（坐标指定）'],x0,y0)
	a=a+crazystorm.ranf(self['角度随机+量'])

	local s=self['子弹速度']+crazystorm.rani(self['子弹速度随机+量'])

	for i=1,w do
		local rw=i*w0-w2-w1
		local ra0=rw+ra
		x0=r*cos(ra0)+x
		y0=r*sin(ra0)+y
		local a0=a+rw
		local x1,y1=crazystorm.TransCStoLUA(self,x0,y0)
		local a1=crazystorm.TransAngle(a0)--+crazystorm.ranf(self['角度随机+量'])
		New(_straight,grain_a,1,x1,y1,s,a1,false,0,true,true,0,false,0,0,0,false)
	end	
end