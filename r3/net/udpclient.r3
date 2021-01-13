| Client test UDP
| PHREDA 2021

^r3/lib/gui.r3
^r3/util/console.r3

#socketset
#serverip 0 0
#serversock 0
#packet



#data * 1024

:clientop | adr -- adr+8*4
	dup 4 + @ netcheck 0? ( drop 8 4 * + ; ) drop
	dup 4 + @ 'data 512 TCPRECV
|	-? ( finconeccion )
	drop
	'data c.print c.cr
	8 4 * +
	;


|typedef struct {
|    int channel;        /* The src/dst channel of the packet */
|    Uint8 *data;        /* The packet data */
|    int len;            /* The length of the packet data */
|    int maxlen;         /* The size of the data buffer */
|    int status;         /* packet status after sending */
|    IPaddress address;  /* The source/dest address of an incoming/outgoing packet */
|} UDPpacket;

:printserver | 'ip --
	@+ dup $ff and
	swap 8 >> dup $ff and
	swap 8 >> dup $ff and
	swap 8 >> $ff and
	"Server:%d.%d.%d.%d:" c.print
	@ dup 8 >> $ff and swap $ff and 8 << or
	"%d" c.print c.cr
	;

:printpacket | adr --
	@+ "Canal: %d" c.print c.cr
	@+ "Datos: %h" c.print c.cr
	@+ "len: %d" c.print c.cr
	@+ "maxlen: %d" c.print c.cr
	@+ "status: %d" c.print c.cr
	@ printserver ;

:net
	serversock packet UDPRECV
	1? ( packet printpacket ) drop

	;


:sendpack
	packet
	"hola" over 4 + @ strcpy
	5 over 8 + !
	'serverip q@ swap 20 + q!
	serversock -1 packet UDPSend
	;

:main
	c.draw
|	c.keys
	net

	key
	>esc< =? ( exit )
	<f1> =? ( sendpack )
	drop
	;




:netini
	mark
	sw sh c.full
	$111111 c.paper
	c.cls
	$ff0000 c.ink "r" c.print
	$ff00 c.ink "3" c.print
	$ffffff c.ink " Client demo" c.print c.cr

	2 netset 'socketset !
	0 UDPOPEN 'serversock !

|	sd -1 UDPPEER 'ipad !
|	ipad 4 + @ $ffff and |"%d" c.print c.cr
|	0 UDPOPEN 'serversock !
	'serverip "localhost" 6666 nethost
	32 UDPALLOC 'packet !

	socketset serversock udpadd

	;

:netend
    serversock 1? ( dup udpclose ) drop
	packet 1? ( dup UDPFREE ) drop
	;

:
	netini
	'main onshow
	netend ;