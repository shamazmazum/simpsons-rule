(in-package :simpsons-rule)
(deftype A->A (type) `(function (,type) (values ,type &optional)))

(macrolet ((def-integrate (name type)
             `(progn
                (sera:-> ,name
                         ((A->A ,type)
                          ,type ,type ,type)
                         (values ,type &optional))
                (defun ,name (fn start end δ)
                  (declare (optimize (speed 3)))
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
  (def-integrate integrate/single-float single-float)
  (def-integrate integrate/double-float double-float))

(define-polymorphic-function integrate (fn start end &key δ)
  :documentation "Integrate a function FN from START to END using the
Simpson's rule. Δ is an optional argument which controls a diameter of
subdivision of the range [START, END]. All numeric arguments must be
of the same float type.")

(macrolet ((def-integrate-polymorph (name type δ)
             `(defpolymorph integrate ((fn t)
                                       (start ,type)
                                       (end   ,type)
                                       &key
                                       ((δ    ,type) ,δ))
                  ,type
                (,name fn start end δ))))
  (def-integrate-polymorph integrate/single-float single-float 1e-6)
  (def-integrate-polymorph integrate/double-float double-float 1d-6))
