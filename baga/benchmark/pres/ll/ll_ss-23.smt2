(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun q_3047 () Int)
(declare-fun Anon_3046 () Int)
(declare-fun Anon_3031 () Int)
(declare-fun n () Int)
(declare-fun v_bool_457_1385_primed () Int)
(declare-fun ys_3038 () Int)
(declare-fun ys () Int)
(declare-fun xs () Int)
(declare-fun next_461_3037 () Int)
(declare-fun q_3032 () Int)
(declare-fun m () Int)
(declare-fun xs_3039 () Int)
(declare-fun flted_14_3030 () Int)
(declare-fun xs_primed () Int)
(declare-fun n_3040 () Int)
(declare-fun m_3041 () Int)
(declare-fun flted_191_3055 () Int)
(declare-fun ys_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ m 1) m_3041))
(assert (= q_3047 ys_3038))
(assert (= Anon_3046 Anon_3031))
(assert (= (+ flted_14_3030 1) n))
(assert (> v_bool_457_1385_primed 0))
(assert (= ys_3038 ys))
(assert (= xs_3039 xs))
(assert (= next_461_3037 q_3032))
(assert (= n_3040 flted_14_3030))
(assert (<= 0 m))
(assert (> xs_3039 0))
(assert (<= 0 flted_14_3030))
(assert (= flted_191_3055 (+ m_3041 n_3040)))
(assert (< xs_primed 1))
(assert (<= 0 n_3040))
(assert (<= 0 m_3041))
(assert (or (and (< ys_primed 1) (= flted_191_3055 0)) (and (<= 1 flted_191_3055) (> ys_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)