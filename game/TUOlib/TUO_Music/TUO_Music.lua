local m={}
tuolib.music=m
m.PATH="TUOlib\\TUO_Music\\"
m.music_list={
	--------------------------------------------------------------------------------------
	--name		resource		loop end 			loop length			play offset
	{"st1",		"st1.ogg",		4622127/44100,		4354178/44100,		100},
	{"boss1",	"boss1.ogg",	2834136/44100,		2550636/44100		},
	{"st2",		"st2.ogg",		4901315/44100,		4546147/44100,		0},
	{"boss2",	"boss2.ogg",	4875055/44100,		4618473/44100		},
	{"st3",		"st3.ogg",		4057670/44100,		426201/44100,		60},
	{"st3_",	"st3.ogg",		0x487BA7/44100,		0x41FACE/44100		},
	{"boss3",	"boss3.ogg",	4044841/44100,		3775185/44100		},
	{"st4",		"st4.ogg",		0x5D428F/44100,		0x5792CB/44100,		303},
	--------------------------------------------------------------------------------------
}
function m:init()
	--把路径加上去
	for _,v in ipairs(m.music_list) do
		v[2]=m.PATH..v[2]
	end
	self.SetMusicInfo()
end
function m.SetMusicInfo()
	for _,v in ipairs(m.music_list) do
		MusicRecord(unpack(v))
	end
end

m:init()