(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_3611 () Int)
(declare-fun l_3608 () Int)
(declare-fun m2_3612 () Int)
(declare-fun m1_3609 () Int)
(declare-fun d_3607 () Int)
(declare-fun t_primed () Int)
(declare-fun t () Int)
(declare-fun m3_3242 () Int)
(declare-fun mx () Int)
(declare-fun n () Int)
(declare-fun v_boolean_189_3297 () Int)
(declare-fun v_boolean_189_3296 () Int)
(declare-fun v_bool_189_1327_primed () Int)
(declare-fun mx2_3249 () Int)
(declare-fun m2_3241 () Int)
(declare-fun r_3247 () Int)
(declare-fun m1_3240 () Int)
(declare-fun mx1_3246 () Int)
(declare-fun m2_3248 () Int)
(declare-fun m1_3245 () Int)
(declare-fun mx3_3354 () Int)
(declare-fun maxi_3356 () Int)
(declare-fun mx1 () Int)
(declare-fun mx2 () Int)
(declare-fun tnleft_3600 () Int)
(declare-fun tleft_3602 () Int)
(declare-fun mx4_3355 () Int)
(declare-fun tnright_3601 () Int)
(declare-fun tright_3603 () Int)
(declare-fun v_3604 () Int)
(declare-fun max1_3595 () Int)
(declare-fun max2_3596 () Int)
(declare-fun tval_3599 () Int)
(declare-fun mx1_3340 () Int)
(declare-fun mx2_3341 () Int)
(declare-fun res () Int)
(declare-fun d_3243 () Int)
(declare-fun mx4_3598 () Int)
(declare-fun mx3_3597 () Int)
(declare-fun mx1_3610 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= r_3611 tright_3603))
(assert (= l_3608 tleft_3602))
(assert (= m2_3612 tnright_3601))
(assert (= m1_3609 tnleft_3600))
(assert (= d_3607 tval_3599))
(assert (= mx2_3341 0))
(assert (= mx1_3340 0))
(assert (or (= tnright_3601 0) (< tright_3603 1)))
(assert (< tleft_3602 1))
(assert (= tnleft_3600 0))
(assert (= mx3_3354 0))
(assert (= mx2 0))
(assert (or (= m2_3241 0) (< r_3247 1)))
(assert (= mx1 mx1_3246))
(assert (= m2_3248 0))
(assert (not (= m1_3245 0)))
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
(assert (> v_boolean_189_3297 0))
(assert (not (> v_boolean_189_3296 0)))
(assert (not (> v_bool_189_1327_primed 0)))
(assert (= mx2_3249 0))
(assert (= m2_3241 0))
(assert (< r_3247 1))
(assert (<= 0 m1_3240))
(assert (<= 0 mx1_3246))
(assert (= (+ (+ 1 tnleft_3600) tnright_3601) (+ m2_3248 m1_3245)))
(assert (<= (+ 0 tnright_3601) tnleft_3600))
(assert (<= tnleft_3600 (+ 1 tnright_3601)))
(assert (<= mx3_3354 mx1))
(assert (<= mx4_3355 mx2))
(assert (or (and (= maxi_3356 mx1) (>= mx1 mx2)) (and (= maxi_3356 mx2) (< mx1 mx2))))
(assert (<= 0 v_3604))
(assert (<= v_3604 maxi_3356))
(assert (exists ((m2_71 Int)) (<= 0 m2_71)))
(assert (exists ((m1_70 Int)) (<= 0 m1_70)))
(assert (<= 0 mx1))
(assert (<= 0 mx2))
(assert (or (= tnleft_3600 0) (< tleft_3602 1)))
(assert (= mx4_3355 0))
(assert (= tnright_3601 0))
(assert (< tright_3603 1))
(assert (<= mx3_3597 mx1_3340))
(assert (<= mx4_3598 mx2_3341))
(assert (or (and (= max1_3595 mx1_3340) (>= mx1_3340 v_3604)) (and (= max1_3595 v_3604) (< mx1_3340 v_3604))))
(assert (or (and (= max2_3596 mx2_3341) (>= mx2_3341 max1_3595)) (and (= max2_3596 max1_3595) (< mx2_3341 max1_3595))))
(assert (<= tval_3599 max2_3596))
(assert (<= mx3_3597 tval_3599))
(assert (<= mx4_3598 tval_3599))
(assert (<= 0 tval_3599))
(assert (exists ((m2_65 Int)) (<= 0 m2_65)))
(assert (exists ((m1_64 Int)) (<= 0 m1_64)))
(assert (<= 0 mx1_3340))
(assert (<= 0 mx2_3341))
(assert (= res d_3243))
(assert (= mx4_3598 0))
(assert (= mx3_3597 0))
(assert (= mx1_3610 0))
;Negation of Consequence
(assert (not false))
(check-sat)