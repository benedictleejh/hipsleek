(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun q_2008 () Int)
(declare-fun Anon_2007 () Int)
(declare-fun Anon_1947 () Int)
(declare-fun flted_12_1993 () Int)
(declare-fun Anon_1968 () Int)
(declare-fun v_bool_182_1411_primed () Int)
(declare-fun self_1992 () Int)
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
(declare-fun flted_174_1967 () Int)
(declare-fun m_1953 () Int)
(declare-fun n_1955 () Int)
(declare-fun prev_183_1996 () Int)
(declare-fun p_1991 () Int)
(declare-fun next_184_1999 () Int)
(declare-fun q_1948 () Int)
(declare-fun res () Int)
(declare-fun x_primed () Int)
(declare-fun Anon_2019 () Int)
(declare-fun Anon_1994 () Int)
(declare-fun q_2020 () Int)
(declare-fun q_1995 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= q_2008 self_1992))
(assert (= Anon_2007 Anon_1947))
(assert (= (+ flted_12_1993 1) flted_174_1967))
(assert (= p_1991 Anon_1968))
(assert (> v_bool_182_1411_primed 0))
(assert (> self_1992 0))
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
(assert (= flted_174_1967 (+ n_1955 m_1953)))
(assert (<= 0 m_1953))
(assert (<= 0 n_1955))
(assert (= prev_183_1996 p_1991))
(assert (= next_184_1999 q_1948))
(assert (= res x_primed))
(assert (= Anon_2019 Anon_1994))
(assert (= q_2020 q_1995))
;Negation of Consequence
(assert (not false))
(check-sat)