# r3 programming language

r3 is a concatenative language of the forth family, more precisely it takes elements of ColorForth. Word colors are encoded by a prefix: in r3 this prefix is explicit.

This repository has a windows (r3.exe) and a linux version (r3lin). There are first versions for the web (emscripten) and the Raspberry Pi.

For Linux and Raspberry Pi, remember to run "chmod +x" on the executable file.

## History

I start with r4 in 2005, in 2020 I develop r3 with 64 bits and some internal diferences, more clear vm and some ideas, breaking r4 code, in 2021 I experiment with DLL linking more concise with 64 bits and remove all SO conecction (now are DLL calls), I think it is a real usefull version, but R3d4 (the prev version) has implementationfor WIN,LIN, RPI and MAX, this version can have this SO but need make all the connetion, not for now.

### 2005 :r4 first lang, 
	lang: https://github.com/phreda4/r4   
	vm: https://github.com/phreda4/r4MV

### 2020 r3 version r3d4 (this name is thinking for make complete enviroment), 
	lang: https://github.com/phreda4/r3d4 
	vm: https://github.com/phreda4/r3vm

### 2021 r3 this version
	lang: this repository
	vm: https://github.com/phreda4/r3evm
 
## How the language works

A WORD is defined as a sequence of letters separated by spaces, there are three exceptions to improve the expressiveness of the language that are seen later.

Each word can be a number or is searched in the DICTIONARY.

If it is a valid number, in decimal, binary (%), hexa ($) or fixed point (0.1) its value is pushed to DATA STACK.

Like all FORTH, the DATA STACK is the memory structure used to perform intermediate calculations and pass parameters between words.

If the word is NOT a valid number, then it is searched in the DICTIONARY, if it is not found, it is an ERROR, the rule is "every word used must be defined before".

The language has a BASIC DICTIONARY that is already defined, from which new WORDS are defined that will be used to build the program.

## BASE word list:

We use `|` to indicate comment until the end of the line (the first exception to word separation).

Each word can take and/or leave values of the DATA STACK, this is expressed with a state diagram of the stack before -- and after the word.

for example

```
+ | a b -- c
```
the word + takes the two elements from the top of the DATA STACK, consumes them and leaves the result.
In addition to a modification in the stack, there may also be a lateral action, for example:

```
REDRAW | --
```
It does not consume or produce values in the stack but it updates the graphic screen with the buffer in memory, this is a side effect.

```
;	| End of Word
(  )	| Word block to build IF and WHILE
[  ]	| Word block to build nameless definitions
EX	| Run a word through your address
```

## Conditional, together with blocks make the control structures
```
0? 1?	| Zero and non-zero conditionals
+? -?	| Conditional positive and negative
<? >?	| Comparison conditions
=? >=? 	| Comparison conditions
<=? <>?	| Comparison conditions
AND? NAND?	| Logical conditioners AND and NOT AND
BT?	| Conditional between
```

## Words to modify the DATA STACK
```
DUP	| a -- a a
DROP	| a --
OVER	| a b -- a b a
PICK2	| a b c -- a b c a
PICK3	| a b c d -- a b c d a
PICK4	| a b c d e -- a b c d e a
SWAP	| a b -- b a
NIP	| a b -- b
ROT	| a b c -- b c a
2DUP	| a b -- a b a b
2DROP	| a b --
3DROP	| a b c --
4DROP	| a b c d --
2OVER	| a b c d -- a b c d a b
2SWAP	| a b c d -- c d a b
```

## Words to modify the RETURN STACK
```
>R	| a --		; r: -- a
R>	| -- a 		; r: a --
R@	| -- a 		; r: a -- a
```

## Logical operators
```
AND	| a b -- c
OR	| a b -- c
XOR	| a b -- c
NOT	| a -- b
```

## Arithmetic Operators
```
+	| a b -- c
-	| a b -- c
*	| a b -- c
/	| a b -- c
<<	| a b -- c
>>	| a b -- c
>>>	| a b -- c
MOD	| a b -- c
/MOD	| a b -- c d
*/	| a b c -- d
*>>	| a b c -- d
<</	| a b c -- d
NEG	| a -- b
ABS	| a -- b
SQRT	| a -- b
CLZ	| a -- b
```

## Access to Memory

`@` fetch a value from memory
`!` store a value in memory

```
@	| a -- [a]
C@	| a -- b[a]
Q@	| a -- q[a]
@+	| a -- b [a]
C@+	| a -- b b[a]
Q@+	| a -- b q[a]
!	| a b --
C!	| a b --
Q!	| a b --
!+	| a b -- c
C!+	| a b -- c
Q!+	| a b -- c
+!	| a b --
C+!	| a b --
Q+!	| a b --
```

## Help registers facility

Registers to traverse memory and read, copy or fill values

```
>A	| a --
A>	| -- a
A@	| -- a
A!	| a --
A+	| a --
A@+	| -- a
A!+	| a --
>B	| a --
B>      | -- a
B@	| -- a
B!	| a --
B+      | a --
B@+     | -- a
B!+     | a --
```

## Copy and Memory Filling

Block memory operation, only for data memory

```
MOVE	| dst src cnt --
MOVE>	| dst src cnt --
FILL	| dst fill cnt --
CMOVE	| dst src cnt --
CMOVE>	| dst src cnt --
CFILL	| dst fill cnt --
QMOVE	| dst src cnt --
QMOVE>	| dst src cnt --
QFILL	| dst fill cnt --
```

## Use and Interaction with the Operating System

```
UPDATE	| --
REDRAW	| --
MEM	| -- a
SW	| -- a
SH	| -- a
VFRAME	| -- a
XYPEN	| -- a b
BPEN	| -- a
KEY	| -- a
CHAR	| -- a
MSEC	| -- a
TIME	| -- a
DATE	| -- a
LOAD	| m "filename" -- lm
SAVE	| m cnt "filename" --
APPEND	| m cnt "filename" --
FFIRST	| a -- b
FNEXT	| a -- b
SYS	| "sys" --
```

## Prefixes in words

* `|` ignored until the end of the line, this is a comment
* `^` the name of the file to be included is taken until the end of the line, this allows filenames with spaces.
* `"` the end of quotation marks is searched to delimit the content, if there is a double quotation mark `""` it is taken as a quotation mark included in the string.
* `:` define action
* `::` define action and this definition prevails when a file is included (* exported)
* `#` define data
* `##` define exported data
* `$` define hexadecimal number
* `%` defines binary number, allows the `.` like `0`
* `'` means the direction of a word, this address is pushed to DATA STACK, it should be clarified that the words of the BASIC DICTIONARY have NO address, but those defined by the programmer, yes.

Programming occurs when we define our own words.
We can define words as actions with the prefix:

```
:addmul + * ;
```

or data with the prefix #

```
#lives 3
```

`: ` only is the beginning of the program, a complete program in r3 can be the following

```
:sum3 dup dup + + ;

: 2 sum3 ;
```


## Conditional and Repeat

The way to build conditionals and repetitions is through the words `(` and `)`

for example:
```
5 >? ( drop 5 )
```

The meaning of these 6 words is: check the top of the stack with 5, if it is greater, remove this value and stack a 5.

The condition produces a jump at the end of the code block if it is not met. It becomes an IF block.

r3 identifies this construction when there is a conditional word before the word `(`. If this does not happen the block represents a repetition and, a conditional in that this repetition that is not an IF is used with the WHILE condition.

for example:
```
1 ( 10 <?
	1 + ) drop
```

account from 1 to 9, while the Top of stack is less 10.

You have to notice some details:

There is no IF-ELSE construction, this is one of the differences with: r4, on the other hand, ColorForth also does not allow this construction, although it seems limiting, this forces to factor the part of the code that needs this construction, or reformulate the code.

In: r4 could be constructed as follows

```
...
1? ( notzero )( zero )
follow
```

It must become:

```
:choice 1? ( nocero ; ) zero ;

...
choice
follow
```

Sometimes it happens that rethinking code logic avoids ELSE without the need to do this factoring. There are also tricks with bit operations that allow you to avoid conditionals completely but this no longer depends on the language.

Another feature to note that it is possible to perform a WHILE with multiple output conditions at different points, I do not know that this construction exists in another language, in fact it emerged when the way to detect the IF and WHILE was defined

```
'list ( c@+
	1?
	13 <>?
	emit ) 2drop
```

Does this repetition meet that the byte obtained is not 0 ` 1? ` and that is not 13 ` 13 <>? `, in any of the two conditions the WHILE ends

Another possible construction, that if it is in other FORTH, is the definition that continues in the following.
For example, define1 adds 3 to the top of the stack while define2 adds 2.

```
:define1 | n -- n+3
	1 +
:define2 | n -- n+2
	2 + ;
```

## Recursion

Recursion occurs naturally, when the word is defined with ` : ` it appears in the dictionary and it is possible to call it even when its definition is not closed.

```
:fibonacci | n -- f
	2 <? ( 1 nip ; )
	1 - dup 1 - fibonacci swap fibonacci + ;
```

## Call Optimization

When the last word before a `;` is a word defined by the programmer, both in the interpreter and in the compiler, the call is translated into JMP or jump and not with a CALL or call with return, this is commonly called TAIL CALL and saves a return in the chain of words called.

This feature can convert a recursion into a loop with no callback cost, the following definition has no impact on the return stack.

```
:loopback | n -- 0
	0? ( ; )
	1 -
	loopback ;
```



