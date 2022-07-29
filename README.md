simpsons-rule
============
[![CI tests](https://github.com/shamazmazum/simpsons-rule/actions/workflows/test.yml/badge.svg)](https://github.com/shamazmazum/simpsons-rule/actions/workflows/test.yml)

This system is for numeric integration of functions of one variable. See an
example:

~~~~{.lisp}
CL-USER> ;; Integrate sin(500x)/x from -5 to 5
; No value
CL-USER> (simpsons-rule:integrate
 (serapeum:hook
  (serapeum:flip #'/)
  (alexandria:compose
   #'sin
   (alexandria:curry #'* 500)))
 -5d0 5d0)
3.1409850016443404d0
~~~~

All numeric arguments to `SIMPSONS-RULE:INTEGRATE` must be of the same floating
point type `T` and the function must be of the type `T -> T`.

The compiler produces specialized code when types of arguments are known at
compile time and when optimizing for speed:

~~~~
CL-USER> (defun integrate-in-unit-range (fn)
  (declare (optimize speed))
  (simpsons-rule:integrate fn 0d0 1d0))
INTEGRATE-IN-UNIT-RANGE
CL-USER> (disassemble 'integrate-in-unit-range)
; disassembly for INTEGRATE-IN-UNIT-RANGE
; Size: 46 bytes. Origin: #x224A91BD                          ; INTEGRATE-IN-UNIT-RANGE
; BD:       488B3DC4FFFFFF   MOV RDI, [RIP-60]                ; 0.0d0
; C4:       488B35B5FFFFFF   MOV RSI, [RIP-75]                ; 1.0d0
; CB:       488B05A6FFFFFF   MOV RAX, [RIP-90]                ; 1.0d-6
; D2:       488945F0         MOV [RBP-16], RAX
; D6:       488B5DF0         MOV RBX, [RBP-16]
; DA:       B908000000       MOV ECX, 8
; DF:       FF7508           PUSH QWORD PTR [RBP+8]
; E2:       B882B74520       MOV EAX, #x2045B782              ; #<FDEFN SIMPSONS-RULE:INTEGRATE/DOUBLE-FLOAT>
; E7:       FFE0             JMP RAX
; E9:       CC10             INT3 16                          ; Invalid argument count trap
NIL
CL-USER> 
~~~~

`SIMPSONS-RULE:INTEGRATE` expands to one of specialized versions: either
`SIMPSONS-RULE:INTEGRATE/SINGLE-FLOAT` or `SIMPSONS-RULE:INTEGRATE/DOUBLE-FLOAT`
when possible.
