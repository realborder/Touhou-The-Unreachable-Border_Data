---------------------------------------------------
--选择机体通用	
---------------------------------------------------
_exani_predefine={}
local _infinite=-1
_exani_predefine['layer']=LAYER_TOP
_exani_predefine['viewmode']='ui'

_exani_predefine['init']=				{{startf=1,		endf=46},							'keepA'}
_exani_predefine['keepA']=				{{startf=47,	endf=47,	repeatc=_infinite}}
_exani_predefine['chooseA']=			{{startf=48,	endf=72,	repeatc=3},				'killA'}
_exani_predefine['killA']=				{{startf=47,	endf=62}}
_exani_predefine['AtoB']=				{{startf=77,	endf=102},							'keepB'}
_exani_predefine['BtoA']=				{{startf=102,	endf=77},							'keepA'}
_exani_predefine['keepB']=				{{startf=103,	endf=103,	repeatc=_infinite}}
_exani_predefine['chooseB']=			{{startf=124,	endf=129,	repeatc=3},				'killB'}
_exani_predefine['killB']=				{{startf=132,	endf=147}}

return _exani_predefine