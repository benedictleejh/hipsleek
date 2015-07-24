(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun sm_1631 () Int)
(declare-fun nn () Int)
(declare-fun s0 () Int)
(declare-fun b0 () Int)
(declare-fun y_primed () Int)
(declare-fun x () Int)
(declare-fun m_1639 () Int)
(declare-fun s2_1640 () Int)
(declare-fun b2_1641 () Int)
(declare-fun s2 () Int)
(declare-fun b2 () Int)
(declare-fun m () Int)
(declare-fun y () Int)
(declare-fun x_primed () Int)
(declare-fun qs_1635 () Int)
(declare-fun lg_1632 () Int)
(declare-fun flted_14_1633 () Int)
(declare-fun q_1634 () Int)
(declare-fun v_node_57_1440_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= sm_1631 s0))
(assert (= (+ flted_14_1633 1) nn))
(assert (<= s0 qs_1635))
(assert (= lg_1632 b0))
(assert (<= b0 s2))
(assert (= y_primed y))
(assert (= x_primed x))
(assert (= m_1639 m))
(assert (= s2_1640 s2))
(assert (= b2_1641 b2))
(assert (> x_primed 0))
(assert (or (and (and (= b2 s2) (= m 1)) (> y 0)) (and (and (<= s2 b2) (<= 2 m)) (> y 0))))
(assert (not (= x_primed y)))
(assert (not (= q_1634 y)))
(assert (not (= x_primed q_1634)))
(assert (or (and (and (= lg_1632 qs_1635) (= flted_14_1633 1)) (> q_1634 0)) (and (and (<= qs_1635 lg_1632) (<= 2 flted_14_1633)) (> q_1634 0))))
(assert (= v_node_57_1440_primed q_1634))
;Negation of Consequence
(assert (not (< v_node_57_1440_primed 1)))
(check-sat)