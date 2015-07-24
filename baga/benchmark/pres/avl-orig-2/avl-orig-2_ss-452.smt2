(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_118_2215_primed () Int)
(declare-fun left_118_2214_primed () Int)
(declare-fun height_118_2213_primed () Int)
(declare-fun ele_118_2212_primed () Int)
(declare-fun Anon_4446 () Int)
(declare-fun resn_4456 () Int)
(declare-fun tmp2_4457 () Int)
(declare-fun resln_4458 () Int)
(declare-fun tmp1_4455 () Int)
(declare-fun Anon_62 () Int)
(declare-fun Anon_61 () Int)
(declare-fun rr () Int)
(declare-fun q_4213 () Int)
(declare-fun rl () Int)
(declare-fun p_4209 () Int)
(declare-fun Anon_60 () Int)
(declare-fun Anon_59 () Int)
(declare-fun Anon_4208 () Int)
(declare-fun Anon_58 () Int)
(declare-fun r () Int)
(declare-fun v_node_107_4102 () Int)
(declare-fun l () Int)
(declare-fun p_3752 () Int)
(declare-fun Anon_57 () Int)
(declare-fun Anon_56 () Int)
(declare-fun b_4240 () Int)
(declare-fun Anon_4212 () Int)
(declare-fun m_4238 () Int)
(declare-fun b_4221 () Int)
(declare-fun Anon_4216 () Int)
(declare-fun m_4219 () Int)
(declare-fun b_4129 () Int)
(declare-fun Anon_3755 () Int)
(declare-fun n_4128 () Int)
(declare-fun m_4127 () Int)
(declare-fun right_107_4097 () Int)
(declare-fun resn_4091 () Int)
(declare-fun resb_4092 () Int)
(declare-fun q_3756 () Int)
(declare-fun flted_74_4090 () Int)
(declare-fun b_4068 () Int)
(declare-fun Anon_3759 () Int)
(declare-fun tn_4067 () Int)
(declare-fun tm_4066 () Int)
(declare-fun t_4282 () Int)
(declare-fun t () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun v_bool_80_2243_primed () Int)
(declare-fun n_3750 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n1_3754 () Int)
(declare-fun n2_3758 () Int)
(declare-fun tm () Int)
(declare-fun m2_3757 () Int)
(declare-fun m1_3753 () Int)
(declare-fun Anon_3751 () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_86_2211_primed () Int)
(declare-fun v_bool_108_2210_primed () Int)
(declare-fun n_4207 () Int)
(declare-fun b_4108 () Int)
(declare-fun n () Int)
(declare-fun n1_4211 () Int)
(declare-fun n2_4215 () Int)
(declare-fun m () Int)
(declare-fun m2_4214 () Int)
(declare-fun m1_4210 () Int)
(declare-fun n_4239 () Int)
(declare-fun n_4220 () Int)
(declare-fun v_bool_109_2209_primed () Int)
(declare-fun resl_4447 () Int)
(declare-fun cn () Int)
(declare-fun Anon_4450 () Int)
(declare-fun cm () Int)
(declare-fun resr_4449 () Int)
(declare-fun an () Int)
(declare-fun Anon_4452 () Int)
(declare-fun am () Int)
(declare-fun resll_4451 () Int)
(declare-fun bn () Int)
(declare-fun Anon_4454 () Int)
(declare-fun bm () Int)
(declare-fun reslr_4453 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_118_2215_primed resr_4449))
(assert (= left_118_2214_primed resl_4447))
(assert (= height_118_2213_primed resn_4456))
(assert (= ele_118_2212_primed Anon_4446))
(assert (<= Anon_62 2))
(assert (<= 0 Anon_62))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (<= Anon_61 2))
(assert (<= 0 Anon_61))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (<= Anon_58 2))
(assert (<= 0 Anon_58))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (or (and (= tmp2_4457 resln_4458) (>= resln_4458 cn)) (and (= tmp2_4457 cn) (< resln_4458 cn))))
(assert (= resn_4456 (+ 1 tmp2_4457)))
(assert (or (and (= tmp1_4455 an) (>= an bn)) (and (= tmp1_4455 bn) (< an bn))))
(assert (= resln_4458 (+ 1 tmp1_4455)))
(assert (> t_4282 0))
(assert (<= b_4129 2))
(assert (<= 0 b_4129))
(assert (<= 0 n_4128))
(assert (<= 0 m_4127))
(assert (> v_node_107_4102 0))
(assert (<= b_4240 2))
(assert (<= 0 b_4240))
(assert (<= 0 n_4239))
(assert (<= 0 m_4238))
(assert (<= b_4221 2))
(assert (<= 0 b_4221))
(assert (<= 0 n_4220))
(assert (<= 0 m_4219))
(assert (= Anon_62 b_4221))
(assert (= cn n_4220))
(assert (= cm m_4219))
(assert (= Anon_61 b_4240))
(assert (= bn n_4239))
(assert (= bm m_4238))
(assert (= rr q_4213))
(assert (= rl p_4209))
(assert (= Anon_60 n_4207))
(assert (= Anon_59 Anon_4208))
(assert (= Anon_58 b_4129))
(assert (= an n_4128))
(assert (= am m_4127))
(assert (= r v_node_107_4102))
(assert (= l p_3752))
(assert (= Anon_57 n_3750))
(assert (= Anon_56 Anon_3751))
(assert (<= Anon_4212 2))
(assert (<= 0 Anon_4212))
(assert (<= 0 n1_4211))
(assert (<= 0 m1_4210))
(assert (= b_4240 Anon_4212))
(assert (= n_4239 n1_4211))
(assert (= m_4238 m1_4210))
(assert (<= Anon_4216 2))
(assert (<= 0 Anon_4216))
(assert (<= 0 n2_4215))
(assert (<= 0 m2_4214))
(assert (= b_4221 Anon_4216))
(assert (= n_4220 n2_4215))
(assert (= m_4219 m2_4214))
(assert (= (+ 2 n_4128) n))
(assert (<= Anon_3755 2))
(assert (<= 0 Anon_3755))
(assert (<= 0 n1_3754))
(assert (<= 0 m1_3753))
(assert (= b_4129 Anon_3755))
(assert (= n_4128 n1_3754))
(assert (= m_4127 m1_3753))
(assert (<= b_4108 2))
(assert (<= 0 b_4108))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (<= resb_4092 2))
(assert (<= 0 resb_4092))
(assert (<= 0 resn_4091))
(assert (<= 0 flted_74_4090))
(assert (= b_4108 resb_4092))
(assert (= n resn_4091))
(assert (= m flted_74_4090))
(assert (= right_107_4097 q_3756))
(assert (<= b_4068 2))
(assert (<= 0 b_4068))
(assert (<= 0 tn_4067))
(assert (<= 0 tm_4066))
(assert (or (= tn_4067 resn_4091) (and (= resn_4091 (+ 1 tn_4067)) (not (= resb_4092 1)))))
(assert (< 0 tn_4067))
(assert (< 0 tm_4066))
(assert (> q_3756 0))
(assert (= flted_74_4090 (+ 1 tm_4066)))
(assert (<= Anon_3759 2))
(assert (<= 0 Anon_3759))
(assert (<= 0 n2_3758))
(assert (<= 0 m2_3757))
(assert (= b_4068 Anon_3759))
(assert (= tn_4067 n2_3758))
(assert (= tm_4066 m2_3757))
(assert (= t_4282 t))
(assert (= x_primed x))
(assert (< tmp_primed 1))
(assert (not (> v_bool_80_2243_primed 0)))
(assert (= n_3750 tn))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (exists ((max_79 Int)) (and (= tn (+ max_79 1)) (or (and (= max_79 n1_3754) (>= n1_3754 n2_3758)) (and (= max_79 n2_3758) (< n1_3754 n2_3758))))))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (<= Anon_3751 x_primed))
(assert (not (> v_bool_86_2211_primed 0)))
(assert (> v_bool_108_2210_primed 0))
(assert (= n_4207 n))
(assert (= (+ b_4108 n2_4215) (+ 1 n1_4211)))
(assert (<= n1_4211 (+ 1 n2_4215)))
(assert (<= (+ 0 n2_4215) (+ n1_4211 1)))
(assert (exists ((max_79 Int)) (and (= n (+ max_79 1)) (or (and (= max_79 n1_4211) (>= n1_4211 n2_4215)) (and (= max_79 n2_4215) (< n1_4211 n2_4215))))))
(assert (= m (+ (+ m2_4214 1) m1_4210)))
(assert (< n_4239 n_4220))
(assert (> v_bool_109_2209_primed 0))
(assert (= resl_4447 1))
(assert (or (and (and (and (< resr_4449 1) (= cm 0)) (= cn 0)) (= Anon_4450 1)) (and (and (and (and (and (<= 0 Anon_4450) (<= (+ (- 0 cn) 2) Anon_4450)) (<= Anon_4450 cn)) (<= Anon_4450 2)) (<= 1 cm)) (> resr_4449 0))))
(assert (or (and (and (and (< resll_4451 1) (= am 0)) (= an 0)) (= Anon_4452 1)) (and (and (and (and (and (<= 0 Anon_4452) (<= (+ (- 0 an) 2) Anon_4452)) (<= Anon_4452 an)) (<= Anon_4452 2)) (<= 1 am)) (> resll_4451 0))))
(assert (or (and (and (and (< reslr_4453 1) (= bm 0)) (= bn 0)) (= Anon_4454 1)) (and (and (and (and (and (<= 0 Anon_4454) (<= (+ (- 0 bn) 2) Anon_4454)) (<= Anon_4454 bn)) (<= Anon_4454 2)) (<= 1 bm)) (> reslr_4453 0))))
;Negation of Consequence
(assert (not false))
(check-sat)