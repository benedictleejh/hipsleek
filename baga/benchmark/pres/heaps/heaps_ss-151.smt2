(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun d_primed () Int)
(declare-fun v_primed () Int)
(declare-fun l_primed () Int)
(declare-fun r_primed () Int)
(declare-fun v () Int)
(declare-fun d () Int)
(declare-fun m1 () Int)
(declare-fun m2 () Int)
(declare-fun m1_primed () Int)
(declare-fun v_bool_132_1567_primed () Int)
(declare-fun m2_primed () Int)
(declare-fun v_bool_141_1566_primed () Int)
(declare-fun mx1 () Int)
(declare-fun m1_2364 () Int)
(declare-fun l () Int)
(declare-fun mx2 () Int)
(declare-fun m2_2365 () Int)
(declare-fun r () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m2_primed 0))
(assert (= d_primed d))
(assert (= v_primed v))
(assert (= m1_primed m1))
(assert (= m2_primed m2))
(assert (= l_primed l))
(assert (= r_primed r))
(assert (<= (+ 0 m2) m1))
(assert (<= m1 (+ 1 m2)))
(assert (<= mx1 d))
(assert (<= mx2 d))
(assert (<= 0 v))
(assert (<= v d))
(assert (= m1_2364 m1))
(assert (= m2_2365 m2))
(assert (not (= m1_primed 0)))
(assert (not (> v_bool_132_1567_primed 0)))
(assert (= m2_primed m2_primed))
(assert (> v_bool_141_1566_primed 0))
(assert (or (and (and (< l 1) (= m1_2364 0)) (= mx1 0)) (and (and (<= 0 mx1) (<= 1 m1_2364)) (> l 0))))
(assert (or (and (and (< r 1) (= m2_2365 0)) (= mx2 0)) (and (and (<= 0 mx2) (<= 1 m2_2365)) (> r 0))))
;Negation of Consequence
(assert (not false))
(check-sat)