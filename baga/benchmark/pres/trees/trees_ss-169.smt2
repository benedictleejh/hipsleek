(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun sm () Int)
(declare-fun lg () Int)
(declare-fun v_bool_160_1529_primed () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun v_2408 () Int)
(declare-fun a_primed () Int)
(declare-fun v_int_164_1504_primed () Int)
(declare-fun x_primed () Int)
(declare-fun sm_2404 () Int)
(declare-fun pl_2406 () Int)
(declare-fun p_2409 () Int)
(declare-fun qs_2407 () Int)
(declare-fun lg_2405 () Int)
(declare-fun q_2410 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= pl_2406 v_2408))
(assert (<= v_2408 qs_2407))
(assert (= sm_2404 sm))
(assert (= lg_2405 lg))
(assert (not (> v_bool_160_1529_primed 0)))
(assert (> x_primed 0))
(assert (< tmp_null_primed 1))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= v_int_164_1504_primed v_2408))
(assert (<= a_primed v_int_164_1504_primed))
(assert (= x_primed 1))
(assert (or (and (< p_2409 1) (<= sm_2404 pl_2406)) (and (<= sm_2404 pl_2406) (> p_2409 0))))
(assert (or (and (< q_2410 1) (<= qs_2407 lg_2405)) (and (<= qs_2407 lg_2405) (> q_2410 0))))
;Negation of Consequence
(assert (not false))
(check-sat)