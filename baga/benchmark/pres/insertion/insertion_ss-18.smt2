(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v () Int)
(declare-fun v_primed () Int)
(declare-fun sm_1466 () Int)
(declare-fun n () Int)
(declare-fun xs () Int)
(declare-fun xl () Int)
(declare-fun qs_1470 () Int)
(declare-fun lg_1467 () Int)
(declare-fun flted_15_1468 () Int)
(declare-fun res () Int)
(declare-fun x () Int)
(declare-fun v_node_28_1381_primed () Int)
(declare-fun q_1469 () Int)
(declare-fun x_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= v_primed v))
(assert (<= v_primed sm_1466))
(assert (< 0 n))
(assert (= sm_1466 xs))
(assert (= (+ flted_15_1468 1) n))
(assert (<= xs qs_1470))
(assert (= lg_1467 xl))
(assert (not (= q_1469 v_node_28_1381_primed)))
(assert (> v_node_28_1381_primed 0))
(assert (or (and (and (= lg_1467 qs_1470) (= flted_15_1468 1)) (> q_1469 0)) (and (and (<= qs_1470 lg_1467) (<= 2 flted_15_1468)) (> q_1469 0))))
(assert (> q_1469 0))
(assert (= res v_node_28_1381_primed))
(assert (= x_primed x))
(assert (> x_primed 0))
(assert (not (= x_primed v_node_28_1381_primed)))
(assert (not (= x_primed q_1469)))
;Negation of Consequence
(assert (not (< x_primed 1)))
(check-sat)