---------------------------------------------------
--Manual菜单：标题
---------------------------------------------------
local _exani_predefine={}
local _infinite=-1
_exani_predefine['layer']=LAYER_TOP
_exani_predefine['viewmode']='ui'

_exani_predefine['init']=				{{startf=1,		endf=50},						'keep'}
_exani_predefine['keep']=				{{startf=51,	endf=175,	repeatc=_infinite}}
_exani_predefine['kill']=				{{startf=51,	endf=1}}

return _exani_predefine