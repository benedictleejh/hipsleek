(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_82_1725_primed () Int)
(declare-fun v_boolean_82_2100 () Int)
(declare-fun v_boolean_82_2101 () Int)
(declare-fun mx2_2053 () Int)
(declare-fun mx () Int)
(declare-fun m3_2046 () Int)
(declare-fun m1_2044 () Int)
(declare-fun t_primed () Int)
(declare-fun t () Int)
(declare-fun n () Int)
(declare-fun tval_primed () Int)
(declare-fun d_2047 () Int)
(declare-fun tnleft_primed () Int)
(declare-fun m1_2049 () Int)
(declare-fun tnright_primed () Int)
(declare-fun m2_2052 () Int)
(declare-fun tleft_primed () Int)
(declare-fun l_2048 () Int)
(declare-fun tright_primed () Int)
(declare-fun mx1 () Int)
(declare-fun mx1_2050 () Int)
(declare-fun m2_2045 () Int)
(declare-fun r_2051 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< r_2051 1))
(assert (= m2_2045 0))
(assert (= mx2_2053 0))
(assert (not (> v_bool_82_1725_primed 0)))
(assert (not (> v_boolean_82_2100 0)))
(assert (> v_boolean_82_2101 0))
(assert (= n (+ (+ m2_2052 1) m1_2049)))
(assert (<= 0 d_2047))
(assert (<= mx1_2050 d_2047))
(assert (<= mx2_2053 d_2047))
(assert (<= d_2047 mx))
(assert (= (+ m3_2046 m2_2052) m1_2049))
(assert (<= 0 m3_2046))
(assert (<= m3_2046 1))
(assert (= m1_2044 m1_2049))
(assert (= m2_2045 m2_2052))
(assert (= t_primed t))
(assert (< 0 n))
(assert (not (= m1_2049 0)))
(assert (= m2_2052 0))
(assert (= tval_primed d_2047))
(assert (= tnleft_primed m1_2049))
(assert (= tnright_primed m2_2052))
(assert (= tleft_primed l_2048))
(assert (= tright_primed r_2051))
(assert (= mx1 mx1_2050))
(assert (or (= m2_2045 0) (< r_2051 1)))
;Negation of Consequence
(assert (not false))
(check-sat)