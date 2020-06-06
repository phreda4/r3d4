|REBOTE game
|MEM 1024
|SCR 1200 675

^r3/lib/gui.r3
^r3/lib/vdraw.r3
^r3/lib/gr.r3
^r3/lib/cursor.r3

:keyboard key >esc< =? ( exit ) drop ;

#MAXPOWER

#barsx #barsy | bar start
#barex #barey | bar end

| ball dynamics
#bx 50.0 #by 75.0 #vx 1.0 #vy 0.0 #g 0.1

:stats_ball
	by bx "x:%f y:%f" print cr
	vy vx "vx:%f vy:%f" print cr ;
	
:update_ball
	vy g + 'vy !
	bx vx + 'bx !
	by vy + 'by !
	by 450.0 >? ( vy -1.0 *. 'vy ! ) drop
	;

| compute which side of a line a point is
| https://math.stackexchange.com/questions/274712/calculate-on-which-side-of-a-straight-line-is-a-given-point-located
:side | ( -- 1/-1 )
      bx 16 >> barsx -
      barey barsy -
      *
      by 16 >> barsy -
      barex barsx -
      *
      - +? ( drop 1 ; ) drop -1 ;

:setblue $FF 'ink ! ;

:setred $FF0000 'ink ! ;

:draw_disk 20 20 bx 16 >> by 16 >> bellipseb ;

:draw_ball
	side dup "side: %d" print cr
	+? ( setblue draw_disk drop ; )
	setred draw_disk drop ;

:rot- rot rot ;

:calcpower | ( dist -- pow )
	   16 << MAXPOWER /. ;

:draw_bar barsx barsy barex barey rot - rot- swap - swap distfast
	  calcpower "power: %f" print cr
	  xypen barsx barsy 2 glineg ;

:main home cls gui
      [ xypen 'barsy ! 'barsx ! ; ]
      [ xypen 'barey ! 'barex ! draw_bar ; ]  onDnMove
      update_ball
      stats_ball
      draw_ball
      $ffffff 'paper !
      0 'ink !
      keyboard
      acursor ;

:init sw sh distfast 16 << 'MAXPOWER ! ;

: init 'main onshow ;
