(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_47 () Int)
(declare-fun flted_43_4115 () Int)
(declare-fun tm_4091 () Int)
(declare-fun n_3775 () Int)
(declare-fun m () Int)
(declare-fun tm () Int)
(declare-fun m2_3782 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n2_3783 () Int)
(declare-fun tn_4092 () Int)
(declare-fun m1_3778 () Int)
(declare-fun n1_3779 () Int)
(declare-fun m2_4239 () Int)
(declare-fun Anon_4241 () Int)
(declare-fun m1_4235 () Int)
(declare-fun m_4244 () Int)
(declare-fun b_4246 () Int)
(declare-fun height_79_4752 () Int)
(declare-fun ba3 () Int)
(declare-fun cm () Int)
(declare-fun m_4263 () Int)
(declare-fun Anon_49 () Int)
(declare-fun m_4152 () Int)
(declare-fun n_4153 () Int)
(declare-fun resb_4117 () Int)
(declare-fun resn_4116 () Int)
(declare-fun n_4232 () Int)
(declare-fun q_5614 () Int)
(declare-fun b_4612 () Int)
(declare-fun m_4610 () Int)
(declare-fun resr_4465 () Int)
(declare-fun bn () Int)
(declare-fun bm () Int)
(declare-fun an () Int)
(declare-fun am () Int)
(declare-fun n_4264 () Int)
(declare-fun n () Int)
(declare-fun b_4133 () Int)
(declare-fun n1_4236 () Int)
(declare-fun n2_4240 () Int)
(declare-fun n_4245 () Int)
(declare-fun tmp1_4468 () Int)
(declare-fun resn_4469 () Int)
(declare-fun tmp2_4470 () Int)
(declare-fun cn () Int)
(declare-fun v_int_79_5605 () Int)
(declare-fun n_4611 () Int)
(declare-fun resln_4471 () Int)
(declare-fun n1_4526 () Int)
(declare-fun n2_4530 () Int)
(declare-fun m2_4529 () Int)
(declare-fun m1_4525 () Int)
(declare-fun p_5610 () Int)
(declare-fun b_4501 () Int)
(declare-fun m_4499 () Int)
(declare-fun n_4500 () Int)
(declare-fun resl_4463 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= b_4246 2))
(assert (<= 0 b_4246))
(assert (<= 0 m_4244))
(assert (= Anon_47 n_3775))
(assert (<= 0 m1_4235))
(assert (<= Anon_4241 2))
(assert (<= 0 Anon_4241))
(assert (<= 0 m2_4239))
(assert (<= 0 n1_3779))
(assert (<= 0 m1_3778))
(assert (<= 0 m))
(assert (<= 0 flted_43_4115))
(assert (= m flted_43_4115))
(assert (<= 0 tn_4092))
(assert (<= 0 tm_4091))
(assert (< 0 tm_4091))
(assert (= flted_43_4115 (+ 1 tm_4091)))
(assert (<= 0 n2_3783))
(assert (<= 0 m2_3782))
(assert (= tm_4091 m2_3782))
(assert (= n_3775 tn))
(assert (= m (+ (+ m2_4239 1) m1_4235)))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (exists ((max_5636 Int)) (and (= tn (+ 1 max_5636)) (or (and (= max_5636 n1_3779) (>= n1_3779 n2_3783)) (and (= max_5636 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tn_4092 n2_3783))
(assert (< 0 tn_4092))
(assert (or (= tn_4092 resn_4116) (and (= resn_4116 (+ 1 tn_4092)) (not (= resb_4117 1)))))
(assert (= m_4152 m1_3778))
(assert (= n_4153 n1_3779))
(assert (= m_4244 m2_4239))
(assert (= b_4246 Anon_4241))
(assert (= m_4263 m1_4235))
(assert (= cm m_4244))
(assert (= ba3 b_4246))
(assert (= height_79_4752 resn_4469))
(assert (<= b_4612 2))
(assert (<= 0 b_4612))
(assert (<= 0 m_4610))
(assert (<= ba3 2))
(assert (<= 0 ba3))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (= b_4612 ba3))
(assert (= m_4610 cm))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (or (and (= tmp1_4468 an) (>= an bn)) (and (= tmp1_4468 bn) (< an bn))))
(assert (<= 0 n_4153))
(assert (<= 0 m_4152))
(assert (<= 0 n_4264))
(assert (<= 0 m_4263))
(assert (<= 0 n_4245))
(assert (= bn n_4264))
(assert (= bm m_4263))
(assert (= Anon_49 n_4232))
(assert (= an n_4153))
(assert (= am m_4152))
(assert (<= 0 n1_4236))
(assert (= n_4264 n1_4236))
(assert (<= 0 n2_4240))
(assert (= (+ 2 n_4153) n))
(assert (<= b_4133 2))
(assert (<= 0 b_4133))
(assert (<= 0 n))
(assert (<= resb_4117 2))
(assert (<= 0 resb_4117))
(assert (<= 0 resn_4116))
(assert (= b_4133 resb_4117))
(assert (= n resn_4116))
(assert (= n_4232 n))
(assert (= q_5614 resr_4465))
(assert (or (and (and (and (< resr_4465 1) (= m_4610 0)) (= n_4611 0)) (= b_4612 1)) (and (and (and (and (and (<= 0 b_4612) (<= (+ (- 0 n_4611) 2) b_4612)) (<= b_4612 n_4611)) (<= b_4612 2)) (<= 1 m_4610)) (> resr_4465 0))))
(assert (= (+ b_4501 n2_4530) (+ 1 n1_4526)))
(assert (or (and (= resln_4471 (+ n1_4526 1)) (<= n2_4530 n1_4526)) (and (= resln_4471 (+ n2_4530 1)) (< n1_4526 n2_4530))))
(assert (<= n2_4530 (+ 1 n1_4526)))
(assert (<= n1_4526 (+ n2_4530 1)))
(assert (= n2_4530 bn))
(assert (= m2_4529 bm))
(assert (= n1_4526 an))
(assert (= m1_4525 am))
(assert (< n_4264 n_4245))
(assert (exists ((max_5635 Int)) (and (= n (+ 1 max_5635)) (or (and (= max_5635 n1_4236) (>= n1_4236 n2_4240)) (and (= max_5635 n2_4240) (< n1_4236 n2_4240))))))
(assert (= (+ b_4133 n2_4240) (+ 1 n1_4236)))
(assert (<= n2_4240 (+ 1 n1_4236)))
(assert (<= n1_4236 (+ n2_4240 1)))
(assert (= n_4245 n2_4240))
(assert (= cn n_4245))
(assert (= resln_4471 (+ 1 tmp1_4468)))
(assert (= resn_4469 (+ 1 tmp2_4470)))
(assert (or (and (= tmp2_4470 resln_4471) (>= resln_4471 cn)) (and (= tmp2_4470 cn) (< resln_4471 cn))))
(assert (<= 0 b_4501))
(assert (<= b_4501 2))
(assert (= n_4611 cn))
(assert (<= 0 n_4611))
(assert (= v_int_79_5605 (+ 1 n_4500)))
(assert (<= n_4611 n_4500))
(assert (<= 0 n_4500))
(assert (<= 0 m_4499))
(assert (> resl_4463 0))
(assert (= resln_4471 n_4500))
(assert (exists ((max_5634 Int)) (and (= n_4500 (+ 1 max_5634)) (or (and (= max_5634 n1_4526) (>= n1_4526 n2_4530)) (and (= max_5634 n2_4530) (< n1_4526 n2_4530))))))
(assert (= m_4499 (+ (+ m2_4529 1) m1_4525)))
(assert (= p_5610 resl_4463))
(assert (or (and (and (and (< resl_4463 1) (= m_4499 0)) (= n_4500 0)) (= b_4501 1)) (and (and (and (and (and (<= 0 b_4501) (<= (+ (- 0 n_4500) 2) b_4501)) (<= b_4501 n_4500)) (<= b_4501 2)) (<= 1 m_4499)) (> resl_4463 0))))
;Negation of Consequence
(assert (not (or (= m_4499 0) (or (= n_4500 0) (< resl_4463 1)))))
(check-sat)