| load save pg test
| PHREDA 2020
|MEM $ffff

^r3/util/loadjpg.r3
^r3/util/savejpg.r3

#imgp

:testsave
	"media/img/cerezo2.jpg" 200 200 100 savejpg ;

:show
	cls
	0 0 imgp sprite
	key
	<f1> =? ( testsave )
	>esc< =? ( exit )
	drop ;

:main
	mark
	"media/img/cerezo.jpg" loadjpg 'imgp !
	'show onShow ;

: main ;

