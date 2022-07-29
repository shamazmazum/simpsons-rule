(defun do-all()
  (ql:quickload :simpsons-rule/tests)
  (uiop:quit
   (if (uiop:call-function "simpsons-rule-tests:run-tests")
       0 1)))

(do-all)
