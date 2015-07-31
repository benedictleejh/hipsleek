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
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n1_3779 () Int)
(declare-fun tn_3798 () Int)
(declare-fun resb_3823 () Int)
(declare-fun resn_3822 () Int)
(declare-fun n2_3783 () Int)
(declare-fun n () Int)
(declare-fun m1_3941 () Int)
(declare-fun m_3950 () Int)
(declare-fun n_3859 () Int)
(declare-fun Anon_3947 () Int)
(declare-fun n2_3946 () Int)
(declare-fun m2_3945 () Int)
(declare-fun n1_3942 () Int)
(declare-fun m () Int)
(declare-fun flted_43_3821 () Int)
(declare-fun tm_3797 () Int)
(declare-fun n_3951 () Int)
(declare-fun n_4045 () Int)
(declare-fun b_3971 () Int)
(declare-fun n_3970 () Int)
(declare-fun m_3969 () Int)
(declare-fun m1_4048 () Int)
(declare-fun n1_4049 () Int)
(declare-fun n2_4053 () Int)
(declare-fun am () Int)
(declare-fun bm () Int)
(declare-fun flted_97_4445 () Int)
(declare-fun bb1_4448 () Int)
(declare-fun b_4501 () Int)
(declare-fun m_4499 () Int)
(declare-fun ss1_4447 () Int)
(declare-fun v_int_79_2270_primed () Int)
(declare-fun n_4500 () Int)
(declare-fun cn () Int)
(declare-fun dn () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun t1_4454 () Int)
(declare-fun h_4451 () Int)
(declare-fun m2_4052 () Int)
(declare-fun tm () Int)
(declare-fun m1_3778 () Int)
(declare-fun m2_3782 () Int)
(declare-fun m_3858 () Int)
(declare-fun cm () Int)
(declare-fun dm () Int)
(declare-fun t_4452 () Int)
(declare-fun h1_4453 () Int)
(declare-fun t2_4456 () Int)
(declare-fun v_node_79_2265_primed () Int)
(declare-fun bb2_4450 () Int)
(declare-fun flted_98_4444 () Int)
(declare-fun h2_4455 () Int)
(declare-fun ss2_4449 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_22 n_3938))
(assert (= Anon_19 n_3775))
(assert (<= 0 m1_3941))
(assert (<= 0 n2_3783))
(assert (<= b_3839 2))
(assert (<= 0 b_3839))
(assert (<= resb_3823 2))
(assert (<= 0 resb_3823))
(assert (<= 0 resn_3822))
(assert (= b_3839 resb_3823))
(assert (<= 0 tn_3798))
(assert (<= 0 n1_3779))
(assert (= n_3775 tn))
(assert (<= bb1_4448 2))
(assert (<= 0 bb1_4448))
(assert (<= 0 flted_97_4445))
(assert (<= 0 bm))
(assert (<= 0 am))
(assert (<= 0 n_3859))
(assert (<= 0 n_3951))
(assert (<= 0 m_3950))
(assert (<= 0 n1_4049))
(assert (<= 0 m1_4048))
(assert (<= 0 n2_4053))
(assert (= Anon_25 n_4045))
(assert (= m (+ (+ m2_3945 1) m1_3941)))
(assert (exists ((max_4663 Int)) (and (= n (+ 1 max_4663)) (or (and (= max_4663 n1_3942) (>= n1_3942 n2_3946)) (and (= max_4663 n2_3946) (< n1_3942 n2_3946))))))
(assert (= (+ b_3839 n2_3946) (+ 1 n1_3942)))
(assert (<= n2_3946 (+ 1 n1_3942)))
(assert (<= n1_3942 (+ n2_3946 1)))
(assert (= n_3938 n))
(assert (exists ((max_4664 Int)) (and (= tn (+ 1 max_4664)) (or (and (= max_4664 n1_3779) (>= n1_3779 n2_3783)) (and (= max_4664 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tn_3798 n1_3779))
(assert (< 0 tn_3798))
(assert (or (= tn_3798 resn_3822) (and (= resn_3822 (+ 1 tn_3798)) (not (= resb_3823 1)))))
(assert (= n resn_3822))
(assert (<= 0 n))
(assert (= n_3859 n2_3783))
(assert (= (+ 2 n_3859) n))
(assert (= m_3950 m1_3941))
(assert (= an n_3951))
(assert (= am m_3950))
(assert (= dn n_3859))
(assert (<= b_3971 2))
(assert (<= 0 b_3971))
(assert (<= 0 n_3970))
(assert (<= 0 m_3969))
(assert (<= Anon_3947 2))
(assert (<= 0 Anon_3947))
(assert (<= 0 n2_3946))
(assert (<= 0 m2_3945))
(assert (= b_3971 Anon_3947))
(assert (= n_3970 n2_3946))
(assert (= m_3969 m2_3945))
(assert (<= 0 n1_3942))
(assert (= n_3951 n1_3942))
(assert (<= 0 m2_3782))
(assert (<= 0 m))
(assert (<= 0 flted_43_3821))
(assert (= m flted_43_3821))
(assert (<= 0 tm_3797))
(assert (< 0 tm_3797))
(assert (= flted_43_3821 (+ 1 tm_3797)))
(assert (<= 0 m1_3778))
(assert (= tm_3797 m1_3778))
(assert (<= n_3951 n_3970))
(assert (= n_4045 n_3970))
(assert (<= n1_4049 (+ n2_4053 1)))
(assert (<= n2_4053 (+ 1 n1_4049)))
(assert (= (+ b_3971 n2_4053) (+ 1 n1_4049)))
(assert (exists ((max_4662 Int)) (and (= n_3970 (+ 1 max_4662)) (or (and (= max_4662 n1_4049) (>= n1_4049 n2_4053)) (and (= max_4662 n2_4053) (< n1_4049 n2_4053))))))
(assert (= m_3969 (+ (+ m2_4052 1) m1_4048)))
(assert (= bm m1_4048))
(assert (= bn n1_4049))
(assert (= cn n2_4053))
(assert (= flted_97_4445 (+ (+ 1 am) bm)))
(assert (= m_4499 flted_97_4445))
(assert (= b_4501 bb1_4448))
(assert (<= 0 m_4499))
(assert (<= 0 b_4501))
(assert (<= b_4501 2))
(assert (or (and (and (and (< ss1_4447 1) (= m_4499 0)) (= n_4500 0)) (= b_4501 1)) (and (and (and (and (and (<= 0 b_4501) (<= (+ (- 0 n_4500) 2) b_4501)) (<= b_4501 n_4500)) (<= b_4501 2)) (<= 1 m_4499)) (> ss1_4447 0))))
(assert (<= 0 n_4500))
(assert (= v_int_79_2270_primed n_4500))
(assert (<= 0 h1_4453))
(assert (= n_4500 h1_4453))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (<= 0 bn))
(assert (<= 0 an))
(assert (<= 0 dn))
(assert (<= 0 dm))
(assert (or (and (= t2_4456 cn) (>= cn dn)) (and (= t2_4456 dn) (< cn dn))))
(assert (or (and (= t1_4454 an) (>= an bn)) (and (= t1_4454 bn) (< an bn))))
(assert (= h1_4453 (+ t1_4454 1)))
(assert (= h_4451 (+ t_4452 1)))
(assert (<= 0 m_3858))
(assert (<= 0 m2_4052))
(assert (= cm m2_4052))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (= m_3858 m2_3782))
(assert (= dm m_3858))
(assert (= flted_98_4444 (+ (+ 1 cm) dm)))
(assert (or (and (= t_4452 h1_4453) (>= h1_4453 h2_4455)) (and (= t_4452 h2_4455) (< h1_4453 h2_4455))))
(assert (= h2_4455 (+ t2_4456 1)))
(assert (= v_node_79_2265_primed ss2_4449))
(assert (or (and (and (and (< ss2_4449 1) (= flted_98_4444 0)) (= h2_4455 0)) (= bb2_4450 1)) (and (and (and (and (and (<= 0 bb2_4450) (<= (+ (- 0 h2_4455) 2) bb2_4450)) (<= bb2_4450 h2_4455)) (<= bb2_4450 2)) (<= 1 flted_98_4444)) (> ss2_4449 0))))
;Negation of Consequence
(assert (not (or (= flted_98_4444 0) (or (= h2_4455 0) (< ss2_4449 1)))))
(check-sat)