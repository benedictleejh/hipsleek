(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun fl_primed () Int)
(declare-fun x () Int)
(declare-fun n () Int)
(declare-fun tmp_primed () Int)
(declare-fun q_1570 () Int)
(declare-fun flted_7_1568 () Int)
(declare-fun y_primed () Int)
(declare-fun n_1581 () Int)
(declare-fun x_primed () Int)
(declare-fun m () Int)
(declare-fun y () Int)
(declare-fun y_1590 () Int)
(declare-fun n_1591 () Int)
(declare-fun v_node_31_1361_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> fl_primed 0))
(assert (> tmp_primed 0))
(assert (< 0 n))
(assert (= y_primed y))
(assert (= x_primed x))
(assert (= (+ flted_7_1568 1) n))
(assert (= tmp_primed q_1570))
(assert (= v_node_31_1361_primed q_1570))
(assert (= n_1581 flted_7_1568))
(assert (<= 0 flted_7_1568))
(assert (= y_1590 y_primed))
(assert (= n_1591 n_1581))
(assert (<= 0 n_1581))
(assert (= x_primed 1))
(assert (or (and (< y 1) (= m 0)) (and (<= 1 m) (> y 0))))
(assert (or (and (= y_1590 v_node_31_1361_primed) (= n_1591 0)) (and (<= 1 n_1591) (> v_node_31_1361_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)