(in-package :simpsons-rule)
(deftype A->A (type) `(function (,type) (values ,type &optional)))

#+sbcl
(progn
  (sb-c:defknown integrate
      ((a->a real) real real real)
      real
      (sb-c:foldable sb-c:flushable sb-c:call sb-c::recursive))
  (sb-c:defknown %integrate/single-float
      ((a->a single-float) single-float single-float single-float)
      single-float
      (sb-c:foldable sb-c:flushable sb-c:call sb-c::recursive))
  (sb-c:defknown %integrate/double-float
      ((a->a double-float) double-float double-float double-float)
      double-float
      (sb-c:foldable sb-c:flushable sb-c:call sb-c::recursive)))

(macrolet ((def-integrate (name type &body docstring-and-declarations)
             `(progn
                (sera:-> ,name
                         ((A->A ,type)
                          ,type ,type ,type)
                         (values ,type &optional))
                (defun ,name (fn start end δ)
                  ,@docstring-and-declarations
                  (flet ((simpsons-rule (a b)
                           (* (/ (- b a) 6)
                              (+ (funcall fn a)
                                 (funcall fn b)
                                 (* 4 (funcall fn (/ (+ a b) 2)))))))
                    (if (> start end)
                        (- (,name fn end start δ))
                        (loop for x of-type ,type from start below end by δ sum
                              (simpsons-rule x (+ x δ))
                              of-type ,type)))))))
  (def-integrate integrate/single-float single-float
    (declare (optimize (speed 3))))
  (def-integrate integrate/double-float double-float
    (declare (optimize (speed 3))))
  (def-integrate integrate real
    "Integrate a function FN from START to END using the Simpson's
rule. Δ controls the argument's increment during integration. Smaller
values give more accurate result."))

#+sbcl
(progn
  (sb-c:deftransform integrate
      ((fn start end δ) (t single-float single-float single-float) *)
    '(integrate/single-float fn start end δ))
  (sb-c:deftransform integrate
      ((fn start end δ) (t double-float double-float double-float) *)
    '(integrate/double-float fn start end δ)))
