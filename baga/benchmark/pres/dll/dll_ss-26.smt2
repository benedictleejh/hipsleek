(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun q_1884 () Int)
(declare-fun q_1859 () Int)
(declare-fun Anon_1883 () Int)
(declare-fun Anon_1858 () Int)
(declare-fun res () Int)
(declare-fun prev_160_1860 () Int)
(declare-fun next_159_1834 () Int)
(declare-fun n_1816 () Int)
(declare-fun n () Int)
(declare-fun p_1815 () Int)
(declare-fun p () Int)
(declare-fun m_1814 () Int)
(declare-fun q_1813 () Int)
(declare-fun tmp_1823 () Int)
(declare-fun q_1809 () Int)
(declare-fun x () Int)
(declare-fun y_primed () Int)
(declare-fun y () Int)
(declare-fun v_bool_149_1459_primed () Int)
(declare-fun self_1806 () Int)
(declare-fun x_primed () Int)
(declare-fun p_1805 () Int)
(declare-fun q () Int)
(declare-fun flted_12_1807 () Int)
(declare-fun m () Int)
(declare-fun v_bool_157_1458_primed () Int)
(declare-fun p_1855 () Int)
(declare-fun Anon_1829 () Int)
(declare-fun flted_12_1857 () Int)
(declare-fun flted_144_1828 () Int)
(declare-fun Anon_1871 () Int)
(declare-fun Anon_1808 () Int)
(declare-fun q_1872 () Int)
(declare-fun self_1856 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= q_1884 q_1859))
(assert (= Anon_1883 Anon_1858))
(assert (= res x_primed))
(assert (= prev_160_1860 p_1855))
(assert (= next_159_1834 q_1809))
(assert (<= 0 n_1816))
(assert (<= 0 m_1814))
(assert (= flted_144_1828 (+ n_1816 m_1814)))
(assert (<= 0 flted_12_1807))
(assert (<= 0 n))
(assert (= n_1816 n))
(assert (= p_1815 p))
(assert (= m_1814 flted_12_1807))
(assert (= q_1813 self_1806))
(assert (= tmp_1823 q_1809))
(assert (= x_primed x))
(assert (= y_primed y))
(assert (> x_primed 0))
(assert (not (> v_bool_149_1459_primed 0)))
(assert (= self_1806 x_primed))
(assert (= p_1805 q))
(assert (= (+ flted_12_1807 1) m))
(assert (> self_1856 0))
(assert (> v_bool_157_1458_primed 0))
(assert (= p_1855 Anon_1829))
(assert (= (+ flted_12_1857 1) flted_144_1828))
(assert (= Anon_1871 Anon_1808))
(assert (= q_1872 self_1856))
;Negation of Consequence
(assert (not false))
(check-sat)