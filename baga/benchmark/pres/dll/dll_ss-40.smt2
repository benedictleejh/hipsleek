(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m () Int)
(declare-fun p_1944 () Int)
(declare-fun q () Int)
(declare-fun v_bool_177_1415_primed () Int)
(declare-fun y_primed () Int)
(declare-fun y () Int)
(declare-fun x () Int)
(declare-fun q_1952 () Int)
(declare-fun self_1945 () Int)
(declare-fun p_1954 () Int)
(declare-fun p () Int)
(declare-fun n () Int)
(declare-fun flted_12_1946 () Int)
(declare-fun m_1953 () Int)
(declare-fun n_1955 () Int)
(declare-fun x_primed () Int)
(declare-fun flted_174_1960 () Int)
(declare-fun tmp_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ flted_12_1946 1) m))
(assert (= p_1944 q))
(assert (= self_1945 x_primed))
(assert (not (> v_bool_177_1415_primed 0)))
(assert (> x_primed 0))
(assert (= y_primed y))
(assert (= x_primed x))
(assert (= q_1952 self_1945))
(assert (= m_1953 flted_12_1946))
(assert (= p_1954 p))
(assert (= n_1955 n))
(assert (<= 0 n))
(assert (<= 0 flted_12_1946))
(assert (= flted_174_1960 (+ n_1955 m_1953)))
(assert (<= 0 m_1953))
(assert (<= 0 n_1955))
(assert (> tmp_primed 0))
(assert (= x_primed 1))
(assert (or (and (< tmp_primed 1) (= flted_174_1960 0)) (and (<= 1 flted_174_1960) (> tmp_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)