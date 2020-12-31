| Server test
| PHREDA 2020
^r3/lib/gui.r3
^r3/util/console.r3

#mensaje * 1024
#sockserver 0
#ip 0 0
#nn 0

#nset

#scliente 0
#socket * 256
#socketn

:aceptacliente
	sockserver TCPACCEPT 0? ( drop ; )
	dup socketn "aceppt %d %d" c.print c.cr
	nset over tcpadd
	'socket socketn 2 << + !
	1 'socketn +!
	;

#buff * 1024
:testclient | n -- n
	dup 2 << 'socket + @
	dup netcheck 0? ( 2drop ; ) drop
	'buff 1024 TCPrecv
	-? ( drop ; )
	'buff + 0 swap c!
	'buff c.print c.cr
	;

:recibe
	sockserver 0 NETSETCHECK | cnt
	0? ( drop ; ) drop
	sockserver NETCHECK 1? ( aceptacliente ) drop
	socketn
	( 1? 1 -
		testclient
		) drop
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

	'ip 0 9990 nethost | 0=server 9999 port
	printserver
	'ip tcpopen 'sockserver !
	sockserver "server:%d" c.print c.cr

	16 netset 'nset !
	nset sockserver tcpadd
	;

:netend
	scliente 1? ( dup tcpclose ) drop
    sockserver 1? ( dup tcpclose ) drop
	;

:
	netini
	'main onshow
	netend ;