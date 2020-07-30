| blur
| PHREDA 2020
|--------------------

#rgba

#sumRed
#sumGreen
#sumBlue

#wid
#hei
#radius

#sumLookupTable
#indexLookupTable

:calc1
	0 ( radius <=? dup 2 << a!+ 1 + ) drop ;

:calcind
	radius wid <? ( drop calc1 ; ) drop
	0 ( wid <? dup 2 << a!+ 1 + )
	( radius <=? wid 1 - 2 << a!+ 1 + ) drop 	;

::iniblur | w h radio --
	'radius ! 'hei ! 'wid !
	mark
	here
	dup 'rgba ! wid hei * 2 << +
	dup 'sumLookupTable ! radius 1 << 1 + 10 << +
	dup 'indexLookupTable ! radius 1 + 2 << +
	'here !

	sumLookupTable >a
	radius 1 << 1 + 8 <<
	0 ( over <?
		dup 16 << pick2 / a!+
		1 + ) 2drop
	indexLookupTable >a
	calcind
	;

::endblur
	empty
	;

:rgb!
	sumRed 2 << sumLookupTable + @ $ff0000 and
	sumGreen 2 << sumLookupTable + @ 8 >> $ff00 and or
	sumBlue 2 << sumLookupTable + @ 16 >> $ff and or
	b!
	;

:blurPass | (int[] srcPixels, int[] dstPixels
	hei ( 1? 1 -
		a@
		dup $ff and radius 1 + * 'sumBlue !
		dup 8 >> $ff and radius 1 + * 'sumGreen !
		16 >> $ff and radius 1 + * 'sumRed !

		indexLookupTable 4 + radius
		( 1? 1 - swap
 			@+ a> + @
			dup $ff and 'sumBlue +!
			dup 8 >> $ff and 'sumGreen +!
			16 >> $ff and 'sumRed +!
    		swap ) 2drop

		0 ( wid <?
			rgb!
			hei 2 << b+
			dup radius + 1 + wid 1 - min
			2 << a> + @
			over radius - 0clamp
			2 << a> + @
			over $ff and over $ff and - 'sumBlue +!
			over 8 >> $ff and over 8 >> $ff and - 'sumGreen +!
			16 >> $ff and swap 16 >> $ff and - 'sumRed +!
			1 + ) drop

		wid 2 << a+
    	) drop
	;


:blur | (int[] inputRGBA, int width, int height, int radius, int iterations)
	vframe >a
	rgba >b
	blurPass
	wid hei 'wid ! 'hei !
	rgba >a
	vframe >b
	blurPass
	wid hei 'wid ! 'hei !
	;