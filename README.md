simpsons-rule
============
[![CI tests](https://github.com/shamazmazum/simpsons-rule/actions/workflows/test.yml/badge.svg)](https://github.com/shamazmazum/simpsons-rule/actions/workflows/test.yml)

This system is for numeric integration of functions of one variable. See an
example:

~~~~{.lisp}
CL-USER> ;; Integrate sin(50x) + sin(55x) from 0 to 1
; No value
CL-USER> (simpsons-rule:integrate
 (lambda (x) (+ (sin (* 50 x)) (sin (* 55 x))))
 0d0 1d0 1d-3)

0.018480193010683304d0
~~~~

The compiler produces specialized code when types of arguments are known at
compile time.

`SIMPSONS-RULE:INTEGRATE` expands to one of specialized versions: either
`SIMPSONS-RULE::INTEGRATE/SINGLE-FLOAT` or `SIMPSONS-RULE::INTEGRATE/DOUBLE-FLOAT`
when possible.
