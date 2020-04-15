| Editor de imagenes
| PHREDA 2020
|--------------------------------------------------
^r3/lib/gui.r3
^r3/lib/btn.r3
^r3/lib/rand.r3
^r3/lib/input.r3
^r3/lib/sprite.r3
^r3/lib/vdraw.r3

^r3/util/loadimg.r3

^r3/lib/trace.r3

#nombre * 256

#imagen
#imagenw 320
#imagenh 200

#zoom 0
#xi 60
#yi 24 | donde esta el pixel 0,0
#color $ff
#size 1

:scr2img | x y -- xi yi
	yi - zoom >> swap
	xi - zoom >> swap ;

:imagena
	imagenw * + 2 << imagen + 4 + ;

:imagenset | x y --
	imagena color swap ! ;

:imagenget | x y -- c
	imagena @ ;

#xa #ya
#xs1 #ys1
#xs2 #ys2

|----------- DRAW
:mododraw
	[ xypen scr2img vop ; ] [ xypen scr2img vline ; ]  onDnMove ;

|----------- FILL
:modofill
	[ color xypen scr2img vfill ; ] onClick ;

|----------- LINE
:modoline
	[ xypen 'ya ! 'xa ! ; ]
	[ color 'ink ! xa ya op xypen line ; ]
	[ xa ya scr2img vop xypen scr2img vline ; ] guiMap ;

|----------- BOX
:modobox
	[ xypen 'ya ! 'xa ! ; ]
	[ color 'ink ! xa ya xypen rectbox ; ]
	[ xa ya scr2img xypen scr2img vrect ; ] guiMap ;

|----------- CIRCLE
:modocircle
	[ xypen 'ya ! 'xa ! ; ]
	[ color 'ink ! xa ya xypen rectbox ; ]
	[ xa ya scr2img xypen scr2img 	| x y x y
		rot 2dup + 1 >> >r - abs 1 >> >r
		2dup + 1 >> >r - abs 1 >>
		r> r> swap r> 					| xr yr xm ym
		vellipse ; ] guiMap ;

|----------- PICKER
:modopicker
	[ xypen scr2img imagenget 'color ! ; ] onClick ;

|----------- ERASER
:modoeraser
	[ xypen scr2img vop ; ] [ xypen scr2img vline ; ]  onDnMove ;

|----------- SELECT
:modoselect
	[ xypen 'ys1 ! 'xs1 ! ; ]
	[ xs1 ys1 xypen box.dot ; ]
	[ xypen scr2img 'ys2 ! 'xs2 ! ; ] guiMap ;


|------------------------------
#modo 0
#modoex 'mododraw

#xtool 0 #ytool 24

#imgtoolbar
#modos
	'mododraw 'modopicker
	'modoline 'modofill
	'modobox 'modocircle
	'modoeraser 'modoselect

:modo2xy
	dup $1 and 30 * xtool +
	swap 1 >> 30 * ytool + ;

:toolbar
    xtool ytool imgtoolbar sprite
	modo modo2xy
	30 30 2swap
	box.inv
|	$ff00 'ink ! box.mix50

	color 'ink !
	xtool 8 + ytool 300 +
	over 50 + over 50 + fillbox

	xypen
	swap xtool - -? ( 2drop ; ) 59 >? ( 2drop ; )
	swap ytool - -? ( 2drop ; ) 299 >? ( 2drop ; )
	30 / 1 << swap 30 / +
	dup modo2xy
	2dup 30 30 guiBox
	rot
	[ dup 'modo ! dup 2 << 'modos + @ 'modoex ! ; ] onClick
	drop
	over 30 + over 30 +
	$ffffff 'ink ! rectbox
	;

:imagen.draw | --
|	bmrm 1 and? ( imagenw imagenh xi yi drawalphagrid ) drop
	xi yi
	imagenw zoom <<
	imagenh zoom <<
	imagen
	spritesize
	;

:teclado
	key
	<up> =? ( 1 zoom << neg 'yi +! )
	<dn> =? ( 1 zoom << 'yi +! )
	<le> =? ( 1 zoom << neg 'xi +! )
	<ri> =? ( 1 zoom << 'xi +! )
	<f1> =? ( 1 'modo +! )
	>esc< =? ( exit )
	drop
	;

|-----------------------------
:main
	cls gui

	'imagenset vset!
    imagen.draw

	$454545 'ink !
	home
	2 backlines

	$ffffff 'ink !
	4 4 atxy
	over ":r%d Img Editor [ " print
	'nombre print
	imagenh imagenw " | %dx%d ] " print
	$7f7f7f 'ink !
	sp [ 0 'zoom ! ; ] "x1" btnt
	sp [ 1 'zoom ! ; ] "x2" btnt
	sp [ 2 'zoom ! ; ] "x4" btnt
	sp [ 3 'zoom ! ; ] "x8" btnt

	toolbar

	xi clamp0
	yi clamp0
	imagenw zoom << sw clampmax
	imagenh zoom << sh clampmax
	guiBox
	modoex 1? ( dup ex ) drop

	teclado
	acursor ;

:inimem
	mark
	"media/img/img-toolbar.png" loadimg 'imgtoolbar !
	here
	dup 'imagen !
	imagenw $fff and imagenh $fff and 12 << or swap !+

	dup >a imagenw imagenh * ( 1? 1 - $ffffff a!+ ) drop

	imagenw imagenh * 2 << +
	'here !

	imagenw imagenh vsize
	'imagenset vset!
	'imagenget vget!
	;

:   inimem
	$454545 'paper !
|	"mem/img-edit.mem" bmr.load
	3
	'main onShow
	drop
|	"mem/img-edit.mem" bmr.save
	;
