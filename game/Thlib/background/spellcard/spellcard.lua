_spellcard_background=Class(background)
function _spellcard_background:init()
	background.init(self,true)
	self.layers={}
	self.fxsize=0
	self.spr=0
end
function _spellcard_background:AddLayer(img,tile,x,y,rot,vx,vy,omiga,blend,hscale,vscale,init,frame,render)
	table.insert(self.layers,{img=img,tile=tile,x=x,y=y,rot=rot,vx=vx,vy=vy,omiga=omiga,blend=blend,a=255,r=255,g=255,b=255,frame=frame,render=render,timer=0,hscale=hscale,vscale=vscale})
	if init then init(self.layers[#self.layers]) end
end
function _spellcard_background:frame()
	for _,l in ipairs(self.layers) do
		l.x=l.x+l.vx
		l.y=l.y+l.vy
		l.rot=l.rot+l.omiga
		l.timer=l.timer+1
		if l.frame then l.frame(l) end
		if lstg.tmpvar.bg and lstg.tmpvar.bg.hide==true then
			self.fxsize=min(self.fxsize+2,200)
		else
			self.fxsize=max(self.fxsize-2,0)
		end
	end
	if IsValid(_boss) and _boss.card_num and _boss.cards[_boss.card_num] then 
		if _boss.cards[_boss.card_num].is_sc then self.spr=min(1,self.spr+1/45) else self.spr=max(0,self.spr-1/45) end
	end
	-- Print('scbg_spr='..self.spr)
end
function _spellcard_background:render()
	SetViewMode'world'
	if self.alpha>0 then
		-- local showboss = lstg.tmpvar.bg and lstg.tmpvar.bg.hide==true
		-- if showboss then
			background.WarpEffectCapture()
		-- end
		for i=#(self.layers),1,-1 do
			local l=self.layers[i]
			SetImageState(l.img,l.blend,Color(l.a,l.r,l.g,l.b)) --【开卡特效修改】
			local world=lstg.world
			if l.tile then
				local w,h=GetTextureSize(l.img)
				for i=-int((world.r+16+l.x)/w+1),int((world.r+16-l.x)/w+1),0.5 do
					for j=-int((world.t+16+l.y)/h+1),int((world.t+16-l.y)/h+1),0.5 do
						Render(l.img,l.x+i*w,l.y+j*h)
					end
				end
			else
				Render(l.img,l.x,l.y,l.rot,l.hscale,l.vscale)
			end
			if l.render then l.render(l) end
		end
		-- if showboss then
			background.WarpEffectApply(self.spr)
		-- end
	end
end

LoadImageFromFile("_scbg","THlib\\background\\spellcard\\background.png",true,0,0,false)
LoadImageFromFile("_scbg_mask","THlib\\background\\spellcard\\mask.png",true,0,0,false)
spellcard_background=Class(_spellcard_background)
spellcard_background.init=function(self)
    _spellcard_background.init(self)
    _spellcard_background.AddLayer(self,"_scbg_mask",true,0,0,0,1,1,0,"",1,1,nil,nil)
    _spellcard_background.AddLayer(self,"_scbg",false,0,0,0,0,0,0,"",1,1,nil,nil)
end
