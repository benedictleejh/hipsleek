(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m_3468 () Int)
(declare-fun m_3459 () Int)
(declare-fun q_3456 () Int)
(declare-fun p_3453 () Int)
(declare-fun xleftheight_primed () Int)
(declare-fun xleftval_primed () Int)
(declare-fun Anon_3452 () Int)
(declare-fun Anon_3397 () Int)
(declare-fun flted_160_3396 () Int)
(declare-fun n_3383 () Int)
(declare-fun m_3382 () Int)
(declare-fun tmp_primed () Int)
(declare-fun q_3372 () Int)
(declare-fun xleft_3391 () Int)
(declare-fun p_3369 () Int)
(declare-fun xheight_primed () Int)
(declare-fun Anon_3368 () Int)
(declare-fun x () Int)
(declare-fun a () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_165_1734_primed () Int)
(declare-fun n_3367 () Int)
(declare-fun n () Int)
(declare-fun n2_3374 () Int)
(declare-fun n1_3371 () Int)
(declare-fun m () Int)
(declare-fun m2_3373 () Int)
(declare-fun m1_3370 () Int)
(declare-fun a_primed () Int)
(declare-fun xval_primed () Int)
(declare-fun v_bool_170_1733_primed () Int)
(declare-fun v_bool_175_1534_primed () Int)
(declare-fun n_3451 () Int)
(declare-fun n_3393 () Int)
(declare-fun n2_3458 () Int)
(declare-fun n1_3455 () Int)
(declare-fun m_3392 () Int)
(declare-fun m2_3457 () Int)
(declare-fun m1_3454 () Int)
(declare-fun n_3460 () Int)
(declare-fun n_3469 () Int)
(declare-fun v_bool_178_1524_primed () Int)
(declare-fun v_int_184_1482_primed () Int)
(declare-fun v_bool_184_1523_primed () Int)
(declare-fun n_3403 () Int)
(declare-fun m_3402 () Int)
(declare-fun xright_primed () Int)
(declare-fun n_3507 () Int)
(declare-fun m_3506 () Int)
(declare-fun xleftleft_primed () Int)
(declare-fun n_3516 () Int)
(declare-fun m_3515 () Int)
(declare-fun xleftright_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ v_int_184_1482_primed 1) n_3516))
(assert (<= 0 n_3516))
(assert (<= 0 m_3515))
(assert (<= 0 n_3469))
(assert (<= 0 m_3468))
(assert (= n_3516 n_3469))
(assert (= m_3515 m_3468))
(assert (<= 0 n_3507))
(assert (<= 0 m_3506))
(assert (<= 0 n_3460))
(assert (<= 0 m_3459))
(assert (= n_3507 n_3460))
(assert (= m_3506 m_3459))
(assert (<= 0 n2_3458))
(assert (<= 0 m2_3457))
(assert (= n_3469 n2_3458))
(assert (= m_3468 m2_3457))
(assert (<= 0 n1_3455))
(assert (<= 0 m1_3454))
(assert (= n_3460 n1_3455))
(assert (= m_3459 m1_3454))
(assert (= xleftright_primed q_3456))
(assert (= xleftleft_primed p_3453))
(assert (= xleftheight_primed n_3451))
(assert (= xleftval_primed Anon_3452))
(assert (= (+ 2 n_3403) n_3393))
(assert (<= 0 n_3403))
(assert (<= 0 m_3402))
(assert (<= 0 n2_3374))
(assert (<= 0 m2_3373))
(assert (= n_3403 n2_3374))
(assert (= m_3402 m2_3373))
(assert (<= 0 n_3393))
(assert (<= 0 m_3392))
(assert (<= 0 Anon_3397))
(assert (<= 0 flted_160_3396))
(assert (= n_3393 Anon_3397))
(assert (= m_3392 flted_160_3396))
(assert (<= 0 n_3383))
(assert (<= 0 m_3382))
(assert (= flted_160_3396 (+ 1 m_3382)))
(assert (<= 0 n1_3371))
(assert (<= 0 m1_3370))
(assert (= n_3383 n1_3371))
(assert (= m_3382 m1_3370))
(assert (= tmp_primed xleft_3391))
(assert (= xright_primed q_3372))
(assert (= xleft_3391 p_3369))
(assert (= xheight_primed n_3367))
(assert (= xval_primed Anon_3368))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (< tmp_null_primed 1))
(assert (> x_primed 0))
(assert (not (> v_bool_165_1734_primed 0)))
(assert (= n_3367 n))
(assert (exists ((max_32 Int)) (and (= n (+ 1 max_32)) (or (and (= max_32 n1_3371) (>= n1_3371 n2_3374)) (and (= max_32 n2_3374) (< n1_3371 n2_3374))))))
(assert (<= n1_3371 (+ 1 n2_3374)))
(assert (<= (+ 0 n2_3374) (+ n1_3371 1)))
(assert (= m (+ (+ m2_3373 1) m1_3370)))
(assert (<= a_primed xval_primed))
(assert (> v_bool_170_1733_primed 0))
(assert (> v_bool_175_1534_primed 0))
(assert (= n_3451 n_3393))
(assert (exists ((max_32 Int)) (and (= n_3393 (+ 1 max_32)) (or (and (= max_32 n1_3455) (>= n1_3455 n2_3458)) (and (= max_32 n2_3458) (< n1_3455 n2_3458))))))
(assert (<= n1_3455 (+ 1 n2_3458)))
(assert (<= (+ 0 n2_3458) (+ n1_3455 1)))
(assert (= m_3392 (+ (+ m2_3457 1) m1_3454)))
(assert (<= n_3460 n_3469))
(assert (not (> v_bool_178_1524_primed 0)))
(assert (not (= n_3507 v_int_184_1482_primed)))
(assert (not (> v_bool_184_1523_primed 0)))
(assert (or (and (and (< xright_primed 1) (= m_3402 0)) (= n_3403 0)) (and (and (<= 1 n_3403) (<= 1 m_3402)) (> xright_primed 0))))
(assert (or (and (and (< xleftleft_primed 1) (= m_3506 0)) (= n_3507 0)) (and (and (<= 1 n_3507) (<= 1 m_3506)) (> xleftleft_primed 0))))
(assert (or (and (and (< xleftright_primed 1) (= m_3515 0)) (= n_3516 0)) (and (and (<= 1 n_3516) (<= 1 m_3515)) (> xleftright_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)