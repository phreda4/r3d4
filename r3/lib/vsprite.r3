| VSPRITE   Sprites Vectoriales (v3)
| PHREDA 2013
|-------------------------------------------
^r3/lib/gr.r3
^r3/lib/3d.r3

|--------- formato vesprite
#yp #xp

:gc>xy | valor -- xy
	dup 23 >> xa 9 *>> ccx +
	swap 41 << 23 >> ya 9 *>> ccy + ;

:endp xp $80000000 <>? ( yp pline ; ) drop ;
:finpoli xp yp pline $80000000 'xp ! poli ;

|--------??????
:a0 drop ; 						| el valor no puede ser 0
:a1 8 >> 'ink ! ; 					| color0
|-------- poligono
:a4 endp gc>xy 2dup 'yp !+ ! op ;  | punto
:a5 gc>xy pline ; | linea
:a6 swap >b gc>xy b@+ gc>xy pcurve b> ;  | curva
:a7 swap >b gc>xy b@+ gc>xy b@+ gc>xy pcurve3 b> ; | curva3
|-------- linea
:a8 gc>xy op ; | punto de trazo
:a9 gc>xy line ; | linea
:aa swap >b gc>xy b@+ gc>xy curve b> ;  | curva
:ab swap >b gc>xy b@+ gc>xy b@+ gc>xy curve3 b> ; | curva3
|-------- pintado de poligonos
:ac 8 >> 'ink ! finpoli ; 			| solido

#jves a0 a1 a0 a0 a4 a5 a6 a7 a8 a9 aa ab ac ac ac ac

::vesprite | 'rf --
	$80000000 'xp !
	( @+ 1? dup $f and 2 << 'jves + @ ex ) 2drop ;

|--------- R vesprite
#cosa #sina | para rotar
:r>xy
	d>xy over sina * over cosa * + 16 >> ya * 14 >> ccy + >r
	swap cosa * swap sina * - 16 >> xa * 14 >> ccx + r> ;

|-------- poligono
:a4 endp r>xy 2dup 'yp !+ ! op ;  | punto
:a5 r>xy pline ; | linea
:a6 swap >b r>xy b@+ r>xy pcurve b> ;  | curva
:a7 swap >b r>xy b@+ r>xy b@+ r>xy pcurve3 b> ; | curva3
|-------- linea
:a8 r>xy op ; | punto de trazo
:a9 r>xy line ; | linea
:aa swap >b r>xy b@+ r>xy curve b> ;  | curva
:ab swap >b r>xy b@+ r>xy b@+ r>xy curve3 b> ; | curva3

#jves a0 a1 a0 a0 a4 a5 a6 a7 a8 a9 aa ab ac ac ac ac

::rvesprite | adr ang --
	dup cos 'cosa ! sin 'sina !
	$80000000 'xp !
	( @+ 1? dup $f and 2 << 'jves + @ ex ) 2drop ;

|--------- 3d vesprite
| 3 << porque usa 14 bits a 17 bits queda 1.0
:3d>xy
	dup 18 >> 3 << swap 46 << 50 >> 3 << 0 project3d ;

|-------- poligono
:a4 endp 3d>xy 2dup 'yp !+ ! op ;  | punto
:a5 3d>xy pline ; | linea
:a6 swap >b 3d>xy b@+ 3d>xy pcurve b> ;  | curva
:a7 swap >b 3d>xy b@+ 3d>xy b@+ 3d>xy pcurve3 b> ; | curva3
|-------- linea
:a8 3d>xy op ; | punto de trazo
:a9 3d>xy line ; | linea
:aa swap >b 3d>xy b@+ 3d>xy curve b> ;  | curva
:ab swap >b 3d>xy b@+ 3d>xy b@+ 3d>xy curve3 b> ; | curva3

#jves a0 a1 a0 a0 a4 a5 a6 a7 a8 a9 aa ab ac ac ac ac

::3dvesprite | adr --
	$80000000 'xp !
	( @+ 1? dup $f and 2 << 'jves + @ ex ) 2drop ;

|--------------------------------------------------------------
:dumprf | 'rf
	$80000000 'xp !
	( @+ 1? "%h " print ) 2drop
	cr
	;
