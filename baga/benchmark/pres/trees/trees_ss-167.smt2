(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_164_1499_primed () Int)
(declare-fun left_164_1498_primed () Int)
(declare-fun val_164_1497_primed () Int)
(declare-fun x () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_160_1529_primed () Int)
(declare-fun lg () Int)
(declare-fun sm () Int)
(declare-fun v_2408 () Int)
(declare-fun sm_2404 () Int)
(declare-fun pl_2406 () Int)
(declare-fun p_2409 () Int)
(declare-fun qs_2407 () Int)
(declare-fun lg_2405 () Int)
(declare-fun q_2410 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_164_1499_primed q_2410))
(assert (= left_164_1498_primed p_2409))
(assert (= val_164_1497_primed v_2408))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (< tmp_null_primed 1))
(assert (> x_primed 0))
(assert (not (> v_bool_160_1529_primed 0)))
(assert (= lg_2405 lg))
(assert (= sm_2404 sm))
(assert (<= v_2408 qs_2407))
(assert (<= pl_2406 v_2408))
(assert (or (and (< p_2409 1) (<= sm_2404 pl_2406)) (and (<= sm_2404 pl_2406) (> p_2409 0))))
(assert (or (and (< q_2410 1) (<= qs_2407 lg_2405)) (and (<= qs_2407 lg_2405) (> q_2410 0))))
;Negation of Consequence
(assert (not false))
(check-sat)