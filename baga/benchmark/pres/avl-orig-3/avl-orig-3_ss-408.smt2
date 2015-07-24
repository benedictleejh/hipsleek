(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_3775 () Int)
(declare-fun tm () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun m2_3782 () Int)
(declare-fun n2_3783 () Int)
(declare-fun tm_4091 () Int)
(declare-fun tn_4092 () Int)
(declare-fun m1_3778 () Int)
(declare-fun n1_3779 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun b_4154 () Int)
(declare-fun m_4152 () Int)
(declare-fun p_3777 () Int)
(declare-fun Anon_4237 () Int)
(declare-fun p_4234 () Int)
(declare-fun n_4153 () Int)
(declare-fun resb_4117 () Int)
(declare-fun resn_4116 () Int)
(declare-fun flted_43_4115 () Int)
(declare-fun n_4232 () Int)
(declare-fun m () Int)
(declare-fun m1_4235 () Int)
(declare-fun n () Int)
(declare-fun b_4133 () Int)
(declare-fun n1_4236 () Int)
(declare-fun v_node_70_2221_primed () Int)
(declare-fun Anon_4241 () Int)
(declare-fun m2_4239 () Int)
(declare-fun n2_4240 () Int)
(declare-fun q_4238 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= Anon_3780 2))
(assert (<= 0 Anon_3780))
(assert (<= 0 n1_3779))
(assert (<= 0 m1_3778))
(assert (<= 0 tn_4092))
(assert (<= 0 tm_4091))
(assert (< 0 tm_4091))
(assert (<= 0 n2_3783))
(assert (<= 0 m2_3782))
(assert (= n_3775 tn))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (exists ((max_4249 Int)) (and (= tn (+ 1 max_4249)) (or (and (= max_4249 n1_3779) (>= n1_3779 n2_3783)) (and (= max_4249 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tm_4091 m2_3782))
(assert (= tn_4092 n2_3783))
(assert (= flted_43_4115 (+ 1 tm_4091)))
(assert (< 0 tn_4092))
(assert (or (= tn_4092 resn_4116) (and (= resn_4116 (+ 1 tn_4092)) (not (= resb_4117 1)))))
(assert (= m_4152 m1_3778))
(assert (= n_4153 n1_3779))
(assert (= b_4154 Anon_3780))
(assert (<= 0 m_4152))
(assert (<= 0 n_4153))
(assert (<= 0 b_4154))
(assert (<= b_4154 2))
(assert (or (and (and (and (< p_3777 1) (= m_4152 0)) (= n_4153 0)) (= b_4154 1)) (and (and (and (and (and (<= 0 b_4154) (<= (+ (- 0 n_4153) 2) b_4154)) (<= b_4154 n_4153)) (<= b_4154 2)) (<= 1 m_4152)) (> p_3777 0))))
(assert (or (and (and (and (< p_4234 1) (= m1_4235 0)) (= n1_4236 0)) (= Anon_4237 1)) (and (and (and (and (and (<= 0 Anon_4237) (<= (+ (- 0 n1_4236) 2) Anon_4237)) (<= Anon_4237 n1_4236)) (<= Anon_4237 2)) (<= 1 m1_4235)) (> p_4234 0))))
(assert (= (+ 2 n_4153) n))
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
(assert (= n_4232 n))
(assert (= m (+ (+ m2_4239 1) m1_4235)))
(assert (exists ((max_4250 Int)) (and (= n (+ 1 max_4250)) (or (and (= max_4250 n1_4236) (>= n1_4236 n2_4240)) (and (= max_4250 n2_4240) (< n1_4236 n2_4240))))))
(assert (= (+ b_4133 n2_4240) (+ 1 n1_4236)))
(assert (<= n2_4240 (+ 1 n1_4236)))
(assert (<= n1_4236 (+ n2_4240 1)))
(assert (= v_node_70_2221_primed q_4238))
(assert (or (and (and (and (< q_4238 1) (= m2_4239 0)) (= n2_4240 0)) (= Anon_4241 1)) (and (and (and (and (and (<= 0 Anon_4241) (<= (+ (- 0 n2_4240) 2) Anon_4241)) (<= Anon_4241 n2_4240)) (<= Anon_4241 2)) (<= 1 m2_4239)) (> q_4238 0))))
;Negation of Consequence
(assert (not (or (= m2_4239 0) (or (= n2_4240 0) (< q_4238 1)))))
(check-sat)