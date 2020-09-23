| bvh load
| PHREDA 2016,2020
|----------------
|MEM $ffff
^r3/lib/gui.r3
^r3/lib/parse.r3
^r3/lib/3d.r3
^r3/util/dlgfile.r3

^r3/lib/trace.r3

#bvhfile
#$bvhfile

#level
#ox #oy #oz
#chcnt
#chpos
#chtype * 1024
#offend

#chsum
#model
#frames
#frametime
#animation

#framenow

#xcam 0 #ycam 0 #zcam 300.0
#xr 0 #yr 0

:,off+cha
	level chpos 8 << or , ox , oy , oz , ;
:,off
	level , ox , oy , oz ,  ;

:parsechp
	trim
	dup "Xposition" scanp 1? ( nip 1 ; ) drop
	dup "Yposition" scanp 1? ( nip 2 ; ) drop
	dup "Zposition" scanp 1? ( nip 3 ; ) drop
	dup "Xrotation" scanp 1? ( nip 4 ; ) drop
	dup "Yrotation" scanp 1? ( nip 5 ; ) drop
	dup "Zrotation" scanp 1? ( nip 6 ; ) drop
	0 ;

:savetype | nro mask adr type
	dup 4 - 63 >> 1 and 1 xor
|	4 <? ( 0 )( 1 )	| pos o ang
	pick4 chsum + chcnt - 'chtype + c!
	;

:parsecha
	trim
	getnro dup 'chcnt ! 'chsum +!
	0 0 ( chcnt <?  | mask nro
		swap rot
		parsechp
		savetype
		pick3 2 << <<
		rot or rot 1 + ) drop
	'chpos !
	,off+cha ;

:parseoff
	trim
	getfenro 'ox !
	getfenro 'oy !
	getfenro 'oz !
	offend 1? ( ,off 0 'offend ! ) drop
	;

:parsejoi
	trim
|	dup nombres> scanstr 'nombres> !
	>>cr
	;

:atom
	trim
	dup "{" scanp 1? ( nip 1 'level +! ; ) drop
	dup "}" scanp 1? ( nip -1 'level +! ; ) drop
	dup "OFFSET" scanp 1? ( nip parseoff ; ) drop
	dup "CHANNELS" scanp 1? ( nip parsecha ; ) drop
	dup "JOINT" scanp 1? ( nip parsejoi ; ) drop
	dup "End Site" scanp 1? ( nip 1 'offend ! ; ) drop
|	dup memmap
	trace
	;

:parseroo
	trim
|	dup nombres> scanstr 'nombres> !
	>>cr
	0 'level !
	0 'chsum !
	0 'offend !
	( atom level 1? drop ) drop
	;

:parsehie
	trim
	dup "ROOT" scanp 1? ( nip parseroo ; ) drop
	>>cr ;

:typech | fram chsum adr nro
	chsum pick3 - 'chtype + c@
	0? ( drop ; ) drop
	-360.0 /.	| angulo
	;

:parsemot
	0 , 0 , 0 , 0 ,
	here 'animation !
	trim dup "Frames:" scanp 0? ( drop ; ) nip
	trim getnro 'frames !
	trim dup "Frame Time:" scanp 0? ( drop ; ) nip
	trim getfenro 'frametime !
	frames ( 1?
		chsum ( 1?
			rot trim getfenro
			typech
			, rot rot
			1 - ) drop
		1 - ) drop
	;

:nextword
	trim
	dup "HIERARCHY" scanp 1? ( nip parsehie ; ) drop
	dup "MOTION" scanp 1? ( nip parsemot ; ) drop
	;

:parsebvh | --
	bvhfile ( $bvhfile <? nextword >>sp ) drop ;

|------------------------------------------
:dumpmod | adr
	( @+ 1?
		"%h " print
		@+ "%f " print
		@+ "%f " print
		@+ "%f " print
		cr
		) 2drop
	;

:3dop project3d op ;
:3dline project3d line ;

:drawboxz | z --
	-0.5 -0.5 pick2 3dop
	0.5 -0.5 pick2 3dline
	0.5 0.5 pick2 3dline
	-0.5 0.5 pick2 3dline
	-0.5 -0.5 rot 3dline ;

:drawlinez | x1 x2 --
	2dup -0.5 3dop 0.5 3dline ;

#boneslevel * 1024

:box
	>a
	over a> - over a> - 2swap
	swap a> + swap a> +
	rectbox ;

:drawstick | level
	0 0 0 project3d
	2dup $ff00 'ink ! 1 box 2dup op
	swap
	pick2 5 << 'boneslevel + !+ !
	2 <? ( ; )
	dup 1 - 5 << 'boneslevel +
	@+ swap @ $ff 'ink !  line ;

:drawcube |
	$ff00 'ink !
	-0.5 drawboxz
	0.5 drawboxz
	-0.5 -0.5 drawlinez
	0.5 -0.5 drawlinez
	0.5 0.5 drawlinez
	-0.5 0.5 drawlinez ;


|-------------------------------
#anip
:val anip @+ swap 'anip ! ;

:xpos val 0 0 mtransi ;
:ypos val 0 swap 0 mtransi ;
:zpos val 0 0 rot mtransi ;
:xrot val mrotxi ;
:yrot val mrotyi ;
:zrot val mrotzi ;
#lani xpos ypos zpos xrot yrot zrot

:anibones | flags --
	8 >> $ffffff and
	( 1? dup $f and 1 - 2 << 'lani + @ ex 4 >> )
	drop ;

:drawbones | bones --
	>b
	framenow chsum * 2 << animation + 'anip !
	0 ( b@+ 1? dup $ff and
		rot over - 1 + clamp0 | anterior-actual+1
		nmpop
		mpush
		b@+ b@+ b@+ mtransi
		swap anibones
		drawstick  |drawcube
		) drop
	nmpop
	;

:drawbones0 | bones --
	>b
	0 ( b@+ 1? $ff and
		swap over - 1 + clamp0 nmpop
		mpush
		b@+ b@+ b@+ mtransi
		drawcube
		) drop
	nmpop
	;

:freelook
	xypen
	sh 1 >> - 7 << swap
	sw 1 >> - neg 7 << swap
	neg mrotx
	mroty ;

:people
	-300.0 ( 300.0 <? 50.0 +
		-300.0 ( 300.0 <? 50.0 +
			mpush
			2dup 0.0 swap mtransi
			model drawbones
			mpop ) drop
		) drop
	;

:3dscreen
	omode
	freelook
	xcam ycam zcam mtrans

	model drawbones
|	people
|	model drawbones0

	framenow 1 + frames >=? ( 0 nip ) 'framenow !
	;

#smem

:reload | "" --
	smem swap
	load dup '$bvhfile ! dup 'model ! 'here !
	parsebvh      	
	;

:loadbvh
	"media/bvh" dlgfileload 0? ( drop ; )
	reload
	;

:main
	cls home
	$ffffff 'ink !
	dup "%d" print cr
	chsum "chsum:%d " print
	frames "frames:%d " print
	frametime " frame time:%f " print
	here model - "%d bytes" print cr
	framenow "%d " print cr
	model dumpmod cr
	3dscreen
	key
	<f1> =? ( loadbvh )
	>esc< =? ( exit )
	drop
	;
:ini
	mark
	here dup 'bvhfile !
	'smem !
|	"media/bvh/Example1.bvh"
	"media/bvh/0008_ChaCha001.bvh"
|	"media/bvh/10_01.bvh"
|	"media\bvh\megaPAK1\MECombat014B.bvh"
	reload
	0 'framenow !
	fonti
	;

: ini 'main onshow ;