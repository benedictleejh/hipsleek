(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_4329 () Int)
(declare-fun v_bool_70_2246_primed () Int)
(declare-fun v_bool_69_2247_primed () Int)
(declare-fun v_bool_50_2248_primed () Int)
(declare-fun tm () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun v_bool_48_2249_primed () Int)
(declare-fun tmp_primed () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun t_primed () Int)
(declare-fun t () Int)
(declare-fun m2_3782 () Int)
(declare-fun n2_3783 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun tm_4091 () Int)
(declare-fun tn_4092 () Int)
(declare-fun b_4093 () Int)
(declare-fun right_68_4122 () Int)
(declare-fun q_3781 () Int)
(declare-fun flted_43_4115 () Int)
(declare-fun resn_4116 () Int)
(declare-fun resb_4117 () Int)
(declare-fun m () Int)
(declare-fun b_4133 () Int)
(declare-fun m1_3778 () Int)
(declare-fun n1_3779 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun n () Int)
(declare-fun m2_4239 () Int)
(declare-fun n2_4240 () Int)
(declare-fun Anon_4241 () Int)
(declare-fun m1_4235 () Int)
(declare-fun n1_4236 () Int)
(declare-fun Anon_4237 () Int)
(declare-fun m_4263 () Int)
(declare-fun n_4264 () Int)
(declare-fun b_4265 () Int)
(declare-fun Anon_29 () Int)
(declare-fun Anon_3776 () Int)
(declare-fun Anon_30 () Int)
(declare-fun n_3775 () Int)
(declare-fun a () Int)
(declare-fun p_3777 () Int)
(declare-fun k2 () Int)
(declare-fun v_node_68_4127 () Int)
(declare-fun am () Int)
(declare-fun m_4152 () Int)
(declare-fun an () Int)
(declare-fun n_4153 () Int)
(declare-fun Anon_31 () Int)
(declare-fun b_4154 () Int)
(declare-fun Anon_32 () Int)
(declare-fun Anon_4233 () Int)
(declare-fun Anon_33 () Int)
(declare-fun n_4232 () Int)
(declare-fun k3 () Int)
(declare-fun d () Int)
(declare-fun q_4238 () Int)
(declare-fun dm () Int)
(declare-fun m_4244 () Int)
(declare-fun dn () Int)
(declare-fun n_4245 () Int)
(declare-fun Anon_34 () Int)
(declare-fun b_4246 () Int)
(declare-fun p_4234 () Int)
(declare-fun n1_4333 () Int)
(declare-fun Anon_4334 () Int)
(declare-fun m1_4332 () Int)
(declare-fun p_4331 () Int)
(declare-fun n2_4337 () Int)
(declare-fun Anon_4338 () Int)
(declare-fun m2_4336 () Int)
(declare-fun q_4335 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m_4263 (+ (+ m2_4336 1) m1_4332)))
(assert (exists ((max_63 Int)) (and (= n_4264 (+ 1 max_63)) (or (and (= max_63 n1_4333) (>= n1_4333 n2_4337)) (and (= max_63 n2_4337) (< n1_4333 n2_4337))))))
(assert (= (+ b_4265 n2_4337) (+ 1 n1_4333)))
(assert (<= n2_4337 (+ 1 n1_4333)))
(assert (<= n1_4333 (+ n2_4337 1)))
(assert (= n_4329 n_4264))
(assert (not (> v_bool_70_2246_primed 0)))
(assert (<= n_4245 n_4264))
(assert (= m (+ (+ m2_4239 1) m1_4235)))
(assert (exists ((max_63 Int)) (and (= n (+ 1 max_63)) (or (and (= max_63 n1_4236) (>= n1_4236 n2_4240)) (and (= max_63 n2_4240) (< n1_4236 n2_4240))))))
(assert (= (+ b_4133 n2_4240) (+ 1 n1_4236)))
(assert (<= n2_4240 (+ 1 n1_4236)))
(assert (<= n1_4236 (+ n2_4240 1)))
(assert (= n_4232 n))
(assert (> v_bool_69_2247_primed 0))
(assert (not (> v_bool_50_2248_primed 0)))
(assert (<= Anon_3776 x_primed))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (exists ((max_63 Int)) (and (= tn (+ 1 max_63)) (or (and (= max_63 n1_3779) (>= n1_3779 n2_3783)) (and (= max_63 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= n_3775 tn))
(assert (not (> v_bool_48_2249_primed 0)))
(assert (> t_primed 0))
(assert (< tmp_primed 1))
(assert (= x_primed x))
(assert (= t_primed t))
(assert (= tm_4091 m2_3782))
(assert (= tn_4092 n2_3783))
(assert (= b_4093 Anon_3784))
(assert (<= 0 m2_3782))
(assert (<= 0 n2_3783))
(assert (<= 0 Anon_3784))
(assert (<= Anon_3784 2))
(assert (= flted_43_4115 (+ 1 tm_4091)))
(assert (> q_3781 0))
(assert (< 0 tm_4091))
(assert (< 0 tn_4092))
(assert (or (= tn_4092 resn_4116) (and (= resn_4116 (+ 1 tn_4092)) (not (= resb_4117 1)))))
(assert (<= 0 tm_4091))
(assert (<= 0 tn_4092))
(assert (<= 0 b_4093))
(assert (<= b_4093 2))
(assert (= right_68_4122 q_3781))
(assert (= m flted_43_4115))
(assert (= n resn_4116))
(assert (= b_4133 resb_4117))
(assert (<= 0 flted_43_4115))
(assert (<= 0 resn_4116))
(assert (<= 0 resb_4117))
(assert (<= resb_4117 2))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (<= 0 b_4133))
(assert (<= b_4133 2))
(assert (= m_4152 m1_3778))
(assert (= n_4153 n1_3779))
(assert (= b_4154 Anon_3780))
(assert (<= 0 m1_3778))
(assert (<= 0 n1_3779))
(assert (<= 0 Anon_3780))
(assert (<= Anon_3780 2))
(assert (<= 0 m_4152))
(assert (<= 0 n_4153))
(assert (<= 0 b_4154))
(assert (<= b_4154 2))
(assert (= (+ 2 n_4153) n))
(assert (= m_4244 m2_4239))
(assert (= n_4245 n2_4240))
(assert (= b_4246 Anon_4241))
(assert (<= 0 m2_4239))
(assert (<= 0 n2_4240))
(assert (<= 0 Anon_4241))
(assert (<= Anon_4241 2))
(assert (<= 0 m_4244))
(assert (<= 0 n_4245))
(assert (<= 0 b_4246))
(assert (<= b_4246 2))
(assert (= m_4263 m1_4235))
(assert (= n_4264 n1_4236))
(assert (= b_4265 Anon_4237))
(assert (<= 0 m1_4235))
(assert (<= 0 n1_4236))
(assert (<= 0 Anon_4237))
(assert (<= Anon_4237 2))
(assert (<= 0 m_4263))
(assert (<= 0 n_4264))
(assert (<= 0 b_4265))
(assert (<= b_4265 2))
(assert (= Anon_29 Anon_3776))
(assert (= Anon_30 n_3775))
(assert (= a p_3777))
(assert (= k2 v_node_68_4127))
(assert (= am m_4152))
(assert (= an n_4153))
(assert (= Anon_31 b_4154))
(assert (= Anon_32 Anon_4233))
(assert (= Anon_33 n_4232))
(assert (= k3 p_4234))
(assert (= d q_4238))
(assert (= dm m_4244))
(assert (= dn n_4245))
(assert (= Anon_34 b_4246))
(assert (= p_4234 1))
(assert (or (and (and (and (< p_4331 1) (= m1_4332 0)) (= n1_4333 0)) (= Anon_4334 1)) (and (and (and (and (and (<= 0 Anon_4334) (<= (+ (- 0 n1_4333) 2) Anon_4334)) (<= Anon_4334 n1_4333)) (<= Anon_4334 2)) (<= 1 m1_4332)) (> p_4331 0))))
(assert (or (and (and (and (< q_4335 1) (= m2_4336 0)) (= n2_4337 0)) (= Anon_4338 1)) (and (and (and (and (and (<= 0 Anon_4338) (<= (+ (- 0 n2_4337) 2) Anon_4338)) (<= Anon_4338 n2_4337)) (<= Anon_4338 2)) (<= 1 m2_4336)) (> q_4335 0))))
;Negation of Consequence
(assert (not false))
(check-sat)