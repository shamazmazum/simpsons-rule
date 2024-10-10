(defsystem :simpsons-rule
  :name :simpsons-rule
  :version "0.2"
  :author "Vasily Postnicov <shamaz.mazum@gmail.com>"
  :description "Implementation of numeric integration with Simpson's rule"
  :licence "2-clause BSD"
  :serial t
  :pathname "src/"
  :components ((:file "package")
               (:file "integrate"))
  :depends-on (:serapeum)
  :in-order-to ((test-op (load-op "simpsons-rule/tests")))
  :perform (test-op (op system)
                    (declare (ignore op system))
                    (uiop:symbol-call :simpsons-rule-tests '#:run-tests)))


(defsystem :simpsons-rule/tests
  :name :simpsons-rule/tests
  :version "0.2"
  :author "Vasily Postnicov <shamaz.mazum@gmail.com>"
  :licence "2-clause BSD"
  :pathname "tests/"
  :components ((:file "package")
               (:file "tests" :depends-on ("package")))
  :depends-on (:fiveam :simpsons-rule))
