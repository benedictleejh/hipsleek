(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_4237 () Int)
(declare-fun Anon_4241 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun right_68_4122 () Int)
(declare-fun resn_4116 () Int)
(declare-fun resb_4117 () Int)
(declare-fun q_3781 () Int)
(declare-fun flted_43_4115 () Int)
(declare-fun b_4093 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun tn_4092 () Int)
(declare-fun tm_4091 () Int)
(declare-fun t () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun v_bool_48_2249_primed () Int)
(declare-fun n_3775 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n1_3779 () Int)
(declare-fun n2_3783 () Int)
(declare-fun tm () Int)
(declare-fun m2_3782 () Int)
(declare-fun m1_3778 () Int)
(declare-fun Anon_3776 () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_50_2248_primed () Int)
(declare-fun v_bool_69_2247_primed () Int)
(declare-fun n_4232 () Int)
(declare-fun b_4133 () Int)
(declare-fun n () Int)
(declare-fun n1_4236 () Int)
(declare-fun n2_4240 () Int)
(declare-fun m () Int)
(declare-fun m2_4239 () Int)
(declare-fun m1_4235 () Int)
(declare-fun v_bool_70_2246_primed () Int)
(declare-fun n_4153 () Int)
(declare-fun b_4154 () Int)
(declare-fun m_4152 () Int)
(declare-fun p_3777 () Int)
(declare-fun n_4245 () Int)
(declare-fun b_4246 () Int)
(declare-fun m_4244 () Int)
(declare-fun q_4238 () Int)
(declare-fun n_4264 () Int)
(declare-fun b_4265 () Int)
(declare-fun m_4263 () Int)
(declare-fun p_4234 () Int)
(declare-fun t_primed () Int)
(declare-fun v_node_68_4127 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= b_4265 2))
(assert (<= 0 b_4265))
(assert (<= 0 n_4264))
(assert (<= 0 m_4263))
(assert (<= Anon_4237 2))
(assert (<= 0 Anon_4237))
(assert (<= 0 n1_4236))
(assert (<= 0 m1_4235))
(assert (= b_4265 Anon_4237))
(assert (= n_4264 n1_4236))
(assert (= m_4263 m1_4235))
(assert (<= b_4246 2))
(assert (<= 0 b_4246))
(assert (<= 0 n_4245))
(assert (<= 0 m_4244))
(assert (<= Anon_4241 2))
(assert (<= 0 Anon_4241))
(assert (<= 0 n2_4240))
(assert (<= 0 m2_4239))
(assert (= b_4246 Anon_4241))
(assert (= n_4245 n2_4240))
(assert (= m_4244 m2_4239))
(assert (= (+ 2 n_4153) n))
(assert (<= b_4154 2))
(assert (<= 0 b_4154))
(assert (<= 0 n_4153))
(assert (<= 0 m_4152))
(assert (<= Anon_3780 2))
(assert (<= 0 Anon_3780))
(assert (<= 0 n1_3779))
(assert (<= 0 m1_3778))
(assert (= b_4154 Anon_3780))
(assert (= n_4153 n1_3779))
(assert (= m_4152 m1_3778))
(assert (<= b_4133 2))
(assert (<= 0 b_4133))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (<= resb_4117 2))
(assert (<= 0 resb_4117))
(assert (<= 0 resn_4116))
(assert (<= 0 flted_43_4115))
(assert (= b_4133 resb_4117))
(assert (= n resn_4116))
(assert (= m flted_43_4115))
(assert (= right_68_4122 q_3781))
(assert (<= b_4093 2))
(assert (<= 0 b_4093))
(assert (<= 0 tn_4092))
(assert (<= 0 tm_4091))
(assert (or (= tn_4092 resn_4116) (and (= resn_4116 (+ 1 tn_4092)) (not (= resb_4117 1)))))
(assert (< 0 tn_4092))
(assert (< 0 tm_4091))
(assert (> q_3781 0))
(assert (= flted_43_4115 (+ 1 tm_4091)))
(assert (<= Anon_3784 2))
(assert (<= 0 Anon_3784))
(assert (<= 0 n2_3783))
(assert (<= 0 m2_3782))
(assert (= b_4093 Anon_3784))
(assert (= tn_4092 n2_3783))
(assert (= tm_4091 m2_3782))
(assert (= t_primed t))
(assert (= x_primed x))
(assert (< tmp_primed 1))
(assert (> t_primed 0))
(assert (not (> v_bool_48_2249_primed 0)))
(assert (= n_3775 tn))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (exists ((max_63 Int)) (and (= tn (+ 1 max_63)) (or (and (= max_63 n1_3779) (>= n1_3779 n2_3783)) (and (= max_63 n2_3783) (< n1_3779 n2_3783))))))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (<= Anon_3776 x_primed))
(assert (not (> v_bool_50_2248_primed 0)))
(assert (> v_bool_69_2247_primed 0))
(assert (= n_4232 n))
(assert (<= n1_4236 (+ n2_4240 1)))
(assert (<= n2_4240 (+ 1 n1_4236)))
(assert (= (+ b_4133 n2_4240) (+ 1 n1_4236)))
(assert (exists ((max_63 Int)) (and (= n (+ 1 max_63)) (or (and (= max_63 n1_4236) (>= n1_4236 n2_4240)) (and (= max_63 n2_4240) (< n1_4236 n2_4240))))))
(assert (= m (+ (+ m2_4239 1) m1_4235)))
(assert (<= n_4245 n_4264))
(assert (not (> v_bool_70_2246_primed 0)))
(assert (= t_primed 1))
(assert (= v_node_68_4127 2))
(assert (or (and (and (and (< p_3777 1) (= m_4152 0)) (= n_4153 0)) (= b_4154 1)) (and (and (and (and (and (<= 0 b_4154) (<= (+ (- 0 n_4153) 2) b_4154)) (<= b_4154 n_4153)) (<= b_4154 2)) (<= 1 m_4152)) (> p_3777 0))))
(assert (or (and (and (and (< q_4238 1) (= m_4244 0)) (= n_4245 0)) (= b_4246 1)) (and (and (and (and (and (<= 0 b_4246) (<= (+ (- 0 n_4245) 2) b_4246)) (<= b_4246 n_4245)) (<= b_4246 2)) (<= 1 m_4244)) (> q_4238 0))))
(assert (or (and (and (and (< p_4234 1) (= m_4263 0)) (= n_4264 0)) (= b_4265 1)) (and (and (and (and (and (<= 0 b_4265) (<= (+ (- 0 n_4264) 2) b_4265)) (<= b_4265 n_4264)) (<= b_4265 2)) (<= 1 m_4263)) (> p_4234 0))))
(assert (not (= t_primed v_node_68_4127)))
;Negation of Consequence
(assert (not false))
(check-sat)