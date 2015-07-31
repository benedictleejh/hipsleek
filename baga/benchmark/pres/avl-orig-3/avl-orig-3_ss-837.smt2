(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  unsat) 
;Variables declarations
(declare-fun tm_3797 () Int)
(declare-fun Anon_5556 () Int)
(declare-fun n2_5555 () Int)
(declare-fun m2_5554 () Int)
(declare-fun Anon_5552 () Int)
(declare-fun n1_5551 () Int)
(declare-fun m1_5550 () Int)
(declare-fun q_5553 () Int)
(declare-fun p_5549 () Int)
(declare-fun tm () Int)
(declare-fun m1_3778 () Int)
(declare-fun flted_44_3826 () Int)
(declare-fun flted_44_3825 () Int)
(declare-fun flted_44_3824 () Int)
(declare-fun m2_3782 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun m () Int)
(declare-fun b_3839 () Int)
(declare-fun m_3858 () Int)
(declare-fun b_3860 () Int)
(declare-fun b_4501 () Int)
(declare-fun m_4499 () Int)
(declare-fun v_node_52_3835 () Int)
(declare-fun b_4612 () Int)
(declare-fun m_4610 () Int)
(declare-fun q_3781 () Int)
(declare-fun height_79_4749 () Int)
(declare-fun v_int_79_5544 () Int)
(declare-fun n_4611 () Int)
(declare-fun n_4500 () Int)
(declare-fun v_int_54_4460 () Int)
(declare-fun n () Int)
(declare-fun n_3859 () Int)
(declare-fun tn_3798 () Int)
(declare-fun n_3775 () Int)
(declare-fun tn () Int)
(declare-fun n2_3783 () Int)
(declare-fun n1_3779 () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= b_3860 2))
(assert (<= 0 b_3860))
(assert (<= 0 m_3858))
(assert (<= b_3839 2))
(assert (<= 0 b_3839))
(assert (<= 0 m))
(assert (<= Anon_3784 2))
(assert (<= 0 Anon_3784))
(assert (<= 0 m2_3782))
(assert (<= flted_44_3824 2))
(assert (<= 0 flted_44_3824))
(assert (<= 0 flted_44_3825))
(assert (<= 0 flted_44_3826))
(assert (<= 0 tm_3797))
(assert (= tm_3797 0))
(assert (<= 0 m1_3778))
(assert (= tm_3797 m1_3778))
(assert (exists ((flted_44_5598 Int)) (= (+ flted_44_5598 n2_5555) (+ 1 n1_5551))))
(assert (exists ((max_5597 Int)) (and (= v_int_79_5544 (+ 1 max_5597)) (or (and (= max_5597 n1_5551) (>= n1_5551 n2_5555)) (and (= max_5597 n2_5555) (< n1_5551 n2_5555))))))
(assert (= Anon_5556 b_4612))
(assert (= n2_5555 n_4611))
(assert (= m2_5554 m_4610))
(assert (= Anon_5552 b_4501))
(assert (= n1_5551 n_4500))
(assert (= m1_5550 m_4499))
(assert (= q_5553 q_3781))
(assert (= p_5549 v_node_52_3835))
(assert (not (= v_int_54_4460 2)))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (= flted_44_3826 1))
(assert (= flted_44_3825 1))
(assert (= flted_44_3824 1))
(assert (= m flted_44_3826))
(assert (= n flted_44_3825))
(assert (= b_3839 flted_44_3824))
(assert (= m_3858 m2_3782))
(assert (= b_3860 Anon_3784))
(assert (= m_4499 m))
(assert (= b_4501 b_3839))
(assert (<= 0 m_4499))
(assert (<= 0 b_4501))
(assert (<= b_4501 2))
(assert (= m_4610 m_3858))
(assert (= b_4612 b_3860))
(assert (<= 0 m_4610))
(assert (<= 0 b_4612))
(assert (<= b_4612 2))
(assert (or (and (and (and (< v_node_52_3835 1) (= m_4499 0)) (= n_4500 0)) (= b_4501 1)) (and (and (and (and (and (<= 0 b_4501) (<= (+ (- 0 n_4500) 2) b_4501)) (<= b_4501 n_4500)) (<= b_4501 2)) (<= 1 m_4499)) (> v_node_52_3835 0))))
(assert (or (and (and (and (< q_3781 1) (= m_4610 0)) (= n_4611 0)) (= b_4612 1)) (and (and (and (and (and (<= 0 b_4612) (<= (+ (- 0 n_4611) 2) b_4612)) (<= b_4612 n_4611)) (<= b_4612 2)) (<= 1 m_4610)) (> q_3781 0))))
(assert (= height_79_4749 n_3775))
(assert (= v_int_79_5544 (+ 1 n_4500)))
(assert (<= n_4611 n_4500))
(assert (<= 0 n_4611))
(assert (<= 0 n_3859))
(assert (= n_4611 n_3859))
(assert (<= 0 n_4500))
(assert (<= 0 n))
(assert (= n_4500 n))
(assert (= (+ v_int_54_4460 n_3859) n))
(assert (<= 0 n2_3783))
(assert (= n_3859 n2_3783))
(assert (<= 0 tn_3798))
(assert (= tn_3798 0))
(assert (<= 0 n1_3779))
(assert (= tn_3798 n1_3779))
(assert (= n_3775 tn))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (exists ((max_5596 Int)) (and (= tn (+ 1 max_5596)) (or (and (= max_5596 n1_3779) (>= n1_3779 n2_3783)) (and (= max_5596 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
;Negation of Consequence
(assert (not (<= 0 b)))
(check-sat)