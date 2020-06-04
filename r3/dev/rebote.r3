|REBOTE game
|MEM 4096
|SCR 1200 675

^r3/lib/gui.r3
^r3/lib/vdraw.r3
^r3/lib/gr.r3
^r3/lib/cursor.r3

:keyboard key >esc< =? ( exit ) drop ;

#bx 50.0 #by 75.0 #vx 1.0 #vy 0.0 #g 0.1

#sx #sy

:stats_ball
	by bx " x:%f  y:%f" print cr
	vy vx "vx:%f vy:%f" print cr ;
	
:update_ball
	vy g + 'vy !
	bx vx + 'bx !
	by vy + 'by !
	by 450.0 >? ( vy -1.0 *. 'vy ! ) drop
	;

:draw_ball 20 20 bx 16 >> by 16 >> bellipseb ;
	
:setstart xypen 'sy ! 'sx ! ;

:setend xypen sx sy 2 glineg ;

:main home cls gui
      [ setstart ; ] [ setend ; ]  onDnMove
      update_ball
      stats_ball
      draw_ball
      $ffffff 'paper !
      0 'ink !
      keyboard
      acursor ;

:init ;

: init 'main onshow ;
