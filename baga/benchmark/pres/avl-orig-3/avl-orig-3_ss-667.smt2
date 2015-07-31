(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status sat)
;Variables declarations
(declare-fun Anon_22 () Int)
(declare-fun Anon_19 () Int)
(declare-fun n_3775 () Int)
(declare-fun Anon_25 () Int)
(declare-fun b_3839 () Int)
(declare-fun n_3938 () Int)
(declare-fun tm () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun m1_3778 () Int)
(declare-fun n1_3779 () Int)
(declare-fun tm_3797 () Int)
(declare-fun tn_3798 () Int)
(declare-fun resb_3823 () Int)
(declare-fun resn_3822 () Int)
(declare-fun m2_3782 () Int)
(declare-fun n2_3783 () Int)
(declare-fun n () Int)
(declare-fun n_3859 () Int)
(declare-fun m_3858 () Int)
(declare-fun Anon_3947 () Int)
(declare-fun n2_3946 () Int)
(declare-fun n1_3942 () Int)
(declare-fun flted_43_3821 () Int)
(declare-fun n_3951 () Int)
(declare-fun n_4045 () Int)
(declare-fun b_3971 () Int)
(declare-fun n_3970 () Int)
(declare-fun n1_4049 () Int)
(declare-fun n2_4053 () Int)
(declare-fun height_79_4748 () Int)
(declare-fun bb2_4450 () Int)
(declare-fun cn () Int)
(declare-fun dn () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun flted_98_4444 () Int)
(declare-fun dm () Int)
(declare-fun cm () Int)
(declare-fun m () Int)
(declare-fun m1_3941 () Int)
(declare-fun q_5064 () Int)
(declare-fun b_4612 () Int)
(declare-fun m_4610 () Int)
(declare-fun ss2_4449 () Int)
(declare-fun m_3950 () Int)
(declare-fun m2_3945 () Int)
(declare-fun m_3969 () Int)
(declare-fun m2_4052 () Int)
(declare-fun m1_4048 () Int)
(declare-fun am () Int)
(declare-fun bm () Int)
(declare-fun h_4451 () Int)
(declare-fun t_4452 () Int)
(declare-fun t1_4454 () Int)
(declare-fun t2_4456 () Int)
(declare-fun bb1_4448 () Int)
(declare-fun h2_4455 () Int)
(declare-fun v_int_79_5055 () Int)
(declare-fun n_4611 () Int)
(declare-fun h1_4453 () Int)
(declare-fun flted_97_4445 () Int)
(declare-fun p_5060 () Int)
(declare-fun b_4501 () Int)
(declare-fun m_4499 () Int)
(declare-fun n_4500 () Int)
(declare-fun ss1_4447 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_22 n_3938))
(assert (= Anon_19 n_3775))
(assert (<= 0 n2_3783))
(assert (<= 0 m2_3782))
(assert (<= b_3839 2))
(assert (<= 0 b_3839))
(assert (<= resb_3823 2))
(assert (<= 0 resb_3823))
(assert (<= 0 resn_3822))
(assert (= b_3839 resb_3823))
(assert (<= 0 tn_3798))
(assert (<= 0 tm_3797))
(assert (< 0 tm_3797))
(assert (<= 0 n1_3779))
(assert (<= 0 m1_3778))
(assert (= n_3775 tn))
(assert (<= 0 n_3859))
(assert (<= 0 m_3858))
(assert (<= 0 n_3951))
(assert (<= 0 n1_4049))
(assert (<= 0 n2_4053))
(assert (= Anon_25 n_4045))
(assert (exists ((max_5085 Int)) (and (= n (+ 1 max_5085)) (or (and (= max_5085 n1_3942) (>= n1_3942 n2_3946)) (and (= max_5085 n2_3946) (< n1_3942 n2_3946))))))
(assert (= (+ b_3839 n2_3946) (+ 1 n1_3942)))
(assert (<= n2_3946 (+ 1 n1_3942)))
(assert (<= n1_3942 (+ n2_3946 1)))
(assert (= n_3938 n))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (exists ((max_5084 Int)) (and (= tn (+ 1 max_5084)) (or (and (= max_5084 n1_3779) (>= n1_3779 n2_3783)) (and (= max_5084 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tm_3797 m1_3778))
(assert (= tn_3798 n1_3779))
(assert (= flted_43_3821 (+ 1 tm_3797)))
(assert (< 0 tn_3798))
(assert (or (= tn_3798 resn_3822) (and (= resn_3822 (+ 1 tn_3798)) (not (= resb_3823 1)))))
(assert (= n resn_3822))
(assert (<= 0 n))
(assert (= m_3858 m2_3782))
(assert (= n_3859 n2_3783))
(assert (= (+ 2 n_3859) n))
(assert (= an n_3951))
(assert (= dn n_3859))
(assert (= dm m_3858))
(assert (<= b_3971 2))
(assert (<= 0 b_3971))
(assert (<= 0 n_3970))
(assert (<= Anon_3947 2))
(assert (<= 0 Anon_3947))
(assert (<= 0 n2_3946))
(assert (= b_3971 Anon_3947))
(assert (= n_3970 n2_3946))
(assert (<= 0 n1_3942))
(assert (<= 0 m1_3941))
(assert (= n_3951 n1_3942))
(assert (<= 0 m))
(assert (<= 0 flted_43_3821))
(assert (= m flted_43_3821))
(assert (<= n_3951 n_3970))
(assert (= n_4045 n_3970))
(assert (<= n1_4049 (+ n2_4053 1)))
(assert (<= n2_4053 (+ 1 n1_4049)))
(assert (= (+ b_3971 n2_4053) (+ 1 n1_4049)))
(assert (exists ((max_5086 Int)) (and (= n_3970 (+ 1 max_5086)) (or (and (= max_5086 n1_4049) (>= n1_4049 n2_4053)) (and (= max_5086 n2_4053) (< n1_4049 n2_4053))))))
(assert (= bn n1_4049))
(assert (= cn n2_4053))
(assert (= height_79_4748 h_4451))
(assert (<= b_4612 2))
(assert (<= 0 b_4612))
(assert (<= 0 m_4610))
(assert (<= bb2_4450 2))
(assert (<= 0 bb2_4450))
(assert (<= 0 h2_4455))
(assert (<= 0 flted_98_4444))
(assert (= b_4612 bb2_4450))
(assert (= m_4610 flted_98_4444))
(assert (<= bb1_4448 2))
(assert (<= 0 bb1_4448))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (<= 0 dn))
(assert (<= 0 dm))
(assert (or (and (= t2_4456 cn) (>= cn dn)) (and (= t2_4456 dn) (< cn dn))))
(assert (or (and (= t1_4454 an) (>= an bn)) (and (= t1_4454 bn) (< an bn))))
(assert (= flted_98_4444 (+ (+ 1 cm) dm)))
(assert (<= 0 m_3950))
(assert (<= 0 m1_4048))
(assert (<= 0 m2_4052))
(assert (= cm m2_4052))
(assert (= m (+ (+ m2_3945 1) m1_3941)))
(assert (= m_3950 m1_3941))
(assert (= q_5064 ss2_4449))
(assert (or (and (and (and (< ss2_4449 1) (= m_4610 0)) (= n_4611 0)) (= b_4612 1)) (and (and (and (and (and (<= 0 b_4612) (<= (+ (- 0 n_4611) 2) b_4612)) (<= b_4612 n_4611)) (<= b_4612 2)) (<= 1 m_4610)) (> ss2_4449 0))))
(assert (= am m_3950))
(assert (<= 0 m_3969))
(assert (<= 0 m2_3945))
(assert (= m_3969 m2_3945))
(assert (= m_3969 (+ (+ m2_4052 1) m1_4048)))
(assert (= bm m1_4048))
(assert (= flted_97_4445 (+ (+ 1 am) bm)))
(assert (= h_4451 (+ t_4452 1)))
(assert (or (and (= t_4452 h1_4453) (>= h1_4453 h2_4455)) (and (= t_4452 h2_4455) (< h1_4453 h2_4455))))
(assert (= h1_4453 (+ t1_4454 1)))
(assert (= h2_4455 (+ t2_4456 1)))
(assert (= b_4501 bb1_4448))
(assert (<= 0 flted_97_4445))
(assert (<= 0 h1_4453))
(assert (<= 0 b_4501))
(assert (<= b_4501 2))
(assert (= n_4611 h2_4455))
(assert (<= 0 n_4611))
(assert (= v_int_79_5055 (+ 1 n_4500)))
(assert (<= n_4611 n_4500))
(assert (<= 0 n_4500))
(assert (<= 0 m_4499))
(assert (= n_4500 h1_4453))
(assert (= m_4499 flted_97_4445))
(assert (= p_5060 ss1_4447))
(assert (or (and (and (and (< ss1_4447 1) (= m_4499 0)) (= n_4500 0)) (= b_4501 1)) (and (and (and (and (and (<= 0 b_4501) (<= (+ (- 0 n_4500) 2) b_4501)) (<= b_4501 n_4500)) (<= b_4501 2)) (<= 1 m_4499)) (> ss1_4447 0))))
;Negation of Consequence
(assert (not (or (= m_4499 0) (or (= n_4500 0) (< ss1_4447 1)))))
(check-sat)