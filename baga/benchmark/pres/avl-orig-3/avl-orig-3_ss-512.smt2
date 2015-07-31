(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status sat)
;Variables declarations
(declare-fun flted_44_3826 () Int)
(declare-fun flted_44_3824 () Int)
(declare-fun m () Int)
(declare-fun b_3839 () Int)
(declare-fun b_4501 () Int)
(declare-fun m_4499 () Int)
(declare-fun v_node_52_3835 () Int)
(declare-fun v_int_79_2270_primed () Int)
(declare-fun n_4500 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun flted_44_3825 () Int)
(declare-fun tn_3798 () Int)
(declare-fun tm_3797 () Int)
(declare-fun n_3775 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n1_3779 () Int)
(declare-fun tm () Int)
(declare-fun m1_3778 () Int)
(declare-fun m2_3782 () Int)
(declare-fun n2_3783 () Int)
(declare-fun v_int_54_4460 () Int)
(declare-fun n () Int)
(declare-fun v_node_79_2265_primed () Int)
(declare-fun b_3860 () Int)
(declare-fun m_3858 () Int)
(declare-fun n_3859 () Int)
(declare-fun q_3781 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= b_3839 2))
(assert (<= 0 b_3839))
(assert (<= 0 m))
(assert (<= flted_44_3824 2))
(assert (<= 0 flted_44_3824))
(assert (<= 0 flted_44_3826))
(assert (= flted_44_3826 1))
(assert (= flted_44_3825 1))
(assert (= flted_44_3824 1))
(assert (= m flted_44_3826))
(assert (= b_3839 flted_44_3824))
(assert (= m_4499 m))
(assert (= b_4501 b_3839))
(assert (<= 0 m_4499))
(assert (<= 0 b_4501))
(assert (<= b_4501 2))
(assert (or (and (and (and (< v_node_52_3835 1) (= m_4499 0)) (= n_4500 0)) (= b_4501 1)) (and (and (and (and (and (<= 0 b_4501) (<= (+ (- 0 n_4500) 2) b_4501)) (<= b_4501 n_4500)) (<= b_4501 2)) (<= 1 m_4499)) (> v_node_52_3835 0))))
(assert (<= 0 n_4500))
(assert (= v_int_79_2270_primed n_4500))
(assert (<= 0 n))
(assert (= n_4500 n))
(assert (<= b_3860 2))
(assert (<= 0 b_3860))
(assert (<= Anon_3784 2))
(assert (<= 0 Anon_3784))
(assert (<= 0 n2_3783))
(assert (<= 0 m2_3782))
(assert (= b_3860 Anon_3784))
(assert (<= 0 flted_44_3825))
(assert (= n flted_44_3825))
(assert (<= 0 tn_3798))
(assert (<= 0 tm_3797))
(assert (= tm_3797 0))
(assert (= tn_3798 0))
(assert (<= 0 n1_3779))
(assert (<= 0 m1_3778))
(assert (= tn_3798 n1_3779))
(assert (= tm_3797 m1_3778))
(assert (= n_3775 tn))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (exists ((max_4672 Int)) (and (= tn (+ 1 max_4672)) (or (and (= max_4672 n1_3779) (>= n1_3779 n2_3783)) (and (= max_4672 n2_3783) (< n1_3779 n2_3783))))))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (not (= v_int_54_4460 2)))
(assert (= m_3858 m2_3782))
(assert (= n_3859 n2_3783))
(assert (<= 0 m_3858))
(assert (<= 0 n_3859))
(assert (= (+ v_int_54_4460 n_3859) n))
(assert (= v_node_79_2265_primed q_3781))
(assert (or (and (and (and (< q_3781 1) (= m_3858 0)) (= n_3859 0)) (= b_3860 1)) (and (and (and (and (and (<= 0 b_3860) (<= (+ (- 0 n_3859) 2) b_3860)) (<= b_3860 n_3859)) (<= b_3860 2)) (<= 1 m_3858)) (> q_3781 0))))
;Negation of Consequence
(assert (not (or (= m_3858 0) (or (= n_3859 0) (< q_3781 1)))))
(check-sat)