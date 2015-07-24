(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_3383 () Int)
(declare-fun xheight_primed () Int)
(declare-fun n_3367 () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun n1_3371 () Int)
(declare-fun q_3372 () Int)
(declare-fun m1_3370 () Int)
(declare-fun m_3382 () Int)
(declare-fun m2_3373 () Int)
(declare-fun n2_3374 () Int)
(declare-fun q_3456 () Int)
(declare-fun xleftright_primed () Int)
(declare-fun m_3402 () Int)
(declare-fun xright_primed () Int)
(declare-fun m_3468 () Int)
(declare-fun xleftheight_primed () Int)
(declare-fun n_3403 () Int)
(declare-fun Anon_3397 () Int)
(declare-fun flted_160_3396 () Int)
(declare-fun n_3451 () Int)
(declare-fun n_3393 () Int)
(declare-fun n2_3458 () Int)
(declare-fun m_3392 () Int)
(declare-fun m2_3457 () Int)
(declare-fun n_3469 () Int)
(declare-fun p_3453 () Int)
(declare-fun m1_3454 () Int)
(declare-fun n1_3455 () Int)
(declare-fun m_3459 () Int)
(declare-fun n_3460 () Int)
(declare-fun xleftleft_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n2_3374))
(assert (<= 0 m2_3373))
(assert (<= 0 n_3383))
(assert (<= 0 m_3382))
(assert (<= 0 n1_3371))
(assert (<= 0 m1_3370))
(assert (= n_3383 n1_3371))
(assert (= xheight_primed n_3367))
(assert (= n_3367 n))
(assert (= m (+ (+ m2_3373 1) m1_3370)))
(assert (<= (+ 0 n2_3374) (+ n1_3371 1)))
(assert (<= n1_3371 (+ 1 n2_3374)))
(assert (exists ((max_3510 Int)) (and (= n (+ 1 max_3510)) (or (and (= max_3510 n1_3371) (>= n1_3371 n2_3374)) (and (= max_3510 n2_3374) (< n1_3371 n2_3374))))))
(assert (= xright_primed q_3372))
(assert (= m_3382 m1_3370))
(assert (= flted_160_3396 (+ 1 m_3382)))
(assert (= m_3402 m2_3373))
(assert (= n_3403 n2_3374))
(assert (<= 0 m_3402))
(assert (<= 0 n_3403))
(assert (= xleftright_primed q_3456))
(assert (or (and (and (< xleftright_primed 1) (= m_3468 0)) (= n_3469 0)) (and (and (<= 1 n_3469) (<= 1 m_3468)) (> xleftright_primed 0))))
(assert (or (and (and (< xright_primed 1) (= m_3402 0)) (= n_3403 0)) (and (and (<= 1 n_3403) (<= 1 m_3402)) (> xright_primed 0))))
(assert (<= 0 n_3469))
(assert (<= 0 m_3468))
(assert (<= 0 n2_3458))
(assert (<= 0 m2_3457))
(assert (= n_3469 n2_3458))
(assert (= m_3468 m2_3457))
(assert (<= 0 n1_3455))
(assert (<= 0 m1_3454))
(assert (= xleftheight_primed n_3451))
(assert (= (+ 2 n_3403) n_3393))
(assert (<= 0 n_3393))
(assert (<= 0 m_3392))
(assert (<= 0 Anon_3397))
(assert (<= 0 flted_160_3396))
(assert (= n_3393 Anon_3397))
(assert (= m_3392 flted_160_3396))
(assert (= n_3451 n_3393))
(assert (exists ((max_3511 Int)) (and (= n_3393 (+ 1 max_3511)) (or (and (= max_3511 n1_3455) (>= n1_3455 n2_3458)) (and (= max_3511 n2_3458) (< n1_3455 n2_3458))))))
(assert (<= n1_3455 (+ 1 n2_3458)))
(assert (<= (+ 0 n2_3458) (+ n1_3455 1)))
(assert (= m_3392 (+ (+ m2_3457 1) m1_3454)))
(assert (<= n_3460 n_3469))
(assert (= xleftleft_primed p_3453))
(assert (= m_3459 m1_3454))
(assert (= n_3460 n1_3455))
(assert (<= 0 m_3459))
(assert (<= 0 n_3460))
(assert (or (and (and (< xleftleft_primed 1) (= m_3459 0)) (= n_3460 0)) (and (and (<= 1 n_3460) (<= 1 m_3459)) (> xleftleft_primed 0))))
;Negation of Consequence
(assert (not (or (= m_3459 0) (or (= n_3460 0) (< xleftleft_primed 1)))))
(check-sat)