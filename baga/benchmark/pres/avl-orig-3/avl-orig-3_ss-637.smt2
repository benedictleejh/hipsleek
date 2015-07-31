(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun Anon_4968 () Int)
(declare-fun n2_4967 () Int)
(declare-fun m2_4966 () Int)
(declare-fun Anon_4964 () Int)
(declare-fun n1_4963 () Int)
(declare-fun m1_4962 () Int)
(declare-fun q_4965 () Int)
(declare-fun p_4961 () Int)
(declare-fun resl_4434 () Int)
(declare-fun Anon_4960 () Int)
(declare-fun Anon_4433 () Int)
(declare-fun Anon_4623 () Int)
(declare-fun n2_4622 () Int)
(declare-fun m2_4621 () Int)
(declare-fun Anon_4619 () Int)
(declare-fun n1_4618 () Int)
(declare-fun m1_4617 () Int)
(declare-fun q_4620 () Int)
(declare-fun resrr_4438 () Int)
(declare-fun p_4616 () Int)
(declare-fun resrl_4437 () Int)
(declare-fun Anon_4615 () Int)
(declare-fun Anon_4436 () Int)
(declare-fun v_bool_55_2168_primed () Int)
(declare-fun v_bool_54_2169_primed () Int)
(declare-fun v_bool_50_2248_primed () Int)
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
(declare-fun left_52_3828 () Int)
(declare-fun p_3777 () Int)
(declare-fun flted_43_3821 () Int)
(declare-fun resn_3822 () Int)
(declare-fun resb_3823 () Int)
(declare-fun m () Int)
(declare-fun b_3839 () Int)
(declare-fun m2_3782 () Int)
(declare-fun n2_3783 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun n () Int)
(declare-fun m1_3941 () Int)
(declare-fun n1_3942 () Int)
(declare-fun Anon_3943 () Int)
(declare-fun m2_3945 () Int)
(declare-fun n2_3946 () Int)
(declare-fun Anon_3947 () Int)
(declare-fun Anon_40 () Int)
(declare-fun Anon_3776 () Int)
(declare-fun Anon_41 () Int)
(declare-fun n_3775 () Int)
(declare-fun l () Int)
(declare-fun r () Int)
(declare-fun q_3781 () Int)
(declare-fun Anon_42 () Int)
(declare-fun Anon_3939 () Int)
(declare-fun Anon_43 () Int)
(declare-fun n_3938 () Int)
(declare-fun ll () Int)
(declare-fun p_3940 () Int)
(declare-fun lr () Int)
(declare-fun q_3944 () Int)
(declare-fun m_3969 () Int)
(declare-fun n_3970 () Int)
(declare-fun b_3971 () Int)
(declare-fun m_3950 () Int)
(declare-fun n_3951 () Int)
(declare-fun b_3952 () Int)
(declare-fun v_node_52_3833 () Int)
(declare-fun m_3858 () Int)
(declare-fun n_3859 () Int)
(declare-fun b_3860 () Int)
(declare-fun t_4013 () Int)
(declare-fun tmp1_4439 () Int)
(declare-fun tmp2_4441 () Int)
(declare-fun resrn_4442 () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun ba1 () Int)
(declare-fun m_4499 () Int)
(declare-fun b_4501 () Int)
(declare-fun cm () Int)
(declare-fun cn () Int)
(declare-fun ba3 () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun ba2 () Int)
(declare-fun resr_4435 () Int)
(declare-fun m_4610 () Int)
(declare-fun b_4612 () Int)
(declare-fun n_4611 () Int)
(declare-fun v_int_79_4956 () Int)
(declare-fun n_4500 () Int)
(declare-fun height_79_4747 () Int)
(declare-fun resn_4440 () Int)
(declare-fun res () Int)
(declare-fun t_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_4968 b_4612))
(assert (= n2_4967 n_4611))
(assert (= m2_4966 m_4610))
(assert (= Anon_4964 b_4501))
(assert (= n1_4963 n_4500))
(assert (= m1_4962 m_4499))
(assert (= q_4965 resr_4435))
(assert (= p_4961 resl_4434))
(assert (= Anon_4960 Anon_4433))
(assert (= m_4610 (+ (+ m2_4621 1) m1_4617)))
(assert (exists ((max_63 Int)) (and (= n_4611 (+ 1 max_63)) (or (and (= max_63 n1_4618) (>= n1_4618 n2_4622)) (and (= max_63 n2_4622) (< n1_4618 n2_4622))))))
(assert (= (+ b_4612 n2_4622) (+ 1 n1_4618)))
(assert (= resrn_4442 n_4611))
(assert (or (and (= resrn_4442 (+ n1_4618 1)) (<= n2_4622 n1_4618)) (and (= resrn_4442 (+ n2_4622 1)) (< n1_4618 n2_4622))))
(assert (<= n2_4622 (+ 1 n1_4618)))
(assert (<= n1_4618 (+ n2_4622 1)))
(assert (= Anon_4623 ba3))
(assert (= n2_4622 cn))
(assert (= m2_4621 cm))
(assert (= Anon_4619 ba2))
(assert (= n1_4618 bn))
(assert (= m1_4617 bm))
(assert (= q_4620 resrr_4438))
(assert (= p_4616 resrl_4437))
(assert (= Anon_4615 Anon_4436))
(assert (> v_bool_55_2168_primed 0))
(assert (< n_3970 n_3951))
(assert (= m (+ (+ m2_3945 1) m1_3941)))
(assert (exists ((max_63 Int)) (and (= n (+ 1 max_63)) (or (and (= max_63 n1_3942) (>= n1_3942 n2_3946)) (and (= max_63 n2_3946) (< n1_3942 n2_3946))))))
(assert (= (+ b_3839 n2_3946) (+ 1 n1_3942)))
(assert (<= n2_3946 (+ 1 n1_3942)))
(assert (<= n1_3942 (+ n2_3946 1)))
(assert (= n_3938 n))
(assert (> v_bool_54_2169_primed 0))
(assert (> v_bool_50_2248_primed 0))
(assert (< x_primed Anon_3776))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (exists ((max_63 Int)) (and (= tn (+ 1 max_63)) (or (and (= max_63 n1_3779) (>= n1_3779 n2_3783)) (and (= max_63 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= n_3775 tn))
(assert (not (> v_bool_48_2249_primed 0)))
(assert (= x_primed x))
(assert (= t_4013 t))
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
(assert (<= 0 m))
(assert (<= 0 n))
(assert (<= 0 b_3839))
(assert (<= b_3839 2))
(assert (= m_3858 m2_3782))
(assert (= n_3859 n2_3783))
(assert (= b_3860 Anon_3784))
(assert (<= 0 m2_3782))
(assert (<= 0 n2_3783))
(assert (<= 0 Anon_3784))
(assert (<= Anon_3784 2))
(assert (= (+ 2 n_3859) n))
(assert (= m_3950 m1_3941))
(assert (= n_3951 n1_3942))
(assert (= b_3952 Anon_3943))
(assert (<= 0 m1_3941))
(assert (<= 0 n1_3942))
(assert (<= 0 Anon_3943))
(assert (<= Anon_3943 2))
(assert (= m_3969 m2_3945))
(assert (= n_3970 n2_3946))
(assert (= b_3971 Anon_3947))
(assert (<= 0 m2_3945))
(assert (<= 0 n2_3946))
(assert (<= 0 Anon_3947))
(assert (<= Anon_3947 2))
(assert (= Anon_40 Anon_3776))
(assert (= Anon_41 n_3775))
(assert (= l v_node_52_3833))
(assert (= r q_3781))
(assert (= cm m_3858))
(assert (= cn n_3859))
(assert (= ba3 b_3860))
(assert (= Anon_42 Anon_3939))
(assert (= Anon_43 n_3938))
(assert (= ll p_3940))
(assert (= lr q_3944))
(assert (= am m_3950))
(assert (= an n_3951))
(assert (= ba1 b_3952))
(assert (= bm m_3969))
(assert (= bn n_3970))
(assert (= ba2 b_3971))
(assert (<= 0 m_3969))
(assert (<= 0 n_3970))
(assert (<= 0 b_3971))
(assert (<= b_3971 2))
(assert (<= 0 m_3950))
(assert (<= 0 n_3951))
(assert (<= 0 b_3952))
(assert (<= b_3952 2))
(assert (> v_node_52_3833 0))
(assert (<= 0 m_3858))
(assert (<= 0 n_3859))
(assert (<= 0 b_3860))
(assert (<= b_3860 2))
(assert (> t_4013 0))
(assert (= resrn_4442 (+ 1 tmp1_4439)))
(assert (or (and (= tmp1_4439 cn) (>= cn bn)) (and (= tmp1_4439 bn) (< cn bn))))
(assert (= resn_4440 (+ 1 tmp2_4441)))
(assert (or (and (= tmp2_4441 an) (>= an resrn_4442)) (and (= tmp2_4441 resrn_4442) (< an resrn_4442))))
(assert (= m_4499 am))
(assert (= n_4500 an))
(assert (= b_4501 ba1))
(assert (<= 0 am))
(assert (<= 0 an))
(assert (<= 0 ba1))
(assert (<= ba1 2))
(assert (<= 0 m_4499))
(assert (<= 0 n_4500))
(assert (<= 0 b_4501))
(assert (<= b_4501 2))
(assert (<= 0 cm))
(assert (<= 0 cn))
(assert (<= 0 ba3))
(assert (<= ba3 2))
(assert (<= 0 bm))
(assert (<= 0 bn))
(assert (<= 0 ba2))
(assert (<= ba2 2))
(assert (> resr_4435 0))
(assert (<= 0 m_4610))
(assert (<= 0 n_4611))
(assert (<= 0 b_4612))
(assert (<= b_4612 2))
(assert (<= n_4611 n_4500))
(assert (= v_int_79_4956 (+ 1 n_4500)))
(assert (= height_79_4747 resn_4440))
(assert (= res t_primed))
;Negation of Consequence
(assert (not false))
(check-sat)