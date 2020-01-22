-----------------------------------
--令敌机从背景渐隐渐显的函数 By JanrilW
-----------------------------------
--参数表	参数名 类型 备注
--@paramater self LuaSTGObject
--@paramater duration number 非0，为正则从背景出现，为负责从背景消失，数字大小指代持续帧数
--@paramater r,g,b number 环境色，从背景出现时对象的颜色会逐渐从这个颜色过渡
--@paramater scale_min,scale_max number 从背景渐隐渐显时的最大scale和最小scale
function EnemyAppearFromEnvironment(self,duration,r,g,b,scale_min,scale_max)
	--self.z值属于(0,1)，指代该对象的深度，让对象从背景中出现只需要让对象的z从0到1过渡
	--self.envi_r以及其他两个指代环境色，默认为深灰色
	--self.hscale_max,self.hscale_min,self.vscale_max,self.vscale_min}指代搞对象从背景中出现时比例的初值和末值，默认为初值0.5,0.5,1,1
--参数检查
	if not IsValid(self) then error('paramater #1 of function Enemy_appear_envi require LuaSTG object') end
	if (not duration) or duration==0 then error('paramater #2 of function Enemy_appear_envi require number which isn\'t 0') end
--初值补足
	self.envi_dura=duration
	self.envi_r=r or 90
	self.envi_g=g or 180
	self.envi_b=b or 172
	self.scale_max=scale_max or 1
	self.scale_min=scale_min or 0
	if duration>0 then self.z=0 self.colli=false else self.z=1 end
--令z值、rgb和scale的平滑变换的task
	task.New(self,function() 
		local sig if duration>0 then sig=1 else sig=-1 end
		local deltaz=1/abs(duration)*sig
		local r,g,b=self.envi_r,self.envi_g,self.envi_b
		local smax,smin=self.scale_max,self.scale_min
		self._blend=self._blend or ''
		for i=1,abs(duration) do
			self.z=self.z+deltaz
			self._a,self._r,self._g,self._b=255*self.z,r+(255-r)*self.z,g+(255-g)*self.z,b+(255-b)*self.z
			self.hscale=smin+(smax-smin)*self.z		self.vscale=self.hscale
			task.Wait()
		end
		if sig>0 then self.colli=true else Del(self) end --如果是渐隐，那么del自身
		return
	end)
end