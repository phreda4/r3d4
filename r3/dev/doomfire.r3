| doomfire
| PHREDA 2020
| from http://fabiensanglard.net/doom_fire_psx/
|------------------------------
^r3/lib/gui.r3
^r3/lib/rand.r3
^r3/util/miniscr.r3

#vsh 200
#vsw 380

#pallete
  $070707 $1f0707 $2f0f07 $470f07 $571707 $671f07
  $771f07 $8f2707 $9f2f07 $af3f07 $bf4707 $c74707
  $DF4F07 $DF5707 $DF5707 $D75F07 $D7670F $cf6f0f
  $cf770f $cf7f0f $CF8717 $C78717 $C78F17 $C7971F
  $BF9F1F $BF9F1F $BFA727 $BFA727 $BFAF2F $B7AF2F
  $B7B72F $B7B737 $CFCF6F $DFDF9F $EFEFC7 $FFFFFF

#scr8bit

:fire | adr -- adr'
	rand dup
	15 >> $3 and 1 - 1 clampmax 	| -1..+1
	pick2 + vsw + c@	| adr rand color
	1? ( over 17 >> $1 and - )
	rot rot
	20 >> $7 and 3 - 3 clampmax		| -3..+3
	+ c!+
	;

:putfire | x y --
	vsw * + scr8bit +
	35 swap c! ;

:firescr
	scr8bit vsw +
	vsh 2 - ( 1? 1 -
		vsw ( 1? 1 -
			rot fire rot rot
			) drop
		) 2drop ;

:palfire
	c@+ 0? ( drop 4 a+ ; )
	2 << 'pallete + @ a!+ ;

:render
	vframe >a
	scr8bit
	vsh ( 1? 1 -
		vsw ( 1? 1 -
			rot palfire rot rot
			) drop
		sw vsw - 2 << a+
		) 2drop ;

:onfire
	scr8bit vsh 1 - vsw * + 35 vsw cfill ;

:offfire
	scr8bit vsh 1 - vsw * + 0 vsw cfill ;

#state 'onfire

:main
	cls
	home
	$ff00 'ink !
	vsw 1 >> 64 - vsh 1 >>
	msec 2 << vsh 2 >>
	xy+polar
	over 32 + over putfire
	atxy "FIREDOOM" print
	state ex
	firescr
	render
	minidraw
	key
	>esc< =? ( exit )
	<f1> =? ( 'onfire 'state ! )
	<f2> =? ( 'offfire 'state ! )
	drop
	;

:ini
	mark
	vsw vsh miniscreen

	here dup 'scr8bit !
	vsw vsh * + 'here !

	scr8bit 0 vsw vsh * cfill
	onfire
	;

:
ini
'main onShow
;
