| About timeline
| PHREDA 2020
|------------------
|MEM $fff

^r3/lib/gui.r3
^r3/util/arr8.r3

#screen 0 0
#fx 0 0

|------ tiempo
#prevt
#timenow

:itime
	msec 'prevt ! 0 'timenow ! ;

:dtime
	msec dup prevt - 'timenow +! 'prevt ! ;

|------ linea de tiempo
#timeline 0
#timeline< 0
#timeline> 0

:itline
	timeline
	dup 'timeline> !
	'timeline< !
	;

:+tline	| event time --
	timeline> >a
	1000 *. a!+
	a!+
	a> 'timeline> !
	;

:tictline
	timeline< timenow
	( over
		timeline> =? ( 3drop ; )
		@ >?
		swap
		4 + dup @ ex
		4 + swap ) drop
	'timeline< ! ;

|------ duracion convertida
:a
|	>a
|	timenow a@+ - a@+ *. | 0--1.0
|	1.0 >=? ( drop setlastcoor 0 ; )
|	Bac_InOut

	;

:+evento
	;


#n

:main
	cls home

	dtime
	tictline

	$ff00 'ink !
	"timeline " print
	timenow "%d" print cr
	n "%d" print
	key
	<f1> =? ( itime )
	>esc< =? ( exit )
	drop

	'screen p.drawo

	;

:xy2 | int -- x y
	dup 48 << 48 >> swap 16 >> ;

:drawbox
	>b
	b@ timenow - -? ( drop 0 ; ) b!+
	b@+ xy2 b@+ xy2
	b@+ 'ink !
	fillbox ;

:+box
	'drawbox 'screen p!+ >a
	timenow 1000 + a!+
	2swap
	16 << swap $ffff and or a!+
	16 << swap $ffff and or a!+
	a!+
	;

:event1
	$ff0000 10 10 40 40 +box ;
:event2
	$ff00 40 40 140 70 +box ;
:event3
	$ff 200 210 240 280 +box ;

:memory
	mark
	here 'timeline !
	$ffff 'here +!
	1024 'screen p.ini
	1024 'fx p.ini

	itline
	'event1 1.2 +tline	| event time --
	'event2 2.01 +tline	| event time --
	'event1 3.1 +tline	| event time --
	'event3 3.1 +tline	| event time --
	;

: memory 'main onShow ;