| Server test
| PHREDA 2020
|scr 640 480
^r3/lib/gui.r3
^r3/util/console.r3

#socketset
#ip 0 0
#sock 0

| active,socket,peer,n,a,m,e,e
#players * 1024
#players> 'players

:+player | "name" peer socket active --
	players> >a
	a!+ a!+ a!+
	5 ( 1? 1 -
		swap @+ a!+ swap
		) 2drop
	0 a> 1 - c!
	a> 'players> ! ;

#newsock

:serverop
	"severop" c.print c.cr
	sock TCPACCEPT 'newsock !
	"jugador n"
	newsock TCPADR
	newsock 1 +player
	;

#data * 1024


:recibe
	socketset 0 NETSETCHECK
	0? ( drop ; ) drop
	"." c.print
	sock netcheck 1? ( serverop ) drop
	;

:sendmsg
	"hola" c.print c.cr
	sock "hola" 512 tcpsend
	drop ;

:main
	c.draw
|	c.keys
|	recibe

	key
	>esc< =? ( exit )
	<f1> =? ( sendmsg )
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
	$ffffff c.ink " client demo" c.print c.cr


	'ip "localhost" 7777 nethost | 0=server 7777 port
	printserver
	'ip tcpopen 'sock !
	sock "server:%d" c.print c.cr

	2 netset 'socketset !
	socketset sock tcpadd

	;

:netend
    sock 1? ( dup tcpclose ) drop
|	socketset 1? ( dup setfree ) drop
	;

:
	netini
	'main onshow
	netend ;