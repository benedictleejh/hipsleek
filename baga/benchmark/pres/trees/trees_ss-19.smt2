(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_1779 () Int)
(declare-fun v_bool_51_1680_primed () Int)
(declare-fun m () Int)
(declare-fun p_1755 () Int)
(declare-fun Anon_18 () Int)
(declare-fun v_bool_45_1681_primed () Int)
(declare-fun y_primed () Int)
(declare-fun y () Int)
(declare-fun x () Int)
(declare-fun Anon_1763 () Int)
(declare-fun self_1756 () Int)
(declare-fun Anon_1765 () Int)
(declare-fun Anon_19 () Int)
(declare-fun n () Int)
(declare-fun n1_1759 () Int)
(declare-fun flted_40_1778 () Int)
(declare-fun m_1764 () Int)
(declare-fun n_1766 () Int)
(declare-fun right_50_1780 () Int)
(declare-fun q_1758 () Int)
(declare-fun left_52_1810 () Int)
(declare-fun p_1805 () Int)
(declare-fun res () Int)
(declare-fun n1_1809 () Int)
(declare-fun q_1808 () Int)
(declare-fun x_primed () Int)
(declare-fun self_1806 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_40_1778 (+ 1 n1_1809)))
(assert (= p_1805 r_1779))
(assert (> v_bool_51_1680_primed 0))
(assert (> self_1806 0))
(assert (= m (+ 1 n1_1759)))
(assert (= p_1755 Anon_18))
(assert (= self_1756 x_primed))
(assert (not (> v_bool_45_1681_primed 0)))
(assert (> x_primed 0))
(assert (= y_primed y))
(assert (= x_primed x))
(assert (= Anon_1763 self_1756))
(assert (= m_1764 n1_1759))
(assert (= Anon_1765 Anon_19))
(assert (= n_1766 n))
(assert (<= 0 n))
(assert (<= 0 n1_1759))
(assert (= flted_40_1778 (+ n_1766 m_1764)))
(assert (<= 0 m_1764))
(assert (<= 0 n_1766))
(assert (= right_50_1780 q_1758))
(assert (= left_52_1810 p_1805))
(assert (= res x_primed))
(assert (or (and (< q_1808 1) (= n1_1809 0)) (and (<= 1 n1_1809) (> q_1808 0))))
(assert (= x_primed 1))
(assert (= self_1806 2))
(assert (not (= x_primed self_1806)))
;Negation of Consequence
(assert (not false))
(check-sat)