(defpackage simpsons-rule
  (:use #:cl #:polymorphic-functions)
  (:export #:integrate
           #:integrate/single-float
           #:integrate/double-float)
  (:local-nicknames (:alex :alexandria)
                    (:sera :serapeum)))
