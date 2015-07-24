(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun ln () Int)
(declare-fun n () Int)
(declare-fun ln_4365 () Int)
(declare-fun height1_4405 () Int)
(declare-fun height2_4408 () Int)
(declare-fun h_4382 () Int)
(declare-fun flted_33_4366 () Int)
(declare-fun h_4386 () Int)
(declare-fun height1_4392 () Int)
(declare-fun height2_4395 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n))
(assert (<= 0 ln_4365))
(assert (<= 0 flted_33_4366))
(assert (= h_4382 (+ 1 n)))
(assert (<= 0 ln))
(assert (= n ln))
(assert (= flted_33_4366 (+ 1 ln)))
(assert (= ln_4365 ln))
(assert (= height1_4405 n))
(assert (= height2_4408 ln_4365))
(assert (<= height1_4405 (+ 1 height2_4408)))
(assert (<= height2_4408 (+ 1 height1_4405)))
(assert (or (and (= h_4382 (+ height1_4405 1)) (<= height2_4408 height1_4405)) (and (= h_4382 (+ height2_4408 1)) (< height1_4405 height2_4408))))
(assert (exists ((max_4421 Int)) (and (= height1_4392 (+ 1 max_4421)) (or (and (= max_4421 height1_4405) (>= height1_4405 height2_4408)) (and (= max_4421 height2_4408) (< height1_4405 height2_4408))))))
(assert (= h_4382 height1_4392))
(assert (= h_4386 (+ 1 h_4382)))
(assert (= height2_4395 flted_33_4366))
;Negation of Consequence
(assert (not (or (and (= h_4386 (+ 1 height1_4392)) (<= height2_4395 height1_4392)) (and (= h_4386 (+ 1 height2_4395)) (< height1_4392 height2_4395)))))
(check-sat)