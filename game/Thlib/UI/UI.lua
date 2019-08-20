Include'THlib\\ui\\uiconfig.lua'
Include'THlib\\ui\\font.lua'
Include'THlib\\ui\\title.lua'
Include'THlib\\ui\\sc_pr.lua'
Include'THlib\\ui\\stage_clear_bonus.lua'
ui={}

LoadTTF('WordStyle','THlib\\UI\\ttf\\yrdzst.ttf',20)
LoadTTF('PointStyle1','THlib\\UI\\ttf\\yrdzst.ttf',30)
LoadTTF('PointStyle2','THlib\\UI\\ttf\\yrdzst.ttf',24)

LoadTexture('boss_ui','THlib\\UI\\boss_ui.png')
LoadImage('boss_spell_name_bg','boss_ui',0,0,256*2,36*2)
SetImageCenter('boss_spell_name_bg',256*2,0)

LoadImage('boss_pointer','boss_ui',0,64*2,48*2,16*2)
SetImageCenter('boss_pointer',24*2,0)

LoadImage('boss_sc_left','boss_ui',64*2,64*2,32*2,32*2)
SetImageState('boss_sc_left','',Color(0xFF80FF80))

LoadTexture('hint','THlib\\ui\\hint.png',true)
LoadTexture('hint2','THlib\\ui\\hint2.png',true)
LoadImage('hint.stageclear','hint2',0,0,784,289)
LoadImage('hint.bonusfail','hint2',0,567,784,137)
LoadImage('hint.getbonus','hint2',0,290,784,277)
LoadImage('hint.extend','hint',0,192,160,64)
--LoadImage('hint.power','hint',0,12,84,32)
--LoadImage('hint.graze','hint',86,12,74,32)
--LoadImage('hint.point','hint',160,12,120,32)
--LoadImage('hint.life','hint',288,0,16,15)
--LoadImage('hint.lifeleft','hint',304,0,16,15)
--LoadImage('hint.bomb','hint',320,0,16,16)
--LoadImage('hint.bombleft','hint',336,0,16,16)

LoadImageFromFile('player_life','THlib\\ui\\UI_gaming_player.png')
SetImageCenter('player_life',0,5.5)
LoadImageFromFile('spell_life','THlib\\ui\\UI_gaming_spell.png')
SetImageCenter('spell_life',0,5.5)

LoadImage('kill_time','hint2',0,704,161,41,16,16)

LoadImageFromFile('UI_gaming_item_collect_line','THlib\\ui\\UI_gaming_item_collect_line.png')
LoadImageFromFile('UI_gaming_item_collect_word','THlib\\ui\\UI_gaming_item_collect_word.png')
--SetImageCenter('hint.power',0,16)
--SetImageCenter('hint.graze',0,16)
--SetImageCenter('hint.point',0,16)
--LoadImageGroup('lifechip','hint',288,16,16,15,4,1,0,0)
--LoadImageGroup('bombchip','hint',288,32,16,16,4,1,0,0)
--LoadImage('hint.hiscore','hint',424,8,80,20)
--LoadImage('hint.score','hint',424,30,64,20)
--LoadImage('hint.Pnumber','hint',352,8,56,20)
--LoadImage('hint.Bnumber','hint',352,30,72,20)
--LoadImage('hint.Cnumber','hint',352,52,40,20)
--SetImageCenter('hint.hiscore',0,10)
--SetImageCenter('hint.score',0,10)
--SetImageCenter('hint.Pnumber',0,10)
--SetImageCenter('hint.Bnumber',0,10)

--LoadTexture('line','THlib\\ui\\line.png',true)
--LoadImageGroup('line_','line',0,0,180,8,1,7,0,0)

LoadTexture('ui_rank','THlib\\ui\\rank.png')
LoadImage('rank_Easy','ui_rank',0,0,144,32)
LoadImage('rank_Normal','ui_rank',0,32,144,32)
LoadImage('rank_Hard','ui_rank',0,64,144,32)
LoadImage('rank_Lunatic','ui_rank',0,96,144,32)
LoadImage('rank_Extra','ui_rank',0,128,144,32)

ui.menu={
	font_size=0.625,
	line_height=24,
	char_width=20,
	num_width=12.5,
	title_color={255,255,255},
	unfocused_color={128,128,128},
--	unfocused_color={255,255,255},
	focused_color1={255,255,255},
	focused_color2={255,192,192},
	blink_speed=7,
	shake_time=9,
	shake_speed=40,
	shake_range=3,
	sc_pr_line_per_page=12,
	sc_pr_line_height=22,
	sc_pr_width=320,
	sc_pr_margin=8,
	rep_font_size=0.6,
	rep_line_height=20,
	
	FlowTimer=0,
	FlowAlpha=255,
	HighlightFlag=0,
	LoseLife=0,
	LoseSpell=0,
}

function RenderTTFplus(ttfname,text,left,right,bottom,top,color,...) 
	local a,r,g,b=lstgColor.ARGB(color)
	r,g,b=r*0.15,g*0.15,b*0.15
	RenderTTF(ttfname,text,left+1,right+1,bottom-1,top-1,Color(a,r,g,b),...)
	RenderTTF(ttfname,text,left,right,bottom,top,color,...)
end

function ui.DrawMenu(title,text,pos,x,y,alpha,timer,shake,align)
	align=align or 'center'
	local yos
	if title=='' then yos=(#text+1)*ui.menu.line_height*0.5 else
		yos=(#text-1)*ui.menu.line_height*0.5
		SetFontState('menu','',Color(alpha*255,unpack(ui.menu.title_color)))
		RenderText('menu',title,x,y+yos+ui.menu.line_height,ui.menu.font_size,align,'vcenter')
	end
	for i=1,#text do
		if i==pos then
			local color={}
			local k=cos(timer*ui.menu.blink_speed)^2
			for j=1,3 do color[j]=ui.menu.focused_color1[j]*k+ui.menu.focused_color2[j]*(1-k) end

			local xos=ui.menu.shake_range*sin(ui.menu.shake_speed*shake)

			SetFontState('menu','',Color(alpha*255,unpack(color)))
			RenderText('menu',text[i],x+xos,y-i*ui.menu.line_height+yos,ui.menu.font_size,align,'vcenter')
		--	RenderTTF('menuttf',text[i],x+xos+2,x+xos+2,y-i*ui.menu.line_height+yos,y-i*ui.menu.line_height+yos,Color(alpha*255,0,0,0),'centerpoint')
		--	RenderTTF('menuttf',text[i],x+xos,x+xos,y-i*ui.menu.line_height+yos,y-i*ui.menu.line_height+yos,Color(alpha*255,unpack(color)),'centerpoint')
		else
			SetFontState('menu','',Color(alpha*255,unpack(ui.menu.unfocused_color)))
			RenderText('menu',text[i],x,y-i*ui.menu.line_height+yos,ui.menu.font_size,align,'vcenter')
		--	RenderTTF('menuttf',text[i],x+2,x+2,y-i*ui.menu.line_height+yos,y-i*ui.menu.line_height+yos,Color(alpha*255,0,0,0),'centerpoint')
		--	RenderTTF('menuttf',text[i],x,x,y-i*ui.menu.line_height+yos,y-i*ui.menu.line_height+yos,Color(alpha*255,unpack(ui.menu.unfocused_color)),'centerpoint')
		end
	end
end

function ui.DrawMenuTTF(ttfname,title,text,pos,x,y,alpha,timer,shake,align)
	align=align or 'center'
	local yos
	if title=='' then yos=(#text+1)*ui.menu.sc_pr_line_height*0.5 else
		yos=(#text-1)*ui.menu.sc_pr_line_height*0.5
		RenderTTF(ttfname,title,x,x,y+yos+ui.menu.sc_pr_line_height,y+yos+ui.menu.sc_pr_line_height,Color(alpha*255,unpack(ui.menu.title_color)),align,'vcenter','noclip')
	end
	for i=1,#text do
		if i==pos then
			local color={}
			local k=cos(timer*ui.menu.blink_speed)^2
			for j=1,3 do color[j]=ui.menu.focused_color1[j]*k+ui.menu.focused_color2[j]*(1-k) end
			local xos=ui.menu.shake_range*sin(ui.menu.shake_speed*shake)
			RenderTTF(ttfname,text[i],x+xos,x+xos,y-i*ui.menu.sc_pr_line_height+yos,y-i*ui.menu.sc_pr_line_height+yos,Color(alpha*255,unpack(color)),align,'vcenter','noclip')
		else
			RenderTTF(ttfname,text[i],x,x,y-i*ui.menu.sc_pr_line_height+yos,y-i*ui.menu.sc_pr_line_height+yos,Color(alpha*255,unpack(ui.menu.unfocused_color)),align,'vcenter','noclip')
		end
	end
end

function ui.DrawMenuTTFBlack(ttfname,title,text,pos,x,y,alpha,timer,shake,align)
	align=align or 'center'
	local yos
	if title=='' then yos=(#text+1)*ui.menu.sc_pr_line_height*0.5 else
		yos=(#text-1)*ui.menu.sc_pr_line_height*0.5
		RenderTTF(ttfname,title,x,x,y+yos+ui.menu.sc_pr_line_height,y+yos+ui.menu.sc_pr_line_height,Color(0xFF000000),align,'vcenter','noclip')
	end
	for i=1,#text do
		if i==pos then
			local xos=ui.menu.shake_range*sin(ui.menu.shake_speed*shake)
			RenderTTF(ttfname,text[i],x+xos,x+xos,y-i*ui.menu.sc_pr_line_height+yos,y-i*ui.menu.sc_pr_line_height+yos,Color(0xFF000000),align,'vcenter','noclip')
		else
			RenderTTF(ttfname,text[i],x,x,y-i*ui.menu.sc_pr_line_height+yos,y-i*ui.menu.sc_pr_line_height+yos,Color(0xFF000000),align,'vcenter','noclip')
		end
	end
end

function ui.DrawRepText(ttfname,title,text,pos,x,y,alpha,timer,shake)
	local yos
	if title=='' then yos=(#text+1)*ui.menu.sc_pr_line_height*0.5 else
		yos=(#text-1)*ui.menu.sc_pr_line_height*0.5
		Render(title,x,y+ui.menu.sc_pr_line_height+yos)
--		RenderTTF(ttfname,title,x,x,y+yos+ui.menu.sc_pr_line_height+1,y+yos+ui.menu.sc_pr_line_height-1,Color(0xFF000000),'center','vcenter','noclip')
--		RenderTTF(ttfname,title,x,x,y+yos+ui.menu.sc_pr_line_height,y+yos+ui.menu.sc_pr_line_height,Color(255,unpack(ui.menu.title_color)),'center','vcenter','noclip')
	end
	local _text=text
	local xos={-300,-240,-120,20,130,240}
	for i=1,#_text do
		if i==pos then
			local color={}
			local k=cos(timer*ui.menu.blink_speed)^2
			for j=1,3 do color[j]=ui.menu.focused_color1[j]*k+ui.menu.focused_color2[j]*(1-k) end
--			local xos=ui.menu.shake_range*sin(ui.menu.shake_speed*shake)
			SetFontState('replay','',Color(0xFFFFFF30))
--			RenderTTF(ttfname,text[i],x+xos,x+xos,y-i*ui.menu.sc_pr_line_height+yos,y-i*ui.menu.sc_pr_line_height+yos,Color(alpha*255,unpack(color)),align,'vcenter','noclip')
			for m=1,6 do
				RenderText('replay',_text[i][m],x+xos[m],y-i*ui.menu.rep_line_height+yos,ui.menu.rep_font_size,'vcenter','left')
			end
		else
			SetFontState('replay','',Color(0xFF808080))
--			RenderTTF(ttfname,text[i],x,x,y-i*ui.menu.sc_pr_line_height+yos,y-i*ui.menu.sc_pr_line_height+yos,Color(alpha*255,unpack(ui.menu.unfocused_color)),align,'vcenter','noclip')
			for m=1,6 do
				RenderText('replay',_text[i][m],x+xos[m],y-i*ui.menu.rep_line_height+yos,ui.menu.rep_font_size,'vcenter','left')
			end
		end
	end
end

function ui.DrawRepText2(ttfname,title,text,pos,x,y,alpha,timer,shake)
	local yos
	if title=='' then yos=(#text+1)*ui.menu.sc_pr_line_height*0.5 else
		yos=(#text-1)*ui.menu.sc_pr_line_height*0.5
		Render(title,x,y+ui.menu.sc_pr_line_height+yos)
--		RenderTTF(ttfname,title,x,x,y+yos+ui.menu.sc_pr_line_height+1,y+yos+ui.menu.sc_pr_line_height-1,Color(0xFF000000),'center','vcenter','noclip')
--		RenderTTF(ttfname,title,x,x,y+yos+ui.menu.sc_pr_line_height,y+yos+ui.menu.sc_pr_line_height,Color(255,unpack(ui.menu.title_color)),'center','vcenter','noclip')
	end
	local _text=text
	local xos={-80,120}
	for i=1,#_text do
		if i==pos then
			local color={}
			local k=cos(timer*ui.menu.blink_speed)^2
			for j=1,3 do color[j]=ui.menu.focused_color1[j]*k+ui.menu.focused_color2[j]*(1-k) end
--			local xos=ui.menu.shake_range*sin(ui.menu.shake_speed*shake)
			SetFontState('replay','',Color(0xFFFFFF30))
--			RenderTTF(ttfname,text[i],x+xos,x+xos,y-i*ui.menu.sc_pr_line_height+yos,y-i*ui.menu.sc_pr_line_height+yos,Color(alpha*255,unpack(color)),align,'vcenter','noclip')
			RenderText('replay',_text[i][1],x+xos[1],y-i*ui.menu.rep_line_height+yos,ui.menu.rep_font_size,'vcenter','center')
			RenderText('replay',_text[i][2],x+xos[2],y-i*ui.menu.rep_line_height+yos,ui.menu.rep_font_size,'vcenter','right')
		else
			SetFontState('replay','',Color(0xFF808080))
--			RenderTTF(ttfname,text[i],x,x,y-i*ui.menu.sc_pr_line_height+yos,y-i*ui.menu.sc_pr_line_height+yos,Color(alpha*255,unpack(ui.menu.unfocused_color)),align,'vcenter','noclip')
			RenderText('replay',_text[i][1],x+xos[1],y-i*ui.menu.rep_line_height+yos,ui.menu.rep_font_size,'vcenter','center')
			RenderText('replay',_text[i][2],x+xos[2],y-i*ui.menu.rep_line_height+yos,ui.menu.rep_font_size,'vcenter','right')
		end
	end
end

function RenderScore(fontname,score,x,y,size,mode)
	if score<1000 then
		RenderText(fontname,string.format('%d',score),x,y,size,mode)
	elseif score<1000000 then
		RenderText(fontname,string.format('%d,%03d',math.floor(score/1000),score%1000),x,y,size,mode)
	elseif score<1000000000 then
		RenderText(fontname,string.format('%d,%03d,%03d',math.floor(score/1000000),math.floor(int(score/1000))%1000,score%1000),x,y,size,mode)
	elseif score<100000000000 then
		RenderText(fontname,string.format('%d,%03d,%03d,%03d',math.floor(score/1000000000),math.floor(int(score/1000000))%1000,math.floor(score/1000)%1000,score%1000),x,y,size,mode)
	else
		RenderText(fontname,string.format('99,999,999,999'),x,y,size,mode)
	end
end
--
diff_render_obj=Class(object)
function diff_render_obj:init(x,y,_type,img)
	self.group=GROUP_GHOST
	self.bound=false
	self.x=x
	self.y=y
	self.rot,self.
	self.layer=LAYER_TOP
	self.img=_type..img
	self._a,self._r,self._g,self._b=255,255,255,255
	ui_diff=self
end
function diff_render_obj:render()
	Render(self.img,self.x,self.y,self.rot,self.hscale,self.vscale)
end

--
function ResetUI()
	if setting.resx>setting.resy then
		if not CheckRes('img','image:UI_img') 	then 
		LoadImageFromFile('UI_gaming_bg','THlib\\ui\\UI_gaming_bg.png')
		LoadImageFromFile('UI_gaming_bgFlow','THlib\\ui\\UI_gaming_bgFlow.png')
		LoadImageFromFile('UI_gaming_bgCover','THlib\\ui\\UI_gaming_bgCover.png') 
		LoadImageFromFile('UI_gaming_bg_highlight','THlib\\ui\\UI_gaming_bg_highlight.png')
		LoadImageFromFile('UI_gaming_DR_ruler','THlib\\ui\\UI_gaming_DR_ruler.png')
		LoadImageFromFile('UI_gaming_DR_pin','THlib\\ui\\UI_gaming_DR_pin.png')
		end
		--[[
		if not CheckRes('img','image:LOGO_img') then LoadImageFromFile('logo','THlib\\ui\\logo.png') end
		SetImageCenter('logo',0,0)
		]]--
		LoadImageFromFile('menu_bg','THlib\\ui\\menu_bg.png')

		function ui.DrawFrame()
		    ui.menu.FlowTimer=ui.menu.FlowTimer+1
			if CheckRes('img','image:UI_img') then Render('image:UI_img',320,240) 
			else Render('UI_gaming_bg',320,240,0,0.5) 
			     if ui.menu.FlowTimer%5==4 then ui.menu.FlowAlpha=ran:Int(100,255) else ui.menu.FlowAlpha=min(255,ui.menu.FlowAlpha+25) end
                 SetImageState('UI_gaming_bgFlow','',Color(ui.menu.FlowAlpha,255,255,255))
				 for i=1,3 do Render('UI_gaming_bgFlow',320,240,ui.menu.FlowTimer*(0.035+0.015*i)+120*i,0.5) end
				 Render('UI_gaming_bgCover',320,240,0,0.5)
				 if ui.menu.HighlightFlag>0 then
					 SetImageState('UI_gaming_bg_highlight','mul+add',Color(max(100*(abs(lstg.var.dr)-2.5)/2.5,100*(ui.menu.HighlightFlag/30)),255,255,255))				 
					 Render('UI_gaming_bg_highlight',320,240,0,0.5)
					 ui.menu.HighlightFlag=ui.menu.HighlightFlag-1
				 else if abs(lstg.var.dr)>2.5 then
                     SetImageState('UI_gaming_bg_highlight','mul+add',Color(100*(abs(lstg.var.dr)-2.5)/2.5,255,255,255))				 
				     Render('UI_gaming_bg_highlight',320,240,0,0.5) end
				 end
				 Render('UI_gaming_DR_ruler',31,353,0,0.5)
				 Render('UI_gaming_DR_pin',15,353+112*lstg.var.dr/5,0,0.5)
			end
			--[[
			if CheckRes('img','image:LOGO_img') then Render('image:LOGO_img',400,150,0,0.5,0.5) else Render('logo',400,150,0,0.5,0.5) end
			]]--
			SetFontState('menu','',Color(0xFFFFFFFF))
			local x_offset=((16/9)/(4/3)-1)/2*640
			RenderText('menu',string.format('%.1ffps',GetFPS()),636+x_offset,1,0.25,'right','bottom')
			RenderText('menu',string.format('%dobjs',GetnObj()),636+x_offset,11,0.25,'right','bottom')
			
		end

		function ui.DrawMenuBG()
			SetViewMode'ui'
			Render('menu_bg',320,240)
			SetFontState('menu','',Color(0xFFFFFFFF))
			local x_offset=((16/9)/(4/3)-1)/2*640
			RenderText('menu',string.format('%.1ffps',GetFPS()),636+x_offset,1,0.25,'right','bottom')
			RenderText('menu',string.format('%dobjs',GetnObj()),636+x_offset,6,0.25,'right','bottom')

		end
		function ui.DrawScore()
			SetFontState('score3','',Color(0xFFADADAD))
			local diff=string.match(stage.current_stage.name,"[%w_][%w_ ]*$")
			local diffimg=CheckRes('img','image:diff_'..diff)
			if diffimg then
				Render('image:diff_'..diff,528,448)
			else
				if diff=='Easy' or diff=='Normal' or diff=='Hard' or diff=='Lunatic' or diff=='Extra' then
					local x_offset=((16/9)/(4/3)-1)/2*640/2
			        Render('rank_'..diff,528+x_offset,448,0.5,0.5)
		        else
			        RenderText('score',diff,528,466,0.5,'center')
		        end
			end
			--Render('line_1',525,419,0,1,1)
			--Render('line_2',525,397,0,1,1)
			--Render('line_3',525,349,0,1,1)
			--Render('line_4',525,311,0,1,1)
			--Render('line_5',525,247,0,1,1)
			--Render('line_6',525,224,0,1,1)
			--Render('line_7',525,202,0,1,1)
			--Render('hint.hiscore',428,425,0,1,1)
			--Render('hint.score',428,403,0,1,1)
			--Render('hint.Pnumber',428,371,0,1,1)
			--Render('hint.Bnumber',428,334,0,1,1)
			--Render('hint.Cnumber',554,316,0,0.85,0.85)
			--Render('hint.Cnumber',554,354,0,0.85,0.85)
			--Render('hint.power',455,253,0,0.5,0.5)
			--Render('hint.point',455,230,0,0.5,0.5)
			--Render('hint.graze',470,208,0,0.5,0.5)
			--RenderText('score','HiScore\nScore\nPlayer\nSpell\nGraze',432,424,0.5,'left')
			--for i=1,8 do
			--	Render('hint.life',518+13*i,371,0,1,1)
			--end
			if ui.menu.LoseLife>0 then
			    SetImageState('player_life','mul+add',Color(255,255,255,255))
			    for i=1,lstg.var.lifeleft do Render('player_life',518+12*i,376.3,0,0.5) end
				Render('player_life',518+12*(lstg.var.lifeleft+1),376.3,0,0.5*(ui.menu.LoseLife/15),1.5-ui.menu.LoseLife/15)
				if lstg.var.lifeleft<10 then
				    local chipNum=lstg.var.chip/100
				    SetImageState('player_life','mul+add',Color(125,255,255,255))
					for i=1,(11-(lstg.var.lifeleft+1)) do
			            Render('player_life',518+12*(12-i),376.3,0,0.5*min(1,max(0,(lstg.var.lifeleft+1)+chipNum-(11-i))),0.5)
					end
				end
				ui.menu.LoseLife=ui.menu.LoseLife-1
			else
			    SetImageState('player_life','mul+add',Color(255,255,255,255))
			    for i=1,lstg.var.lifeleft do Render('player_life',518+12*i,376.3,0,0.5) end
				if lstg.var.lifeleft<11 then
				    local chipNum=lstg.var.chip/100
				    SetImageState('player_life','mul+add',Color(125,255,255,255))
					for i=1,(11-lstg.var.lifeleft) do
			            Render('player_life',518+12*(12-i),376.3,0,0.5*min(1,max(0,lstg.var.lifeleft+chipNum-(11-i))),0.5)
					end
				end
			end
			--for i=1,8 do
			--	Render('hint.bomb',518+13*i,334,0,1,1)
			--end
			if ui.menu.LoseSpell>0 then
			    SetImageState('spell_life','mul+add',Color(255,255,255,255))
			    for i=1,lstg.var.bomb do Render('spell_life',518+12*i,356.8,0,0.5) end
				Render('spell_life',518+12*(lstg.var.bomb+1),356.8,0,0.5*(ui.menu.LoseSpell/15),1.5-ui.menu.LoseSpell/15)
				if lstg.var.bomb<2 then
				    local chipNum=lstg.var.bombchip/100
				    SetImageState('spell_life','mul+add',Color(125,255,255,255))
					if lstg.var.bomb==1 then
			            Render('spell_life',518+12*(lstg.var.bomb+2),356.8,0,0.5*min(1,chipNum),0.5)
					else
					    if chipNum>1 then Render('spell_life',518+12*(lstg.var.bomb+3),356.8,0,0.5*min(1,chipNum-1),0.5) end
					    Render('spell_life',518+12*(lstg.var.bomb+2),356.8,0,0.5*min(1,chipNum),0.5)
					end
				end
				ui.menu.LoseSpell=ui.menu.LoseSpell-1
			else
			    SetImageState('spell_life','mul+add',Color(255,255,255,255))
			    for i=1,lstg.var.bomb do Render('spell_life',518+12*i,356.8,0,0.5) end
				if lstg.var.bomb<3 then
				    local chipNum=lstg.var.bombchip/100
				    SetImageState('spell_life','mul+add',Color(125,255,255,255))
					for i=1,(3-lstg.var.bomb) do
			            Render('spell_life',518+12*(4-i),356.8,0,0.5*min(1,max(0,lstg.var.bomb+chipNum-(3-i))),0.5)
					end
				end
			end
			
			local SpellName='0'
			if player.SpellCardHp>0 then 
			    SpellName=player.SC_name
			else
			    if lstg.var.bomb==0 then SpellName='符卡用尽'
				else
			        if player.slow==1 then
				        if lstg.var.bomb==1 then SpellName=player.cardname.low1 end
					    if lstg.var.bomb==2 then SpellName=player.cardname.low2 end
					    if lstg.var.bomb==3 then SpellName=player.cardname.low3 end
				    else
				        if lstg.var.bomb==1 then SpellName=player.cardname.high1 end
					    if lstg.var.bomb==2 then SpellName=player.cardname.high2 end
					    if lstg.var.bomb==3 then SpellName=player.cardname.high3 end
				    end	
				end
			end
			RenderTTFplus('WordStyle',SpellName,576,663.5,352.5,361.5,Color(255,233,255,233),'center','vcenter')
			
			RenderTTFplus('PointStyle1',int(max(lstg.tmpvar.hiscore or 0,lstg.var.score)),551,665,422,437,Color(255,208,216,255),'bottom','right')
			RenderTTFplus('PointStyle1',int(lstg.var.score),551,665,404,419,Color(255,208,245,253),'bottom','right')
			
			RenderTTFplus('PointStyle1',string.format('%d',math.floor(lstg.var.power/100)),600.5,645,313.5,328.5,Color(255,253,223,223),'bottom','left')
			RenderTTFplus('PointStyle1',string.format('/%d',player.maxPower/100),600.5,645,313.5,328.5,Color(255,253,223,223),'bottom','right')
			RenderTTFplus('PointStyle2',string.format('.%d%d',math.floor((lstg.var.power%100)/10),math.floor(lstg.var.power%10)),610,665,313.5,328.5,Color(255,253,223,223),'bottom','left')
			RenderTTFplus('PointStyle2','.00',610,665,313.5,328.5,Color(255,253,223,223),'bottom','right')
			--RenderTTFplus('PointStyle1',string.format('%d,%d%d%d',math.floor(lstg.var.pointrate/1000),math.floor(lstg.var.pointrate/100)%10,math.floor(lstg.var.pointrate/10)%10,lstg.var.pointrate%10),518.5,615,295.5,310.5,Color(255,221,235,210),'bottom','right')
			local pointratebase=10000 + int(lstg.var.graze/10)*10 + int(lstg.var.faith/10)*10
			RenderTTFplus('PointStyle1',string.format('%.1f×%d,%d%d%d',max(1.0,-lstg.var.dr),math.floor(pointratebase/1000),math.floor(pointratebase/100)%10,math.floor(pointratebase/10)%10,pointratebase%10),580.5,666,295.5,310.5,Color(255,221,235,210),'bottom','right')
			RenderTTFplus('PointStyle1',string.format('%d',lstg.var.graze),580.5,666,277.5,292.5,Color(255,217,217,217),'bottom','right')
		end
	else
		LoadImageFromFile('ui_bg2','THlib\\ui\\ui_bg_2.png')
		LoadImageFromFile('UI_gaming_bg','THlib\\ui\\UI_gaming_bg.png')
		LoadImageFromFile('UI_gaming_bgFlow','THlib\\ui\\UI_gaming_bgFlow.png')
		LoadImageFromFile('UI_gaming_bgCover','THlib\\ui\\UI_gaming_bgCover.png')
		LoadImageFromFile('UI_gaming_bg_highlight','THlib\\ui\\UI_gaming_bg_highlight.png')
		LoadImageFromFile('UI_gaming_DR_ruler','THlib\\ui\\UI_gaming_DR_ruler.png')
		LoadImageFromFile('UI_gaming_DR_pin','THlib\\ui\\UI_gaming_DR_pin.png')
		--LoadImageFromFile('logo','THlib\\ui\\logo.png')
		--SetImageCenter('logo',0,0)
		LoadImageFromFile('menu_bg2','THlib\\ui\\menu_bg_2.png')
		LoadImageFromFile('menu_bg','THlib\\ui\\menu_bg.png')
		function ui.DrawFrame()
			Render('ui_bg2',198,264)
		end

		function ui.DrawMenuBG()
			SetViewMode'ui'
			Render('menu_bg2',198,264)
			SetFontState('menu','',Color(0xFFFFFFFF))
			local x_offset=((16/9)/(4/3)-1)/2*640
			RenderText('menu',string.format('%.1ffps',GetFPS()),636+x_offset,1,0.25,'right','bottom')
			RenderText('menu',string.format('%dobjs',GetnObj()),636+x_offset,6,0.25,'right','bottom')

		end

		function ui.DrawScore()
			RenderText('score','HiScore',8,520,0.5,'left','top')
			RenderText('score',string.format('%d',max(lstg.tmpvar.hiscore or 0,lstg.var.score)),190,520,0.5,'right','top')
			RenderText('score','Score',206,520,0.5,'left','top')
			RenderText('score',string.format('%d',lstg.var.score),388,520,0.5,'right','top')
			SetFontState('score','',Color(0xFFFF4040))
			RenderText('score',string.format('%1.2f',lstg.var.power/100),8,496,0.5,'left','top')
			SetFontState('score','',Color(0xFF40FF40))
			RenderText('score',string.format('%d',lstg.var.faith),84,496,0.5,'left','top')
			SetFontState('score','',Color(0xFF4040FF))
			RenderText('score',string.format('%d',lstg.var.pointrate),160,496,0.5,'left','top')
			SetFontState('score','',Color(0xFFFFFFFF))
			RenderText('score',string.format('%d',lstg.var.graze),236,496,0.5,'left','top')
			RenderText('score',string.rep('*',max(0,lstg.var.lifeleft)),388,496,0.5,'right','top')
			RenderText('score',string.rep('*',max(0,lstg.var.bomb)),380,490,0.5,'right','top')
		end
	end
end
ResetUI()