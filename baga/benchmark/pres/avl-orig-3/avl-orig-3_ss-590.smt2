(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun v_bool_69_2247_primed () Int)
(declare-fun v_bool_50_2248_primed () Int)
(declare-fun Anon_3776 () Int)
(declare-fun tm () Int)
(declare-fun b () Int)
(declare-fun n_3775 () Int)
(declare-fun tn () Int)
(declare-fun v_bool_48_2249_primed () Int)
(declare-fun tmp_primed () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
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
(declare-fun m1_3778 () Int)
(declare-fun n1_3779 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun v_int_69_4487 () Int)
(declare-fun m_4152 () Int)
(declare-fun n_4153 () Int)
(declare-fun b_4154 () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun b_4133 () Int)
(declare-fun res () Int)
(declare-fun v_int_79_2274_primed () Int)
(declare-fun v_int_79_2275_primed () Int)
(declare-fun t_primed () Int)
(declare-fun n_4500 () Int)
(declare-fun b_4501 () Int)
(declare-fun m_4499 () Int)
(declare-fun p_3777 () Int)
(declare-fun n_4611 () Int)
(declare-fun b_4612 () Int)
(declare-fun m_4610 () Int)
(declare-fun v_node_68_4127 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (not (> v_bool_69_2247_primed 0)))
(assert (not (= v_int_69_4487 2)))
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
(assert (= m_4152 m1_3778))
(assert (= n_4153 n1_3779))
(assert (= b_4154 Anon_3780))
(assert (<= 0 m1_3778))
(assert (<= 0 n1_3779))
(assert (<= 0 Anon_3780))
(assert (<= Anon_3780 2))
(assert (= (+ v_int_69_4487 n_4153) n))
(assert (= m_4499 m_4152))
(assert (= n_4500 n_4153))
(assert (= b_4501 b_4154))
(assert (<= 0 m_4152))
(assert (<= 0 n_4153))
(assert (<= 0 b_4154))
(assert (<= b_4154 2))
(assert (<= 0 m_4499))
(assert (<= 0 n_4500))
(assert (<= 0 b_4501))
(assert (<= b_4501 2))
(assert (= m_4610 m))
(assert (= n_4611 n))
(assert (= b_4612 b_4133))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (<= 0 b_4133))
(assert (<= b_4133 2))
(assert (<= 0 m_4610))
(assert (<= 0 n_4611))
(assert (<= 0 b_4612))
(assert (<= b_4612 2))
(assert (= v_int_79_2275_primed n_4611))
(assert (< n_4500 n_4611))
(assert (= v_int_79_2274_primed 1))
(assert (= res (+ v_int_79_2274_primed v_int_79_2275_primed)))
(assert (= t_primed 1))
(assert (or (and (and (and (< p_3777 1) (= m_4499 0)) (= n_4500 0)) (= b_4501 1)) (and (and (and (and (and (<= 0 b_4501) (<= (+ (- 0 n_4500) 2) b_4501)) (<= b_4501 n_4500)) (<= b_4501 2)) (<= 1 m_4499)) (> p_3777 0))))
(assert (or (and (and (and (< v_node_68_4127 1) (= m_4610 0)) (= n_4611 0)) (= b_4612 1)) (and (and (and (and (and (<= 0 b_4612) (<= (+ (- 0 n_4611) 2) b_4612)) (<= b_4612 n_4611)) (<= b_4612 2)) (<= 1 m_4610)) (> v_node_68_4127 0))))
;Negation of Consequence
(assert (not false))
(check-sat)