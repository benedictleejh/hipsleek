(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_109_1662_primed () Int)
(declare-fun r_primed () Int)
(declare-fun l_primed () Int)
(declare-fun m2_primed () Int)
(declare-fun m2 () Int)
(declare-fun m1 () Int)
(declare-fun res () Int)
(declare-fun v_int_111_1646_primed () Int)
(declare-fun m1_primed () Int)
(declare-fun mx1 () Int)
(declare-fun m1_2305 () Int)
(declare-fun l () Int)
(declare-fun mx2 () Int)
(declare-fun m2_2306 () Int)
(declare-fun r () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_109_1662_primed 0))
(assert (< m2_primed m1_primed))
(assert (= m2_2306 m2))
(assert (= m1_2305 m1))
(assert (<= m1 (+ 1 m2)))
(assert (<= (+ 0 m2) m1))
(assert (< 0 (+ m2 m1)))
(assert (= r_primed r))
(assert (= l_primed l))
(assert (= m2_primed m2))
(assert (= m1_primed m1))
(assert (= v_int_111_1646_primed 1))
(assert (= (+ res v_int_111_1646_primed) m1_primed))
(assert (or (and (and (< l 1) (= m1_2305 0)) (= mx1 0)) (and (and (<= 0 mx1) (<= 1 m1_2305)) (> l 0))))
(assert (or (and (and (< r 1) (= m2_2306 0)) (= mx2 0)) (and (and (<= 0 mx2) (<= 1 m2_2306)) (> r 0))))
;Negation of Consequence
(assert (not false))
(check-sat)