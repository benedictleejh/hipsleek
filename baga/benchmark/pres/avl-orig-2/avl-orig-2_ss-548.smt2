(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun tn_4067 () Int)
(declare-fun tm_4066 () Int)
(declare-fun n_3750 () Int)
(declare-fun tm () Int)
(declare-fun m2_3757 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n2_3758 () Int)
(declare-fun m1_3753 () Int)
(declare-fun Anon_3755 () Int)
(declare-fun m_4127 () Int)
(declare-fun b_4129 () Int)
(declare-fun b_4488 () Int)
(declare-fun m_4486 () Int)
(declare-fun p_3752 () Int)
(declare-fun v_int_118_2232_primed () Int)
(declare-fun n_4487 () Int)
(declare-fun n1_3754 () Int)
(declare-fun flted_76_4093 () Int)
(declare-fun flted_76_4095 () Int)
(declare-fun flted_76_4094 () Int)
(declare-fun v_int_108_4476 () Int)
(declare-fun n_4128 () Int)
(declare-fun v_node_118_2227_primed () Int)
(declare-fun b_4108 () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun v_node_107_4104 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= b_4129 2))
(assert (<= 0 b_4129))
(assert (<= 0 m_4127))
(assert (<= Anon_3755 2))
(assert (<= 0 Anon_3755))
(assert (<= 0 m1_3753))
(assert (<= 0 tn_4067))
(assert (<= 0 tm_4066))
(assert (= tm_4066 0))
(assert (= tn_4067 0))
(assert (<= 0 n2_3758))
(assert (<= 0 m2_3757))
(assert (= tn_4067 n2_3758))
(assert (= tm_4066 m2_3757))
(assert (= n_3750 tn))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (exists ((max_4679 Int)) (and (= tn (+ max_4679 1)) (or (and (= max_4679 n1_3754) (>= n1_3754 n2_3758)) (and (= max_4679 n2_3758) (< n1_3754 n2_3758))))))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (= flted_76_4093 1))
(assert (= m_4127 m1_3753))
(assert (= b_4129 Anon_3755))
(assert (= m_4486 m_4127))
(assert (= b_4488 b_4129))
(assert (<= 0 m_4486))
(assert (<= 0 b_4488))
(assert (<= b_4488 2))
(assert (or (and (and (and (< p_3752 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> p_3752 0))))
(assert (<= 0 n_4487))
(assert (= v_int_118_2232_primed n_4487))
(assert (<= 0 n_4128))
(assert (= n_4487 n_4128))
(assert (<= 0 n1_3754))
(assert (= n_4128 n1_3754))
(assert (<= b_4108 2))
(assert (<= 0 b_4108))
(assert (<= flted_76_4093 2))
(assert (<= 0 flted_76_4093))
(assert (<= 0 flted_76_4094))
(assert (<= 0 flted_76_4095))
(assert (= b_4108 flted_76_4093))
(assert (= flted_76_4094 1))
(assert (= flted_76_4095 1))
(assert (not (= v_int_108_4476 2)))
(assert (= m flted_76_4095))
(assert (= n flted_76_4094))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (= (+ v_int_108_4476 n_4128) n))
(assert (= v_node_118_2227_primed v_node_107_4104))
(assert (or (and (and (and (< v_node_107_4104 1) (= m 0)) (= n 0)) (= b_4108 1)) (and (and (and (and (and (<= 0 b_4108) (<= (+ (- 0 n) 2) b_4108)) (<= b_4108 n)) (<= b_4108 2)) (<= 1 m)) (> v_node_107_4104 0))))
;Negation of Consequence
(assert (not (or (= m 0) (or (= n 0) (< v_node_107_4104 1)))))
(check-sat)