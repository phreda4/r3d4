
^r3/lib/sys.r3
^r3/lib/math.r3
^r3/lib/str.r3
^r3/lib/print.r3
^r3/lib/sprite.r3

^r3/lib/fontr.r3
^r3/rft/robotobold.rft
^r3/rft/robotoregular.rft

^r3/rft/droidsansbold.rft
^r3/rft/comfortaa_bold.rft

^r3/rft/archivoblackregular.rft

^r3/rft/architectsdaughter.rft
^r3/rft/dejavusans.rft
^r3/rft/dejavuserifbold.rft

^r3/rft/gooddog.rft
^r3/rft/opensansregular.rft

:teclado
	key
	>esc< =? ( exit )
	drop ;

:main
	cls home
	$ffffff 'ink !
	robotobold 80 fontr!
	"R3d4 Programing Language" print cr
	robotoregular 80 fontr!
	"R3d4 Programing Language" print cr
	droidsansbold 80 fontr!
	"R3d4 Programing Language" print cr
	comfortaa_bold 80 fontr!
	"R3d4 Programing Language" print cr
	archivoblackregular 80 fontr!
	"R3d4 Programing Language" print cr
	architectsdaughter 80 fontr!
	"R3d4 Programing Language" print cr
	dejavusans 80 fontr!
	"R3d4 Programing Language" print cr
	dejavuserifbold 80 fontr!
	"R3d4 Programing Language" print cr
	gooddog 80 fontr!
	"R3d4 Programing Language" print cr
	opensansregular 80 fontr!
	"R3d4 Programing Language" print cr


	acursor
	teclado
	;


:
	'main onshow
	;