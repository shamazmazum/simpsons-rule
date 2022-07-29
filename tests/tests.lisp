(in-package :simpsons-rule-tests)

(defun run-tests ()
  (let ((status (run 'integrate)))
    (explain! status)
    (results-status status)))

(def-suite integrate :description "Test SIMPSONS-RULE:INTEGRATE")

(defun ≈ (x y ε)
  (< (abs (- x y)) ε))

(defun polynomial (x)
  (1+ (* (expt x 3) 4)))

(in-suite integrate)

(test runtime
  (is (≈ (integrate #'polynomial 1f0 3f0) 82 1e-2))
  (is (≈ (integrate #'polynomial 1d0 3d0) 82 1d-5)))

(defun integrate/test-single (function)
  (declare (optimize (speed 3)))
  (integrate function 1f0 3f0))

(defun integrate/test-double (function)
  (declare (optimize (speed 3)))
  (integrate function 1d0 3d0))

(test specialized
  (is (≈ (integrate/test-single #'polynomial) 82 1e-2))
  (is (≈ (integrate/test-double #'polynomial) 82 1d-5)))
