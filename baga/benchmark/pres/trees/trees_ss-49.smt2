(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun p_1917 () Int)
(declare-fun p_1881 () Int)
(declare-fun m1_1918 () Int)
(declare-fun res () Int)
(declare-fun m () Int)
(declare-fun m1_1882 () Int)
(declare-fun m2_1884 () Int)
(declare-fun v_int_95_1639_primed () Int)
(declare-fun m_1887 () Int)
(declare-fun q_1919 () Int)
(declare-fun m_1896 () Int)
(declare-fun q_1883 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= p_1917 p_1881))
(assert (or (and (< p_1881 1) (= m_1887 0)) (and (<= 1 m_1887) (> p_1881 0))))
(assert (= m1_1918 m_1887))
(assert (= res v_int_95_1639_primed))
(assert (<= 0 m2_1884))
(assert (<= 0 m_1887))
(assert (<= 0 m1_1882))
(assert (= m_1887 m1_1882))
(assert (= m (+ (+ m2_1884 1) m1_1882)))
(assert (= m_1896 m2_1884))
(assert (<= 0 m_1896))
(assert (= v_int_95_1639_primed (+ m_1896 (+ m_1887 1))))
(assert (= q_1919 q_1883))
(assert (or (and (< q_1883 1) (= m_1896 0)) (and (<= 1 m_1896) (> q_1883 0))))
;Negation of Consequence
(assert (not (or (= m_1896 0) (< q_1883 1))))
(check-sat)