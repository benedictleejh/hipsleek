(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_6299 () Int)
(declare-fun m2_6297 () Int)
(declare-fun q_6296 () Int)
(declare-fun flted_44_4120 () Int)
(declare-fun flted_44_4118 () Int)
(declare-fun m () Int)
(declare-fun b_4133 () Int)
(declare-fun b_4612 () Int)
(declare-fun m_4610 () Int)
(declare-fun v_node_68_4129 () Int)
(declare-fun height_79_4755 () Int)
(declare-fun tn_4092 () Int)
(declare-fun n_3775 () Int)
(declare-fun n2_6298 () Int)
(declare-fun Anon_6295 () Int)
(declare-fun n1_6294 () Int)
(declare-fun m1_6293 () Int)
(declare-fun p_6292 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n2_3783 () Int)
(declare-fun flted_44_4119 () Int)
(declare-fun n1_3779 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun v_int_69_4489 () Int)
(declare-fun n_4153 () Int)
(declare-fun b_4154 () Int)
(declare-fun n () Int)
(declare-fun n_4611 () Int)
(declare-fun v_int_79_6287 () Int)
(declare-fun n_4500 () Int)
(declare-fun b_4501 () Int)
(declare-fun p_3777 () Int)
(declare-fun m_4499 () Int)
(declare-fun m_4152 () Int)
(declare-fun tm_4091 () Int)
(declare-fun m2_3782 () Int)
(declare-fun m1_3778 () Int)
(declare-fun tm () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= b_4133 2))
(assert (<= 0 b_4133))
(assert (<= 0 m))
(assert (<= flted_44_4118 2))
(assert (<= 0 flted_44_4118))
(assert (<= 0 flted_44_4120))
(assert (= Anon_6299 b_4612))
(assert (= m2_6297 m_4610))
(assert (= q_6296 v_node_68_4129))
(assert (= flted_44_4120 1))
(assert (= flted_44_4118 1))
(assert (= m flted_44_4120))
(assert (= b_4133 flted_44_4118))
(assert (= m_4610 m))
(assert (= b_4612 b_4133))
(assert (<= 0 m_4610))
(assert (<= 0 b_4612))
(assert (<= b_4612 2))
(assert (or (and (and (and (< v_node_68_4129 1) (= m_4610 0)) (= n_4611 0)) (= b_4612 1)) (and (and (and (and (and (<= 0 b_4612) (<= (+ (- 0 n_4611) 2) b_4612)) (<= b_4612 n_4611)) (<= b_4612 2)) (<= 1 m_4610)) (> v_node_68_4129 0))))
(assert (= height_79_4755 n_3775))
(assert (<= 0 n))
(assert (<= b_4154 2))
(assert (<= 0 b_4154))
(assert (<= 0 n_4153))
(assert (<= Anon_3780 2))
(assert (<= 0 Anon_3780))
(assert (<= 0 n1_3779))
(assert (<= 0 flted_44_4119))
(assert (<= 0 tn_4092))
(assert (= tn_4092 0))
(assert (<= 0 n2_3783))
(assert (= tn_4092 n2_3783))
(assert (= n_3775 tn))
(assert (exists ((flted_44_6335 Int)) (= (+ flted_44_6335 n2_6298) (+ 1 n1_6294))))
(assert (exists ((max_6334 Int)) (and (= v_int_79_6287 (+ 1 max_6334)) (or (and (= max_6334 n1_6294) (>= n1_6294 n2_6298)) (and (= max_6334 n2_6298) (< n1_6294 n2_6298))))))
(assert (= n2_6298 n_4611))
(assert (= Anon_6295 b_4501))
(assert (= n1_6294 n_4500))
(assert (= m1_6293 m_4499))
(assert (= p_6292 p_3777))
(assert (not (= v_int_69_4489 2)))
(assert (exists ((max_6333 Int)) (and (= tn (+ 1 max_6333)) (or (and (= max_6333 n1_3779) (>= n1_3779 n2_3783)) (and (= max_6333 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= flted_44_4119 1))
(assert (= n flted_44_4119))
(assert (= n_4153 n1_3779))
(assert (= b_4154 Anon_3780))
(assert (= (+ v_int_69_4489 n_4153) n))
(assert (= n_4500 n_4153))
(assert (= b_4501 b_4154))
(assert (<= 0 n_4500))
(assert (<= 0 b_4501))
(assert (<= b_4501 2))
(assert (= n_4611 n))
(assert (<= 0 n_4611))
(assert (<= n_4611 n_4500))
(assert (= v_int_79_6287 (+ 1 n_4500)))
(assert (or (and (and (and (< p_3777 1) (= m_4499 0)) (= n_4500 0)) (= b_4501 1)) (and (and (and (and (and (<= 0 b_4501) (<= (+ (- 0 n_4500) 2) b_4501)) (<= b_4501 n_4500)) (<= b_4501 2)) (<= 1 m_4499)) (> p_3777 0))))
(assert (<= 0 m_4499))
(assert (<= 0 m_4152))
(assert (= m_4499 m_4152))
(assert (<= 0 m1_3778))
(assert (= m_4152 m1_3778))
(assert (<= 0 tm_4091))
(assert (= tm_4091 0))
(assert (<= 0 m2_3782))
(assert (= tm_4091 m2_3782))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
;Negation of Consequence
(assert (not (<= 0 tm)))
(check-sat)