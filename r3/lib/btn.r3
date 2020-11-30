|--------------------
| btn.r3 PHREDA 2010
|--------------------
^r3/lib/gui.r3
^r3/lib/trace.r3

:print2gc | "" --
	ccx 1 - 'xr1 !
	ccy 1 - 'yr1 !
	swprint ccx + 1 + 'xr2 !
	cch ccy + 1 + 'yr2 !
	;

:xy+!
	dup 'ccx +! 'ccy +! ;

:coldn | c -- c
	2 >> $3f3f3f and ;

:colup
	$3f3f3f and 3 << $30303 or ;

:drawbtn | normal up dn
	'ink !
	xr1 1 + yr1 xr2 1 - yr1 2 + fillbox
	xr1 yr1 1 + xr1 2 + yr2 1 - fillbox
	'ink !
	xr1 1 + yr2 xr2 1 - yr2 2 - fillbox
	xr2 yr1 1 + xr2 2 - yr2 1 - fillbox
	'ink !
	xr1 2 + yr1 2 +
	xr2 2 - yr2 2 -
	fillbox
	;

:drawbtnflat
	xr1 yr1 xr2 yr2 fillbox ;

:drawbtnrect
	xr1 yr1 xr2 yr2 rectbox ;

:btnsimple
	ink dup coldn over colup
	[ swap ; ] guiI
	drawbtn ;


::btnt | 'event "texto" --
	ccw 1 >> 'ccx +!
	print2gc
	ccw dup neg 'xr1 +! 'xr2 +!
	cch 2 >> dup neg 'yr1 +! 'yr2 +!
	btnsimple
	ink >r
	$ffffff 'ink !
	[ 1 xy+! ; ] guiI
	print
	[ -1 xy+! ; ] guiI
	onClick
	xr2
	'ccx !
	r> 'ink !
	;

::link | 'event "txt" --
	ccw 2 >> 'ccx +!
	print2gc
	ccw 2 >> 'xr2 +!
	btnsimple
	ink >r
	$ffffff 'ink !
	[ 1 xy+! ; ] guiI
	print
	[ -1 xy+! ; ] guiI
	onClick
	ccw 2 >> 'ccx +!
	r> 'ink !
	;

|-------------------- icons

::ibtn | 'event 'ico --
	ccx ccy pick2 @
	dup $ff and 6 +
	swap 8 >> $ff and 6 +
	guiBox
	btnsimple
	3 [ 1 + ; ] guiI xy+!
	$ffffff drawcico  | negro
	-3 [ 1 - ; ] guiI xy+!
	onClick
	2 'ccx +!
	;

::ibtnf | 'event 'ico --
	ccx ccy pick2 @
	dup $ff and 6 +
	swap 8 >> $ff and 6 +
	guiBox
	[ ink $888888 'ink ! drawbtnflat 'ink ! ; ] guiI
	3 xy+! ink drawcico  | negro
	-3 xy+!
	onClick
	2 'ccx +!
	;

|--- btns mode
| #modosd 'icofi 'icopr 'icopl 'icofi 0

:colormodo | nro -- nro color
	pick2 @ =? ( $ffffff ; ) $0 ;

::ibtnmode | 'mode 'list --
	0 ( colormodo 'ink !
		swap @+ 1?			 	| 'mode act 'list ico
		[ over pick3 ! ; ] swap | 'mode act 'list [] ico
		ibtnf 4 'ccx +!			| 'mode act 'list
		swap 1 + ) 4drop ;

|------------------------
::btnfpx | 'event px py --
	ccx ccy 2swap guiBox
	btnsimple
	onClick
	;

::btnf | "" "fx" --
	sp
	$ff0000 'ink ! backprint
	$ffffff 'ink ! emits
	0 'ink ! emits
	;
