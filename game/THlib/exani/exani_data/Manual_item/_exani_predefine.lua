---------------------------------------------------
--Manual菜单：所有项目
---------------------------------------------------
local _exani_predefine={}
local _infinite=-1
_exani_predefine['layer']=LAYER_TOP
_exani_predefine['viewmode']='ui'

_exani_predefine['init']=				{{startf=1,		endf=63},						'keep1'}
_exani_predefine['kill']=				{{'FORCE_INTERPOLATION',force_interpolation_time=5},{startf=40,	endf=1}}
	_exani_predefine['10to1']=				{{startf=501,	endf=519},'keep1'}
	_exani_predefine['1to10']=				{{startf=519,	endf=501},'keep10'}
_exani_predefine['keep1']=				{{startf=519,	endf=519,	repeatc=_infinite}}
	_exani_predefine['1to2']=				{{startf=96,	endf=117},'keep2'}
	_exani_predefine['2to1']=				{{startf=117,	endf=96},'keep1'}
_exani_predefine['keep2']=				{{startf=117,	endf=117,	repeatc=_infinite}}
	_exani_predefine['2to3']=				{{startf=132,	endf=156},'keep3'}
	_exani_predefine['3to2']=				{{startf=156,	endf=117},'keep2'}
_exani_predefine['keep3']=				{{startf=156,	endf=156,	repeatc=_infinite}}
	_exani_predefine['3to4']=				{{startf=157,	endf=181},'keep4'}
	_exani_predefine['4to3']=				{{startf=181,	endf=156},'keep3'}
_exani_predefine['keep4']=				{{startf=181,	endf=181,	repeatc=_infinite}}
	_exani_predefine['4to5']=				{{startf=181,	endf=201},'keep5'}
	_exani_predefine['5to4']=				{{startf=201,	endf=181},'keep4'}
_exani_predefine['keep5']=				{{startf=201,	endf=201,	repeatc=_infinite}}
	_exani_predefine['5to6']=				{{startf=244,	endf=264},'keep6'}
	_exani_predefine['6to5']=				{{startf=264,	endf=201},'keep5'}
_exani_predefine['keep6']=				{{startf=264,	endf=264,	repeatc=_infinite}}
	_exani_predefine['6to7']=				{{startf=307,	endf=327},'keep7'}
	_exani_predefine['7to6']=				{{startf=327,	endf=264},'keep6'}
_exani_predefine['keep7']=				{{startf=327,	endf=327,	repeatc=_infinite}}
	_exani_predefine['7to8']=				{{startf=340,	endf=360},'keep8'}
	_exani_predefine['8to7']=				{{startf=360,	endf=327},'keep7'}
_exani_predefine['keep8']=				{{startf=360,	endf=360,	repeatc=_infinite}}
	_exani_predefine['8to9']=				{{startf=370,	endf=390},'keep9'}
	_exani_predefine['9to8']=				{{startf=390,	endf=360},'keep8'}
_exani_predefine['keep9']=				{{startf=390,	endf=390,	repeatc=_infinite}}
	_exani_predefine['9to10']=				{{startf=433,	endf=453},'keep10'}
	_exani_predefine['10to9']=				{{startf=453,	endf=390},'keep9'}
_exani_predefine['keep10']=				{{startf=453,	endf=453,	repeatc=_infinite}}

return _exani_predefine