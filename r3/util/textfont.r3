| fx font
| PHREDA 2020
|---------------
^r3/lib/fontr.r3

^r3/rft/robotobold.rft
^r3/rft/robotolight.rft
^r3/rft/robotoregular.rft
^r3/rft/robotothin.rft
^r3/rft/architectsdaughter.rft
^r3/rft/archivoblackregular.rft
^r3/rft/comfortaa_bold.rft
^r3/rft/comfortaa_thin.rft
^r3/rft/dejavusans.rft
^r3/rft/dejavuserif.rft
^r3/rft/dejavuserifbold.rft
^r3/rft/droidsansbold.rft
^r3/rft/gooddog.rft
^r3/rft/opensanslight.rft
^r3/rft/opensansregular.rft

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
	>r $f and 2 << 'fontlist + @ ex r> fontr! ;

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
