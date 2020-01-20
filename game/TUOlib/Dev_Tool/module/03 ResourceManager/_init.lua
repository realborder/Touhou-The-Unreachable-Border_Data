local ResourceManager=TUO_Developer_UI:NewModule()

function ResourceManager:init()
	self.name='游戏资源管理'
	
end

local scrp=TUO_Developer_UI:NewPanel()
function scrp:init()
	self.name='[0]脚本'
	local list
	local search=''
	Neww'title'.text='已加载的脚本'
	Neww'text_displayer'.text= '这个列表显示了已经载入的脚本。\n重载游戏会把游戏整个重载掉。\nsave和load按钮可以保存和载入您的选区信息。(没有实装）'
	list=Neww'list_box'
	list.monitoring_value=lstg.included
	list.monitoring_value=function()
		local t1=lstg.included
		local out={}
		for k,v in pairs(t1) do
			if search=='' or search==nil then
				table.insert(out,{name=k,v=v})
			else
				if string.find(k,search)~=nil then
					table.insert(out,{name=k,v=v})
				end
			end
		end
		return out
	end

	TUO_Developer_UI.SetWidgetSlot'slot2'
	Neww'title'.text='操作'
	local btn1=Neww'button'
	btn1.text='重载 (F10)'
	local func=function(widget)  
		local dis=list.display_value
		local v_tmp={}
		for i,v in pairs(dis) do
			if list.selection[i] then 
				table.insert(v_tmp,v.name) 
			end
			
		end
		local r=TUO_Developer_Tool_kit.ReloadFiles(v_tmp)
		InitAllClass()
		return r
	end
	btn1._event_mouseclick=func
	TUO_Developer_Tool_kit.ReloadSelectedFile=func
	local sw1=Neww'switch'
	sw1.text_on='实时重载 开启'
	sw1.text_off='实时重载 关闭'
	sw1.frame=function(widget)
		if widget.flag then
			local ret=func()
			if not ret then
				widget.flag=false
			end
		end
	end

	local totop=Neww'button'
	totop.text='回到顶部'
	totop.gap_t=10
	totop._event_mouseclick=function(self) preview.y_offset_aim=0 end

	local btn2=Neww'button'
	btn2.text='反转'
	btn2._event_mouseclick=function(widget)  
		local dis=list.display_value
		local v_tmp={}
		for i,v in pairs(dis) do
			if list.selection[i] then 
				lstg.included[v.name]=not lstg.included[v.name]
			end
		end
	end
	-- local btn3=Neww'button'
	-- btn3.text='重载游戏'
	-- btn3._event_mouseclick=function(widget) 
		-- ResetPool()
		-- lstg.included={}
		-- stage.Set('none', 'init') 
		-- lstg.DoFile('core.lua')
	-- end
	local btn4=Neww'button'
	btn4.text='全选'
	btn4._event_mouseclick=function(widget) 
		list.selection={}
		for i=1,#(list.display_value) do
			list.selection[i]=true
		end
	end
	local btn5=Neww'button'
	btn5.text='全不选'
	btn5._event_mouseclick=function(widget) 
		list.selection={}
	end
	
	local txt2=Neww'text_displayer'
	txt2.text='输入文字以筛选'
	txt2.gap_t=12
	local txt=Neww'inputer'
	txt.text=''
	txt.width=120
	txt._event_textchange=function(self)
		search=self.text
	end
	local btnclr=Neww'button'
	btnclr.text='清除'
	btnclr.width=64
	btnclr._event_mouseclick=function(self)
		txt.text=''
		search=nil
	end

end


local res_type_t={"[1]纹理","[2]图像","[3]动画","[4]音乐","[5]音效","[6]粒子","[7]纹理字体","[8]TTF字体","[9]shader"}
local preview_widgets={}
local preview_frame={}
local st={}

preview_widgets[4]=function(self) --[4]音乐
	
	self.play_process=0
	self.play_state=0
	self.last_time=os.clock()
	self.play_length=1
	self.play_period=1

	Neww'title'.text='TUOlib音乐列表'
	self.txt0=txt0
	local list1=Neww'list_box'
	local bar1=Neww'value_slider'
	local txt0=Neww'text_displayer'
	local btn1=Neww'button'
	local btn2=Neww'button'
	local btn3=Neww'button'
	local btn4=Neww'button'
	local txt1=Neww'text_displayer'
	local bar2=Neww'value_slider'

	local function GetMusicName(index)
		if list1.cur then
			return tuolib.music.music_list[list1.cur][index or 1]
		else
			return nil
		end
	end

	--基本属性设置
	list1._ban_mul_select=true
	txt0.width=128
	txt0.gap_b=-2
	txt0._stay_in_this_line=true
	bar1.l=440
	bar1.width=444
	btn2._stay_in_this_line=true
	btn3._stay_in_this_line=true
	btn4._stay_in_this_line=true
	txt1._stay_in_this_line=true
	bar2._stay_in_this_line=true
	btn1.text='播放'
	btn2.text='暂停'
	btn3.text='继续'
	btn4.text='停止'
	txt1.text='音量'
	btn1.width=72
	btn2.width=72
	btn3.width=72
	btn4.width=72
	txt1.width=90
	txt1.gap_b=5
	bar2.pos_aim=100
	bar2.l=100
	bar2.max_value=1
	bar2.width=104
	bar2.gap_b=9
	list1._ban_list_sort=true
	--功能
	txt0.frame=function(widget)
		local full=GetMusicName(3)
		if full then 
			widget.text=string.format("%.2f/%.2f", self.play_process,full)
		end
	end	
	txt1.frame=function(widget)
		widget.text=string.format("音量：%.2f", bar2.pos/bar2.l)
	end
	list1.monitoring_value=function()
		local tmp={}
		for i,v in ipairs(tuolib.music.music_list) do
			local mst=''
			if CheckRes('bgm','v[1]') then mst=string.format("[%s]",tostring(GetMusicState(v[1]))) end
			table.insert(tmp,string.format("%s ( %.4f / %.4f ) %s",v[1],v[3]-v[4],v[3],mst))
		end
		return tmp
	end
	btn1._event_mouseclick=function()
		local msc=GetMusicName()
		if msc then 
			if not CheckRes('bgm',msc) then
				LoadMusicRecord(msc)
			end
			_play_music(msc,0)
			self.play_process=0
			self.play_state=1
			self.play_length=GetMusicName(3)
			self.play_period=GetMusicName(4)
		end	
	end
	btn2._event_mouseclick=function()
		local msc=GetMusicName()
		if msc and CheckRes('bgm',msc) and GetMusicState(msc)=='playing' then 
			PauseMusic(msc)
			self.play_state=0
		end	
	end
	btn3._event_mouseclick=function()
		local msc=GetMusicName()
		if msc and CheckRes('bgm',msc) and GetMusicState(msc)=='paused' then 
			ResumeMusic(msc)
			self.play_state=1
		end	
	end
	btn4._event_mouseclick=function()
		local msc=GetMusicName()
		if msc and CheckRes('bgm',msc) and GetMusicState(msc)=='playing' then 
			StopMusic(msc)
			self.play_process=0
			self.play_state=0
		end	
	end
	bar1.frame=function(widget)
		if widget._pressed then
			local msc=GetMusicName()
			if msc then 
				if not CheckRes('bgm',msc) then
					LoadMusicRecord(msc)
				end
				local k=bar1.pos_aim/bar1.l
				self.play_length=GetMusicName(3)
				self.play_period=GetMusicName(4)
				_play_music(msc,self.play_length*k)
				self.play_process=self.play_length*k
				self.play_state=1
			end	
		else
			bar1.pos_aim=bar1.l*self.play_process/self.play_length
		end
	end
	bar1.render=function(widget,alpha,l,r,b,t)
		---排版
		local BORDER_WIDTH=widget.borderwidth
		local HEIGHT=widget.w+BORDER_WIDTH*2
		local GAP_T=widget.gap_t
		local x_pos=widget.x
		---lrbt初始值
		local m=r-(bar1.l*self.play_period/self.play_length)-widget.borderwidth
		local yc=(t+b)/2
		local h=widget.w/2
		local w2=1
		local coor1=Color(255*alpha*(sin(os.clock()*150)+1)/2,20+120,20,20)
		local coor2=Color(0,20+120,20,20)
		SetImageState('white','',coor1,coor2,coor2,coor1)
		RenderRect('white',m,r-BORDER_WIDTH,yc-h,yc+h)
	end
	bar2.frame=function(widget)
		local name=GetMusicName()
		if name and CheckRes('bgm',name) and GetMusicState(name)=='playing' then
			SetBGMVolume(name,bar2.pos/bar2.l)
		end
	end
end

preview_frame[4]=function(self) --[4]音乐
	if self.play_state==1 then
		self.play_process=self.play_process+os.clock()-self.last_time
	end
	if self.play_process>self.play_length then self.play_process=self.play_process-self.play_period end
	self.last_time=os.clock()
end

for i=1,#res_type_t do
	st[i]=TUO_Developer_UI:NewPanel()
	local set=st[i]
	function set:init()
		if preview_widgets[i] then preview_widgets[i](set) end
		local l1,l2
		local search=''    
		self.name=res_type_t[i]
		Neww'title'.text='全局池'
		Neww'value_displayer'.monitoring_value=function()
			return {{name='数量',v=#(l1.display_value)}}
		end
		l1=Neww'list_box'
		l1.sortfunc=function(v1,v2)  return v1.v<v2.v end
		l1.monitoring_value=function()
			local t1,t2=lstg.EnumRes(i)
			local  out={}
			for k,v in pairs(t1) do
				if search=='' or search==nil then
					table.insert(out,{name='',v=v})
				else
					if string.find(v,search)~=nil then
						table.insert(out,{name='',v=v})
					end
				end
			end
			return out
		end
		Neww'title'.text='关卡池'
		Neww'value_displayer'.monitoring_value=function()
			return {{name='数量',v=#(l2.display_value)}}
		end
		l2=Neww'list_box'
		l2.sortfunc=function(v1,v2)  return v1.v<v2.v end
		l2.monitoring_value=function()
			local t1,t2=lstg.EnumRes(i)
			local  out={}
			for k,v in pairs(t2) do
				if search=='' or search==nil then
					table.insert(out,{name='',v=v})
				else
					if string.find(v,search)~=nil then
						table.insert(out,{name='',v=v})
					end
				end
			end
			return out
		end


		
		TUO_Developer_UI.SetWidgetSlot('slot2')
		Neww'title'.text='操作'
		local totop=Neww'button'
		totop.text='回到顶部'
		totop._event_mouseclick=function(self) set.y_offset_aim=0 end
		local preview=Neww'button'
		preview.text='预览'
		preview._event_mouseclick=function(self) TUO_Developer_Flow:MsgWindow('该功能开发中，下个快照见！') end
		local toglobal=Neww'button'
		toglobal.text='切换到关卡池'
		toglobal.mode=0
		toglobal._event_mouseclick=function(self)
			if self.mode==0 then
				toglobal.text='切换到全局池'
				self.mode=1
				l1.visiable=false
				-- l2.visiable=true
			else
				toglobal.text='切换到关卡池'
				self.mode=0
				l1.visiable=true
				-- l2.visiable=false
			end
		end
		local txt2=Neww'text_displayer'
		txt2.text='输入文字以筛选'
		txt2.gap_t=12
		local txt=Neww'inputer'
		txt.text=''
		txt.width=120
		txt._event_textchange=function(self)
			search=self.text
		end
		local btnclr=Neww'button'
		btnclr.text='清除'
		btnclr.width=64
		btnclr._event_mouseclick=function(self)
			txt.text=''
			search=nil
		end
	end
	if preview_frame[i] then
		set.frame=preview_frame[i]
	end
end

