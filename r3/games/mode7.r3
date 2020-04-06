| mode 7 demo
| from http://www.helixsoft.nl/articles/circle/sincos.htm
| PHREDA 2020
|-------------------
|MEM $3fff

^r3/lib/gui.r3
^r3/lib/sprite.r3
^r3/util/loadpng.r3

#map

:getmap | x y -- col
	16 >> $3ff and 10 <<
	swap 16 >> $3ff and +
	2 << map + 4 + @ ;

#distance

#scalex 200.0
#scaley 200.0
#horizon 20

#spacez 50.0
#spacex
#spacey
#hscale

#cosa #sina
#cx
#cy

#linedx
#linedy

:renderfloor | x y ang --
	sincos 'cosa ! 'sina !
	'cy ! 'cx !
	vframe
	sh 1 >> sw * 2 << +
	>a
	sh 1 >> ( sh <?
		spacez scaley pick2 horizon + 16 << */ 'distance !
		distance scalex /. 'hscale !
		sina neg hscale *. 'linedx !
		cosa hscale *. 'linedy !
		cosa distance *. cx + sw 1 >> linedx * - 'spacex !
		sina distance *. cy + sw 1 >> linedy * - 'spacey !
		0 ( sw <?
			spacex spacey getmap
			a!+
			linedx 'spacex +!
			linedy 'spacey +!
			1 + ) drop
		1 + ) drop ;

:ini
	mark
	cls home $ff00 'ink !
	 "cargando..." print redraw
	"media/img/map1.png" loadpng 'map !
	cr "listo..." print redraw

|	50.0 'spacez !
|	200.0 'scalex !
|	200.0 'scaley !
|   20.0
	sh 1 >> neg 1 + 'horizon !

	;

#angle
#cx #cy

#vrot
#vmov

:mover | speed --
	angle swap polar 'cx +! 'cy +! ;

:draw
	cls
	cx cy angle renderfloor
	key
	<le> =? ( -0.01 'vrot ! )
	<ri> =? ( 0.01 'vrot ! )
	>le< =? ( 0 'vrot ! ) >ri< =? ( 0 'vrot ! )
	<up> =? ( 2.8 'vmov ! )
	<dn> =? ( -2.8 'vmov ! )
	>up< =? ( 0 'vmov ! ) >dn< =? ( 0 'vmov ! )
	>esc< =? ( exit )
	drop

	vrot 1? ( dup 'angle +! ) drop
	vmov 1? ( dup mover ) drop

	;

:main
	ini
	'draw onshow ;

: main ;