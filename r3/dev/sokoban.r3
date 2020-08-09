| SOKOBAN - MC 2020
| Sprites from: https://kenney.nl/assets/
| Levels  from: https://github.com/begoon/sokoban-maps
|
|MEM 16384
|SCR 1200 675

^r3/lib/gui.r3
^r3/lib/sys.r3
^r3/lib/mem.r3
^r3/lib/print.r3
^r3/lib/sprite.r3
^r3/lib/xfb.r3
^r3/lib/fontr.r3
^r3/util/loadimg.r3
^media/rft/archivoblackregular.rft
^r3/dev/sokoban.levels.r3

| sprites
#spritesheet
|        ground wall box boxgoal groundgoal
#sprites 89     98   6   9       102

|       playerup playerdn playerri playerle
#player 55       52       78       81

#playerx #playery

#playerdir 0
#UP 0 #DN 1 #RI 2 #LE 3

#movex  0  0  1 -1
#movey -1  1  0  0

#FLOOR 0 #WALL 1 #BOX 2 #BOXGOAL 3 #GOAL 4

|  -- Format of the compressed levels ( RLE style )
|  -- Prolog
|         char size_x
|         char size_y
|  -- Elements
|         counter (bits)
|                 0                - 1 symbol
|                 1 D3 D2 D1       - 2+D3*4+D2*2+D1 symbols (9 max)
|         char (bits)
|                 0 0              - an empty space              -> 0
|                 0 1              - the wall                    -> 1
|                 1 0              - the box                     -> 2
|                 1 1 1            - the box already in place    -> 3
|                 1 1 0            - the goal for a box          -> 4
|  -- Epilog
|         char man_x
|         char man_y

#xmap #ymap #scale

#NMAPS 63

#nboxes 0

| storing played moves
#moves * 1000
#curmove 0

#maploaded 0 #curmap 0
#maps 'lvlaz  'lvlbz  'lvlcz
      'lvl1z  'lvl2z  'lvl3z 'lvl4z 'lvl5z 'lvl6z 'lvl7z 'lvl8z 'lvl9z 'lvl10z
      'lvl11z 'lvl12z 'lvl13z 'lvl14z 'lvl15z 'lvl16z 'lvl17z 'lvl18z 'lvl19z 'lvl20z
      'lvl21z 'lvl22z 'lvl23z 'lvl24z 'lvl25z 'lvl26z 'lvl27z 'lvl28z 'lvl29z 'lvl30z
      'lvl31z 'lvl32z 'lvl33z 'lvl34z 'lvl35z 'lvl36z 'lvl37z 'lvl38z 'lvl39z 'lvl40z
      'lvl41z 'lvl42z 'lvl43z 'lvl44z 'lvl45z 'lvl46z 'lvl47z 'lvl48z 'lvl49z 'lvl50z
      'lvl51z 'lvl52z 'lvl53z 'lvl54z 'lvl55z 'lvl56z 'lvl57z 'lvl58z 'lvl59z 'lvl60z

| data for the current map, max is 40*25
#mapw #maph
#mapwh 0
#map * 1000
#map>

| ----- Decompression related code -----

:getmapwh | ( adr1 -- adr2 )
   c@+ 'mapw ! c@+ 'maph ! ;

:getplayerxy | ( adr -- )
   c@+ 'playerx ! c@ 'playery ! ;

#ptr #bitn

:getbyte | ( adr bitn - byte )
	 8 / + c@ ;
 
| gets next bit in the bitstream
:get1bit | ( -- 0/1 )
	 ptr bitn
	 dup rot swap getbyte swap
	 8 mod 1 + 8 swap - >>     | 8-((i%8)+1)
	 1 and
	 1 'bitn +! ;

:calccounter | ( b3 b2 b1 - val )
	    rot 4 * rot 2 * rot + + 2 + ;

:get3bits | ( -- b1 b2 b3 )
	    get1bit get1bit get1bit ;

:getcounter | ( -- counter )
	    get1bit 0? ( drop 1 ; ) drop
	    get3bits
	    calccounter ;
	    
:getcharacter | ( -- character )
	      get1bit 0? ( drop get1bit 0? ( ; ) drop 1 ; ) drop
	      get1bit 0? ( drop 2 ; ) drop
	      get1bit 0? ( drop 4 ; ) drop 3 ;

:writepair | ( char cnt -- )
	  ( 1? over map> c!+ 'map> ! 1 - ) 2drop ;

:readpair | ( -- cnt )
       getcounter dup getcharacter rot writepair ;

| decompresses a level in the current map
:mapdecomp | ( lvl - )
	   getmapwh 'ptr ! 0 'bitn !
	   'map 'map> !
	   mapw maph * 'mapwh !
	   0 ( mapwh <? readpair + ) drop

	   | bitn is sometimes not at the end of a byte
	   bitn 8 mod 1? ( bitn dup 8 mod 8 swap - + 'bitn ! ) drop

	   ptr bitn 8 / + getplayerxy
	   1 'maploaded ! ;

| ----- 

| compute size of sprite to fit same size _w,h sprites inside 7/8 of the screen
:calcscale sw 7 * 8 / mapw /
	   sh 7 * 8 / maph /
	   min 'scale ! ;

:xy2map mapw * + 'map + ;

| save the player position and the tile on which the player is in this frame
#px #py #ptile
:saveplayer playerx playery
	    2dup 'py ! 'px !
	    xy2map c@ 'ptile c! ;

:scaltrans | ( x y -- x*scale+xmap y*scale+ymap )
	   scale * ymap + swap scale * xmap + swap ;

:drawtile rot rot scaltrans scale scale spritesheet sspritesize ;
:drawtile+ | ( x y tile -- ) draws floor under tiles with transparency
	   89 =? ( drawtile ; )
	   102 =? ( drawtile ; )
	   pick2 pick2 89 drawtile
	   drawtile ;

:restoretile px -1 =? ( drop ; ) drop
	     px py ptile 4 * 'sprites + @ drawtile ;

:drawplayer restoretile
	    playerx playery playerdir 4 * 'player + @ drawtile ;

:drawmap
	0 ( maph <?
		0 ( mapw <?
		  2dup swap 2dup xy2map c@ 4 * 'sprites + @ drawtile+
		1 + ) drop
	1 + ) drop ;

:nextmap curmap 1 + NMAPS mod 'curmap ! 0 'maploaded ! ;
:prevmap curmap 1 - 0 max 'curmap ! 0 'maploaded ! ;

:box? xy2map c@ 2 =? ( drop nboxes 1 + 'nboxes ! ; ) drop ;
:won? 0 'nboxes !
      0 ( mapw <?
		0 ( maph <?
		  2dup box?
		1 + ) drop
	1 + ) drop
	nboxes 0? ( nextmap ) drop ;

:playertrans | (dx dy -- player+dx player+dy )
	     playery + swap playerx + swap ;

:x,y*2 |( x y -- 2*x 2*y)
	 dup + swap dup + swap ;

:rot- rot rot ;

:3dup pick2 pick2 pick2 ;

:updatemap! | ( dx dy tile -- )
	    rot- playertrans
	    3dup rot 4 * 'sprites + @ drawtile+
	    xy2map c! ;

:pushbox! | ( dx dy tile1 tile2 -- )
	  pick3 pick3 x,y*2 rot updatemap! updatemap! ;

:pushbox? | ( dx dy ptile -- 0/1 ) ptile is tile under the player if the move happens
	  rot-
	  2dup x,y*2 playertrans xy2map c@ | what tile behind the box in the push direction?
	  FLOOR =? ( drop pick2 BOX     pushbox! drop 1 ; )
	  GOAL  =? ( drop pick2 BOXGOAL pushbox! drop 1 ; )
	  4drop 0 ;

| can the player move to (playerx+dx, playery+dy) ? Also deals with box pushing
:movelogic | ( dx dy -- 0/1 )
	   saveplayer                 | to redraw the tile under the player
	   2dup playertrans xy2map c@ | what tile are we trying to move on ?
	   FLOOR   =? ( 3drop 1 ; )
	   BOX     =? ( drop FLOOR pushbox? ; )
	   BOXGOAL =? ( drop GOAL  pushbox? ; )
	   GOAL    =? ( 3drop 1 ; )
	   3drop 0 ;

:setdir 'playerdir ! ;

:adjustplayer playertrans 'playery ! 'playerx ! ;

:trymove | ( dir dx dy -- )
	 2dup movelogic 1? ( drop adjustplayer 'moves curmove + c! 1 'curmove +! ; )
	 4drop ;

:getdxdy | ( dir -- dx dy )
	 dup
	 2 << 'movex + @
	 swap
	 2 << 'movey + @
	 ;
	 
:try | ( dir -- )
     dup setdir
     dup getdxdy
     trymove ;

:trymove2 | ( dir dx dy -- )
	  2dup movelogic 1? ( drop adjustplayer ; ) 4drop ;

:undo! | ( dir -- )
       dup setdir
       getdxdy
       trymove2 ;

:resetp -1 dup 'px ! 'py ! ;

:loadcurmap 'maps curmap 4 * + @ mapdecomp calcscale resetp ;

:undo | ( -- )
      curmove 0? ( drop ; ) drop | nothing has been played yet
      loadcurmap cls drawmap
      | run moves from 0 to (curmove-1)
      0 ( curmove 2 - <=?
      	dup
	'moves + c@ undo!
	1 + ) drop
      curmove 1 - 'curmove !
      ;

:keyboard key
	  >esc< =? ( exit )
	  <pgup> =? ( nextmap )
	  <pgdn> =? ( prevmap )
	  <up> =? ( UP try )
	  <dn> =? ( DN try )
	  <ri> =? ( RI try )
	  <le> =? ( LE try )
	  <f1> =? ( 0 'maploaded ! )
	  <f2> =? ( undo )
	  drop ;

| - - - - -

#dt 0
#framedt 0

:angle | ( val basis -- angle)
	swap $10000 * swap / $10000 2 / swap - ;

| x = a*sin(t), y = a*cos(2t)
:lsjw sw 3 / 16 << ;
:lsjh sh 3 / 16 << ;
:lsjx        cos lsjw *. 16 >> sw 2 / + ;
:lsjy 2.0 *. sin lsjh *. 16 >> sh 2 / + ;

:getxy 	1000 angle dup lsjx swap lsjy ;

:incdt dt 4 + 'dt ! ;

:animletter | ( l t -- )
	    getxy atxy print ;

:fontsize dt 1000 angle cos abs 128.0 *. 128.0 + 16 >> ;

#levelstr "Level %d"
#msg * 16
#letter " "

:buildmsg curmap 1 + 'levelstr sprint 'msg strcpy ;

:strlen count nip ;

:incframedt framedt 32 + 'framedt ! ;

:drawletters | ( -- )
	     'msg strlen
	     ( +? dup
	       'msg + c@ 'letter c!
	       'letter framedt animletter
	       incframedt
	       1 - ) drop ;

:screen key
	>esc< =? ( exit )
	>esp< =? ( exit )
	<pgup> =? ( nextmap exit )
	<pgdn> =? ( prevmap exit )
	drop
	xfb>
	dt 'framedt !
	archivoblackregular fontsize fontr!
	buildmsg drawletters
	incdt ;

:animation 'screen onshow ;

:black 0 'ink ! ;

:white $ffffff 'ink ! ;

:erase black
       sw 2 /
       ymap 1 -
       0 0 fillrect ;

:controlsini  home erase white
	      archivoblackregular 32 fontr!
	      ;
	      
:controlsanim controlsini
	      "ESC/SPACE: Start Level - " print
	      "PGUP: Next Level - " print
	      "PGDN: Previous Level" print
	      ;

:controlsplay controlsini
	      "ESC: Exit - " print
	      "Cursor: Move Character - " print
	      "F1: Restart Level - " print
	      "PGUP: Next Level - " print
	      "PGDN: Previous Level - " print
	      ;

:newmap loadcurmap cls drawmap controlsanim >xfb animation xfb> ;

:game home keyboard
      maploaded 0? ( newmap 0 'curmove ! ) drop | full screen drawn only once
      controlsplay
      drawplayer won? ;

:load_tilesheet | ( -- )
	64 64 "media/img/sokoban_tilesheet.png" loadimg tileSheet 'spritesheet ! ;

:topleft! | set top left of map
	  sw 16 / 'xmap !
	  sh 16 / 'ymap ! ;

:gray $eeeeee 'ink ! ;

:init	cls home gray
	mark
	load_tilesheet
	topleft!
	0 'curmap !
	iniXFB
	;

: init 'game onshow ;

