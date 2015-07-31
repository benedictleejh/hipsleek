(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun right_79_2253_primed () Int)
(declare-fun left_79_2252_primed () Int)
(declare-fun height_79_2251_primed () Int)
(declare-fun ele_79_2250_primed () Int)
(declare-fun Anon_4462 () Int)
(declare-fun resn_4469 () Int)
(declare-fun tmp2_4470 () Int)
(declare-fun resln_4471 () Int)
(declare-fun tmp1_4468 () Int)
(declare-fun rr () Int)
(declare-fun q_4238 () Int)
(declare-fun rl () Int)
(declare-fun p_4234 () Int)
(declare-fun Anon_49 () Int)
(declare-fun Anon_48 () Int)
(declare-fun Anon_4233 () Int)
(declare-fun r () Int)
(declare-fun v_node_68_4127 () Int)
(declare-fun l () Int)
(declare-fun p_3777 () Int)
(declare-fun Anon_47 () Int)
(declare-fun Anon_46 () Int)
(declare-fun b_4265 () Int)
(declare-fun Anon_4237 () Int)
(declare-fun m_4263 () Int)
(declare-fun b_4246 () Int)
(declare-fun Anon_4241 () Int)
(declare-fun m_4244 () Int)
(declare-fun b_4154 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun n_4153 () Int)
(declare-fun m_4152 () Int)
(declare-fun right_68_4122 () Int)
(declare-fun resn_4116 () Int)
(declare-fun resb_4117 () Int)
(declare-fun q_3781 () Int)
(declare-fun flted_43_4115 () Int)
(declare-fun b_4093 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun tn_4092 () Int)
(declare-fun tm_4091 () Int)
(declare-fun t_4307 () Int)
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
(declare-fun n_4264 () Int)
(declare-fun n_4245 () Int)
(declare-fun v_bool_70_2246_primed () Int)
(declare-fun resl_4463 () Int)
(declare-fun cn () Int)
(declare-fun ba3 () Int)
(declare-fun cm () Int)
(declare-fun resr_4465 () Int)
(declare-fun an () Int)
(declare-fun ba1 () Int)
(declare-fun am () Int)
(declare-fun resll_4466 () Int)
(declare-fun bn () Int)
(declare-fun ba2 () Int)
(declare-fun bm () Int)
(declare-fun reslr_4467 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_79_2253_primed resr_4465))
(assert (= left_79_2252_primed resl_4463))
(assert (= height_79_2251_primed resn_4469))
(assert (= ele_79_2250_primed Anon_4462))
(assert (<= ba3 2))
(assert (<= 0 ba3))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (<= ba2 2))
(assert (<= 0 ba2))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (<= ba1 2))
(assert (<= 0 ba1))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (or (and (= tmp2_4470 resln_4471) (>= resln_4471 cn)) (and (= tmp2_4470 cn) (< resln_4471 cn))))
(assert (= resn_4469 (+ 1 tmp2_4470)))
(assert (or (and (= tmp1_4468 an) (>= an bn)) (and (= tmp1_4468 bn) (< an bn))))
(assert (= resln_4471 (+ 1 tmp1_4468)))
(assert (> t_4307 0))
(assert (<= b_4154 2))
(assert (<= 0 b_4154))
(assert (<= 0 n_4153))
(assert (<= 0 m_4152))
(assert (> v_node_68_4127 0))
(assert (<= b_4265 2))
(assert (<= 0 b_4265))
(assert (<= 0 n_4264))
(assert (<= 0 m_4263))
(assert (<= b_4246 2))
(assert (<= 0 b_4246))
(assert (<= 0 n_4245))
(assert (<= 0 m_4244))
(assert (= ba3 b_4246))
(assert (= cn n_4245))
(assert (= cm m_4244))
(assert (= ba2 b_4265))
(assert (= bn n_4264))
(assert (= bm m_4263))
(assert (= rr q_4238))
(assert (= rl p_4234))
(assert (= Anon_49 n_4232))
(assert (= Anon_48 Anon_4233))
(assert (= ba1 b_4154))
(assert (= an n_4153))
(assert (= am m_4152))
(assert (= r v_node_68_4127))
(assert (= l p_3777))
(assert (= Anon_47 n_3775))
(assert (= Anon_46 Anon_3776))
(assert (<= Anon_4237 2))
(assert (<= 0 Anon_4237))
(assert (<= 0 n1_4236))
(assert (<= 0 m1_4235))
(assert (= b_4265 Anon_4237))
(assert (= n_4264 n1_4236))
(assert (= m_4263 m1_4235))
(assert (<= Anon_4241 2))
(assert (<= 0 Anon_4241))
(assert (<= 0 n2_4240))
(assert (<= 0 m2_4239))
(assert (= b_4246 Anon_4241))
(assert (= n_4245 n2_4240))
(assert (= m_4244 m2_4239))
(assert (= (+ 2 n_4153) n))
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
(assert (= t_4307 t))
(assert (= x_primed x))
(assert (< tmp_primed 1))
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
(assert (< n_4264 n_4245))
(assert (> v_bool_70_2246_primed 0))
(assert (= resl_4463 1))
(assert (or (and (and (and (< resr_4465 1) (= cm 0)) (= cn 0)) (= ba3 1)) (and (and (and (and (and (<= 0 ba3) (<= (+ (- 0 cn) 2) ba3)) (<= ba3 cn)) (<= ba3 2)) (<= 1 cm)) (> resr_4465 0))))
(assert (or (and (and (and (< resll_4466 1) (= am 0)) (= an 0)) (= ba1 1)) (and (and (and (and (and (<= 0 ba1) (<= (+ (- 0 an) 2) ba1)) (<= ba1 an)) (<= ba1 2)) (<= 1 am)) (> resll_4466 0))))
(assert (or (and (and (and (< reslr_4467 1) (= bm 0)) (= bn 0)) (= ba2 1)) (and (and (and (and (and (<= 0 ba2) (<= (+ (- 0 bn) 2) ba2)) (<= ba2 bn)) (<= ba2 2)) (<= 1 bm)) (> reslr_4467 0))))
;Negation of Consequence
(assert (not false))
(check-sat)