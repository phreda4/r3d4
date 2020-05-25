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
	r> fontr! ;

#auxvar

| with shadow aux=padx(4)pady(4)color(24)
:semit1 | c --
	ccy ccx
	auxvar 24 >> dup $f and 'ccy +! 4 >> 'ccx +!
	ink >r
	auxvar 'ink !
	pick2 emit
	'ccx ! 'ccy ! r> 'ink !
	emit ;

| with background aux=color
:semit2 | c --
	ink >r
	auxvar 'ink !
	dup emitsize cch ccx ccy fillrect
	r> 'ink !
	emit ;

#fontfx 'emit 'semit1 'semit2

::fxfont! | fx aux --
	'auxvar !
	$f and 2 << 'fontfx + @ textboxvec ;
