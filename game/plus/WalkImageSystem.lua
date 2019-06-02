WalkImageSystem = plus.Class()
function WalkImageSystem:init(obj, intv, dx_level, dx_rate)
    self.dx_level = abs(dx_level)
    self.dx_rate = abs(dx_rate)
    self.obj = obj
    self.obj.ani_intv = intv or 8
    self.obj.lr = self.obj.lr or 1
end
function WalkImageSystem:frame(dx)
    local obj, lv, rt = self.obj, self.dx_level, self.dx_rate
    if dx == nil then dx = obj.dx end
    if dx > 0.5 then
        dx = lv
    elseif dx < -0.5 then
        dx = -lv
    else
        dx = 0
    end
    obj.lr = obj.lr + dx
    if obj.lr > rt then obj.lr = rt end
    if obj.lr < -rt then obj.lr = -rt end
    if obj.lr == 0 then obj.lr = obj.lr + dx end
    if dx == 0 then
        if obj.lr > 1 then obj.lr = obj.lr - 1 end
        if obj.lr < -1 then obj.lr = obj.lr + 1 end
    end
end
function WalkImageSystem:render(dmgt, dmgmaxt)
    local obj = self.obj
    local c = 0
    if dmgt and dmgmaxt then
        c = dmgt / dmgmaxt
    end
    if obj._blend and obj._a and obj._r and obj._g and obj._b then
        SetImageState(obj.img, obj._blend, Color(obj._a, obj._r - obj._r * 0.75 * c, obj._g - obj._g * 0.75 * c, obj._b))
    else
        SetImageState(obj.img, '', Color(255, 255 - 255 * 0.75 * c, 255 - 255 * 0.75 * c, 255))
    end
    Render(obj.img, obj.x, obj.y, obj.rot, obj.hscale, obj.vscale)
    if obj._blend and obj._a and obj._r and obj._g and obj._b then
        SetImageState(obj.img, "", Color(0xFFFFFFFF))
    end
end
function WalkImageSystem:SetImage()
end


BossWalkImageSystem = plus.Class(WalkImageSystem)
function BossWalkImageSystem:init(obj, img, nRow, nCol, imgs, anis, intv, a, b)
    WalkImageSystem.init(self, obj, intv, 2, 28)
    self.obj.cast = self.obj.cast or 0
    self.obj.cast_t = self.obj.cast_t or 0
    self:SetImage(img, nRow, nCol, imgs, anis, intv, a, b)
end
function BossWalkImageSystem:frame()
    local obj = self.obj
    WalkImageSystem.frame(self, obj.dx)
    if obj.img4 then
        self.mode = 4
    elseif obj.img3 then
        self.mode = 3
    elseif obj.img2 then
        self.mode = 2
    elseif obj.img1 then
        self.mode = 1
    else
        self.mode = 0
    end
    if obj.cast_t > 0 then
        obj.cast = obj.cast + 1
    elseif obj.cast_t < 0 then
        obj.cast = 0
        obj.cast_t = 0
    end
    if obj.dx ~= 0 then
        obj.cast = 0
        obj.cast_t = 0
    end
    if BossWalkImageSystem['UpdateImage'..self.mode] then
        BossWalkImageSystem['UpdateImage'..self.mode](obj)
    end
    if type(obj.A)=='number' and type(obj.B)=='number' then
        obj.a=obj.A;obj.b=obj.B
    end
end
function BossWalkImageSystem:render(dmgt, dmgmaxt)

    local obj = self.obj
    local c = 0
    if dmgt and dmgmaxt then
        c = dmgt / dmgmaxt
    end
    if self.mode == 0 then
        if obj._blend and obj._a and obj._r and obj._g and obj._b then
            SetImageState('undefined', obj._blend, Color(obj._a, obj._r - obj._r * 0.75 * c, obj._g - obj._g * 0.75 * c, obj._b))
        else
            SetImageState('undefined', 'mul+add', Color(128, 255 - 255 * 0.75 * c, 255 - 255 * 0.75 * c, 255))
        end
        Render('undefined',obj.x+cos( obj.ani*6+180)*3,obj.y+sin( obj.ani*6+180)*3, obj.ani*10)
        Render('undefined',obj.x+cos(-obj.ani*6+180)*3,obj.y+sin(-obj.ani*6+180)*3,-obj.ani*10)
        Render('undefined',obj.x+cos( obj.ani*6)*3,obj.y+sin( obj.ani*6)*3, obj.ani*20)
        Render('undefined',obj.x+cos(-obj.ani*6)*3,obj.y+sin(-obj.ani*6)*3,-obj.ani*20)
        if obj._blend and obj._a and obj._r and obj._g and obj._b then
            SetImageState('undefined', 'mul+add', Color(0x80FFFFFF))
        end
    else
        WalkImageSystem.render(self, dmgt, dmgmaxt)
    end
end
function BossWalkImageSystem:SetImage(img, nRow, nCol, imgs, anis, intv, a, b)
    local obj = self.obj
    for i = 1, 4 do
        obj['img'..i] = nil
        obj['ani'..i] = nil
    end
    if lstg.tmpvar._WLS_IMG_CHECK == nil then
        lstg.tmpvar._WLS_IMG_CHECK = {}
    end
    if img then
        if not(lstg.tmpvar._WLS_IMG_CHECK[img]) then
            local number_n = {}
            for i = 1, nRow do number_n[i] = nCol end
            LoadTexture('anonymous:'..img, img)
            local bt_n, bt_m = GetTextureSize('anonymous:'..img)
            local w, h = bt_n / nCol, bt_m / nRow
            for i = 1, nRow do
                LoadImageGroup('anonymous:'..img..i, 'anonymous:'..img, 
                0, h * (i - 1), w, h, number_n[i], 1, a, b)
            end
            lstg.tmpvar._WLS_IMG_CHECK[img] = true
        end
        for i = 1, nRow do obj['img'..i] = {} end
        for i = 2, nRow do obj['ani'..i] = imgs[i] - anis[i - 1] end
        for i = 1, nRow do for j = 1, imgs[i] do
            obj['img'..i][j] = 'anonymous:'..img..i..j
        end end
        obj.ani_intv = intv or obj.ani_intv or 8
        obj.lr = obj.lr or 1
        obj.nn, obj.mm = imgs, anis
        self.mode = nCol
    else
        self.mode = 0
    end
end
function BossWalkImageSystem:UpdateImage4()
    if self.cast>0 and self.dx==0 then
        if self.cast>=self.ani_intv*self.nn[4] then
            if self.mm[3]==1 then
                self.img=self.img4[self.nn[4]]
            else
                self.img=self.img4[int(self.cast/self.ani_intv)%self.mm[3]+self.ani4+1]
            end
            self.cast_t=self.cast_t-1
        else
            self.img=self.img4[int(self.cast/self.ani_intv)+1]
        end
    elseif self.lr>0 then
        if abs(self.lr)==1 then
            self.img=self.img1[int(self.ani/self.ani_intv)%self.nn[1]+1]
        elseif abs(self.lr)==28 then
            if self.mm[1]==1 then
                self.img=self.img2[self.nn[2]]
            else
                self.img=self.img2[int(self.ani/self.ani_intv)%self.mm[1]+self.ani2+1]
            end
        else
            if self.ani2==2 then
                self.img=self.img2[int((abs(self.lr)+2)/10)+1]
            elseif self.ani2==3 then
                self.img=self.img2[int((abs(self.lr))/7)+1]
            elseif self.ani2==4 then
                self.img=self.img2[int((abs(self.lr)+2)/6)+1]
            elseif self.ani2>4 then
                self.img=self.img2[int((abs(self.lr)+2)/5)+1]
            end
        end
    else
        if abs(self.lr)==1 then
            self.img=self.img1[int(self.ani/self.ani_intv)%self.nn[1]+1]
        elseif abs(self.lr)==28 then
            if self.mm[2]==1 then
                self.img=self.img3[self.nn[3]]
            else
                self.img=self.img3[int(self.ani/self.ani_intv)%self.mm[2]+self.ani3+1]
            end
        else
            if self.ani3==2 then
                self.img=self.img3[int((abs(self.lr)+2)/10)+1]
            elseif self.ani3==3 then
                self.img=self.img3[int((abs(self.lr))/7)+1]
            elseif self.ani3==4 then
                self.img=self.img3[int((abs(self.lr)+2)/6)+1]
            elseif self.ani3>4 then
                self.img=self.img3[int((abs(self.lr)+2)/5)+1]
            end
        end
    end
end
function BossWalkImageSystem:UpdateImage3()
    if self.cast>0 and self.dx==0 then
        if self.cast>=self.ani_intv*self.nn[3] then
            if self.mm[2]==1 then
                self.img=self.img3[self.nn[3]]
            else
                self.img=self.img3[int(self.cast/self.ani_intv)%self.mm[2]+self.ani3+1]
            end
            self.cast_t=self.cast_t-1
        else
            self.img=self.img3[int(self.cast/self.ani_intv)+1]
        end
    elseif self.lr>0 then
        if abs(self.lr)==1 then
            self.img=self.img1[int(self.ani/self.ani_intv)%self.nn[1]+1]
        elseif abs(self.lr)==28 then
            if self.mm[1]==1 then
                self.img=self.img2[self.nn[2]]
            else
                self.img=self.img2[int(self.ani/self.ani_intv)%self.mm[1]+self.ani2+1]
            end
        else
            if self.ani2==2 then
                self.img=self.img2[int((abs(self.lr)+2)/10)+1]
            elseif self.ani2==3 then
                self.img=self.img2[int((abs(self.lr))/7)+1]
            elseif self.ani2==4 then
                self.img=self.img2[int((abs(self.lr)+2)/6)+1]
            else
                self.img=self.img2[int((abs(self.lr)+2)/5)+1]
            end
        end
    else
        if abs(self.lr)==1 then
            self.img=self.img1[int(self.ani/self.ani_intv)%self.nn[1]+1]
        elseif abs(self.lr)==28 then
            if self.mm[1]==1 then
                self.img=self.img2[self.nn[2]]
            else
                self.img=self.img2[int(self.ani/self.ani_intv)%self.mm[1]+self.ani2+1]
            end
        else
            if self.ani2==2 then
                self.img=self.img2[int((abs(self.lr)+2)/10)+1]
            elseif self.ani2==3 then
                self.img=self.img2[int((abs(self.lr))/7)+1]
            elseif self.ani2==4 then
                self.img=self.img2[int((abs(self.lr)+2)/6)+1]
            else
                self.img=self.img2[int((abs(self.lr)+2)/5)+1]
            end
        end
    end
    local scale=abs(self.hscale)
    self.hscale=sign(self.lr)*scale
end
function BossWalkImageSystem:UpdateImage2()
    if self.cast>0 and self.dx==0 then
        if self.cast>=self.ani_intv*self.nn[2] then
            if self.mm[1]==1 then
                self.img=self.img2[self.nn[2]]
            else
                self.img=self.img2[int(self.cast/self.ani_intv)%self.mm[1]+self.ani2+1]
            end
            self.cast_t=self.cast_t-1
        else
            self.img=self.img2[int(self.cast/self.ani_intv)+1]
        end
    else
        if abs(self.lr)==1 then
            self.img=self.img1[1]
        elseif abs(self.lr)==28 then
                self.img=self.img1[self.nn[1]]
        else
            if self.ani2==2 then
                self.img=self.img2[int((abs(self.lr)+2)/10)+1]
            elseif self.ani2==3 then
                self.img=self.img2[int((abs(self.lr))/7)+1]
            elseif self.ani2==4 then
                self.img=self.img2[int((abs(self.lr)+2)/6)+1]
            else
                self.img=self.img2[int((abs(self.lr)+2)/5)+1]
            end
        end
    end
    local scale=abs(self.hscale)
    self.hscale=sign(self.lr)*scale
end
function BossWalkImageSystem:UpdateImage1()
--    if self.cast>0 then
--        self.cast=self.cast-1
--        self.img=self.imgs[int(self.cast/8)+9]
--    else
--        if abs(self.lr)==1 then
--            self.img=self.imgs[int(self.ani/self.ani_intv)%4+1]
--        elseif abs(self.lr)==18 then
--            self.img=self.imgs[8]
--        else
--            self.img=self.imgs[int((abs(self.lr)-2)/4)+5]
--        end
--    end
--    self.hscale=sign(self.lr)
end

EnemyWalkImageSystem = plus.Class(WalkImageSystem)
function EnemyWalkImageSystem:init(obj, style, intv)
    WalkImageSystem.init(self, obj, intv, 1, 18)
    self:SetImage(style)
end
function EnemyWalkImageSystem:frame()
    local obj = self.obj
    WalkImageSystem.frame(self, obj.dx)
    if obj.style <= 16 then
        EnemyWalkImageSystem.UpdateImage(obj)
    end
    if type(obj.A)=='number' and type(obj.B)=='number' then
        obj.a=obj.A;obj.b=obj.B
    end
end
function EnemyWalkImageSystem:render(dmgt, dmgmaxt)
    local obj = self.obj
    local c = 0
    if dmgt and dmgmaxt then
        c = dmgt / dmgmaxt
    end
    if obj._blend and obj._a and obj._r and obj._g and obj._b then
        SetImgState(obj, obj._blend, obj._a, obj._r - obj._r * 0.75 * c, obj._g - obj._g * 0.75 * c, obj._b)
    else
        SetImgState(obj, '', 255, 255 - 255 * 0.75 * c, 255 - 255 * 0.75 * c, 255)
    end
    
    --if obj.aura then
    --    if obj._blend and obj._a and obj._r and obj._g and obj._b then
    --        SetImageState('enemy_aura'..obj.aura,obj._blend, Color(obj._a, obj._r, obj._g, obj._b))
    --    end
    --    local breath=1.25 + 0.15 * sin(obj.timer * 6)
    --    Render('enemy_aura'..obj.aura, obj.x, obj.y, obj.timer * 3, obj.hscale*breath, obj.vscale*breath)
    --    if obj._blend and obj._a and obj._r and obj._g and obj._b then
    --        SetImageState('enemy_aura'..obj.aura,'', Color(0xFFFFFFFF))
    --    end
    --end
    
    --调换到低一层
	if obj.style > 16 and obj.style <= 24 then
        local img='ghost'..(obj.style-16)..'_'..int((obj.timer / 4) % 8) + 1
        if obj._blend and obj._a and obj._r and obj._g and obj._b then
            SetImageState(img, obj._blend, Color(obj._a, obj._r, obj._g, obj._b))
        end
        Render(img, obj.x, obj.y, 90, obj.hscale*1.1, obj.vscale*1.1)
        if obj._blend and obj._a and obj._r and obj._g and obj._b then
            SetImageState(img, '', Color(0xFFFFFFFF))
        end
    end
	
    --if obj.style > 27 and obj.style <= 30 then
    --    local img='Ghost'..(obj.style-26)..int((obj.timer / 4) % 8) + 1
    --    if obj._blend and obj._a and obj._r and obj._g and obj._b then
    --        SetImageState(img, obj._blend, Color(obj._a, obj._r, obj._g, obj._b))
    --    end
    --    Render(img, obj.x, obj.y, 90, obj.hscale*1.1, obj.vscale*1.1)
    --    if obj._blend and obj._a and obj._r and obj._g and obj._b then
    --        SetImageState(img, '', Color(0xFFFFFFFF))
    --    end
    --end
    --if obj.style > 30 then
    --    local img='Ghost'..(obj.style - 30)..int((obj.timer / 4) % 8) + 1
    --    if obj._blend and obj._a and obj._r and obj._g and obj._b then
    --        SetImageState(img, obj._blend, Color(obj._a, obj._r, obj._g, obj._b))
    --    end
    --    Render(img, obj.x, obj.y, 90, obj.hscale*1.1, obj.vscale*1.1)
    --    if obj._blend and obj._a and obj._r and obj._g and obj._b then
    --        SetImageState(img, '', Color(0xFFFFFFFF))
    --    end
    --end
    
    object.render(obj)
    
    if obj.style > 24 and obj.style <= 32 then
        if obj._blend and obj._a and obj._r and obj._g and obj._b then
            SetImageState('enemy_orb_ring'..obj.aura, 'mul+add', Color(obj._a, obj._r, obj._g, obj._b))
        end
        Render('enemy_orb_ring'..(obj.style-24), obj.x, obj.y, -obj.timer * 6, obj.hscale, obj.vscale)
        Render('enemy_orb_ring'..(obj.style-24), obj.x, obj.y, obj.timer * 4, obj.hscale*1.4, obj.vscale*1.4)
    end
	
	--if obj.style > 22 and obj.style <= 26 then
    --    if obj._blend and obj._a and obj._r and obj._g and obj._b then
    --        SetImageState('enemy_orb_ring'..obj.aura, 'mul+add', Color(obj._a, obj._r, obj._g, obj._b))
    --    end
    --    Render('enemy_orb_ring'..obj.aura, obj.x, obj.y, -obj.timer * 6, obj.hscale, obj.vscale)
    --    Render('enemy_orb_ring'..obj.aura, obj.x, obj.y, obj.timer * 4, obj.hscale*1.4, obj.vscale*1.4)
    --end
    
    if obj._blend and obj._a and obj._r and obj._g and obj._b then
        SetImgState(obj, '', 255, 255, 255, 255)
    end
end
function EnemyWalkImageSystem:SetImage(style, intv)
    local obj = self.obj
    obj.style = style
    obj.aura = _enemy_aura_tb[style]
    obj.death_ef = _death_ef_tb[style]
    obj.ani_intv = intv or obj.ani_intv or 8
    obj.lr = obj.lr or 1
    if style <= 16 then --普通妖精
		obj.imgs={}
		for i=1,12 do obj.imgs[i]='enemy'..style..'_'..i end
	elseif style<=24 then --仅有粒子效果的神灵型敌机
		obj.img='ghost_fire'..(style-16)
		obj.rot=-90
	elseif style<=32 then --阴阳玉
		obj.img='enemy_orb'..(style-24)
		obj.omiga=6
	elseif style<=40 then--毛玉
		obj.img='kedama'..(style-32)
		obj.omiga=12
    else
        obj.img = obj.imgs[1]
        obj.style = 0
    end
end
function EnemyWalkImageSystem:UpdateImage()
    if abs(self.lr) == 1 then
        self.img = self.imgs[int(self.ani / self.ani_intv) % 4 + 1]
    elseif abs(self.lr) == 18 then
        self.img = self.imgs[int(self.ani / self.ani_intv) % 4 + 9]
    else
        self.img = self.imgs[int((abs(self.lr) - 2) / 4) + 5]
    end
    self.hscale = sign(self.lr) * abs(self.hscale)
end

PlayerWalkImageSystem = plus.Class(WalkImageSystem)
function PlayerWalkImageSystem:init(obj, intv)
    WalkImageSystem.init(self, obj, intv, 1, 6)
    self.obj.protect = self.obj.protect or 0
end
function PlayerWalkImageSystem:frame(dx)
    local obj = self.obj
    PlayerWalkImageSystem.UpdateImage(obj)
    WalkImageSystem.frame(self, dx or 0)
end
function PlayerWalkImageSystem:render()
    local obj = self.obj
    if obj.protect % 3 == 1 then
        SetImageState(obj.img, '', Color(0xFF0000FF))
    else
        SetImageState(obj.img, '', Color(0xFFFFFFFF))
    end
    object.render(obj)
end
function PlayerWalkImageSystem:UpdateImage()
    if abs(self.lr) == 1 then
        self.img = self.imgs[int(self.ani / 8) % 12 + 1]
    elseif self.lr == -6 then
        self.img = self.imgs[int(self.ani / 8) %6 + 19]
    elseif self.lr == 6 then
        self.img = self.imgs[int(self.ani / 8) % 6 + 31]
    elseif self.lr < 0 then
        self.img = self.imgs[11 - self.lr]
    elseif self.lr > 0 then
        self.img = self.imgs[23 + self.lr]
    end
    self.a = self.A
    self.b = self.B
end
