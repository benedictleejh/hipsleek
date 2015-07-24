(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun mx2_3115 () Int)
(declare-fun mx1_3112 () Int)
(declare-fun r_3113 () Int)
(declare-fun r_2532 () Int)
(declare-fun l_3110 () Int)
(declare-fun l_2529 () Int)
(declare-fun m2_3114 () Int)
(declare-fun m1_3111 () Int)
(declare-fun d_3109 () Int)
(declare-fun mx2_3073 () Int)
(declare-fun mx1_3070 () Int)
(declare-fun r_3071 () Int)
(declare-fun r_2485 () Int)
(declare-fun l_3068 () Int)
(declare-fun l_2482 () Int)
(declare-fun m2_3072 () Int)
(declare-fun m1_3069 () Int)
(declare-fun d_3067 () Int)
(declare-fun v_int_172_3060 () Int)
(declare-fun max2_3057 () Int)
(declare-fun max1_3056 () Int)
(declare-fun mx4_3059 () Int)
(declare-fun mx3_3058 () Int)
(declare-fun mx2_2639 () Int)
(declare-fun mx1_2638 () Int)
(declare-fun d_primed () Int)
(declare-fun d_2617 () Int)
(declare-fun l_primed () Int)
(declare-fun l () Int)
(declare-fun r_primed () Int)
(declare-fun r () Int)
(declare-fun v () Int)
(declare-fun d () Int)
(declare-fun m1 () Int)
(declare-fun m2 () Int)
(declare-fun m1_primed () Int)
(declare-fun v_bool_132_1567_primed () Int)
(declare-fun m2_primed () Int)
(declare-fun v_bool_141_1566_primed () Int)
(declare-fun m2_2479 () Int)
(declare-fun m1_2478 () Int)
(declare-fun m3_2480 () Int)
(declare-fun mx1 () Int)
(declare-fun mx2_2487 () Int)
(declare-fun mx1_2484 () Int)
(declare-fun m1_2364 () Int)
(declare-fun m2_2486 () Int)
(declare-fun m1_2483 () Int)
(declare-fun m2_2526 () Int)
(declare-fun m1_2525 () Int)
(declare-fun m3_2527 () Int)
(declare-fun mx2 () Int)
(declare-fun mx2_2534 () Int)
(declare-fun mx1_2531 () Int)
(declare-fun m2_2365 () Int)
(declare-fun m2_2533 () Int)
(declare-fun m1_2530 () Int)
(declare-fun d_2481 () Int)
(declare-fun v_bool_154_1565_primed () Int)
(declare-fun v_primed () Int)
(declare-fun d_2528 () Int)
(declare-fun v_bool_166_1564_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= mx2_3115 mx4_3059))
(assert (= mx1_3112 mx3_3058))
(assert (= r_3113 r_2532))
(assert (= l_3110 l_2529))
(assert (= m2_3114 m2_2533))
(assert (= m1_3111 m1_2530))
(assert (= d_3109 d_2528))
(assert (exists ((mx3_3065 Int)) (<= d_3067 mx3_3065)))
(assert (= mx2_3073 mx2_2487))
(assert (= mx1_3070 mx1_2484))
(assert (= r_3071 r_2485))
(assert (= l_3068 l_2482))
(assert (= m2_3072 m2_2486))
(assert (= m1_3069 m1_2483))
(assert (= d_3067 d_2481))
(assert (<= 0 mx2_2639))
(assert (<= 0 mx1_2638))
(assert (exists ((m1_64 Int)) (<= 0 m1_64)))
(assert (exists ((m2_65 Int)) (<= 0 m2_65)))
(assert (<= 0 v_int_172_3060))
(assert (<= mx4_3059 v_int_172_3060))
(assert (<= mx3_3058 v_int_172_3060))
(assert (<= v_int_172_3060 max2_3057))
(assert (or (and (= max2_3057 mx2_2639) (>= mx2_2639 max1_3056)) (and (= max2_3057 max1_3056) (< mx2_2639 max1_3056))))
(assert (or (and (= max1_3056 mx1_2638) (>= mx1_2638 v_primed)) (and (= max1_3056 v_primed) (< mx1_2638 v_primed))))
(assert (<= mx4_3059 mx2_2639))
(assert (<= mx3_3058 mx1_2638))
(assert (<= 0 mx1_2531))
(assert (<= 0 m1_2525))
(assert (<= 0 mx2_2534))
(assert (<= 0 m2_2526))
(assert (= mx2_2639 mx2_2534))
(assert (= mx1_2638 mx1_2531))
(assert (= d_primed d_2528))
(assert (= d_2617 d))
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
(assert (not (= m2_primed 0)))
(assert (not (> v_bool_141_1566_primed 0)))
(assert (= m2_2479 m2_2486))
(assert (= m1_2478 m1_2483))
(assert (<= m3_2480 1))
(assert (<= 0 m3_2480))
(assert (= (+ m3_2480 m2_2486) m1_2483))
(assert (<= d_2481 mx1))
(assert (<= mx2_2487 d_2481))
(assert (<= mx1_2484 d_2481))
(assert (<= 0 d_2481))
(assert (= m1_2364 (+ (+ m2_2486 1) m1_2483)))
(assert (= m2_2526 m2_2533))
(assert (= m1_2525 m1_2530))
(assert (<= m3_2527 1))
(assert (<= 0 m3_2527))
(assert (= (+ m3_2527 m2_2533) m1_2530))
(assert (<= d_2528 mx2))
(assert (<= mx2_2534 d_2528))
(assert (<= mx1_2531 d_2528))
(assert (<= 0 d_2528))
(assert (= m2_2365 (+ (+ m2_2533 1) m1_2530)))
(assert (< d_2481 d_2528))
(assert (not (> v_bool_154_1565_primed 0)))
(assert (< v_primed d_2528))
(assert (not (> v_bool_166_1564_primed 0)))
;Negation of Consequence
(assert (not false))
(check-sat)