(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun t () Int)
(declare-fun m3_3242 () Int)
(declare-fun mx () Int)
(declare-fun d_3243 () Int)
(declare-fun n () Int)
(declare-fun m2_3248 () Int)
(declare-fun m1_3245 () Int)
(declare-fun res () Int)
(declare-fun v_boolean_189_1304_primed () Int)
(declare-fun v_boolean_189_1305_primed () Int)
(declare-fun t_primed () Int)
(declare-fun mx1_3246 () Int)
(declare-fun m1_3240 () Int)
(declare-fun l_3244 () Int)
(declare-fun mx2_3249 () Int)
(declare-fun m2_3241 () Int)
(declare-fun r_3247 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m2_3248 0))
(assert (< 0 n))
(assert (= t_primed t))
(assert (= m2_3241 m2_3248))
(assert (= m1_3240 m1_3245))
(assert (<= m3_3242 1))
(assert (<= 0 m3_3242))
(assert (= (+ m3_3242 m2_3248) m1_3245))
(assert (<= d_3243 mx))
(assert (<= mx2_3249 d_3243))
(assert (<= mx1_3246 d_3243))
(assert (<= 0 d_3243))
(assert (= n (+ (+ m2_3248 1) m1_3245)))
(assert (= m1_3245 0))
(assert (> res 0))
(assert (> v_boolean_189_1304_primed 0))
(assert (> v_boolean_189_1305_primed 0))
(assert (= t_primed 1))
(assert (or (and (and (< l_3244 1) (= m1_3240 0)) (= mx1_3246 0)) (and (and (<= 0 mx1_3246) (<= 1 m1_3240)) (> l_3244 0))))
(assert (or (and (and (< r_3247 1) (= m2_3241 0)) (= mx2_3249 0)) (and (and (<= 0 mx2_3249) (<= 1 m2_3241)) (> r_3247 0))))
;Negation of Consequence
(assert (not false))
(check-sat)