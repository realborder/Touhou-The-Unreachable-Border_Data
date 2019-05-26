--======================================
--luastg math
--======================================

----------------------------------------
--常量

PI=math.pi
PIx2=math.pi*2
PI_2=math.pi*0.5
PI_4=math.pi*0.25
SQRT2=math.sqrt(2)
SQRT3=math.sqrt(3)
SQRT2_2=math.sqrt(0.5)
GOLD=360*(math.sqrt(5)-1)/2

----------------------------------------
--数学函数

int=math.floor
abs=math.abs
max=math.max
min=math.min
rnd=math.random
sqrt=math.sqrt

if not math.mod then--坑爹新luajit没了mod函数
	math.mod=function(a,b)
		return a%b
	end
end
mod=math.mod

--获得数字的符号(1/-1/0)
function sign(x)
	if x>0 then
		return 1
	elseif x<0 then
		return -1
	else
		return 0
	end
end

--获得(x,y)向量的模长
function hypot(x,y)
	return sqrt(x*x+y*y)
end

--阶乘，目前用于组合数和贝塞尔曲线
local fac = {}
function Factorial(num)
	if num < 0 then
		error("Can't get factorial of a minus number.")
	end
	if num < 2 then
		return 1
	end
	num = int(num)
	if fac[num] then
		return fac[num]
	end
	local result = 1
	for i = 1, num do
		if fac[i] then
			result = fac[i]
		else
			result = result * i
			fac[i] = result
		end
	end
	return result
end

--组合数，目前用于贝塞尔曲线
function combinNum(ord,sum)
	if sum<0 or ord<0 then error("Can't get combinatorial of minus numbers.") end
	ord=int(ord)
	sum=int(sum)
	return Factorial(sum)/(Factorial(ord)*Factorial(sum-ord))
end

----------------------------------------
--随机数系统，用于支持replay系统

local ranx=Rand()
ran = {}
ran.Int = function(self,a,b)
	if a > b then
		return ranx:Int(b,a)
	else
		return ranx:Int(a,b)
	end
end
ran.Float = function(self,a,b)
	return ranx:Float(a,b)
end
ran.Sign = function(self,a,b)
	return ranx:Sign(a,b)
end
ran.Seed = function(self,a,b)
	return ranx:Seed(a,b)
end
ran.GetSeed = function(self)
	return ranx:GetSeed()
end
