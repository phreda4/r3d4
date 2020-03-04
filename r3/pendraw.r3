| Example 5 DRAW in Canvas

^r3/lib/gr.r3
^r3/lib/rand.r3

#last 0

:show
  key 27 =? ( exit ) drop
  bpen 0? ( 'last ! ; ) drop
  last 0? ( drop 1 'last ! xypen op
  	rand 'ink !
  	; ) drop
  xypen line ;

:
'show onshow
;