local _exani_predefine={}
local _infinite=-1
_exani_predefine['layer']=LAYER_TOP
_exani_predefine['viewmode']='ui'

_exani_predefine['init']={{startf=1,endf=42},{startf=43,endf=43,repeatc=_infinite}}
_exani_predefine['kill']={{startf=42,endf=1}}

return _exani_predefine