(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun q_3704 () Int)
(declare-fun p_3701 () Int)
(declare-fun xrightheight_primed () Int)
(declare-fun xrightval_primed () Int)
(declare-fun Anon_3700 () Int)
(declare-fun Anon_3645 () Int)
(declare-fun flted_160_3644 () Int)
(declare-fun n_3631 () Int)
(declare-fun m_3630 () Int)
(declare-fun tmp_primed () Int)
(declare-fun xright_3639 () Int)
(declare-fun q_3372 () Int)
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
(declare-fun xval_primed () Int)
(declare-fun a_primed () Int)
(declare-fun v_bool_170_1733_primed () Int)
(declare-fun v_bool_198_1732_primed () Int)
(declare-fun n_3699 () Int)
(declare-fun n_3641 () Int)
(declare-fun n2_3706 () Int)
(declare-fun n1_3703 () Int)
(declare-fun m_3640 () Int)
(declare-fun m2_3705 () Int)
(declare-fun m1_3702 () Int)
(declare-fun res () Int)
(declare-fun v_int_201_1615_primed () Int)
(declare-fun v_int_201_1616_primed () Int)
(declare-fun n_3651 () Int)
(declare-fun m_3650 () Int)
(declare-fun xleft_primed () Int)
(declare-fun n_3708 () Int)
(declare-fun m_3707 () Int)
(declare-fun xrightright_primed () Int)
(declare-fun n_3717 () Int)
(declare-fun m_3716 () Int)
(declare-fun xrightleft_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_3717))
(assert (<= 0 m_3716))
(assert (= v_int_201_1615_primed n_3717))
(assert (<= 0 n1_3703))
(assert (<= 0 m1_3702))
(assert (= n_3717 n1_3703))
(assert (= m_3716 m1_3702))
(assert (<= 0 n_3708))
(assert (<= 0 m_3707))
(assert (= v_int_201_1616_primed n_3708))
(assert (<= 0 n2_3706))
(assert (<= 0 m2_3705))
(assert (= n_3708 n2_3706))
(assert (= m_3707 m2_3705))
(assert (= xrightright_primed q_3704))
(assert (= xrightleft_primed p_3701))
(assert (= xrightheight_primed n_3699))
(assert (= xrightval_primed Anon_3700))
(assert (= (+ 2 n_3651) n_3641))
(assert (<= 0 n_3651))
(assert (<= 0 m_3650))
(assert (<= 0 n1_3371))
(assert (<= 0 m1_3370))
(assert (= n_3651 n1_3371))
(assert (= m_3650 m1_3370))
(assert (<= 0 n_3641))
(assert (<= 0 m_3640))
(assert (<= 0 Anon_3645))
(assert (<= 0 flted_160_3644))
(assert (= n_3641 Anon_3645))
(assert (= m_3640 flted_160_3644))
(assert (<= 0 n_3631))
(assert (<= 0 m_3630))
(assert (= flted_160_3644 (+ 1 m_3630)))
(assert (<= 0 n2_3374))
(assert (<= 0 m2_3373))
(assert (= n_3631 n2_3374))
(assert (= m_3630 m2_3373))
(assert (= tmp_primed xright_3639))
(assert (= xright_3639 q_3372))
(assert (= xleft_primed p_3369))
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
(assert (< xval_primed a_primed))
(assert (not (> v_bool_170_1733_primed 0)))
(assert (> v_bool_198_1732_primed 0))
(assert (= n_3699 n_3641))
(assert (exists ((max_32 Int)) (and (= n_3641 (+ 1 max_32)) (or (and (= max_32 n1_3703) (>= n1_3703 n2_3706)) (and (= max_32 n2_3706) (< n1_3703 n2_3706))))))
(assert (<= n1_3703 (+ 1 n2_3706)))
(assert (<= (+ 0 n2_3706) (+ n1_3703 1)))
(assert (= m_3640 (+ (+ m2_3705 1) m1_3702)))
(assert (> res 0))
(assert (< v_int_201_1615_primed v_int_201_1616_primed))
(assert (or (and (and (< xleft_primed 1) (= m_3650 0)) (= n_3651 0)) (and (and (<= 1 n_3651) (<= 1 m_3650)) (> xleft_primed 0))))
(assert (or (and (and (< xrightright_primed 1) (= m_3707 0)) (= n_3708 0)) (and (and (<= 1 n_3708) (<= 1 m_3707)) (> xrightright_primed 0))))
(assert (or (and (and (< xrightleft_primed 1) (= m_3716 0)) (= n_3717 0)) (and (and (<= 1 n_3717) (<= 1 m_3716)) (> xrightleft_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)