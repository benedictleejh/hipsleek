(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun l_primed () Int)
(declare-fun mx1 () Int)
(declare-fun l () Int)
(declare-fun m1_2307 () Int)
(declare-fun m2_primed () Int)
(declare-fun m1_primed () Int)
(declare-fun m2_2328 () Int)
(declare-fun m1 () Int)
(declare-fun m2 () Int)
(declare-fun r_primed () Int)
(declare-fun mx2 () Int)
(declare-fun m2_2308 () Int)
(declare-fun r () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= l_primed l))
(assert (or (and (and (< l 1) (= m1_2307 0)) (= mx1 0)) (and (and (<= 0 mx1) (<= 1 m1_2307)) (> l 0))))
(assert (<= m1_primed m2_2328))
(assert (= m1_2307 m1))
(assert (= (+ m2_primed 1) m2_2328))
(assert (= m1_primed m1))
(assert (= m2_2328 m2))
(assert (< 0 (+ m2 m1)))
(assert (<= (+ 0 m2) m1))
(assert (<= m1 (+ 1 m2)))
(assert (= m2_2308 m2))
(assert (= r_primed r))
(assert (or (and (and (< r 1) (= m2_2308 0)) (= mx2 0)) (and (and (<= 0 mx2) (<= 1 m2_2308)) (> r 0))))
;Negation of Consequence
(assert (not (or (= m2_2308 0) (< r 1))))
(check-sat)