| NAVES GAME
| PHREDA 2018

^r3/lib/sprite.r3
^r3/lib/str.r3
^r3/lib/print.r3
^r3/lib/key.r3

#nav32 $08008 | 8x8 32bits
$ffffff $ffffff $ffffff $ffff $ffff $ffff $ffff $ffff
$ffffff $ffffff $ffffff $ffff $ffff $ffff $ffff $ffff
$ffffff $ffffff $ffffff $ffff $ffff $ffff $ffff $ffff
$ffffff $ffffff $ffffff $ffff $ffff $ffff $ffff $ffff
$ffff $ffff $ffff $ffff $ffff $ffff $ffff $ffff
$ffff $ffff $ffff $ffff $ffff $ffff $ffff $ffff
$ff00 $ff00 $ff00 $ff00 $ff00 $ff00 $ff00 $ff00
$ff00 $ff00 $ff00 $ff00 $ff00 $ff00 $ff00 $ff00


#xn 100 #yn 100

:player
	xn yn 'nav32 sprite
	xn 8 + yn 8 + 'nav32 sprite
	xn yn 8 + 'nav32 sprite
	xn 8 + yn 'nav32 sprite	
	acursor
	;

#val

:ongame
	cls home
	xypen .d print " " print .d print cr
	val .h print cr

	key
	1? ( dup 'val ! )
	<up> =? ( -1 'yn +! )
	<dn> =? ( 1 'yn +! )
	<le> =? ( -1 'xn +! )
	<ri> =? ( 1 'xn +! )

	>esc< =? ( exit )
	drop
	player
	;
:
'ongame onshow
;

