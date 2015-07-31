(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun Anon_5498 () Int)
(declare-fun n2_5497 () Int)
(declare-fun m2_5496 () Int)
(declare-fun Anon_5494 () Int)
(declare-fun n1_5493 () Int)
(declare-fun m1_5492 () Int)
(declare-fun q_5495 () Int)
(declare-fun q_3781 () Int)
(declare-fun p_5491 () Int)
(declare-fun v_node_52_3835 () Int)
(declare-fun Anon_5490 () Int)
(declare-fun v_bool_54_2169_primed () Int)
(declare-fun v_bool_50_2248_primed () Int)
(declare-fun Anon_3776 () Int)
(declare-fun tm () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun v_bool_48_2249_primed () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun t () Int)
(declare-fun m1_3778 () Int)
(declare-fun n1_3779 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun tm_3797 () Int)
(declare-fun tn_3798 () Int)
(declare-fun b_3799 () Int)
(declare-fun left_52_3827 () Int)
(declare-fun p_3777 () Int)
(declare-fun flted_44_3826 () Int)
(declare-fun flted_44_3825 () Int)
(declare-fun flted_44_3824 () Int)
(declare-fun m2_3782 () Int)
(declare-fun n2_3783 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun v_int_54_4460 () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun b_3839 () Int)
(declare-fun m_4499 () Int)
(declare-fun b_4501 () Int)
(declare-fun m_3858 () Int)
(declare-fun n_3859 () Int)
(declare-fun b_3860 () Int)
(declare-fun m_4610 () Int)
(declare-fun b_4612 () Int)
(declare-fun n_4611 () Int)
(declare-fun v_int_79_5486 () Int)
(declare-fun n_4500 () Int)
(declare-fun height_79_4749 () Int)
(declare-fun n_3775 () Int)
(declare-fun res () Int)
(declare-fun t_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_5498 b_4612))
(assert (= n2_5497 n_4611))
(assert (= m2_5496 m_4610))
(assert (= Anon_5494 b_4501))
(assert (= n1_5493 n_4500))
(assert (= m1_5492 m_4499))
(assert (= q_5495 q_3781))
(assert (= p_5491 v_node_52_3835))
(assert (= Anon_5490 Anon_3776))
(assert (not (> v_bool_54_2169_primed 0)))
(assert (not (= v_int_54_4460 2)))
(assert (> v_bool_50_2248_primed 0))
(assert (< x_primed Anon_3776))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (exists ((max_63 Int)) (and (= tn (+ 1 max_63)) (or (and (= max_63 n1_3779) (>= n1_3779 n2_3783)) (and (= max_63 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= n_3775 tn))
(assert (not (> v_bool_48_2249_primed 0)))
(assert (> t_primed 0))
(assert (= x_primed x))
(assert (= t_primed t))
(assert (= tm_3797 m1_3778))
(assert (= tn_3798 n1_3779))
(assert (= b_3799 Anon_3780))
(assert (<= 0 m1_3778))
(assert (<= 0 n1_3779))
(assert (<= 0 Anon_3780))
(assert (<= Anon_3780 2))
(assert (= flted_44_3826 1))
(assert (= flted_44_3825 1))
(assert (= flted_44_3824 1))
(assert (= tn_3798 0))
(assert (= tm_3797 0))
(assert (< p_3777 1))
(assert (<= 0 tm_3797))
(assert (<= 0 tn_3798))
(assert (<= 0 b_3799))
(assert (<= b_3799 2))
(assert (= left_52_3827 p_3777))
(assert (= m flted_44_3826))
(assert (= n flted_44_3825))
(assert (= b_3839 flted_44_3824))
(assert (<= 0 flted_44_3826))
(assert (<= 0 flted_44_3825))
(assert (<= 0 flted_44_3824))
(assert (<= flted_44_3824 2))
(assert (= m_3858 m2_3782))
(assert (= n_3859 n2_3783))
(assert (= b_3860 Anon_3784))
(assert (<= 0 m2_3782))
(assert (<= 0 n2_3783))
(assert (<= 0 Anon_3784))
(assert (<= Anon_3784 2))
(assert (= (+ v_int_54_4460 n_3859) n))
(assert (= m_4499 m))
(assert (= n_4500 n))
(assert (= b_4501 b_3839))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (<= 0 b_3839))
(assert (<= b_3839 2))
(assert (<= 0 m_4499))
(assert (<= 0 n_4500))
(assert (<= 0 b_4501))
(assert (<= b_4501 2))
(assert (= m_4610 m_3858))
(assert (= n_4611 n_3859))
(assert (= b_4612 b_3860))
(assert (<= 0 m_3858))
(assert (<= 0 n_3859))
(assert (<= 0 b_3860))
(assert (<= b_3860 2))
(assert (<= 0 m_4610))
(assert (<= 0 n_4611))
(assert (<= 0 b_4612))
(assert (<= b_4612 2))
(assert (<= n_4611 n_4500))
(assert (= v_int_79_5486 (+ 1 n_4500)))
(assert (= height_79_4749 n_3775))
(assert (= res t_primed))
;Negation of Consequence
(assert (not false))
(check-sat)