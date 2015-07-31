(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun right_55_2147_primed () Int)
(declare-fun left_55_2146_primed () Int)
(declare-fun height_55_2145_primed () Int)
(declare-fun ele_55_2144_primed () Int)
(declare-fun v_int_55_2161_primed () Int)
(declare-fun Anon_3943 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun left_52_3828 () Int)
(declare-fun resn_3822 () Int)
(declare-fun resb_3823 () Int)
(declare-fun p_3777 () Int)
(declare-fun flted_43_3821 () Int)
(declare-fun b_3799 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun tn_3798 () Int)
(declare-fun tm_3797 () Int)
(declare-fun t () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
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
(declare-fun Anon_3776 () Int)
(declare-fun v_bool_50_2248_primed () Int)
(declare-fun v_bool_54_2169_primed () Int)
(declare-fun n_3938 () Int)
(declare-fun b_3839 () Int)
(declare-fun n () Int)
(declare-fun n1_3942 () Int)
(declare-fun m () Int)
(declare-fun m1_3941 () Int)
(declare-fun v_node_52_3833 () Int)
(declare-fun n2_3946 () Int)
(declare-fun Anon_3947 () Int)
(declare-fun m2_3945 () Int)
(declare-fun q_3944 () Int)
(declare-fun n_3859 () Int)
(declare-fun b_3860 () Int)
(declare-fun m_3858 () Int)
(declare-fun q_3781 () Int)
(declare-fun n_3951 () Int)
(declare-fun b_3952 () Int)
(declare-fun m_3950 () Int)
(declare-fun p_3940 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_55_2147_primed q_3781))
(assert (= left_55_2146_primed v_node_52_3833))
(assert (= height_55_2145_primed n_3775))
(assert (= ele_55_2144_primed Anon_3776))
(assert (<= b_3952 2))
(assert (<= 0 b_3952))
(assert (<= 0 n_3951))
(assert (<= 0 m_3950))
(assert (= v_int_55_2161_primed n_3951))
(assert (<= Anon_3943 2))
(assert (<= 0 Anon_3943))
(assert (<= 0 n1_3942))
(assert (<= 0 m1_3941))
(assert (= b_3952 Anon_3943))
(assert (= n_3951 n1_3942))
(assert (= m_3950 m1_3941))
(assert (= (+ 2 n_3859) n))
(assert (<= b_3860 2))
(assert (<= 0 b_3860))
(assert (<= 0 n_3859))
(assert (<= 0 m_3858))
(assert (<= Anon_3784 2))
(assert (<= 0 Anon_3784))
(assert (<= 0 n2_3783))
(assert (<= 0 m2_3782))
(assert (= b_3860 Anon_3784))
(assert (= n_3859 n2_3783))
(assert (= m_3858 m2_3782))
(assert (<= b_3839 2))
(assert (<= 0 b_3839))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (<= resb_3823 2))
(assert (<= 0 resb_3823))
(assert (<= 0 resn_3822))
(assert (<= 0 flted_43_3821))
(assert (= b_3839 resb_3823))
(assert (= n resn_3822))
(assert (= m flted_43_3821))
(assert (= left_52_3828 p_3777))
(assert (<= b_3799 2))
(assert (<= 0 b_3799))
(assert (<= 0 tn_3798))
(assert (<= 0 tm_3797))
(assert (or (= tn_3798 resn_3822) (and (= resn_3822 (+ 1 tn_3798)) (not (= resb_3823 1)))))
(assert (< 0 tn_3798))
(assert (< 0 tm_3797))
(assert (> p_3777 0))
(assert (= flted_43_3821 (+ 1 tm_3797)))
(assert (<= Anon_3780 2))
(assert (<= 0 Anon_3780))
(assert (<= 0 n1_3779))
(assert (<= 0 m1_3778))
(assert (= b_3799 Anon_3780))
(assert (= tn_3798 n1_3779))
(assert (= tm_3797 m1_3778))
(assert (= t_primed t))
(assert (= x_primed x))
(assert (< tmp_primed 1))
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
(assert (> v_bool_54_2169_primed 0))
(assert (= n_3938 n))
(assert (<= n1_3942 (+ n2_3946 1)))
(assert (<= n2_3946 (+ 1 n1_3942)))
(assert (= (+ b_3839 n2_3946) (+ 1 n1_3942)))
(assert (exists ((max_63 Int)) (and (= n (+ 1 max_63)) (or (and (= max_63 n1_3942) (>= n1_3942 n2_3946)) (and (= max_63 n2_3946) (< n1_3942 n2_3946))))))
(assert (= m (+ (+ m2_3945 1) m1_3941)))
(assert (= v_node_52_3833 1))
(assert (or (and (and (and (< q_3944 1) (= m2_3945 0)) (= n2_3946 0)) (= Anon_3947 1)) (and (and (and (and (and (<= 0 Anon_3947) (<= (+ (- 0 n2_3946) 2) Anon_3947)) (<= Anon_3947 n2_3946)) (<= Anon_3947 2)) (<= 1 m2_3945)) (> q_3944 0))))
(assert (or (and (and (and (< q_3781 1) (= m_3858 0)) (= n_3859 0)) (= b_3860 1)) (and (and (and (and (and (<= 0 b_3860) (<= (+ (- 0 n_3859) 2) b_3860)) (<= b_3860 n_3859)) (<= b_3860 2)) (<= 1 m_3858)) (> q_3781 0))))
(assert (or (and (and (and (< p_3940 1) (= m_3950 0)) (= n_3951 0)) (= b_3952 1)) (and (and (and (and (and (<= 0 b_3952) (<= (+ (- 0 n_3951) 2) b_3952)) (<= b_3952 n_3951)) (<= b_3952 2)) (<= 1 m_3950)) (> p_3940 0))))
;Negation of Consequence
(assert (not false))
(check-sat)