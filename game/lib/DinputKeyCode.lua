---DirectInput Keyboard KeyCode
---Code by Xiliusha
---From Microsoft DirectX SDK (June 2010) dinput.h

local KEY={
	-- main keyboard
	
	["0"]=0x0B,--11,0
	["1"]=0x02,--2,1
	["2"]=0x03,--3,2
	["3"]=0x04,--4,3
	["4"]=0x05,--5,4
	["5"]=0x06,--6,5
	["6"]=0x07,--7,6
	["7"]=0x08,--8,7
	["8"]=0x09,--9,8
	["9"]=0x0A,--10,9
	
	A=0x1E,--30,A
	B=0x30,--48,B
	C=0x2E,--46,C
	D=0x20,--32,D
	E=0x12,--18,E
	F=0x21,--33,F
	G=0x22,--34,G
	H=0x23,--35,H
	I=0x17,--23,I
	J=0x24,--36,J
	K=0x25,--37,K
	L=0x26,--38,L
	M=0x32,--50,M
	N=0x32,--49,N
	O=0x18,--24,O
	P=0x19,--25,P
	Q=0x10,--16,Q
	R=0x13,--19,R
	S=0x1F,--31,S
	T=0x14,--20,T
	U=0x16,--22,U
	V=0x2F,--47,V
	W=0x11,--17,W
	X=0x2D,--45,X
	Y=0x15,--21,Y
	Z=0x2C,--44,Z
	
	F1=0x3B,--59,F1
	F2=0x3C,--60,F2
	F3=0x3D,--61,F3
	F4=0x3E,--62,F4
	F5=0x3F,--63,F5
	F6=0x40,--64,F6
	F7=0x41,--65,F7
	F8=0x42,--66,F8
	F9=0x43,--67,F9
	F10=0x44,--68,F10
	F11=0x57,--87,F11
	F12=0x58,--88,F12
	
	ESCAPE=0x01,--1,Esc
	GRAVE=0x29,--41,`
	TAB=0x0F,--16,Tab
	CAPITAL=0x3A,--58,CapsLock
	CAPSLOCK=0x3A,--58,CapsLock
	SHIFT=0x2A,--42,left shift
	LSHIFT=0x2A,--42,left shift
	LCONTROL=0x1D,--29,left ctrl
	CTRL=0x1D,--29,left ctrl
	LCTRL=0x1D,--29,left ctrl
	LMENU=0x38,--56,left alt
	ALT=0x38,--56,left alt
	LALT=0x38,--56,left alt
	LWIN=0xDB,--219,left win
	
	SPACE=0x39,--57, 
	UPARROW=0xC8,--200,up
	DOWNARROW=0xD0,--208,down
	LEFTARROW=0xCB,--203,left
	RIGHTARROW=0xCD,--205,right
	UP=0xC8,--200,up
	DOWN=0xD0,--208,down
	LEFT=0xCB,--203,left
	RIGHT=0xCD,--205,right
	
	MINUS=0x0C,--12,-
	EQUALS=0x0D,--13,=
	BACK=0x0E,--14,backspace
	BACKSPACE=0x0E,--14,backspace
	LBRACKET=0x1A,--26,[
	RBRACKET=0x1B,--27,]
	BACKSLASH=0x2B,--43,\
	SEMICOLON=0x27,--39,;
	APOSTROPHE=0x28,--40,'
	RETURN=0x1C,--28,Enter
	ENTER=0x1C,--28,Enter
	COMMA=0x33,--51,,
	PERIOD=0x34,--52,.
	SLASH=0x35,--53,/
	RSHIFT=0x36,--54,right shift
	RCONTROL=0x9D,--157,right ctrl
	RCTRL=0x9D,--157,right ctrl
	RMENU=0xB8,--184,right alt
	RALT=0xB8,--184,right alt
	RWIN=0xDC,--220,right win
	
	-- numeric keypad
	
	NUMLOCK=0x45,--69,NumLock
	SCROLL=0x46,--70,ScrollLock
	SCROLLLOCK=0x46,--70,ScrollLock
	NUMPADSLASH=0xB5,--181,/
	DIVIDE=0xB5,--181,/
	NUMPADSTAR=0x37,--55,*
	MULTIPLY=0x37,--55,*
	NUMPADMINUS=0x4A,--74,-
	SUBTRACT=0x4A,--74,-
	NUMPADPLUS=0x4E,--78,+
	ADD=0x4E,--78,+
	NUMPADENTER=0x9C,--156,Enter
	NUMPADPERIOD=0x53,--83,.
	DECIMAL=0x53,--83,.
	
	NUMPAD0=0x52,--82,0
	NUMPAD1=0x4F,--79,1
	NUMPAD2=0x50,--80,2
	NUMPAD3=0x51,--81,3
	NUMPAD4=0x4B,--75,4
	NUMPAD5=0x4C,--76,5
	NUMPAD6=0x4D,--77,6
	NUMPAD7=0x47,--71,7
	NUMPAD8=0x48,--72,8
	NUMPAD9=0x49,--73,9
	
	-- command keypad
	
	SYSRQ=0xB7,--183,print screen
	PAUSE=0xC5,--197
	HOME=0xC7,--199
	END=0xCF,--207
	INSERT=0xD2,--210
	DELETE=0xD3,--211
	APPS=0xDD,--221,on ctrl, or alt, or between alt and ctrl
	
	PRIOR=0xC9,--201,PageUp
	PGUP=0xC9,--201,PageUp
	NEXT=0xD1,--209,PageDown
	PGDN=0xD1,--209,PageDown
	
	-- fn keypad
	
	NEXTTRACK=0x99,
	MUTE=0xA0,
	CALCULATOR=0xA1,
	PLAYPAUSE=0xA2,
	MEDIASTOP=0xA4,
	VOLUMEDOWN=0xAE,
	VOLUMEUP=0xB0,
	WEBHOME=0xB2,
	MYCOMPUTER=0xEB,
	MAIL=0xEC,
	MEDIASELECT=0xED,
	
	-- sys keypad
	
	POWER=0xDE,
	SLEEP=0xDF,
	WAKE=0xE3,
	
	-- web keypad
	
	WEBSEARCH=0xE5,
	WEBFAVORITES=0xE6,
	WEBREFRESH=0xE7,
	WEBSTOP=0xE8,
	WEBFORWARD=0xE9,
	WEBBACK=0xEA,
	
	-- missing keys, can't find in dinput keycodes, may be mouse keys
	--[[
	LBUTTON
	RBUTTON
	MBUTTON
	--]]
}

return KEY