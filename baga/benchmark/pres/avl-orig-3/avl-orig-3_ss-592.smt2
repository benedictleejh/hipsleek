(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_54_2169_primed () Int)
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
(declare-fun m1_3778 () Int)
(declare-fun n1_3779 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun tm_3797 () Int)
(declare-fun tn_3798 () Int)
(declare-fun b_3799 () Int)
(declare-fun left_52_3828 () Int)
(declare-fun p_3777 () Int)
(declare-fun flted_43_3821 () Int)
(declare-fun resn_3822 () Int)
(declare-fun resb_3823 () Int)
(declare-fun m2_3782 () Int)
(declare-fun n2_3783 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun v_int_54_4458 () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun b_3839 () Int)
(declare-fun m_3858 () Int)
(declare-fun n_3859 () Int)
(declare-fun b_3860 () Int)
(declare-fun res () Int)
(declare-fun v_int_79_2274_primed () Int)
(declare-fun v_int_79_2275_primed () Int)
(declare-fun t_primed () Int)
(declare-fun n_4500 () Int)
(declare-fun b_4501 () Int)
(declare-fun m_4499 () Int)
(declare-fun v_node_52_3833 () Int)
(declare-fun n_4611 () Int)
(declare-fun b_4612 () Int)
(declare-fun m_4610 () Int)
(declare-fun q_3781 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (not (> v_bool_54_2169_primed 0)))
(assert (not (= v_int_54_4458 2)))
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
(assert (< tmp_primed 1))
(assert (= x_primed x))
(assert (= t_primed t))
(assert (= tm_3797 m1_3778))
(assert (= tn_3798 n1_3779))
(assert (= b_3799 Anon_3780))
(assert (<= 0 m1_3778))
(assert (<= 0 n1_3779))
(assert (<= 0 Anon_3780))
(assert (<= Anon_3780 2))
(assert (= flted_43_3821 (+ 1 tm_3797)))
(assert (> p_3777 0))
(assert (< 0 tm_3797))
(assert (< 0 tn_3798))
(assert (or (= tn_3798 resn_3822) (and (= resn_3822 (+ 1 tn_3798)) (not (= resb_3823 1)))))
(assert (<= 0 tm_3797))
(assert (<= 0 tn_3798))
(assert (<= 0 b_3799))
(assert (<= b_3799 2))
(assert (= left_52_3828 p_3777))
(assert (= m flted_43_3821))
(assert (= n resn_3822))
(assert (= b_3839 resb_3823))
(assert (<= 0 flted_43_3821))
(assert (<= 0 resn_3822))
(assert (<= 0 resb_3823))
(assert (<= resb_3823 2))
(assert (= m_3858 m2_3782))
(assert (= n_3859 n2_3783))
(assert (= b_3860 Anon_3784))
(assert (<= 0 m2_3782))
(assert (<= 0 n2_3783))
(assert (<= 0 Anon_3784))
(assert (<= Anon_3784 2))
(assert (= (+ v_int_54_4458 n_3859) n))
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
(assert (= v_int_79_2275_primed n_4500))
(assert (<= n_4611 n_4500))
(assert (= v_int_79_2274_primed 1))
(assert (= res (+ v_int_79_2274_primed v_int_79_2275_primed)))
(assert (= t_primed 1))
(assert (or (and (and (and (< v_node_52_3833 1) (= m_4499 0)) (= n_4500 0)) (= b_4501 1)) (and (and (and (and (and (<= 0 b_4501) (<= (+ (- 0 n_4500) 2) b_4501)) (<= b_4501 n_4500)) (<= b_4501 2)) (<= 1 m_4499)) (> v_node_52_3833 0))))
(assert (or (and (and (and (< q_3781 1) (= m_4610 0)) (= n_4611 0)) (= b_4612 1)) (and (and (and (and (and (<= 0 b_4612) (<= (+ (- 0 n_4611) 2) b_4612)) (<= b_4612 n_4611)) (<= b_4612 2)) (<= 1 m_4610)) (> q_3781 0))))
;Negation of Consequence
(assert (not false))
(check-sat)