----------------------------------------------
-- 函数 exani补间函数 by JanrilW
----------------------------------------------
--@return number 返回补间结果
--@param v_start number 初值
--@param v_end number 末值
--@param t number 当前帧
--@param t1 number 前一个关键帧处于第几帧
--@param t2 number 后一个关键帧处于第几帧
--@param type1 string 前一个关键帧的补间类型
--@param type2 string 后一个关键帧的补间类型
function exani_interpolation(v_start,v_end,t,t1,t2,type1,type2)
	--参数类型检查
	do local errorType=nil
	if type(v_start)~='number' then errorType=1
	elseif type(v_end)~='number' then errorType=2
	elseif type(t)~='number' then errorType=3
	elseif type(t1)~='number' then errorType=4
	elseif type(t2)~='number' then errorType=5
	elseif type(type1)~='string' then errorType=6
	elseif type(type2)~='string' and type(type2)~='function' then errorType=7 end
	if errorType then error('parameter'..errorType..'is incorrect')	end end
	
	--如果t就卡在t1或者t2上，那么直接返回初值或末值
	if t==t1 then return v_start end
	if t==t2 then return v_end end
	
	--下面根据不同的补间类型分类
	local functmp = nil --插值函数缓存
	if type1=='instant' or type2=='instant' then --两节点但凡有一个是“立刻赋值”，那么中间的值全是初值
		return v_start
	elseif type1=='linear' and type2=='linear' then --两节点都是线性
		functmp= function(v1,v2,t)	return v1+(v2-v1)*t end  --注意这里的t已经是归一化了的
	elseif type1=='linear' and type2=='smooth' then --前线性后平滑，取sin函数单周期前四分之一来平滑
		functmp= function(v1,v2,t) 	return v1+(v2-v1)*sin(t*90) end
	elseif type1=='smooth' and type2=='linear' then --前平滑后线性，取sin函数单周期均分为四份的第二部分来平湖
		functmp= function(v1,v2,t) 	return v1+(v2-v1)*(1-sin(90+t*90))end
	elseif type1=='smooth' and type2=='smooth' then --两节点都是平滑，取sin函数邻域U(0,PI/2)来平滑
		functmp= function(v1,v2,t) 	return v1+(v2-v1)*(sin(-90+t*180)*0.5+0.5) end
	elseif type1=='userdefine' then --用户自定义插值函数
		functmp= type2
	else 
		error('parameter 6 should be instant, linear, smooth or userdefine')
	end
	--集中处理
	return functmp(v_start,v_end,(t-t1)/(t2-t1))--t的归一，再用之前缓存的函数算
end