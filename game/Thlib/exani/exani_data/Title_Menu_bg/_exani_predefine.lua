------------------------------------
--标题画面背景
------------------------------------
local _exani_predefine={}
local _infinite=-1
_exani_predefine['layer']=LAYER_TOP-10
_exani_predefine['viewmode']='ui'

_exani_predefine['init']={{startf=1,endf=212},'keep'}
_exani_predefine['keep']={{startf=213,endf=567,repeatc=_infinite}}
_exani_predefine['kill']={{'FORCE_INTERPOLATION',force_interpolation_time=30},{startf=211,endf=1}}

return _exani_predefine