(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun v_int_51_2311_primed () Int)
(declare-fun p_2542 () Int)
(declare-fun Anon_2545 () Int)
(declare-fun Anon_2524 () Int)
(declare-fun p_2521 () Int)
(declare-fun n1_2544 () Int)
(declare-fun m1_2543 () Int)
(declare-fun n_2519 () Int)
(declare-fun b () Int)
(declare-fun n () Int)
(declare-fun n1_2523 () Int)
(declare-fun m () Int)
(declare-fun m1_2522 () Int)
(declare-fun q_2546 () Int)
(declare-fun Anon_2528 () Int)
(declare-fun m2_2526 () Int)
(declare-fun n2_2527 () Int)
(declare-fun q_2525 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res v_int_51_2311_primed))
(assert (= v_int_51_2311_primed n_2519))
(assert (= p_2542 p_2521))
(assert (= Anon_2545 Anon_2524))
(assert (or (and (and (and (< p_2521 1) (= m1_2522 0)) (= n1_2523 0)) (= Anon_2524 1)) (and (and (and (and (and (<= 0 Anon_2524) (<= (+ (- 0 n1_2523) 2) Anon_2524)) (<= Anon_2524 n1_2523)) (<= Anon_2524 2)) (<= 1 m1_2522)) (> p_2521 0))))
(assert (= n1_2544 n1_2523))
(assert (= m1_2543 m1_2522))
(assert (= n_2519 n))
(assert (= (+ b n2_2527) (+ 1 n1_2523)))
(assert (<= n1_2523 (+ 1 n2_2527)))
(assert (<= (+ 0 n2_2527) (+ n1_2523 1)))
(assert (exists ((max_2561 Int)) (and (= n (+ max_2561 1)) (or (and (= max_2561 n1_2523) (>= n1_2523 n2_2527)) (and (= max_2561 n2_2527) (< n1_2523 n2_2527))))))
(assert (= m (+ (+ m2_2526 1) m1_2522)))
(assert (= q_2546 q_2525))
(assert (or (and (and (and (< q_2525 1) (= m2_2526 0)) (= n2_2527 0)) (= Anon_2528 1)) (and (and (and (and (and (<= 0 Anon_2528) (<= (+ (- 0 n2_2527) 2) Anon_2528)) (<= Anon_2528 n2_2527)) (<= Anon_2528 2)) (<= 1 m2_2526)) (> q_2525 0))))
;Negation of Consequence
(assert (not (or (= m2_2526 0) (or (= n2_2527 0) (< q_2525 1)))))
(check-sat)