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
(sb-c:deftransform integrate
    ((fn start end δ) (t real real real) *)
  (let ((start-type (sb-c::lvar-type start))
        (end-type   (sb-c::lvar-type end))
        (δ-type     (sb-c::lvar-type δ))
        (single-float (sb-kernel:specifier-type 'single-float))
        (double-float (sb-kernel:specifier-type 'double-float)))
    (cond
      ((or (sb-kernel:csubtypep start-type double-float)
           (sb-kernel:csubtypep end-type   double-float)
           (sb-kernel:csubtypep δ-type     double-float))
       ;; Promote all arguments to double float
       '(integrate/double-float fn (float start 0d0) (float end 0d0) (float δ 0d0)))
      ((or (sb-kernel:csubtypep start-type single-float)
           (sb-kernel:csubtypep end-type   single-float)
           (sb-kernel:csubtypep δ-type     single-float))
       ;; Promote all arguments to single float
       '(integrate/single-float fn (float start 0f0) (float end 0f0) (float δ 0f0)))
      (t
       (sb-c::give-up-ir1-transform)))))
