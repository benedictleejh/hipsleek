(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_178_1524_primed () Int)
(declare-fun n_3451 () Int)
(declare-fun v_bool_175_1534_primed () Int)
(declare-fun v_bool_170_1733_primed () Int)
(declare-fun Anon_3368 () Int)
(declare-fun m () Int)
(declare-fun n_3367 () Int)
(declare-fun n () Int)
(declare-fun v_bool_165_1734_primed () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun xleft_3391 () Int)
(declare-fun p_3369 () Int)
(declare-fun m1_3370 () Int)
(declare-fun n1_3371 () Int)
(declare-fun m_3382 () Int)
(declare-fun n_3383 () Int)
(declare-fun flted_160_3396 () Int)
(declare-fun Anon_3397 () Int)
(declare-fun m_3392 () Int)
(declare-fun m2_3373 () Int)
(declare-fun n2_3374 () Int)
(declare-fun n_3393 () Int)
(declare-fun m1_3454 () Int)
(declare-fun n1_3455 () Int)
(declare-fun m2_3457 () Int)
(declare-fun n2_3458 () Int)
(declare-fun m_3402 () Int)
(declare-fun n_3403 () Int)
(declare-fun m_3468 () Int)
(declare-fun n_3469 () Int)
(declare-fun m_3459 () Int)
(declare-fun n_3460 () Int)
(declare-fun flted_50_3914 () Int)
(declare-fun flted_50_3915 () Int)
(declare-fun llm () Int)
(declare-fun lln () Int)
(declare-fun lrm () Int)
(declare-fun rm () Int)
(declare-fun res () Int)
(declare-fun v_node_180_1431_primed () Int)
(declare-fun xleft_3913 () Int)
(declare-fun x_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_178_1524_primed 0))
(assert (< n_3469 n_3460))
(assert (= m_3392 (+ (+ m2_3457 1) m1_3454)))
(assert (<= (+ 0 n2_3458) (+ n1_3455 1)))
(assert (<= n1_3455 (+ 1 n2_3458)))
(assert (exists ((max_32 Int)) (and (= n_3393 (+ 1 max_32)) (or (and (= max_32 n1_3455) (>= n1_3455 n2_3458)) (and (= max_32 n2_3458) (< n1_3455 n2_3458))))))
(assert (= n_3451 n_3393))
(assert (> v_bool_175_1534_primed 0))
(assert (> v_bool_170_1733_primed 0))
(assert (<= a_primed Anon_3368))
(assert (= m (+ (+ m2_3373 1) m1_3370)))
(assert (<= (+ 0 n2_3374) (+ n1_3371 1)))
(assert (<= n1_3371 (+ 1 n2_3374)))
(assert (exists ((max_32 Int)) (and (= n (+ 1 max_32)) (or (and (= max_32 n1_3371) (>= n1_3371 n2_3374)) (and (= max_32 n2_3374) (< n1_3371 n2_3374))))))
(assert (= n_3367 n))
(assert (not (> v_bool_165_1734_primed 0)))
(assert (> x_primed 0))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= xleft_3391 p_3369))
(assert (= m_3382 m1_3370))
(assert (= n_3383 n1_3371))
(assert (<= 0 m1_3370))
(assert (<= 0 n1_3371))
(assert (= flted_160_3396 (+ 1 m_3382)))
(assert (<= 0 m_3382))
(assert (<= 0 n_3383))
(assert (= m_3392 flted_160_3396))
(assert (= n_3393 Anon_3397))
(assert (<= 0 flted_160_3396))
(assert (<= 0 Anon_3397))
(assert (<= 0 m_3392))
(assert (<= 0 n_3393))
(assert (= m_3402 m2_3373))
(assert (= n_3403 n2_3374))
(assert (<= 0 m2_3373))
(assert (<= 0 n2_3374))
(assert (= (+ 2 n_3403) n_3393))
(assert (= m_3459 m1_3454))
(assert (= n_3460 n1_3455))
(assert (<= 0 m1_3454))
(assert (<= 0 n1_3455))
(assert (= m_3468 m2_3457))
(assert (= n_3469 n2_3458))
(assert (<= 0 m2_3457))
(assert (<= 0 n2_3458))
(assert (= llm m_3459))
(assert (= lln n_3460))
(assert (= lrm m_3468))
(assert (= rm m_3402))
(assert (<= 0 m_3402))
(assert (<= 0 n_3403))
(assert (<= 0 m_3468))
(assert (<= 0 n_3469))
(assert (<= 0 m_3459))
(assert (<= 0 n_3460))
(assert (= flted_50_3914 (+ (+ (+ rm llm) 2) lrm)))
(assert (= flted_50_3915 (+ lln 1)))
(assert (exists ((flted_49_112 Int)) (<= 0 flted_49_112)))
(assert (exists ((flted_49_111 Int)) (<= 0 flted_49_111)))
(assert (<= 0 llm))
(assert (<= 0 lln))
(assert (<= 0 lrm))
(assert (<= 0 rm))
(assert (= res v_node_180_1431_primed))
(assert (= xleft_3913 1))
(assert (= x_primed 2))
(assert (not (= xleft_3913 x_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)