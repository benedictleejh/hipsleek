(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun res () Int)
(declare-fun height_79_4749 () Int)
(declare-fun b_3860 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun n_3859 () Int)
(declare-fun m_3858 () Int)
(declare-fun b_3839 () Int)
(declare-fun n () Int)
(declare-fun m () Int)
(declare-fun left_52_3827 () Int)
(declare-fun p_3777 () Int)
(declare-fun flted_44_3824 () Int)
(declare-fun flted_44_3825 () Int)
(declare-fun flted_44_3826 () Int)
(declare-fun b_3799 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun tn_3798 () Int)
(declare-fun tm_3797 () Int)
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
(declare-fun v_int_54_4460 () Int)
(declare-fun v_bool_54_2169_primed () Int)
(declare-fun Anon_5548 () Int)
(declare-fun Anon_3776 () Int)
(declare-fun p_5549 () Int)
(declare-fun v_node_52_3835 () Int)
(declare-fun q_5553 () Int)
(declare-fun q_3781 () Int)
(declare-fun m1_5550 () Int)
(declare-fun m_4499 () Int)
(declare-fun n_4500 () Int)
(declare-fun Anon_5552 () Int)
(declare-fun b_4501 () Int)
(declare-fun m2_5554 () Int)
(declare-fun m_4610 () Int)
(declare-fun n_4611 () Int)
(declare-fun Anon_5556 () Int)
(declare-fun b_4612 () Int)
(declare-fun v_int_79_5544 () Int)
(declare-fun n2_5555 () Int)
(declare-fun n1_5551 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res t_primed))
(assert (= height_79_4749 n_3775))
(assert (= v_int_79_5544 (+ 1 n_4500)))
(assert (<= n_4611 n_4500))
(assert (<= b_4612 2))
(assert (<= 0 b_4612))
(assert (<= 0 n_4611))
(assert (<= 0 m_4610))
(assert (<= b_3860 2))
(assert (<= 0 b_3860))
(assert (<= 0 n_3859))
(assert (<= 0 m_3858))
(assert (= b_4612 b_3860))
(assert (= n_4611 n_3859))
(assert (= m_4610 m_3858))
(assert (<= b_4501 2))
(assert (<= 0 b_4501))
(assert (<= 0 n_4500))
(assert (<= 0 m_4499))
(assert (<= b_3839 2))
(assert (<= 0 b_3839))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (= b_4501 b_3839))
(assert (= n_4500 n))
(assert (= m_4499 m))
(assert (= (+ v_int_54_4460 n_3859) n))
(assert (<= Anon_3784 2))
(assert (<= 0 Anon_3784))
(assert (<= 0 n2_3783))
(assert (<= 0 m2_3782))
(assert (= b_3860 Anon_3784))
(assert (= n_3859 n2_3783))
(assert (= m_3858 m2_3782))
(assert (<= flted_44_3824 2))
(assert (<= 0 flted_44_3824))
(assert (<= 0 flted_44_3825))
(assert (<= 0 flted_44_3826))
(assert (= b_3839 flted_44_3824))
(assert (= n flted_44_3825))
(assert (= m flted_44_3826))
(assert (= left_52_3827 p_3777))
(assert (<= b_3799 2))
(assert (<= 0 b_3799))
(assert (<= 0 tn_3798))
(assert (<= 0 tm_3797))
(assert (< p_3777 1))
(assert (= tm_3797 0))
(assert (= tn_3798 0))
(assert (= flted_44_3824 1))
(assert (= flted_44_3825 1))
(assert (= flted_44_3826 1))
(assert (<= Anon_3780 2))
(assert (<= 0 Anon_3780))
(assert (<= 0 n1_3779))
(assert (<= 0 m1_3778))
(assert (= b_3799 Anon_3780))
(assert (= tn_3798 n1_3779))
(assert (= tm_3797 m1_3778))
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
(assert (< x_primed Anon_3776))
(assert (> v_bool_50_2248_primed 0))
(assert (not (= v_int_54_4460 2)))
(assert (not (> v_bool_54_2169_primed 0)))
(assert (= Anon_5548 Anon_3776))
(assert (= p_5549 v_node_52_3835))
(assert (= q_5553 q_3781))
(assert (= m1_5550 m_4499))
(assert (= n1_5551 n_4500))
(assert (= Anon_5552 b_4501))
(assert (= m2_5554 m_4610))
(assert (= n2_5555 n_4611))
(assert (= Anon_5556 b_4612))
(assert (exists ((max_63 Int)) (and (= v_int_79_5544 (+ 1 max_63)) (or (and (= max_63 n1_5551) (>= n1_5551 n2_5555)) (and (= max_63 n2_5555) (< n1_5551 n2_5555))))))
(assert (exists ((flted_44_5545 Int)) (= (+ flted_44_5545 n2_5555) (+ 1 n1_5551))))
;Negation of Consequence
(assert (not false))
(check-sat)