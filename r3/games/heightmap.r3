| simplest voxel heightmap
| PHREDA 2017
|--------------------------
|MEM $3fff

^r3/lib/gui.r3
^r3/lib/sprite.r3
^r3/util/loadpng.r3

#x 512.0		| x position on the map
#y 800.0		| y position on the map
#angle 0.0		| direction of the camera
#horizon 100	| horizon position (look up and down)
#height 100		| height of the camera

#map
#mapa

#plx #ply
#dx #dy
#invz
#invsw

#hidden * 8192

#sina
#cosa

:inicam
	angle sincos 'cosa ! 'sina !
	'hidden sh sw fill
	;

:iniray | z
	cosa neg sina -  over *. 'plx !
	cosa sina - over *.
	plx - invsw *. 'dx !

	sina cosa - over *. 'ply !
	sina neg cosa - over *.
	ply - invsw *. 'dy !
	x 'plx +!
	y 'ply +!
	;

:getmap
	ply 6 >> $ffc00 and plx 16 >> $3ff and or 2 << 4 + ;

:vline	| i 'h -- i 'h
	height
	getmap mapa + @ $ff and
	- invz *. horizon + clamp0
	over @ >? ( drop 4 + ; )
	dup rot dup @ >r !+ swap
	r> over -	| i 'h he cnt
	pick3 rot xy>v >a		| i 'h cnt
	getmap map + @ swap
	( 1? 1 - over a! sw 2 << a+ ) 2drop
	;

:render
	inicam
	1.0	| dz
	5.0 ( 1000.0 <?
		iniray
		240.0 over /. 'invz !
		'hidden
		0 ( sw <? swap
			vline
			dx 'plx +! dy 'ply +!
			swap 1 + ) 2drop
		swap 0.02 + swap over + ) 2drop ;

:ini
	mark
	cls home $ff00 'ink !
	 "cargando..." print redraw
	"media/img/map1.png" loadpng 'map !
	"media/img/alt1.png" loadpng 'mapa !
	cr "listo..." print redraw
	1.0 sw / 'invsw !
	;

:draw
	cls
	render
	key
	<le> =? ( 0.01 'angle +! )
	<ri> =? ( -0.01 'angle +! )
	<esp> =? ( sina 1 >> neg 'x +! cosa 1 >> neg 'y +! )

	<pgup> =? ( 1 'horizon +! )
	<pgdn> =? ( -1 'horizon +! )
	<up> =? ( 1 'height +! )
	<dn> =? ( -1 'height +! )
	>esc< =? ( exit )
	drop
	;

:main
	ini
	'draw onshow ;

: main ;