| SAVEPNG
| incompresed
| from https://www.nayuki.io/page/tiny-png-output
| PHREDA 2020

^r3/lib/mem.r3
^r3/lib/crc32.r3

#DEFLATE_MAX_BLOCK_SIZE 65535

#pngw
#pngh
#idatsize
#uncompRm
#numBlocks
#idatSize
#pngcrc
#pngadler

:,big | nbigendian --
	dup 24 >> ,c dup 16 >> ,c dup 8 >> ,c ,c ;

#icrc
:inicrc |
	here 'icrc ;

:getcrc |
	icrc dup here - crc32 ;

:,chunk | data len str --
	inicrc
	,s
	dup ,big
	( 1? swap c@+ ,c swap 1 - )
	2drop
	getcrc ,big ;

:header
	pngw 3 * 1 + pngh * dup 'uncompRm !
	dup DEFLATE_MAX_BLOCK_SIZE /
	swap DEFLATE_MAX_BLOCK_SIZE mod 1? ( drop 1 ) +
	'numBlocks !
	numBlocks 5 * 6 + uncompRm + 'idatSize !

	| PNG header
	$89504E47 ,big
	$0D0A1A0A ,big

								| IHDR chunk
	$00 ,c $00 ,c $00 ,c $0D ,c
	$49 ,c $48 ,c $44 ,c $52 ,c
	pngw ,big
	pnfh ,big				| 'width' 'height' placeholder
	$08 ,c $02 ,c $00 ,c $00 ,c $00 ,c

	here 17 - 17 crc32 ,c		| IHDR CRC-32 placeholder

	| IDAT chunk
	idatsize ,big		 		| 'idatSize' placeholder
	$49 ,c $44 ,c $41 ,c $54 ,c
								| DEFLATE data
	$08 ,c $1D ,c

	$D7245B6B 'pngcrc !
	1 'pngadler !
	;


:footer
	pngadler ,big			| DEFLATE Adler-32 placeholder
	here 4 - 4 pngcrc crc32n ,big	| IDAT CRC-32 placeholder
	| IEND chunk
	$00 ,c $00 ,c $00 ,c $00 ,c
	$49 ,c $45 ,c $4E ,c $44 ,c
	$AE ,c $42 ,c $60 ,c $82 ,c
	;


:beginline |  Beginning of line - write filter method byte
	0 ,c
	here 1 - 1 pngcrc crcn 'pngcrc !
	here 1 - 1 pngcrc adlern 'pngcrc !
|			adler32(this, b, 1);
|			this->positionX++;
|			this->uncompRemain--;
|			this->deflateFilled++;


:encodeline | y -- y ; Write some pixel bytes for current line
	vframe over sw * 2 << + >a
	0 ( pngw <?
		a@+ dup $ff ,c dup 8 >> $ff and ,c 16 >> $ff and ,c


		1 + ) drop ;

	uint16_t n = DEFLATE_MAX_BLOCK_SIZE - this->deflateFilled;
	if (this->lineSize - this->positionX < n) n = (uint16_t)(this->lineSize - this->positionX);
	if (count < n) n = (uint16_t)count;
	if (!write(this, pixels, n))
			return TINYPNGOUT_IO_ERROR;

	// Update checksums
	crc32(this, pixels, n);
	adler32(this, pixels, n);

	// Increment positions
	count -= n;
	pixels += n;
	this->positionX += n;
	this->uncompRemain -= n;
	this->deflateFilled += n;

		if (this->deflateFilled >= DEFLATE_MAX_BLOCK_SIZE)
			this->deflateFilled = 0;  // End current block


:encodePNG
	header
	0 ( pngh <?
        encodeline
		1 + ) drop
	footer
	;


::sevepng | "filename" w h --
	'pngh ! 'pngw !
	mark
	encodePNG
	savemem
	empty
	;

