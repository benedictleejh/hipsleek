(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun q_3397 () Int)
(declare-fun Anon_3396 () Int)
(declare-fun Anon_3381 () Int)
(declare-fun n () Int)
(declare-fun v_bool_311_1709_primed () Int)
(declare-fun ys_3388 () Int)
(declare-fun ys () Int)
(declare-fun xs () Int)
(declare-fun next_315_3387 () Int)
(declare-fun q_3382 () Int)
(declare-fun ys_3404 () Int)
(declare-fun xs_3403 () Int)
(declare-fun tmp_primed () Int)
(declare-fun m () Int)
(declare-fun xs_3389 () Int)
(declare-fun flted_14_3380 () Int)
(declare-fun xs_primed () Int)
(declare-fun n_3390 () Int)
(declare-fun m_3391 () Int)
(declare-fun flted_191_3405 () Int)
(declare-fun ys_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ m 1) m_3391))
(assert (= q_3397 ys_3388))
(assert (= Anon_3396 Anon_3381))
(assert (= (+ flted_14_3380 1) n))
(assert (> v_bool_311_1709_primed 0))
(assert (= ys_3388 ys))
(assert (= xs_3389 xs))
(assert (= tmp_primed q_3382))
(assert (= next_315_3387 q_3382))
(assert (= ys_3404 xs_3389))
(assert (= xs_3403 tmp_primed))
(assert (= n_3390 flted_14_3380))
(assert (<= 0 m))
(assert (> xs_3389 0))
(assert (<= 0 flted_14_3380))
(assert (= flted_191_3405 (+ m_3391 n_3390)))
(assert (< xs_primed 1))
(assert (<= 0 n_3390))
(assert (<= 0 m_3391))
(assert (or (and (< ys_primed 1) (= flted_191_3405 0)) (and (<= 1 flted_191_3405) (> ys_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)