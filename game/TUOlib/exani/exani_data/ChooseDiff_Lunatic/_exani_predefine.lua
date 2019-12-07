---------------------------------------------------
--选择难度通用
--一般状态下只有一个贴图，所以init没了，keep也没了
--和一般菜单项需要区分的是，因为难度项被选择之后会滞留在屏幕上，所以有choose也有unchoose
---------------------------------------------------
_exani_predefine={}
local _infinite=-1
_exani_predefine['layer']=LAYER_TOP
_exani_predefine['viewmode']='ui'

_exani_predefine['activate']=			{{startf=1,		endf=49},						'ignite'}
_exani_predefine['ignite']=				{{startf=50,	endf=409,	repeatc=_infinite}}
_exani_predefine['deactivate']=			{{'FORCE_INTERPOLATION',force_interpolation_time=10},{startf=49,	endf=1}}
_exani_predefine['choose']=				{{'FORCE_INTERPOLATION',force_interpolation_time=10},{startf=409,	endf=434},{startf=434,endf=434,repeatc=_infinite}}
_exani_predefine['unchoose']=			{{startf=434,	endf=409},						'ignite'}

return _exani_predefine