(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_6169 () Int)
(declare-fun n2_6168 () Int)
(declare-fun m2_6167 () Int)
(declare-fun Anon_6165 () Int)
(declare-fun n1_6164 () Int)
(declare-fun m1_6163 () Int)
(declare-fun q_6166 () Int)
(declare-fun p_6162 () Int)
(declare-fun tm () Int)
(declare-fun m2_3757 () Int)
(declare-fun tm_4066 () Int)
(declare-fun flted_74_4090 () Int)
(declare-fun m1_3753 () Int)
(declare-fun Anon_3755 () Int)
(declare-fun m_4127 () Int)
(declare-fun b_4129 () Int)
(declare-fun m () Int)
(declare-fun b_4488 () Int)
(declare-fun m_4486 () Int)
(declare-fun p_3752 () Int)
(declare-fun m_4597 () Int)
(declare-fun v_node_107_4102 () Int)
(declare-fun height_118_4743 () Int)
(declare-fun v_int_118_6157 () Int)
(declare-fun b_4599 () Int)
(declare-fun n_4598 () Int)
(declare-fun n_4487 () Int)
(declare-fun v_int_108_4474 () Int)
(declare-fun n_4128 () Int)
(declare-fun b_4108 () Int)
(declare-fun n () Int)
(declare-fun resn_4091 () Int)
(declare-fun resb_4092 () Int)
(declare-fun tn_4067 () Int)
(declare-fun b () Int)
(declare-fun n1_3754 () Int)
(declare-fun n2_3758 () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 m))
(assert (<= b_4129 2))
(assert (<= 0 b_4129))
(assert (<= 0 m_4127))
(assert (<= Anon_3755 2))
(assert (<= 0 Anon_3755))
(assert (<= 0 m1_3753))
(assert (<= 0 flted_74_4090))
(assert (<= 0 tm_4066))
(assert (< 0 tm_4066))
(assert (<= 0 m2_3757))
(assert (exists ((flted_76_6217 Int)) (= (+ flted_76_6217 n2_6168) (+ 1 n1_6164))))
(assert (exists ((max_6216 Int)) (and (= v_int_118_6157 (+ max_6216 1)) (or (and (= max_6216 n1_6164) (>= n1_6164 n2_6168)) (and (= max_6216 n2_6168) (< n1_6164 n2_6168))))))
(assert (= Anon_6169 b_4599))
(assert (= n2_6168 n_4598))
(assert (= m2_6167 m_4597))
(assert (= Anon_6165 b_4488))
(assert (= n1_6164 n_4487))
(assert (= m1_6163 m_4486))
(assert (= q_6166 v_node_107_4102))
(assert (= p_6162 p_3752))
(assert (not (= v_int_108_4474 2)))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (= tm_4066 m2_3757))
(assert (= flted_74_4090 (+ 1 tm_4066)))
(assert (= m flted_74_4090))
(assert (= m_4127 m1_3753))
(assert (= b_4129 Anon_3755))
(assert (= m_4486 m_4127))
(assert (= b_4488 b_4129))
(assert (<= 0 m_4486))
(assert (<= 0 b_4488))
(assert (<= b_4488 2))
(assert (= m_4597 m))
(assert (<= 0 m_4597))
(assert (or (and (and (and (< p_3752 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> p_3752 0))))
(assert (or (and (and (and (< v_node_107_4102 1) (= m_4597 0)) (= n_4598 0)) (= b_4599 1)) (and (and (and (and (and (<= 0 b_4599) (<= (+ (- 0 n_4598) 2) b_4599)) (<= b_4599 n_4598)) (<= b_4599 2)) (<= 1 m_4597)) (> v_node_107_4102 0))))
(assert (= height_118_4743 n_3750))
(assert (= v_int_118_6157 (+ 1 n_4598)))
(assert (< n_4487 n_4598))
(assert (<= b_4599 2))
(assert (<= 0 b_4599))
(assert (<= 0 n_4598))
(assert (<= b_4108 2))
(assert (<= 0 b_4108))
(assert (<= 0 n))
(assert (= b_4599 b_4108))
(assert (= n_4598 n))
(assert (<= 0 n_4487))
(assert (<= 0 n_4128))
(assert (= n_4487 n_4128))
(assert (= (+ v_int_108_4474 n_4128) n))
(assert (<= 0 n1_3754))
(assert (= n_4128 n1_3754))
(assert (<= resb_4092 2))
(assert (<= 0 resb_4092))
(assert (<= 0 resn_4091))
(assert (= b_4108 resb_4092))
(assert (= n resn_4091))
(assert (<= 0 tn_4067))
(assert (or (= tn_4067 resn_4091) (and (= resn_4091 (+ 1 tn_4067)) (not (= resb_4092 1)))))
(assert (< 0 tn_4067))
(assert (<= 0 n2_3758))
(assert (= tn_4067 n2_3758))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (exists ((max_6215 Int)) (and (= tn (+ max_6215 1)) (or (and (= max_6215 n1_3754) (>= n1_3754 n2_3758)) (and (= max_6215 n2_3758) (< n1_3754 n2_3758))))))
(assert (= n_3750 tn))
;Negation of Consequence
(assert (not (= tn 0)))
(check-sat)