(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun xs () Int)
(declare-fun xl () Int)
(declare-fun x () Int)
(declare-fun v () Int)
(declare-fun n () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun sm_1466 () Int)
(declare-fun v_primed () Int)
(declare-fun v_bool_27_1402_primed () Int)
(declare-fun v_bool_32_1401_primed () Int)
(declare-fun qs_1470 () Int)
(declare-fun lg_1467 () Int)
(declare-fun flted_15_1468 () Int)
(declare-fun x_primed () Int)
(declare-fun q_1469 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ flted_15_1468 1) n))
(assert (<= xs qs_1470))
(assert (= sm_1466 xs))
(assert (= lg_1467 xl))
(assert (= x_primed x))
(assert (= v_primed v))
(assert (< 0 n))
(assert (< tmp_null_primed 1))
(assert (< sm_1466 v_primed))
(assert (not (> v_bool_27_1402_primed 0)))
(assert (> q_1469 0))
(assert (> v_bool_32_1401_primed 0))
(assert (= x_primed 1))
(assert (or (and (and (= lg_1467 qs_1470) (= flted_15_1468 1)) (> q_1469 0)) (and (and (<= qs_1470 lg_1467) (<= 2 flted_15_1468)) (> q_1469 0))))
(assert (not (= x_primed q_1469)))
;Negation of Consequence
(assert (not false))
(check-sat)