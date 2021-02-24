|  Fuentes Vectoriales
|  PHREDA 2013
|  uso:
|	^r3/lib/fontr.txt
|   ^r3/rft/...fuente.rtf
|
|   ...fuente size fontr!
|--------------------------------------
^r3/lib/math.r3
^r3/lib/print.r3
^r3/lib/3d.r3

|---------- rfont
#fontrom
#fontsize
##fycc
##fxcc	| ajustes

:v>rfw ccw 14 *>> ;
:rf>xy | value -- x y
	dup 18 >> ccw 14 *>> ccx + 			|fxcc +
	swap 46 << 50 >> cch 14 *>> ccy +	|fycc +
	;

|--------- formato fuente
#yp #xp

:a0 drop ; 									| el valor no puede ser 0
:a1 xp yp pline rf>xy 2dup 'yp !+ ! op ;  | punto
:a2 rf>xy pline ; | linea
:a3 swap >b rf>xy b@+ rf>xy pcurve b> ;  | curva
:a4 swap >b rf>xy b@+ rf>xy b@+ rf>xy pcurve3 b> ; | curva3
|---- accediendo a x e y
:a5 rf>xy opx swap pline opy pline ;
:a6 rf>xy opy pline opx swap pline ;

#gfont a0 a1 a2 a3 a4 a5 a6 0

:drawrf | 'rf --
	fxcc 'ccx +!
	fycc 'ccy +!
	@+ rf>xy 2dup 'yp !+ ! op
	( @+ 1?
		dup $7 and 2 << 'gfont + @ ex
		) 2drop
	xp yp pline
	fxcc neg 'ccx +!
	fycc neg 'ccy +!
	poli ;

::fontrw | c -- wsize
	2 << fontsize + @ ccw 14 *>> ;

:emitrf | c --
	2 << fontrom + @ drawrf ;

::fontr! | rom size --
	dup 'ccw ! 'cch !
	'fontrom ! 'fontsize !
	drop
	v>rfw neg 'fxcc !
	cch dup 2 >> - 'cch !
	cch 1 >> 'fycc !
	'emitrf 'fontrw font!
	;

::remit | 'rf --
	@+ rf>xy 2dup 'yp !+ ! op
	( @+ 1?
		dup $7 and 2 << 'gfont + @ ex
		) 2drop
	xp yp pline
	poli ;


::rpos	'ccy ! 'ccx ! ;

::rsize 'cch ! 'ccw ! ;

|--------------------------
#cosa #sina | para rotar

:r>xy
	dup 18 >> swap 46 << 50 >>
	over sina * over cosa * + 16 >> cch * 14 >> ccy + >r
	swap cosa * swap sina * - 16 >> ccw * 14 >> ccx + r> ;

:a0 drop ; 									| el valor no puede ser 0
:a1 xp yp pline r>xy 2dup 'yp !+ ! op ;  | punto
:a2 r>xy pline ; | linea
:a3 swap >b r>xy b@+ r>xy pcurve b> ;  | curva
:a4 swap >b r>xy b@+ r>xy b@+ r>xy pcurve3 b> ; | curva3
|---- accediendo a x e y
:a5 r>xy opx swap pline opy pline ;
:a6 r>xy opy pline opx swap pline ;

#gfontr a0 a1 a2 a3 a4 a5 a6 0

::remitr | adr ang --
	dup cos 'cosa ! sin 'sina !
	@+ r>xy 2dup 'yp !+ ! op
	( @+ 1?
		dup $7 and 2 << 'gfontr + @ ex
		) 2drop
	xp yp pline
	poli ;

::fontradr | c -- 'rf
	2 << fontrom + @ ;

::fontrprint | 'ev "" --
	fxcc 'ccx +!
	fycc 'ccy +!
	( c@+ 1?
		dup fontradr pick3 ex
		fontrw 'ccx +!
		) 3drop
	fxcc neg 'ccx +!
	fycc neg 'ccy +!
	;

|--------------- fuente en 3d
:3d>xy
	dup 18 >> ccw 14 *>> ccx + 			|fxcc +
	swap 46 << 50 >> cch 14 *>> ccy +	|fycc +
	0 project3d ; | <--- cortar por vista

:a0 drop ; | el valor no puede ser 0
:a1 xp yp pline 3d>xy 2dup 'yp !+ ! op ;  | punto
:a2 3d>xy pline ; | linea
:a3 swap >b 3d>xy b@+ 3d>xy pcurve b> ;  | curva
:a4 swap >b 3d>xy b@+ 3d>xy b@+ 3d>xy pcurve3 b> ; | curva3
|---- accediendo a x e y
:a5 3d>xy opx swap pline opy pline ;
:a6 3d>xy opy pline opx swap pline ;

#gfont a0 a1 a2 a3 a4 a5 a6 0

::remit3d | 'rf --
	@+ 3d>xy 2dup 'yp !+ ! op
	( @+ 1? dup $7 and 2 << 'gfont + @ ex ) 2drop
	xp yp pline
	poli
	;

