(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m () Int)
(declare-fun p_1755 () Int)
(declare-fun Anon_18 () Int)
(declare-fun v_bool_45_1681_primed () Int)
(declare-fun y_primed () Int)
(declare-fun y () Int)
(declare-fun x () Int)
(declare-fun v_node2_49_1670_primed () Int)
(declare-fun q_1758 () Int)
(declare-fun Anon_1763 () Int)
(declare-fun self_1756 () Int)
(declare-fun Anon_1765 () Int)
(declare-fun Anon_19 () Int)
(declare-fun n () Int)
(declare-fun n1_1759 () Int)
(declare-fun m_1764 () Int)
(declare-fun n_1766 () Int)
(declare-fun x_primed () Int)
(declare-fun flted_40_1771 () Int)
(declare-fun res () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m (+ 1 n1_1759)))
(assert (= p_1755 Anon_18))
(assert (= self_1756 x_primed))
(assert (not (> v_bool_45_1681_primed 0)))
(assert (> x_primed 0))
(assert (= y_primed y))
(assert (= x_primed x))
(assert (= v_node2_49_1670_primed q_1758))
(assert (= Anon_1763 self_1756))
(assert (= m_1764 n1_1759))
(assert (= Anon_1765 Anon_19))
(assert (= n_1766 n))
(assert (<= 0 n))
(assert (<= 0 n1_1759))
(assert (= flted_40_1771 (+ n_1766 m_1764)))
(assert (<= 0 m_1764))
(assert (<= 0 n_1766))
(assert (= x_primed 1))
(assert (or (and (< res 1) (= flted_40_1771 0)) (and (<= 1 flted_40_1771) (> res 0))))
;Negation of Consequence
(assert (not false))
(check-sat)