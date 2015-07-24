(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v () Int)
(declare-fun mx1_3070 () Int)
(declare-fun v_int_172_3060 () Int)
(declare-fun max2_3057 () Int)
(declare-fun max1_3056 () Int)
(declare-fun v_primed () Int)
(declare-fun mx4_3059 () Int)
(declare-fun mx3_3058 () Int)
(declare-fun mx2_2639 () Int)
(declare-fun mx1_2638 () Int)
(declare-fun d_primed () Int)
(declare-fun d_2617 () Int)
(declare-fun d () Int)
(declare-fun mx1 () Int)
(declare-fun mx1_2484 () Int)
(declare-fun mx2 () Int)
(declare-fun mx2_2534 () Int)
(declare-fun mx1_2531 () Int)
(declare-fun d_2528 () Int)
(declare-fun d_2481 () Int)
(declare-fun mx2_2487 () Int)
(declare-fun mx2_3073 () Int)
(declare-fun d_3067 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< v_primed d_2528))
(assert (<= v d))
(assert (<= 0 v))
(assert (= v_primed v))
(assert (<= 0 mx1_2484))
(assert (<= 0 mx2_2487))
(assert (<= 0 mx4_3059))
(assert (<= 0 mx3_3058))
(assert (= mx1_3070 mx1_2484))
(assert (<= 0 mx2_2639))
(assert (<= 0 mx1_2638))
(assert (<= 0 v_int_172_3060))
(assert (<= mx4_3059 v_int_172_3060))
(assert (<= mx3_3058 v_int_172_3060))
(assert (<= v_int_172_3060 max2_3057))
(assert (or (and (= max2_3057 mx2_2639) (>= mx2_2639 max1_3056)) (and (= max2_3057 max1_3056) (< mx2_2639 max1_3056))))
(assert (or (and (= max1_3056 mx1_2638) (>= mx1_2638 v_primed)) (and (= max1_3056 v_primed) (< mx1_2638 v_primed))))
(assert (<= mx4_3059 mx2_2639))
(assert (<= mx3_3058 mx1_2638))
(assert (<= 0 mx1_2531))
(assert (<= 0 mx2_2534))
(assert (= mx2_2639 mx2_2534))
(assert (= mx1_2638 mx1_2531))
(assert (= d_primed d_2528))
(assert (= d_2617 d))
(assert (<= mx1 d))
(assert (<= mx2 d))
(assert (<= d_2481 mx1))
(assert (<= mx2_2487 d_2481))
(assert (<= mx1_2484 d_2481))
(assert (<= 0 d_2481))
(assert (<= d_2528 mx2))
(assert (<= mx2_2534 d_2528))
(assert (<= mx1_2531 d_2528))
(assert (<= 0 d_2528))
(assert (< d_2481 d_2528))
(assert (= d_3067 d_2481))
(assert (= mx2_3073 mx2_2487))
;Negation of Consequence
(assert (not (<= mx2_3073 d_3067)))
(check-sat)