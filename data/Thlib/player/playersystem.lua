lstg.rank = 0
local system = {}
function system.stageselect()
	lstg.var.rank = 0
	
end
function system.stageinit()
	
end
function system.stageframe()
	if ex.stageframe%600==0 then
		lstg.var.rank = lstg.var.rank + 1
	end
	
	if lstg.var.rank>32 then lstg.var.rank=32 end
end
function system.stagerender()
	
end
function system.playerinit(player)

end
function system.playerframe(player)

end
function system.playerrender(player)

end

console = {}

function console.log(content)
	local p={}
	p.text=content
	p.next=console.head
	if console.head then
		console.head=p
	else
		console.head=p
		console.tail=p
	end
	return p
end
console.head=nil
console.tail=nil

function console.colorlog(content,color)
	console.log(content).color=color
end



console_class = Class(object)

function console_class:init(x1,x2,y1,y2)
	self.layer = LAYER_TOP + 200
	self.group = GROUP_GHOST
	self.x1 = x1
	self.y1 = y1
	self.x2 = x2
	self.y2 = y2
	self.h = 12
	self._a,self._r,self._g,self._b = 200,0,0,0
	self.alpha=1.0
end

function console_class:frame()
	task.Do(self)
end

function console_class:render()
	SetViewMode'ui'
	SetImageState('white','',Color(self._a*self.alpha,self._r,self._g,self._b))
	RenderRect('white',self.x1+self.x,self.x2+self.x,self.y1+self.y,self.y2+self.y)
	local count=int((self.y2-self.y1)/self.h)
	local x = self.x1+self.x + 5
	local y = self.y1+self.y + self.h
	local p = console.head
	local i = 0
	while p do
		i = i + 1
		RenderTTF('boss_name',p.text,x,x,y,y,p.color or Color(0xFFFFFFFF),'noclip')
		y = y + self.h
		if i==count then
			console.tail = p
			p.next = nil
			break
		end
		p = p.next
	end	
end