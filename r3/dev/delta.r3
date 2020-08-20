|DELTA - MC 2020
|Sprites from Jacob Zinman-Jeanes, below some information included in his package:
|  --
|  These sprites were designed by Jacob Zinman-Jeanes (http://jeanes.co) for Gamedevtuts+ (http://gamedev.tutsplus.com/).
|  http://gamedev.tutsplus.com/articles/news/enjoy-these-totally-free-space-based-shoot-em-up-sprites/
|  --
|
|MEM 2048
|SCR 1600 900

^r3/lib/gui.r3
^r3/lib/sys.r3
^r3/lib/mem.r3
^r3/lib/print.r3
^r3/lib/sprite.r3
^r3/util/loadimg.r3

| star format:    10 bits for x, 10 bits for y, 3 bits for speed
#nstars  128
#stars * 512 | 4 * nstars

#ship #shipi 0 #shipn 4
#enemy #enemyi 0 #enemyn 6

:packstar | ( speed x y - packed )
	  3 << swap 13 << or or ;

:newstar | ( -- speed x y )
	 rand abs 7 mod 1 +   | speed
	 rand abs sw 1 - mod  | x
	 rand abs sh 1 - mod  | y
	 ;

:rnewstar | ( -- speed SW y )
	  newstar nip sw swap ;
	 
:inistars 0 ( nstars <? dup
	  2 << 'stars + newstar packstar swap !
	  1 + ) drop ;

:ini rerand
     inistars
     mark
     64 29 "media/img/Spritesheet_64x29.png" loadimg tileSheet 'ship !
     40 30 "media/img/eSpritesheet_40x30.png" loadimg tileSheet 'enemy ! ;

:keyboard key
	  >esc< =? ( exit ) 
	  drop ;

:shoot | ( -- )
       home "boom" print ;

:drawship | ( x y -- )
	   shipi rot rot ship ssprite
	   shipi 1 + shipn mod 'shipi ! ;
	   
:unpackstar | ( packed -- speed x y )
	    dup %111 and
	    swap dup 13 >>
	    swap 3 >> %1111111111 and
	    ;

:drawenemy | ( x y -- )
	    'stars @ unpackstar
	    enemyi rot rot enemy ssprite
	    drop | drop speed
	    enemyi 1 + enemyn mod 'enemyi ! ;
	    
:drawstar | ( packed -- )
	   unpackstar
	   2dup op
	   >r swap - 1 - r> line ;

:drawstars | ( -- )
	    0 ( nstars <? dup
	    2 << 'stars + @ drawstar
	    1 + ) drop ;

:movestar | ( speed x y - speed x' y )
	   pick2 rot swap - -? ( 3drop rnewstar ; ) swap ;

:movestars | ( -- )
	    0 ( nstars <? dup
	    2 << 'stars + dup @ unpackstar movestar packstar swap !
	    1 + ) drop ;

:game cls
      drawstars
      drawenemy
      xypen drawship
      movestars
      bpen 1? ( shoot ) drop
      keyboard ;

: ini
  'game onshow ;
