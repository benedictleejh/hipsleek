(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_6360 () Int)
(declare-fun n2_6359 () Int)
(declare-fun m2_6358 () Int)
(declare-fun res () Int)
(declare-fun height_79_4754 () Int)
(declare-fun v_int_79_6348 () Int)
(declare-fun b_4612 () Int)
(declare-fun n_4611 () Int)
(declare-fun m_4610 () Int)
(declare-fun b_4501 () Int)
(declare-fun b_4154 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun n_4153 () Int)
(declare-fun m_4152 () Int)
(declare-fun b_4133 () Int)
(declare-fun n () Int)
(declare-fun m () Int)
(declare-fun right_68_4121 () Int)
(declare-fun q_3781 () Int)
(declare-fun flted_44_4118 () Int)
(declare-fun flted_44_4119 () Int)
(declare-fun flted_44_4120 () Int)
(declare-fun b_4093 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun tn_4092 () Int)
(declare-fun tm_4091 () Int)
(declare-fun t () Int)
(declare-fun x () Int)
(declare-fun t_primed () Int)
(declare-fun v_bool_48_2249_primed () Int)
(declare-fun n_3775 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n1_3779 () Int)
(declare-fun n2_3783 () Int)
(declare-fun tm () Int)
(declare-fun m2_3782 () Int)
(declare-fun m1_3778 () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_50_2248_primed () Int)
(declare-fun v_int_69_4489 () Int)
(declare-fun v_bool_69_2247_primed () Int)
(declare-fun Anon_6352 () Int)
(declare-fun Anon_3776 () Int)
(declare-fun p_6353 () Int)
(declare-fun q_6357 () Int)
(declare-fun v_node_68_4129 () Int)
(declare-fun m_4499 () Int)
(declare-fun n_4500 () Int)
(declare-fun p_3777 () Int)
(declare-fun Anon_6356 () Int)
(declare-fun n1_6355 () Int)
(declare-fun m1_6354 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_6360 b_4612))
(assert (= n2_6359 n_4611))
(assert (= m2_6358 m_4610))
(assert (< p_3777 1))
(assert (= m_4499 0))
(assert (= n_4500 0))
(assert (= b_4501 1))
(assert (= res t_primed))
(assert (= height_79_4754 n_3775))
(assert (= v_int_79_6348 (+ 1 n_4611)))
(assert (< n_4500 n_4611))
(assert (<= b_4612 2))
(assert (<= 0 b_4612))
(assert (<= 0 n_4611))
(assert (<= 0 m_4610))
(assert (<= b_4133 2))
(assert (<= 0 b_4133))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (= b_4612 b_4133))
(assert (= n_4611 n))
(assert (= m_4610 m))
(assert (<= b_4501 2))
(assert (<= 0 b_4501))
(assert (<= 0 n_4500))
(assert (<= 0 m_4499))
(assert (<= b_4154 2))
(assert (<= 0 b_4154))
(assert (<= 0 n_4153))
(assert (<= 0 m_4152))
(assert (= b_4501 b_4154))
(assert (= n_4500 n_4153))
(assert (= m_4499 m_4152))
(assert (= (+ v_int_69_4489 n_4153) n))
(assert (<= Anon_3780 2))
(assert (<= 0 Anon_3780))
(assert (<= 0 n1_3779))
(assert (<= 0 m1_3778))
(assert (= b_4154 Anon_3780))
(assert (= n_4153 n1_3779))
(assert (= m_4152 m1_3778))
(assert (<= flted_44_4118 2))
(assert (<= 0 flted_44_4118))
(assert (<= 0 flted_44_4119))
(assert (<= 0 flted_44_4120))
(assert (= b_4133 flted_44_4118))
(assert (= n flted_44_4119))
(assert (= m flted_44_4120))
(assert (= right_68_4121 q_3781))
(assert (<= b_4093 2))
(assert (<= 0 b_4093))
(assert (<= 0 tn_4092))
(assert (<= 0 tm_4091))
(assert (< q_3781 1))
(assert (= tm_4091 0))
(assert (= tn_4092 0))
(assert (= flted_44_4118 1))
(assert (= flted_44_4119 1))
(assert (= flted_44_4120 1))
(assert (<= Anon_3784 2))
(assert (<= 0 Anon_3784))
(assert (<= 0 n2_3783))
(assert (<= 0 m2_3782))
(assert (= b_4093 Anon_3784))
(assert (= tn_4092 n2_3783))
(assert (= tm_4091 m2_3782))
(assert (= t_primed t))
(assert (= x_primed x))
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
(assert (not (= v_int_69_4489 2)))
(assert (not (> v_bool_69_2247_primed 0)))
(assert (= Anon_6352 Anon_3776))
(assert (= p_6353 p_3777))
(assert (= q_6357 v_node_68_4129))
(assert (or (= m_4499 0) (or (= n_4500 0) (< p_3777 1))))
(assert (= Anon_6356 1))
(assert (= n1_6355 0))
(assert (= m1_6354 0))
;Negation of Consequence
(assert (not false))
(check-sat)