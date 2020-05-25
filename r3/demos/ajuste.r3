| Señal de ajuste
| PHREDA 2020

^r3/lib/gui.r3
^r3/util/textfont.r3

|---- datetime
:,2d
	10 <? ( "0" ,s ) ,d ;

:,time
	time
	dup 16 >> $ff and ,d ":" ,s
	dup 8 >> $ff and ,2d ":" ,s
	$ff and ,2d ;

:,date
	date
	dup $ff and ,d "/" ,s
	dup 8 >> $ff and ,d "/" ,s
	16 >> $ffff and ,d ;

:datetime
	40 40 sw 40 - sh 40 - box!
	robotobold 48 fontr!
	2 $000000 fxfont!
	$ffffff 'ink !

	mark ,sp ,date ,sp ,eol empty here $00 textbox
	mark ,sp ,time ,sp ,eol empty here $20 textbox
	;

|---- colorbars
#col $fdfdfd $fdfc01 $fcfd $fe00 $fd00fb $fc0001 $0100fc

:sajuste
	'col sw 7 /mod 1 >> | 'col w x
	( sw 8 - <?
		rot @+ 'ink ! rot rot
		over sh pick2 0 fillrect
		over + )
	3drop ;

|--------------------
:main
	datetime
	key
	>esc< =? ( exit )
	drop
	;

: sajuste 'main onshow ;