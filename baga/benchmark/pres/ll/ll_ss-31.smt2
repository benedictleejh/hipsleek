(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun q_3197 () Int)
(declare-fun Anon_3196 () Int)
(declare-fun Anon_3181 () Int)
(declare-fun n () Int)
(declare-fun v_bool_249_1853_primed () Int)
(declare-fun ys_3188 () Int)
(declare-fun ys () Int)
(declare-fun xs () Int)
(declare-fun next_253_3187 () Int)
(declare-fun q_3182 () Int)
(declare-fun ys_3204 () Int)
(declare-fun xs_3203 () Int)
(declare-fun tmp_primed () Int)
(declare-fun m () Int)
(declare-fun xs_3189 () Int)
(declare-fun flted_14_3180 () Int)
(declare-fun xs_primed () Int)
(declare-fun n_3190 () Int)
(declare-fun m_3191 () Int)
(declare-fun flted_191_3205 () Int)
(declare-fun ys_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ m 1) m_3191))
(assert (= q_3197 ys_3188))
(assert (= Anon_3196 Anon_3181))
(assert (= (+ flted_14_3180 1) n))
(assert (> v_bool_249_1853_primed 0))
(assert (= ys_3188 ys))
(assert (= xs_3189 xs))
(assert (= tmp_primed q_3182))
(assert (= next_253_3187 q_3182))
(assert (= ys_3204 xs_3189))
(assert (= xs_3203 tmp_primed))
(assert (= n_3190 flted_14_3180))
(assert (<= 0 m))
(assert (> xs_3189 0))
(assert (<= 0 flted_14_3180))
(assert (= flted_191_3205 (+ m_3191 n_3190)))
(assert (< xs_primed 1))
(assert (<= 0 n_3190))
(assert (<= 0 m_3191))
(assert (or (and (< ys_primed 1) (= flted_191_3205 0)) (and (<= 1 flted_191_3205) (> ys_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)