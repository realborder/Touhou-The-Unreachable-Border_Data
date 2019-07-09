---------------------------------------------------
--这是第一个预定义播放模式的脚本，不仅可以用还可以做示例
---------------------------------------------------
--这是一个菜单项，菜单项一般包含以下动画
------init事件，即菜单项出现的动画，表项里跟一个'keep'代表之后会执行预定义中的keep动作
------keep事件，即菜单项的通常状态，无限循环
------kill事件，即菜单项消失的动画
------activate事件，即菜单项获得焦点的动画，后跟'ignite'
------ignite事件，即菜单项处于被选中的状态时的动画，无限循环
------deactivate事件，即菜单项失去焦点的动画，'DEFAULT_FORCE_INTERPOLATION'指代在执行后面的动画之前以默认时长10帧进行强制补间
------choose事件，菜单项被确认的动画，在执行这个动画过后通常都会消失，{force_interpolation_time=3},指代3帧强制补间
------init_unable事件，如果菜单项为不可用，则使用此init事件，值得注意的是，在该动画执行完之后播放头就不动了，和通常init不同
------ignitet_unable事件，即菜单项处于被选中的状态时的动画，如果菜单项为不可用则，使用此ignite事件，无限循环
------choose事件，菜单项被确认的动画，如果菜单项为不可用，则使用此choose事件，值得注意的是，在该动画执行完之后播放头就不动了，和通常choose不同
---------------------------------------------------
--在该脚本里定义一个表供播放头函数用，用的时候应该要DoFile一次
local _exani_predefine={}
local _infinite=-1
_exani_predefine['layer']=LAYER_TOP
_exani_predefine['viewmode']='world'

_exani_predefine['init']=				{{startf=1,		endf=26},						'keep'}
_exani_predefine['keep']=				{{startf=26,	endf=146,	repeatc=_infinite}}
_exani_predefine['kill']=				{{'FORCE_INTERPOLATION',force_interpolation_time=10},{startf=26,	endf=1}}
_exani_predefine['activate']=			{{startf=146,	endf=191},						'ignite'}
_exani_predefine['ignite']=				{{startf=191,	endf=391,	repeatc=_infinite}}
_exani_predefine['deactivate']=			{{'FORCE_INTERPOLATION',force_interpolation_time=10},{startf=191,	endf=146}}
_exani_predefine['choose']=				{{'FORCE_INTERPOLATION',force_interpolation_time=3},{startf=391,	endf=399,	repeatc=3},{startf=191,endf=158}}
_exani_predefine['init_unable']=		{{startf=454,	endf=473}}
_exani_predefine['ignite_unable']=		{{startf=473,	endf=548,	repeatc=_infinite}}
_exani_predefine['choose_unable']=		{{'FORCE_INTERPOLATION',force_interpolation_time=10},{startf=548,	endf=564}}