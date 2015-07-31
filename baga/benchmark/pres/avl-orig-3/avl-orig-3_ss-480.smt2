(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun right_79_2261_primed () Int)
(declare-fun left_79_2260_primed () Int)
(declare-fun height_79_2259_primed () Int)
(declare-fun ele_79_2258_primed () Int)
(declare-fun Anon_4433 () Int)
(declare-fun v_int_79_2270_primed () Int)
(declare-fun resn_4440 () Int)
(declare-fun tmp2_4441 () Int)
(declare-fun resrn_4442 () Int)
(declare-fun tmp1_4439 () Int)
(declare-fun ba1 () Int)
(declare-fun an () Int)
(declare-fun am () Int)
(declare-fun lr () Int)
(declare-fun q_3944 () Int)
(declare-fun ll () Int)
(declare-fun p_3940 () Int)
(declare-fun Anon_43 () Int)
(declare-fun Anon_42 () Int)
(declare-fun Anon_3939 () Int)
(declare-fun r () Int)
(declare-fun q_3781 () Int)
(declare-fun l () Int)
(declare-fun v_node_52_3833 () Int)
(declare-fun Anon_41 () Int)
(declare-fun Anon_40 () Int)
(declare-fun b_3971 () Int)
(declare-fun Anon_3947 () Int)
(declare-fun m_3969 () Int)
(declare-fun b_3952 () Int)
(declare-fun Anon_3943 () Int)
(declare-fun m_3950 () Int)
(declare-fun b_3860 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun n_3859 () Int)
(declare-fun m_3858 () Int)
(declare-fun left_52_3828 () Int)
(declare-fun resn_3822 () Int)
(declare-fun resb_3823 () Int)
(declare-fun p_3777 () Int)
(declare-fun flted_43_3821 () Int)
(declare-fun b_3799 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun tn_3798 () Int)
(declare-fun tm_3797 () Int)
(declare-fun t_4013 () Int)
(declare-fun t () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
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
(declare-fun n2_3946 () Int)
(declare-fun m () Int)
(declare-fun m2_3945 () Int)
(declare-fun m1_3941 () Int)
(declare-fun n_3970 () Int)
(declare-fun n_3951 () Int)
(declare-fun v_bool_55_2168_primed () Int)
(declare-fun resr_4435 () Int)
(declare-fun bn () Int)
(declare-fun ba2 () Int)
(declare-fun bm () Int)
(declare-fun resrl_4437 () Int)
(declare-fun cn () Int)
(declare-fun ba3 () Int)
(declare-fun cm () Int)
(declare-fun resrr_4438 () Int)
(declare-fun n_4500 () Int)
(declare-fun b_4501 () Int)
(declare-fun m_4499 () Int)
(declare-fun resl_4434 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_79_2261_primed resr_4435))
(assert (= left_79_2260_primed resl_4434))
(assert (= height_79_2259_primed resn_4440))
(assert (= ele_79_2258_primed Anon_4433))
(assert (<= b_4501 2))
(assert (<= 0 b_4501))
(assert (<= 0 n_4500))
(assert (<= 0 m_4499))
(assert (= v_int_79_2270_primed n_4500))
(assert (<= ba1 2))
(assert (<= 0 ba1))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (= b_4501 ba1))
(assert (= n_4500 an))
(assert (= m_4499 am))
(assert (<= ba2 2))
(assert (<= 0 ba2))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (<= ba3 2))
(assert (<= 0 ba3))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (or (and (= tmp2_4441 an) (>= an resrn_4442)) (and (= tmp2_4441 resrn_4442) (< an resrn_4442))))
(assert (= resn_4440 (+ 1 tmp2_4441)))
(assert (or (and (= tmp1_4439 cn) (>= cn bn)) (and (= tmp1_4439 bn) (< cn bn))))
(assert (= resrn_4442 (+ 1 tmp1_4439)))
(assert (> t_4013 0))
(assert (<= b_3860 2))
(assert (<= 0 b_3860))
(assert (<= 0 n_3859))
(assert (<= 0 m_3858))
(assert (> v_node_52_3833 0))
(assert (<= b_3952 2))
(assert (<= 0 b_3952))
(assert (<= 0 n_3951))
(assert (<= 0 m_3950))
(assert (<= b_3971 2))
(assert (<= 0 b_3971))
(assert (<= 0 n_3970))
(assert (<= 0 m_3969))
(assert (= ba2 b_3971))
(assert (= bn n_3970))
(assert (= bm m_3969))
(assert (= ba1 b_3952))
(assert (= an n_3951))
(assert (= am m_3950))
(assert (= lr q_3944))
(assert (= ll p_3940))
(assert (= Anon_43 n_3938))
(assert (= Anon_42 Anon_3939))
(assert (= ba3 b_3860))
(assert (= cn n_3859))
(assert (= cm m_3858))
(assert (= r q_3781))
(assert (= l v_node_52_3833))
(assert (= Anon_41 n_3775))
(assert (= Anon_40 Anon_3776))
(assert (<= Anon_3947 2))
(assert (<= 0 Anon_3947))
(assert (<= 0 n2_3946))
(assert (<= 0 m2_3945))
(assert (= b_3971 Anon_3947))
(assert (= n_3970 n2_3946))
(assert (= m_3969 m2_3945))
(assert (<= Anon_3943 2))
(assert (<= 0 Anon_3943))
(assert (<= 0 n1_3942))
(assert (<= 0 m1_3941))
(assert (= b_3952 Anon_3943))
(assert (= n_3951 n1_3942))
(assert (= m_3950 m1_3941))
(assert (= (+ 2 n_3859) n))
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
(assert (= t_4013 t))
(assert (= x_primed x))
(assert (< tmp_primed 1))
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
(assert (< n_3970 n_3951))
(assert (> v_bool_55_2168_primed 0))
(assert (= resr_4435 1))
(assert (or (and (and (and (< resrl_4437 1) (= bm 0)) (= bn 0)) (= ba2 1)) (and (and (and (and (and (<= 0 ba2) (<= (+ (- 0 bn) 2) ba2)) (<= ba2 bn)) (<= ba2 2)) (<= 1 bm)) (> resrl_4437 0))))
(assert (or (and (and (and (< resrr_4438 1) (= cm 0)) (= cn 0)) (= ba3 1)) (and (and (and (and (and (<= 0 ba3) (<= (+ (- 0 cn) 2) ba3)) (<= ba3 cn)) (<= ba3 2)) (<= 1 cm)) (> resrr_4438 0))))
(assert (or (and (and (and (< resl_4434 1) (= m_4499 0)) (= n_4500 0)) (= b_4501 1)) (and (and (and (and (and (<= 0 b_4501) (<= (+ (- 0 n_4500) 2) b_4501)) (<= b_4501 n_4500)) (<= b_4501 2)) (<= 1 m_4499)) (> resl_4434 0))))
;Negation of Consequence
(assert (not false))
(check-sat)