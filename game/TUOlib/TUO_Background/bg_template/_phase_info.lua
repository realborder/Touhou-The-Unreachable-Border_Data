---------------------------------
---设置每个phase的属性
---算法说明：
---phaseinfo表用来记录所有的phase固有属性
---stt表用来记录当前3d参数的起始点，
---cur表用来记录当前3d参数
function bg_template:InitPhaseInfo(phase)
	self.phaseinfo={
		{
			time=0,
			duration=1,
			eye={5,0,5},
			at={5.11,0,0},
			up={0,0,1},
			fogdist={0.1,15},
			fogc={255,255,255},
			z={0.1,15},
			fovy={0.5}
		},
		{
			time=60,
			duration=60,
			-- itpl=function(v1,v2,t)
			-- 	return v1+(v2-v1)*t
			-- end,
			eye={5,0,3},
			at={5.06,0,0},
			up={0,0,0.5},
			fogdist={0.1,15},
			fogc={255,255,255},
			z={0.1,15},
			fovy={0.8}
		},
	}
	tuolib.BGHandler.DoPhaseLogic(self,1)
end