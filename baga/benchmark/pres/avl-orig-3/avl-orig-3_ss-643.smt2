(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_41 () Int)
(declare-fun n_3775 () Int)
(declare-fun tm () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun m1_3778 () Int)
(declare-fun n1_3779 () Int)
(declare-fun tm_3797 () Int)
(declare-fun tn_3798 () Int)
(declare-fun m2_3782 () Int)
(declare-fun n2_3783 () Int)
(declare-fun height_79_4747 () Int)
(declare-fun Anon_43 () Int)
(declare-fun m_3858 () Int)
(declare-fun m_3969 () Int)
(declare-fun n_3859 () Int)
(declare-fun resb_3823 () Int)
(declare-fun resn_3822 () Int)
(declare-fun flted_43_3821 () Int)
(declare-fun n_3938 () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun cm () Int)
(declare-fun cn () Int)
(declare-fun m2_4621 () Int)
(declare-fun m1_4617 () Int)
(declare-fun q_4871 () Int)
(declare-fun m_4610 () Int)
(declare-fun resr_4435 () Int)
(declare-fun b_4612 () Int)
(declare-fun n1_4618 () Int)
(declare-fun n2_4622 () Int)
(declare-fun n_3970 () Int)
(declare-fun m () Int)
(declare-fun m2_3945 () Int)
(declare-fun n () Int)
(declare-fun b_3839 () Int)
(declare-fun n2_3946 () Int)
(declare-fun m1_3941 () Int)
(declare-fun n1_3942 () Int)
(declare-fun Anon_3943 () Int)
(declare-fun m_3950 () Int)
(declare-fun n_3951 () Int)
(declare-fun b_3952 () Int)
(declare-fun tmp1_4439 () Int)
(declare-fun resn_4440 () Int)
(declare-fun tmp2_4441 () Int)
(declare-fun resrn_4442 () Int)
(declare-fun ba1 () Int)
(declare-fun v_int_79_4862 () Int)
(declare-fun n_4611 () Int)
(declare-fun an () Int)
(declare-fun am () Int)
(declare-fun p_4867 () Int)
(declare-fun b_4501 () Int)
(declare-fun m_4499 () Int)
(declare-fun n_4500 () Int)
(declare-fun resl_4434 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_41 n_3775))
(assert (<= 0 n2_3783))
(assert (<= 0 m2_3782))
(assert (<= 0 tn_3798))
(assert (<= 0 tm_3797))
(assert (< 0 tm_3797))
(assert (<= 0 n1_3779))
(assert (<= 0 m1_3778))
(assert (= n_3775 tn))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (exists ((max_4893 Int)) (and (= tn (+ 1 max_4893)) (or (and (= max_4893 n1_3779) (>= n1_3779 n2_3783)) (and (= max_4893 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tm_3797 m1_3778))
(assert (= tn_3798 n1_3779))
(assert (= flted_43_3821 (+ 1 tm_3797)))
(assert (< 0 tn_3798))
(assert (or (= tn_3798 resn_3822) (and (= resn_3822 (+ 1 tn_3798)) (not (= resb_3823 1)))))
(assert (= m_3858 m2_3782))
(assert (= n_3859 n2_3783))
(assert (= height_79_4747 resn_4440))
(assert (<= b_4612 2))
(assert (<= 0 b_4612))
(assert (<= 0 m_4610))
(assert (> resr_4435 0))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (<= ba1 2))
(assert (<= 0 ba1))
(assert (or (and (= tmp1_4439 cn) (>= cn bn)) (and (= tmp1_4439 bn) (< cn bn))))
(assert (<= 0 n_3859))
(assert (<= 0 m_3858))
(assert (<= b_3952 2))
(assert (<= 0 b_3952))
(assert (<= 0 n_3951))
(assert (<= 0 m_3950))
(assert (<= 0 n_3970))
(assert (<= 0 m_3969))
(assert (= bn n_3970))
(assert (= bm m_3969))
(assert (= Anon_43 n_3938))
(assert (= cn n_3859))
(assert (= cm m_3858))
(assert (<= 0 n2_3946))
(assert (<= 0 m2_3945))
(assert (= n_3970 n2_3946))
(assert (= m_3969 m2_3945))
(assert (<= Anon_3943 2))
(assert (<= 0 Anon_3943))
(assert (<= 0 n1_3942))
(assert (<= 0 m1_3941))
(assert (= (+ 2 n_3859) n))
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
(assert (= n_3938 n))
(assert (= m1_4617 bm))
(assert (= n1_4618 bn))
(assert (= m2_4621 cm))
(assert (= n2_4622 cn))
(assert (<= n1_4618 (+ n2_4622 1)))
(assert (<= n2_4622 (+ 1 n1_4618)))
(assert (= m_4610 (+ (+ m2_4621 1) m1_4617)))
(assert (= q_4871 resr_4435))
(assert (or (and (and (and (< resr_4435 1) (= m_4610 0)) (= n_4611 0)) (= b_4612 1)) (and (and (and (and (and (<= 0 b_4612) (<= (+ (- 0 n_4611) 2) b_4612)) (<= b_4612 n_4611)) (<= b_4612 2)) (<= 1 m_4610)) (> resr_4435 0))))
(assert (exists ((max_4891 Int)) (and (= n_4611 (+ 1 max_4891)) (or (and (= max_4891 n1_4618) (>= n1_4618 n2_4622)) (and (= max_4891 n2_4622) (< n1_4618 n2_4622))))))
(assert (= (+ b_4612 n2_4622) (+ 1 n1_4618)))
(assert (= resrn_4442 n_4611))
(assert (or (and (= resrn_4442 (+ n1_4618 1)) (<= n2_4622 n1_4618)) (and (= resrn_4442 (+ n2_4622 1)) (< n1_4618 n2_4622))))
(assert (< n_3970 n_3951))
(assert (= m (+ (+ m2_3945 1) m1_3941)))
(assert (exists ((max_4892 Int)) (and (= n (+ 1 max_4892)) (or (and (= max_4892 n1_3942) (>= n1_3942 n2_3946)) (and (= max_4892 n2_3946) (< n1_3942 n2_3946))))))
(assert (= (+ b_3839 n2_3946) (+ 1 n1_3942)))
(assert (<= n2_3946 (+ 1 n1_3942)))
(assert (<= n1_3942 (+ n2_3946 1)))
(assert (= m_3950 m1_3941))
(assert (= n_3951 n1_3942))
(assert (= b_3952 Anon_3943))
(assert (= am m_3950))
(assert (= an n_3951))
(assert (= ba1 b_3952))
(assert (= resrn_4442 (+ 1 tmp1_4439)))
(assert (= resn_4440 (+ 1 tmp2_4441)))
(assert (or (and (= tmp2_4441 an) (>= an resrn_4442)) (and (= tmp2_4441 resrn_4442) (< an resrn_4442))))
(assert (= b_4501 ba1))
(assert (<= 0 am))
(assert (<= 0 an))
(assert (<= 0 b_4501))
(assert (<= b_4501 2))
(assert (<= 0 n_4611))
(assert (= v_int_79_4862 (+ 1 n_4500)))
(assert (<= n_4611 n_4500))
(assert (<= 0 n_4500))
(assert (<= 0 m_4499))
(assert (= n_4500 an))
(assert (= m_4499 am))
(assert (= p_4867 resl_4434))
(assert (or (and (and (and (< resl_4434 1) (= m_4499 0)) (= n_4500 0)) (= b_4501 1)) (and (and (and (and (and (<= 0 b_4501) (<= (+ (- 0 n_4500) 2) b_4501)) (<= b_4501 n_4500)) (<= b_4501 2)) (<= 1 m_4499)) (> resl_4434 0))))
;Negation of Consequence
(assert (not (or (= m_4499 0) (or (= n_4500 0) (< resl_4434 1)))))
(check-sat)