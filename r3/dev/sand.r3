| sand demo
| from Chris Double (chris.double@double.co.nz),
| http://www.double.co.nz/nintendo_ds
| PHRDA 2020
^r3/lib/gui.r3

#SAND_COL $EECD83
#WATER_COL $1F1FFF
#FIRE_COL |OR = RGB15(31,8,8);
#PLANT_COL |OR = RGB15(4,25,4);
#SPOUT_COL |OR = RGB15(8,16,31);
#WAX_COL |OR = RGB15(29,27,25);
#WAX2_COL |OR = RGB15(29,27,26);
#OIL_COL |OR = RGB15(16,8,8);
#WALL_COL |OR = RGB15(16,16,16);
#SOLID_COL $696969

:pswap | diff --
	a> + dup @ a@ rot ! a! ;

:emptymove | diff --
	2 << dup a> + @ 1? ( 2drop ; ) drop
	pswap ;

:sand
	| rand >95
	sw  emptymove
	sw 1 + emptymove
	sw 1 - emptymove
	| rand >50
	;

:water
	| rand >95
	sw  emptymove
	sw 1 + emptymove
	sw 1 - emptymove
	| rand >50
	1 emptymove
	-1 emptymove
	;

:updatepix | ; A place
 	a@
	SAND_COL =? ( drop sand ; )
	WATER_COL =? ( drop water ; )
	drop ;

:hlined
	sw ( 1? 1 - updatepix 4 a+ ) drop ;

:hliner
	sw ( 1? 1 - updatepix -4 a+ ) drop ;

:updatesand
	sh 3 - 1 or
	0 over xy>v >a
	( +?
		hlined sw 2 << 4 + neg a+
		hliner sw 2 << 4 - neg a+
		2 - ) drop ;

#mat

:drawmat
  bpen 0? ( drop ; ) drop
  mat 'ink !
  10 10 xypen swap 5 - swap 5 - fillrect
  ;

:main
	updatesand
	drawmat
	key
	>esc< =? ( exit )
	<f1> =? ( SAND_COL 'mat ! )
	<f2> =? ( WATER_COL 'mat ! )
	<f3> =? ( SOLID_COL 'mat ! )
	drop
	;

:ini
	cls
	SAND_COL 'mat !
	mark ;

:
ini
'main onShow
;