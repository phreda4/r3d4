|MEM 32768
| test zbuffer
| PHREDA 2020

^r3/lib/gui.r3
^r3/lib/zbuffer.r3

:tz
	zb.clear
	30 ( 1? 1 -
		30 ( 1? 1 -
			over 70 + over 70 + 2dup 1 >> + $ff00 32 << or rot rot zbo!
			) drop
		) drop
	30 ( 1? 1 -
		30 ( 1? 1 -
			over 90 + over 90 + 2dup 1 << + $ff 32 << or rot rot zbo!
			) drop
		) drop
	0 0 zdraw
	;

:screen
   	tz
    home
    $ffffff 'ink !
	over "%d" print cr
	key
	>esc< =? ( exit )
	drop
	;

|----------------------
:main
	33
	mark
	sw sh zb.ini
	'screen onshow ;

: main ;