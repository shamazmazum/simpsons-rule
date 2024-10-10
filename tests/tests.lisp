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
  (is (≈ (integrate #'polynomial 1f0 3f0 1f-5) 82 1f-3))
  (is (≈ (integrate #'polynomial 1d0 3d0 1d-5) 82 1d-8)))

(test start>end
  (is (= (integrate #'identity 0d0 1d0 1d-3)
         (- (integrate #'identity 1d0 0d0 1d-3)))))
