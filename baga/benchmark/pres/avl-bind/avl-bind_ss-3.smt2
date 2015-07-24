(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_int_137_1849_primed () Int)
(declare-fun tmp_primed () Int)
(declare-fun mx () Int)
(declare-fun n_2487 () Int)
(declare-fun y_primed () Int)
(declare-fun x () Int)
(declare-fun nx () Int)
(declare-fun v_primed () Int)
(declare-fun x_primed () Int)
(declare-fun n1_2491 () Int)
(declare-fun m1_2490 () Int)
(declare-fun p_2489 () Int)
(declare-fun n2_2494 () Int)
(declare-fun m2_2493 () Int)
(declare-fun q_2492 () Int)
(declare-fun nx_2495 () Int)
(declare-fun my () Int)
(declare-fun y () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= v_int_137_1849_primed 1))
(assert (= tmp_primed n_2487))
(assert (= mx (+ (+ m2_2493 1) m1_2490)))
(assert (<= (+ 0 n2_2494) (+ n1_2491 1)))
(assert (<= n1_2491 (+ 1 n2_2494)))
(assert (exists ((max_32 Int)) (and (= nx (+ 1 max_32)) (or (and (= max_32 n1_2491) (>= n1_2491 n2_2494)) (and (= max_32 n2_2494) (< n1_2491 n2_2494))))))
(assert (= n_2487 nx))
(assert (= x_primed x))
(assert (= y_primed y))
(assert (> x 0))
(assert (= nx_2495 nx))
(assert (= v_primed 0))
(assert (= x_primed 1))
(assert (or (and (and (< p_2489 1) (= m1_2490 0)) (= n1_2491 0)) (and (and (<= 1 n1_2491) (<= 1 m1_2490)) (> p_2489 0))))
(assert (or (and (and (< q_2492 1) (= m2_2493 0)) (= n2_2494 0)) (and (and (<= 1 n2_2494) (<= 1 m2_2493)) (> q_2492 0))))
(assert (or (and (and (< y 1) (= my 0)) (= nx_2495 0)) (and (and (<= 1 nx_2495) (<= 1 my)) (> y 0))))
;Negation of Consequence
(assert (not false))
(check-sat)