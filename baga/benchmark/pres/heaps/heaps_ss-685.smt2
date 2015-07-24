(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_32_1871_primed () Int)
(declare-fun v_bool_30_1961_primed () Int)
(declare-fun n () Int)
(declare-fun mx () Int)
(declare-fun m3_3848 () Int)
(declare-fun m2_3854 () Int)
(declare-fun v_bool_27_1962_primed () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun t () Int)
(declare-fun m1_3846 () Int)
(declare-fun mx1_3852 () Int)
(declare-fun tmpv_3907 () Int)
(declare-fun n_3886 () Int)
(declare-fun mx_3887 () Int)
(declare-fun left_36_3901 () Int)
(declare-fun l_3850 () Int)
(declare-fun v_int_38_3960 () Int)
(declare-fun nleft_38_3916 () Int)
(declare-fun m1_3851 () Int)
(declare-fun val_48_3962 () Int)
(declare-fun d_3849 () Int)
(declare-fun res () Int)
(declare-fun mx2_3855 () Int)
(declare-fun m2_3847 () Int)
(declare-fun r_3853 () Int)
(declare-fun ma_3900 () Int)
(declare-fun n1_3899 () Int)
(declare-fun v_node_36_3905 () Int)
(declare-fun t_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_32_1871_primed 0))
(assert (<= m1_3851 m2_3854))
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
(assert (= tmpv_3907 d_3849))
(assert (= n_3886 m1_3846))
(assert (= mx_3887 mx1_3852))
(assert (<= 0 m1_3846))
(assert (<= 0 mx1_3852))
(assert (= n1_3899 (+ 1 n_3886)))
(assert (or (and (<= mx_3887 tmpv_3907) (= ma_3900 tmpv_3907)) (= ma_3900 mx_3887)))
(assert (<= 0 n_3886))
(assert (<= 0 mx_3887))
(assert (= left_36_3901 l_3850))
(assert (= v_int_38_3960 (+ 1 m1_3851)))
(assert (= nleft_38_3916 m1_3851))
(assert (= val_48_3962 d_3849))
(assert (= res t_primed))
(assert (or (and (and (< r_3853 1) (= m2_3847 0)) (= mx2_3855 0)) (and (and (<= 0 mx2_3855) (<= 1 m2_3847)) (> r_3853 0))))
(assert (or (and (and (< v_node_36_3905 1) (= n1_3899 0)) (= ma_3900 0)) (and (and (<= 0 ma_3900) (<= 1 n1_3899)) (> v_node_36_3905 0))))
(assert (= t_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)