(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_4207 () Int)
(declare-fun v_bool_108_2210_primed () Int)
(declare-fun v_bool_86_2211_primed () Int)
(declare-fun Anon_3751 () Int)
(declare-fun tm () Int)
(declare-fun b () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
(declare-fun v_bool_80_2243_primed () Int)
(declare-fun tmp_primed () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun t () Int)
(declare-fun m2_3757 () Int)
(declare-fun n2_3758 () Int)
(declare-fun Anon_3759 () Int)
(declare-fun tm_4066 () Int)
(declare-fun tn_4067 () Int)
(declare-fun b_4068 () Int)
(declare-fun right_107_4097 () Int)
(declare-fun q_3756 () Int)
(declare-fun flted_74_4090 () Int)
(declare-fun resn_4091 () Int)
(declare-fun resb_4092 () Int)
(declare-fun m () Int)
(declare-fun b_4108 () Int)
(declare-fun m1_3753 () Int)
(declare-fun n1_3754 () Int)
(declare-fun Anon_3755 () Int)
(declare-fun n () Int)
(declare-fun m2_4214 () Int)
(declare-fun n2_4215 () Int)
(declare-fun Anon_4216 () Int)
(declare-fun m1_4210 () Int)
(declare-fun n1_4211 () Int)
(declare-fun Anon_4212 () Int)
(declare-fun v_int_109_2202_primed () Int)
(declare-fun v_int_109_2201_primed () Int)
(declare-fun n_4128 () Int)
(declare-fun b_4129 () Int)
(declare-fun m_4127 () Int)
(declare-fun p_3752 () Int)
(declare-fun n_4220 () Int)
(declare-fun b_4221 () Int)
(declare-fun m_4219 () Int)
(declare-fun q_4213 () Int)
(declare-fun n_4239 () Int)
(declare-fun b_4240 () Int)
(declare-fun m_4238 () Int)
(declare-fun p_4209 () Int)
(declare-fun t_primed () Int)
(declare-fun v_node_107_4102 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m (+ (+ m2_4214 1) m1_4210)))
(assert (exists ((max_79 Int)) (and (= n (+ max_79 1)) (or (and (= max_79 n1_4211) (>= n1_4211 n2_4215)) (and (= max_79 n2_4215) (< n1_4211 n2_4215))))))
(assert (<= (+ 0 n2_4215) (+ n1_4211 1)))
(assert (<= n1_4211 (+ 1 n2_4215)))
(assert (= (+ b_4108 n2_4215) (+ 1 n1_4211)))
(assert (= n_4207 n))
(assert (> v_bool_108_2210_primed 0))
(assert (not (> v_bool_86_2211_primed 0)))
(assert (<= Anon_3751 x_primed))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (exists ((max_79 Int)) (and (= tn (+ max_79 1)) (or (and (= max_79 n1_3754) (>= n1_3754 n2_3758)) (and (= max_79 n2_3758) (< n1_3754 n2_3758))))))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (= n_3750 tn))
(assert (not (> v_bool_80_2243_primed 0)))
(assert (> t_primed 0))
(assert (< tmp_primed 1))
(assert (= x_primed x))
(assert (= t_primed t))
(assert (= tm_4066 m2_3757))
(assert (= tn_4067 n2_3758))
(assert (= b_4068 Anon_3759))
(assert (<= 0 m2_3757))
(assert (<= 0 n2_3758))
(assert (<= 0 Anon_3759))
(assert (<= Anon_3759 2))
(assert (= flted_74_4090 (+ 1 tm_4066)))
(assert (> q_3756 0))
(assert (< 0 tm_4066))
(assert (< 0 tn_4067))
(assert (or (= tn_4067 resn_4091) (and (= resn_4091 (+ 1 tn_4067)) (not (= resb_4092 1)))))
(assert (<= 0 tm_4066))
(assert (<= 0 tn_4067))
(assert (<= 0 b_4068))
(assert (<= b_4068 2))
(assert (= right_107_4097 q_3756))
(assert (= m flted_74_4090))
(assert (= n resn_4091))
(assert (= b_4108 resb_4092))
(assert (<= 0 flted_74_4090))
(assert (<= 0 resn_4091))
(assert (<= 0 resb_4092))
(assert (<= resb_4092 2))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (<= 0 b_4108))
(assert (<= b_4108 2))
(assert (= m_4127 m1_3753))
(assert (= n_4128 n1_3754))
(assert (= b_4129 Anon_3755))
(assert (<= 0 m1_3753))
(assert (<= 0 n1_3754))
(assert (<= 0 Anon_3755))
(assert (<= Anon_3755 2))
(assert (<= 0 m_4127))
(assert (<= 0 n_4128))
(assert (<= 0 b_4129))
(assert (<= b_4129 2))
(assert (= (+ 2 n_4128) n))
(assert (= m_4219 m2_4214))
(assert (= n_4220 n2_4215))
(assert (= b_4221 Anon_4216))
(assert (<= 0 m2_4214))
(assert (<= 0 n2_4215))
(assert (<= 0 Anon_4216))
(assert (<= Anon_4216 2))
(assert (= v_int_109_2202_primed n_4220))
(assert (<= 0 m_4219))
(assert (<= 0 n_4220))
(assert (<= 0 b_4221))
(assert (<= b_4221 2))
(assert (= m_4238 m1_4210))
(assert (= n_4239 n1_4211))
(assert (= b_4240 Anon_4212))
(assert (<= 0 m1_4210))
(assert (<= 0 n1_4211))
(assert (<= 0 Anon_4212))
(assert (<= Anon_4212 2))
(assert (= v_int_109_2201_primed n_4239))
(assert (<= 0 m_4238))
(assert (<= 0 n_4239))
(assert (<= 0 b_4240))
(assert (<= b_4240 2))
(assert (<= v_int_109_2202_primed v_int_109_2201_primed))
(assert (= t_primed 1))
(assert (= v_node_107_4102 2))
(assert (or (and (and (and (< p_3752 1) (= m_4127 0)) (= n_4128 0)) (= b_4129 1)) (and (and (and (and (and (<= 0 b_4129) (<= (+ (- 0 n_4128) 2) b_4129)) (<= b_4129 n_4128)) (<= b_4129 2)) (<= 1 m_4127)) (> p_3752 0))))
(assert (or (and (and (and (< q_4213 1) (= m_4219 0)) (= n_4220 0)) (= b_4221 1)) (and (and (and (and (and (<= 0 b_4221) (<= (+ (- 0 n_4220) 2) b_4221)) (<= b_4221 n_4220)) (<= b_4221 2)) (<= 1 m_4219)) (> q_4213 0))))
(assert (or (and (and (and (< p_4209 1) (= m_4238 0)) (= n_4239 0)) (= b_4240 1)) (and (and (and (and (and (<= 0 b_4240) (<= (+ (- 0 n_4239) 2) b_4240)) (<= b_4240 n_4239)) (<= b_4240 2)) (<= 1 m_4238)) (> p_4209 0))))
(assert (not (= t_primed v_node_107_4102)))
;Negation of Consequence
(assert (not false))
(check-sat)