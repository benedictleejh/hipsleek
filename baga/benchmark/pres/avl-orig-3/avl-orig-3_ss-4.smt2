(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m () Int)
(declare-fun b () Int)
(declare-fun n () Int)
(declare-fun v_bool_28_2349_primed () Int)
(declare-fun x () Int)
(declare-fun n_2556 () Int)
(declare-fun res () Int)
(declare-fun v_int_31_2348_primed () Int)
(declare-fun x_primed () Int)
(declare-fun n1_2560 () Int)
(declare-fun Anon_2561 () Int)
(declare-fun m1_2559 () Int)
(declare-fun p_2558 () Int)
(declare-fun n2_2564 () Int)
(declare-fun Anon_2565 () Int)
(declare-fun m2_2563 () Int)
(declare-fun q_2562 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m (+ (+ m2_2563 1) m1_2559)))
(assert (exists ((max_63 Int)) (and (= n (+ 1 max_63)) (or (and (= max_63 n1_2560) (>= n1_2560 n2_2564)) (and (= max_63 n2_2564) (< n1_2560 n2_2564))))))
(assert (= (+ b n2_2564) (+ 1 n1_2560)))
(assert (<= n2_2564 (+ 1 n1_2560)))
(assert (<= n1_2560 (+ n2_2564 1)))
(assert (= n_2556 n))
(assert (not (> v_bool_28_2349_primed 0)))
(assert (> x_primed 0))
(assert (= x_primed x))
(assert (= v_int_31_2348_primed n_2556))
(assert (= res v_int_31_2348_primed))
(assert (= x_primed 1))
(assert (or (and (and (and (< p_2558 1) (= m1_2559 0)) (= n1_2560 0)) (= Anon_2561 1)) (and (and (and (and (and (<= 0 Anon_2561) (<= (+ (- 0 n1_2560) 2) Anon_2561)) (<= Anon_2561 n1_2560)) (<= Anon_2561 2)) (<= 1 m1_2559)) (> p_2558 0))))
(assert (or (and (and (and (< q_2562 1) (= m2_2563 0)) (= n2_2564 0)) (= Anon_2565 1)) (and (and (and (and (and (<= 0 Anon_2565) (<= (+ (- 0 n2_2564) 2) Anon_2565)) (<= Anon_2565 n2_2564)) (<= Anon_2565 2)) (<= 1 m2_2563)) (> q_2562 0))))
;Negation of Consequence
(assert (not false))
(check-sat)