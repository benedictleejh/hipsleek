(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_1955 () Int)
(declare-fun n () Int)
(declare-fun p_1954 () Int)
(declare-fun p () Int)
(declare-fun m_1953 () Int)
(declare-fun q_1952 () Int)
(declare-fun x () Int)
(declare-fun y_primed () Int)
(declare-fun y () Int)
(declare-fun v_bool_177_1415_primed () Int)
(declare-fun self_1945 () Int)
(declare-fun p_1944 () Int)
(declare-fun q () Int)
(declare-fun flted_12_1946 () Int)
(declare-fun m () Int)
(declare-fun v_bool_182_1411_primed () Int)
(declare-fun x_primed () Int)
(declare-fun flted_174_1965 () Int)
(declare-fun tmp_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_1955))
(assert (<= 0 m_1953))
(assert (= flted_174_1965 (+ n_1955 m_1953)))
(assert (<= 0 flted_12_1946))
(assert (<= 0 n))
(assert (= n_1955 n))
(assert (= p_1954 p))
(assert (= m_1953 flted_12_1946))
(assert (= q_1952 self_1945))
(assert (= x_primed x))
(assert (= y_primed y))
(assert (> x_primed 0))
(assert (not (> v_bool_177_1415_primed 0)))
(assert (= self_1945 x_primed))
(assert (= p_1944 q))
(assert (= (+ flted_12_1946 1) m))
(assert (< tmp_primed 1))
(assert (not (> v_bool_182_1411_primed 0)))
(assert (= x_primed 1))
(assert (or (and (< tmp_primed 1) (= flted_174_1965 0)) (and (<= 1 flted_174_1965) (> tmp_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)