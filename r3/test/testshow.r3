| Example 4

^r3/lib/gr.r3
^r3/util/polygr.r3

|--------------------
#x 10.0 #vx 3.18
#y 10.0 #vy 6.13

:hitx vx neg 'vx ! ;
:hity vy neg 'vy ! ;
 
:show
 cls
 x 16 >> sw >=? ( hitx ) 4 <=? ( hitx )
 y 16 >> sh >=? ( hity ) 4 <=? ( hity )
 16 fcircleg
 vx 'x +!
 vy 'y +!

 key
 >esc< =? ( exit )
 drop
 ;

|--------------------
:
'show onshow
;
