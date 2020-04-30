
^r3/lib/sys.r3
^r3/lib/math.r3
^r3/lib/str.r3
^r3/lib/print.r3
^r3/lib/gui.r3

^r3/lib/fontr.r3
^media/rft/robotobold.rft
^media/rft/robotoregular.rft

^media/rft/droidsansbold.rft
^media/rft/comfortaa_bold.rft

^media/rft/archivoblackregular.rft

^media/rft/architectsdaughter.rft
^media/rft/dejavusans.rft
^media/rft/dejavuserifbold.rft

^media/rft/gooddog.rft
^media/rft/opensansregular.rft

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