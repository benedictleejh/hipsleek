(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun tm_3772 () Int)
(declare-fun Anon_5545 () Int)
(declare-fun n2_5544 () Int)
(declare-fun m2_5543 () Int)
(declare-fun Anon_5541 () Int)
(declare-fun n1_5540 () Int)
(declare-fun m1_5539 () Int)
(declare-fun q_5542 () Int)
(declare-fun p_5538 () Int)
(declare-fun tm () Int)
(declare-fun m1_3753 () Int)
(declare-fun flted_76_3801 () Int)
(declare-fun flted_76_3800 () Int)
(declare-fun flted_76_3799 () Int)
(declare-fun m2_3757 () Int)
(declare-fun Anon_3759 () Int)
(declare-fun m () Int)
(declare-fun b_3814 () Int)
(declare-fun m_3833 () Int)
(declare-fun b_3835 () Int)
(declare-fun b_4488 () Int)
(declare-fun m_4486 () Int)
(declare-fun v_node_87_3810 () Int)
(declare-fun b_4599 () Int)
(declare-fun m_4597 () Int)
(declare-fun q_3756 () Int)
(declare-fun height_118_4736 () Int)
(declare-fun v_int_118_5533 () Int)
(declare-fun n_4598 () Int)
(declare-fun n_4487 () Int)
(declare-fun v_int_89_4444 () Int)
(declare-fun n () Int)
(declare-fun n_3834 () Int)
(declare-fun tn_3773 () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
(declare-fun n2_3758 () Int)
(declare-fun n1_3754 () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= b_3835 2))
(assert (<= 0 b_3835))
(assert (<= 0 m_3833))
(assert (<= b_3814 2))
(assert (<= 0 b_3814))
(assert (<= 0 m))
(assert (<= Anon_3759 2))
(assert (<= 0 Anon_3759))
(assert (<= 0 m2_3757))
(assert (<= flted_76_3799 2))
(assert (<= 0 flted_76_3799))
(assert (<= 0 flted_76_3800))
(assert (<= 0 flted_76_3801))
(assert (<= 0 tm_3772))
(assert (= tm_3772 0))
(assert (<= 0 m1_3753))
(assert (= tm_3772 m1_3753))
(assert (exists ((flted_76_5590 Int)) (= (+ flted_76_5590 n2_5544) (+ 1 n1_5540))))
(assert (exists ((max_5589 Int)) (and (= v_int_118_5533 (+ max_5589 1)) (or (and (= max_5589 n1_5540) (>= n1_5540 n2_5544)) (and (= max_5589 n2_5544) (< n1_5540 n2_5544))))))
(assert (= Anon_5545 b_4599))
(assert (= n2_5544 n_4598))
(assert (= m2_5543 m_4597))
(assert (= Anon_5541 b_4488))
(assert (= n1_5540 n_4487))
(assert (= m1_5539 m_4486))
(assert (= q_5542 q_3756))
(assert (= p_5538 v_node_87_3810))
(assert (not (= v_int_89_4444 2)))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (= flted_76_3801 1))
(assert (= flted_76_3800 1))
(assert (= flted_76_3799 1))
(assert (= m flted_76_3801))
(assert (= n flted_76_3800))
(assert (= b_3814 flted_76_3799))
(assert (= m_3833 m2_3757))
(assert (= b_3835 Anon_3759))
(assert (= m_4486 m))
(assert (= b_4488 b_3814))
(assert (<= 0 m_4486))
(assert (<= 0 b_4488))
(assert (<= b_4488 2))
(assert (= m_4597 m_3833))
(assert (= b_4599 b_3835))
(assert (<= 0 m_4597))
(assert (<= 0 b_4599))
(assert (<= b_4599 2))
(assert (or (and (and (and (< v_node_87_3810 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> v_node_87_3810 0))))
(assert (or (and (and (and (< q_3756 1) (= m_4597 0)) (= n_4598 0)) (= b_4599 1)) (and (and (and (and (and (<= 0 b_4599) (<= (+ (- 0 n_4598) 2) b_4599)) (<= b_4599 n_4598)) (<= b_4599 2)) (<= 1 m_4597)) (> q_3756 0))))
(assert (= height_118_4736 n_3750))
(assert (= v_int_118_5533 (+ 1 n_4487)))
(assert (<= n_4598 n_4487))
(assert (<= 0 n_4598))
(assert (<= 0 n_3834))
(assert (= n_4598 n_3834))
(assert (<= 0 n_4487))
(assert (<= 0 n))
(assert (= n_4487 n))
(assert (= (+ v_int_89_4444 n_3834) n))
(assert (<= 0 n2_3758))
(assert (= n_3834 n2_3758))
(assert (<= 0 tn_3773))
(assert (= tn_3773 0))
(assert (<= 0 n1_3754))
(assert (= tn_3773 n1_3754))
(assert (= n_3750 tn))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (exists ((max_5588 Int)) (and (= tn (+ max_5588 1)) (or (and (= max_5588 n1_3754) (>= n1_3754 n2_3758)) (and (= max_5588 n2_3758) (< n1_3754 n2_3758))))))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
;Negation of Consequence
(assert (not (<= b 2)))
(check-sat)