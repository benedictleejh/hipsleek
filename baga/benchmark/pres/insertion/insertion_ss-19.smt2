(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_27_1402_primed () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun x () Int)
(declare-fun xl () Int)
(declare-fun sm_1466 () Int)
(declare-fun xs () Int)
(declare-fun n () Int)
(declare-fun res () Int)
(declare-fun qs_1470 () Int)
(declare-fun lg_1467 () Int)
(declare-fun flted_15_1468 () Int)
(declare-fun x_primed () Int)
(declare-fun q_1469 () Int)
(declare-fun v_node_28_1381_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_27_1402_primed 0))
(assert (<= v_primed sm_1466))
(assert (< 0 n))
(assert (= v_primed v))
(assert (= x_primed x))
(assert (= lg_1467 xl))
(assert (= sm_1466 xs))
(assert (<= xs qs_1470))
(assert (> q_1469 0))
(assert (= (+ flted_15_1468 1) n))
(assert (= res v_node_28_1381_primed))
(assert (= x_primed 1))
(assert (or (and (and (= lg_1467 qs_1470) (= flted_15_1468 1)) (> q_1469 0)) (and (and (<= qs_1470 lg_1467) (<= 2 flted_15_1468)) (> q_1469 0))))
(assert (= v_node_28_1381_primed 2))
(assert (not (= x_primed v_node_28_1381_primed)))
(assert (not (= x_primed q_1469)))
(assert (not (= q_1469 v_node_28_1381_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)