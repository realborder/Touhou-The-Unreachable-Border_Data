---------------------------------------------------
--标题菜单：Exit选项
---------------------------------------------------
local _exani_predefine={}
local _infinite=-1
_exani_predefine['layer']=LAYER_TOP
_exani_predefine['viewmode']='ui'

_exani_predefine['init']=				{{startf=1,		endf=25},						'keep'}
_exani_predefine['keep']=				{{startf=26,	endf=145,	repeatc=_infinite}}
_exani_predefine['kill']=				{{'FORCE_INTERPOLATION',force_interpolation_time=10},{startf=26,	endf=1}}
_exani_predefine['activate']=			{{startf=146,	endf=190},						'ignite'}
_exani_predefine['ignite']=				{{startf=191,	endf=390,	repeatc=_infinite}}
_exani_predefine['deactivate']=			{{'FORCE_INTERPOLATION',force_interpolation_time=10},{startf=191,	endf=146},'keep'}
_exani_predefine['choose']=				{{'FORCE_INTERPOLATION',force_interpolation_time=3},{startf=391,	endf=399,	repeatc=3},{startf=191,endf=158}}
_exani_predefine['init_unable']=		{{startf=454,	endf=472},'keep_unable'}
_exani_predefine['keep_unable']=		{{startf=473,	endf=473,repeatc=_infinite}}
_exani_predefine['ignite_unable']=		{{startf=473,	endf=548,	repeatc=_infinite}}
_exani_predefine['choose_unable']=		{{'FORCE_INTERPOLATION',force_interpolation_time=10},{startf=548,	endf=564}}

return _exani_predefine