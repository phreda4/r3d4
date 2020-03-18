| fx font
| PHREDA 2020
|---------------
^r3/lib/fontr.r3

^media/rft/robotobold.rft
^media/rft/robotolight.rft
^media/rft/robotoregular.rft
^media/rft/robotothin.rft
^media/rft/architectsdaughter.rft
^media/rft/archivoblackregular.rft
^media/rft/comfortaa_bold.rft
^media/rft/comfortaa_thin.rft
^media/rft/dejavusans.rft
^media/rft/dejavuserif.rft
^media/rft/dejavuserifbold.rft
^media/rft/droidsansbold.rft
^media/rft/gooddog.rft
^media/rft/opensanslight.rft
^media/rft/opensansregular.rft

^r3/util/textbox.r3

#fontlist
robotobold 
robotoregular 
robotolight 
robotothin 
robotothin
architectsdaughter
archivoblackregular
comfortaa_bold
comfortaa_thin
dejavusans
dejavuserif
dejavuserifbold
droidsansbold
gooddog
opensanslight
opensansregular

::nfont! | nro size --
	>r $f and 2 << 'fontlist + @ ex 
	r> fontr!
	;

:semit1 | c --
	ccy ccx
	4 'ccx +! 4 'ccy +!
	ink >r $80808 'ink !
	pick2 emit
	'ccx ! 'ccy ! r> 'ink !
	emit ;

:semit2 | c --
	ccy ccx
	4 'ccx +! 4 'ccy +!
	ink >r $f8f8f8 'ink !
	pick2 emit
	'ccx ! 'ccy ! r> 'ink !
	emit ;

#fontfx 'emit 'semit1 'semit2

::fxfont! | fx --
	$f and 2 << 'fontfx + @ textboxvec ;
