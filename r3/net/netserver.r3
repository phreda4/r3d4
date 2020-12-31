| Server test
| PHREDA 2020
^r3/lib/gui.r3
^r3/util/console.r3

#mensaje * 1024
#sockserver 0
#ip 0 0
#nn 0

#scliente 0

:acepta
	sockserver TCPACCEPT 0? ( drop ; )
	dup "Acepta %d" c.print c.cr
	'scliente ! ;

:recibe
	scliente 0? ( drop acepta ; )
	dup netcheck 0? ( 2drop ; ) drop
	dup 'mensaje 1024 tcprecv -? ( drop 0 'scliente ! ; )
	'mensaje + 0 swap c!
	'mensaje c.print c.cr
	tcpclose
	0 'scliente !
	1 'nn +!
	;


:main
	c.draw
	c.keys
	recibe

	key
	>esc< =? ( exit )
	drop
	;

:printserver
	'ip @ dup $ff and
	swap 8 >> dup $ff and
	swap 8 >> dup $ff and
	swap 8 >> $ff and
	"Server IP Address : %d.%d.%d.%d" c.print c.cr
	'ip 4 + @
	"port: %d" c.print c.cr
	;

:netini
	mark
	sw sh c.full
	$111111 c.paper
	c.cls
	$ff0000 c.ink "r" c.print
	$ff00 c.ink "3" c.print
	$ffffff c.ink " server demo" c.print c.cr

	'ip 0 9999 nethost | 0=server 9999 port
	printserver
	'ip tcpopen 'sockserver !
	sockserver "server:%d" c.print c.cr
	;

:netend
    sockserver 1? ( dup tcpclose ) drop
	;

:
	netini
	'main onshow
	netend ;