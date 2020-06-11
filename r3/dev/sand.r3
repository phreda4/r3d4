| sand demo
| from Chris Double (chris.double@double.co.nz),
| http://www.double.co.nz/nintendo_ds
| PHREDA 2020
|MEM $ffff

^r3/lib/gui.r3
^r3/lib/rand.r3

#SAND_COL $EECD83
#WATER_COL $1F1FFF
#FIRE_COL $FF1F1F
#PLANT_COL $1FCD1F
#SPOUT_COL $4183FF
#WAX_COL $EE9FCD
#WAX2_COL $EE9F98
#OIL_COL $834141
#WALL_COL $838383

:pswap | diff --
	a> + dup @ a@ rot ! a! ;

:emptymove | diff --
	2 << dup a> + @ 1? ( 2drop ; ) drop
	pswap ;


:randff rand 5 >> $ff and ;

:randfire rand $7 and 3 - sw neg + ;

:sand
	randff 242 >? ( drop ; ) drop 	| rand >95
	sw  emptymove
	sw 1 + emptymove
	sw 1 - emptymove
	;

:water
	randff 242 >? ( drop ; ) drop | rand >95
	sw  emptymove
	sw 1 + emptymove
	sw 1 - emptymove
|	randff 128 >? ( drop ; ) drop | rand >50
	1 emptymove
	-1 emptymove
	;

:emptycopy | type diff --
	2 << a> + vframe sw 2 << + <? ( 2drop ; )
	dup @ 1? ( 3drop ; ) drop ! ;

:boxtype | -- c
	a> sw 1 + 2 << - >b
	b@+ b@+ or b@+ or sw 3 - 2 << b+
	b@+ or 4 b+ b@+ or sw 3 - 2 << b+
	b@+ or b@+ or b@+ or
	;

:fire
	randff 128 <? (
		FIRE_COL randfire emptycopy
		) drop
	randff 100 <? (
        boxtype 1? ( 0 a! ) drop
		) drop
	rand 220 <? (
		+1 2 << a> + @ WATER_COL =? ( 0 a! 0 a> 4 + ! ) drop
		-1 2 << a> + @ WATER_COL =? ( 0 a! 0 a> 4 - ! ) drop
		sw 2 << a> + @ WATER_COL =? ( 0 a! 0 a> sw 2 << + ! ) drop
		) drop
	;

:oilmove | diff --
	2 << a> + @ FIRE_COL <>? ( drop ; ) drop
	FIRE_COL a> 4 - !+ FIRE_COL swap !+ FIRE_COL swap !
	FIRE_COL a> sw 2 << - !
	FIRE_COL a> sw 2 << + !
	;

:oil
	randff 64 <? (
		sw neg oilmove
		1 oilmove
		-1 oilmove
		sw oilmove
		) drop
	randff 242 <? (
		sw emptymove
		sw 1 + emptymove
		sw 1 - emptymove
|	randff 128 >? ( drop ; ) drop | rand >50
		1 emptymove
		-1 emptymove
		) drop
	;

:updatepix | ; A place
 	a@
	SAND_COL =? ( drop sand ; )
	WATER_COL =? ( drop water ; )
	FIRE_COL =? ( drop fire ; )
	OIL_COL =? ( drop oil ; )
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
  10 10 xypen
  swap 5 - sw 15 - min 15 max
  swap 5 - sh 13 - min 15 max
  fillrect
  ;

:main
	updatesand
	drawmat
	key
	>esc< =? ( exit )
	<f1> =? ( SAND_COL 'mat ! )
	<f2> =? ( WATER_COL 'mat ! )
	<f3> =? ( WALL_COL 'mat ! )
	<f4> =? ( FIRE_COL 'mat ! )
	<f5> =? ( OIL_COL 'mat ! )
	<f6> =? ( PLANT_COL 'mat ! )
	<f7> =? ( SPOUT_COL 'mat ! )
	<f8> =? ( WAX_COL 'mat ! )
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

