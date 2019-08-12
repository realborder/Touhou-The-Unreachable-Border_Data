---------------------------------------------------
--选择难度菜单：标题
---------------------------------------------------
_exani_predefine={}
local _infinite=-1
_exani_predefine['layer']=LAYER_TOP
_exani_predefine['viewmode']='ui'

_exani_predefine['init']=				{{startf=1,		endf=51},						'keep'}
_exani_predefine['keep']=				{{startf=51,	endf=176,	repeatc=_infinite}}
_exani_predefine['kill']=				{{'FORCE_INTERPOLATION',force_interpolation_time=10},{startf=176,	endf=196}}

return _exani_predefine