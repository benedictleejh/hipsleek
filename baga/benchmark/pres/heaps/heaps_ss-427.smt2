(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun d_primed () Int)
(declare-fun d_2613 () Int)
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
(declare-fun m1_2364 () Int)
(declare-fun m2_2526 () Int)
(declare-fun m1_2525 () Int)
(declare-fun m3_2527 () Int)
(declare-fun mx2 () Int)
(declare-fun m2_2365 () Int)
(declare-fun v_bool_154_1565_primed () Int)
(declare-fun v_primed () Int)
(declare-fun v_bool_166_1564_primed () Int)
(declare-fun d_2481 () Int)
(declare-fun m1_2990 () Int)
(declare-fun m1_2483 () Int)
(declare-fun m2_2993 () Int)
(declare-fun m2_2486 () Int)
(declare-fun l_2989 () Int)
(declare-fun l_2482 () Int)
(declare-fun r_2992 () Int)
(declare-fun r_2485 () Int)
(declare-fun mx1_2991 () Int)
(declare-fun mx1_2484 () Int)
(declare-fun mx2_2994 () Int)
(declare-fun mx2_2487 () Int)
(declare-fun d_2988 () Int)
(declare-fun d_2528 () Int)
(declare-fun m1_3008 () Int)
(declare-fun m1_2530 () Int)
(declare-fun m2_3011 () Int)
(declare-fun m2_2533 () Int)
(declare-fun l_3007 () Int)
(declare-fun l_2529 () Int)
(declare-fun r_3010 () Int)
(declare-fun r_2532 () Int)
(declare-fun mx1_3009 () Int)
(declare-fun mx1_2531 () Int)
(declare-fun mx2_3012 () Int)
(declare-fun mx2_2534 () Int)
(declare-fun d_3006 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= d_primed v_primed))
(assert (= d_2613 d))
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
(assert (<= d_2528 v_primed))
(assert (> v_bool_166_1564_primed 0))
(assert (= d_2988 d_2481))
(assert (= m1_2990 m1_2483))
(assert (= m2_2993 m2_2486))
(assert (= l_2989 l_2482))
(assert (= r_2992 r_2485))
(assert (= mx1_2991 mx1_2484))
(assert (= mx2_2994 mx2_2487))
(assert (exists ((mx3_2986 Int)) (<= d_2988 mx3_2986)))
(assert (= d_3006 d_2528))
(assert (= m1_3008 m1_2530))
(assert (= m2_3011 m2_2533))
(assert (= l_3007 l_2529))
(assert (= r_3010 r_2532))
(assert (= mx1_3009 mx1_2531))
(assert (= mx2_3012 mx2_2534))
(assert (exists ((mx4_2987 Int)) (<= d_3006 mx4_2987)))
;Negation of Consequence
(assert (not false))
(check-sat)