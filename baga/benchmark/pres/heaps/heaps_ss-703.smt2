(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun mx2_4112 () Int)
(declare-fun mx1_4109 () Int)
(declare-fun r_4110 () Int)
(declare-fun v_node_44_3944 () Int)
(declare-fun l_4107 () Int)
(declare-fun l_3850 () Int)
(declare-fun m2_4111 () Int)
(declare-fun m1_4108 () Int)
(declare-fun d_4106 () Int)
(declare-fun v_bool_32_1871_primed () Int)
(declare-fun v_bool_30_1961_primed () Int)
(declare-fun n () Int)
(declare-fun mx1_3852 () Int)
(declare-fun mx () Int)
(declare-fun m3_3848 () Int)
(declare-fun m1_3846 () Int)
(declare-fun m1_3851 () Int)
(declare-fun v_bool_27_1962_primed () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun t () Int)
(declare-fun m2_3847 () Int)
(declare-fun mx2_3855 () Int)
(declare-fun n1_3938 () Int)
(declare-fun tmpv_3946 () Int)
(declare-fun ma_3939 () Int)
(declare-fun n_3925 () Int)
(declare-fun mx_3926 () Int)
(declare-fun right_44_3940 () Int)
(declare-fun r_3853 () Int)
(declare-fun v_int_46_3961 () Int)
(declare-fun nright_46_3955 () Int)
(declare-fun m2_3854 () Int)
(declare-fun val_48_3963 () Int)
(declare-fun d_3849 () Int)
(declare-fun res () Int)
(declare-fun t_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= mx2_4112 ma_3939))
(assert (= mx1_4109 mx1_3852))
(assert (= r_4110 v_node_44_3944))
(assert (= l_4107 l_3850))
(assert (= m2_4111 v_int_46_3961))
(assert (= m1_4108 m1_3851))
(assert (= d_4106 v_primed))
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
(assert (<= 0 v))
(assert (= v_primed v))
(assert (= t_primed t))
(assert (= tmpv_3946 d_3849))
(assert (= n_3925 m2_3847))
(assert (= mx_3926 mx2_3855))
(assert (<= 0 m2_3847))
(assert (<= 0 mx2_3855))
(assert (= n1_3938 (+ 1 n_3925)))
(assert (or (and (<= mx_3926 tmpv_3946) (= ma_3939 tmpv_3946)) (= ma_3939 mx_3926)))
(assert (<= 0 n_3925))
(assert (<= 0 mx_3926))
(assert (= right_44_3940 r_3853))
(assert (= v_int_46_3961 (+ 1 m2_3854)))
(assert (= nright_46_3955 m2_3854))
(assert (= val_48_3963 d_3849))
(assert (= res t_primed))
;Negation of Consequence
(assert (not false))
(check-sat)