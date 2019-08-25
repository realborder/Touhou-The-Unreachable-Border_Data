---------------------------------------------------
--选择关卡菜单通用
---------------------------------------------------
_exani_predefine={}
local _infinite=-1
_exani_predefine['layer']=LAYER_TOP
_exani_predefine['viewmode']='ui'

_exani_predefine['init']=				{{startf=435,		endf=446},						'keep'}
_exani_predefine['keep']=				{{startf=447,	endf=506,	repeatc=_infinite}}
_exani_predefine['kill']=				{{startf=446,	endf=435}}
_exani_predefine['activate']=			{{startf=507,	endf=522},						'ignite'}
_exani_predefine['ignite']=				{{startf=523,	endf=582,	repeatc=_infinite}}
_exani_predefine['deactivate']=			{{'FORCE_INTERPOLATION',force_interpolation_time=3},{startf=522,	endf=507},'keep'}
_exani_predefine['choose']=				{{'FORCE_INTERPOLATION',force_interpolation_time=3},{startf=582,	endf=588,	repeatc=3},		{startf=466,endf=435}}
_exani_predefine['init_unable']=		{{startf=342,	endf=354},						'KEEP'} --大写KEEP指代播放头就此停住
_exani_predefine['ignite_unable']=		{{startf=354,	endf=404, repeatc=_infinite}}
_exani_predefine['choose_unable']=		{{startf=404,	endf=420},						'ignite_unable'}

return _exani_predefine