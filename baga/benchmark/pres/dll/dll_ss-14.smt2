(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_157_1458_primed () Int)
(declare-fun tmp_primed () Int)
(declare-fun m () Int)
(declare-fun p_1805 () Int)
(declare-fun q () Int)
(declare-fun v_bool_149_1459_primed () Int)
(declare-fun y_primed () Int)
(declare-fun y () Int)
(declare-fun x () Int)
(declare-fun tmp_1823 () Int)
(declare-fun q_1813 () Int)
(declare-fun self_1806 () Int)
(declare-fun p_1815 () Int)
(declare-fun p () Int)
(declare-fun n () Int)
(declare-fun flted_12_1807 () Int)
(declare-fun flted_144_1828 () Int)
(declare-fun m_1814 () Int)
(declare-fun n_1816 () Int)
(declare-fun next_159_1834 () Int)
(declare-fun q_1809 () Int)
(declare-fun x_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< tmp_primed 1))
(assert (= flted_144_1828 0))
(assert (> v_bool_157_1458_primed 0))
(assert (> tmp_primed 0))
(assert (= (+ flted_12_1807 1) m))
(assert (= p_1805 q))
(assert (= self_1806 x_primed))
(assert (not (> v_bool_149_1459_primed 0)))
(assert (> x_primed 0))
(assert (= y_primed y))
(assert (= x_primed x))
(assert (= tmp_1823 q_1809))
(assert (= q_1813 self_1806))
(assert (= m_1814 flted_12_1807))
(assert (= p_1815 p))
(assert (= n_1816 n))
(assert (<= 0 n))
(assert (<= 0 flted_12_1807))
(assert (= flted_144_1828 (+ n_1816 m_1814)))
(assert (<= 0 m_1814))
(assert (<= 0 n_1816))
(assert (= next_159_1834 q_1809))
(assert (= x_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)