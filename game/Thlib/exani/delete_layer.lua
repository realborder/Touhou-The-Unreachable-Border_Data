function exani_manager:DeleteFrame()
	for k,v in pairs(self.exanis[self.choose_exani].picList[self.check_layer].keyFrames) do
		if self.check_frame==v.frame_at then table.remove(self.exanis[self.choose_exani].picList[self.check_layer].keyFrames,k) end
	end
	if #(self.exanis[self.choose_exani].picList[self.check_layer].keyFrames)==0 then
		table.remove(self.exanis[self.choose_exani].picList,self.check_layer)
		if self.check_layer>#(self.exanis[self.choose_exani].picList) then self.check_layer=self.check_layer-1 end
	end
end