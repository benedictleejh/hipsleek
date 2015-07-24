(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_32_1871_primed () Int)
(declare-fun v_bool_30_1961_primed () Int)
(declare-fun n () Int)
(declare-fun mx () Int)
(declare-fun m3_3848 () Int)
(declare-fun m1_3851 () Int)
(declare-fun m2_3854 () Int)
(declare-fun v_bool_27_1962_primed () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun t () Int)
(declare-fun tmp_primed () Int)
(declare-fun r_3853 () Int)
(declare-fun d_3849 () Int)
(declare-fun m2_3847 () Int)
(declare-fun mx2_3855 () Int)
(declare-fun tmpv_primed () Int)
(declare-fun n_3925 () Int)
(declare-fun mx_3926 () Int)
(declare-fun t_primed () Int)
(declare-fun mx1_3852 () Int)
(declare-fun m1_3846 () Int)
(declare-fun l_3850 () Int)
(declare-fun ma_3932 () Int)
(declare-fun n1_3931 () Int)
(declare-fun res () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (not (> v_bool_32_1871_primed 0)))
(assert (< m2_3854 m1_3851))
(assert (> v_bool_30_1961_primed 0))
(assert (< d_3849 v_primed))
(assert (= n (+ (+ m2_3854 1) m1_3851)))
(assert (<= 0 d_3849))
(assert (<= mx1_3852 d_3849))
(assert (<= mx2_3855 d_3849))
(assert (<= d_3849 mx))
(assert (= (+ m3_3848 m2_3854) m1_3851))
(assert (<= 0 m3_3848))
(assert (<= m3_3848 1))
(assert (= m1_3846 m1_3851))
(assert (= m2_3847 m2_3854))
(assert (not (> v_bool_27_1962_primed 0)))
(assert (> t_primed 0))
(assert (< tmp_null_primed 1))
(assert (<= 0 v))
(assert (= v_primed v))
(assert (= t_primed t))
(assert (= tmp_primed r_3853))
(assert (= tmpv_primed d_3849))
(assert (= n_3925 m2_3847))
(assert (= mx_3926 mx2_3855))
(assert (<= 0 m2_3847))
(assert (<= 0 mx2_3855))
(assert (= n1_3931 (+ 1 n_3925)))
(assert (or (and (<= mx_3926 tmpv_primed) (= ma_3932 tmpv_primed)) (= ma_3932 mx_3926)))
(assert (<= 0 n_3925))
(assert (<= 0 mx_3926))
(assert (= t_primed 1))
(assert (or (and (and (< l_3850 1) (= m1_3846 0)) (= mx1_3852 0)) (and (and (<= 0 mx1_3852) (<= 1 m1_3846)) (> l_3850 0))))
(assert (or (and (and (< res 1) (= n1_3931 0)) (= ma_3932 0)) (and (and (<= 0 ma_3932) (<= 1 n1_3931)) (> res 0))))
;Negation of Consequence
(assert (not false))
(check-sat)