|  Fuentes Vectoriales 3d
|  PHREDA 2020
|  uso:
|	^r3/lib/fontr.txt
|   ^r3/rft/...fuente.rtf
|
|   ...fuente size fontr!
|--------------------------------------
^r3/lib/3d.r3
^r3/lib/fontr.r3

#yp #xp

|--------------- fuente en 3d
:3d>xy
	dup 18 >> ccw 14 *>> ccx + 			|fxcc +
	swap 14 << 18 >> cch 14 *>> ccy +	|fycc +
	0 project3d ; | <--- cortar por vista

:a0 drop ; | el valor no puede ser 0
:a1 xp yp pline 3d>xy 2dup 'yp !+ ! op ;  | punto
:a2 3d>xy pline ; | linea
:a3 swap >b 3d>xy b@+ 3d>xy pcurve b> ;  | curva
:a4 swap >b 3d>xy b@+ 3d>xy b@+ 3d>xy pcurve3 b> ; | curva3
#gfont a0 a1 a2 a3 a4 0 0 0

::remit3d | 'rf --
	fxcc 'ccx +!
	fycc 'ccy +!
	@+ 3d>xy 2dup 'yp !+ ! op
	( @+ 1? dup $7 and 2 << 'gfont + @ ex ) 2drop
	xp yp pline
	fxcc neg 'ccx +!
	fycc neg 'ccy +!
	poli
	;

