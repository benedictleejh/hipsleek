(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_53_1960_primed () Int)
(declare-fun v_bool_30_1961_primed () Int)
(declare-fun n () Int)
(declare-fun d_3849 () Int)
(declare-fun mx () Int)
(declare-fun m3_3848 () Int)
(declare-fun m2_3854 () Int)
(declare-fun v_bool_27_1962_primed () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun v () Int)
(declare-fun t () Int)
(declare-fun tmp_primed () Int)
(declare-fun m1_3846 () Int)
(declare-fun mx1_3852 () Int)
(declare-fun v_primed () Int)
(declare-fun n_3982 () Int)
(declare-fun mx_3983 () Int)
(declare-fun left_56_3997 () Int)
(declare-fun l_3850 () Int)
(declare-fun m1_3851 () Int)
(declare-fun res () Int)
(declare-fun v_int_58_1920_primed () Int)
(declare-fun tmpv_primed () Int)
(declare-fun mx2_3855 () Int)
(declare-fun m2_3847 () Int)
(declare-fun r_3853 () Int)
(declare-fun ma_3996 () Int)
(declare-fun n1_3995 () Int)
(declare-fun v_node_56_4001 () Int)
(declare-fun t_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_53_1960_primed 0))
(assert (<= m1_3851 m2_3854))
(assert (not (> v_bool_30_1961_primed 0)))
(assert (<= v_primed d_3849))
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
(assert (= tmp_primed l_3850))
(assert (= n_3982 m1_3846))
(assert (= mx_3983 mx1_3852))
(assert (<= 0 m1_3846))
(assert (<= 0 mx1_3852))
(assert (= n1_3995 (+ 1 n_3982)))
(assert (or (and (<= mx_3983 v_primed) (= ma_3996 v_primed)) (= ma_3996 mx_3983)))
(assert (<= 0 n_3982))
(assert (<= 0 mx_3983))
(assert (= left_56_3997 l_3850))
(assert (= tmpv_primed m1_3851))
(assert (= v_int_58_1920_primed 1))
(assert (= res (+ v_int_58_1920_primed tmpv_primed)))
(assert (or (and (and (< r_3853 1) (= m2_3847 0)) (= mx2_3855 0)) (and (and (<= 0 mx2_3855) (<= 1 m2_3847)) (> r_3853 0))))
(assert (or (and (and (< v_node_56_4001 1) (= n1_3995 0)) (= ma_3996 0)) (and (and (<= 0 ma_3996) (<= 1 n1_3995)) (> v_node_56_4001 0))))
(assert (= t_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)