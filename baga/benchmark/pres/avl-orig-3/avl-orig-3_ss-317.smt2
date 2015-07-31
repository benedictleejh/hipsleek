(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status sat)
;Variables declarations
(declare-fun m1_3941 () Int)
(declare-fun Anon_3943 () Int)
(declare-fun m2_3945 () Int)
(declare-fun Anon_3947 () Int)
(declare-fun b_3971 () Int)
(declare-fun m_3969 () Int)
(declare-fun q_3944 () Int)
(declare-fun b_3952 () Int)
(declare-fun m_3950 () Int)
(declare-fun p_3940 () Int)
(declare-fun Anon_41 () Int)
(declare-fun n_3970 () Int)
(declare-fun n_3951 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun m () Int)
(declare-fun resn_3822 () Int)
(declare-fun resb_3823 () Int)
(declare-fun flted_43_3821 () Int)
(declare-fun tn_3798 () Int)
(declare-fun tm_3797 () Int)
(declare-fun n_3775 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n1_3779 () Int)
(declare-fun tm () Int)
(declare-fun m1_3778 () Int)
(declare-fun n_3938 () Int)
(declare-fun b_3839 () Int)
(declare-fun n1_3942 () Int)
(declare-fun n2_3946 () Int)
(declare-fun m2_3782 () Int)
(declare-fun n2_3783 () Int)
(declare-fun n () Int)
(declare-fun r () Int)
(declare-fun b_3860 () Int)
(declare-fun m_3858 () Int)
(declare-fun n_3859 () Int)
(declare-fun q_3781 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= Anon_3947 2))
(assert (<= 0 Anon_3947))
(assert (<= 0 m2_3945))
(assert (<= Anon_3943 2))
(assert (<= 0 Anon_3943))
(assert (<= 0 m1_3941))
(assert (< n_3970 n_3951))
(assert (= m (+ (+ m2_3945 1) m1_3941)))
(assert (= m_3950 m1_3941))
(assert (= b_3952 Anon_3943))
(assert (<= 0 m_3950))
(assert (<= 0 b_3952))
(assert (<= b_3952 2))
(assert (= m_3969 m2_3945))
(assert (= b_3971 Anon_3947))
(assert (<= 0 m_3969))
(assert (<= 0 b_3971))
(assert (<= b_3971 2))
(assert (or (and (and (and (< q_3944 1) (= m_3969 0)) (= n_3970 0)) (= b_3971 1)) (and (and (and (and (and (<= 0 b_3971) (<= (+ (- 0 n_3970) 2) b_3971)) (<= b_3971 n_3970)) (<= b_3971 2)) (<= 1 m_3969)) (> q_3944 0))))
(assert (or (and (and (and (< p_3940 1) (= m_3950 0)) (= n_3951 0)) (= b_3952 1)) (and (and (and (and (and (<= 0 b_3952) (<= (+ (- 0 n_3951) 2) b_3952)) (<= b_3952 n_3951)) (<= b_3952 2)) (<= 1 m_3950)) (> p_3940 0))))
(assert (= Anon_41 n_3775))
(assert (<= 0 n_3970))
(assert (<= 0 n2_3946))
(assert (= n_3970 n2_3946))
(assert (<= 0 n_3951))
(assert (<= 0 n1_3942))
(assert (= n_3951 n1_3942))
(assert (<= b_3860 2))
(assert (<= 0 b_3860))
(assert (<= Anon_3784 2))
(assert (<= 0 Anon_3784))
(assert (<= 0 n2_3783))
(assert (<= 0 m2_3782))
(assert (= b_3860 Anon_3784))
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
(assert (<= 0 tn_3798))
(assert (<= 0 tm_3797))
(assert (or (= tn_3798 resn_3822) (and (= resn_3822 (+ 1 tn_3798)) (not (= resb_3823 1)))))
(assert (< 0 tn_3798))
(assert (< 0 tm_3797))
(assert (= flted_43_3821 (+ 1 tm_3797)))
(assert (<= 0 n1_3779))
(assert (<= 0 m1_3778))
(assert (= tn_3798 n1_3779))
(assert (= tm_3797 m1_3778))
(assert (= n_3775 tn))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (exists ((max_3988 Int)) (and (= tn (+ 1 max_3988)) (or (and (= max_3988 n1_3779) (>= n1_3779 n2_3783)) (and (= max_3988 n2_3783) (< n1_3779 n2_3783))))))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (= n_3938 n))
(assert (<= n1_3942 (+ n2_3946 1)))
(assert (<= n2_3946 (+ 1 n1_3942)))
(assert (= (+ b_3839 n2_3946) (+ 1 n1_3942)))
(assert (exists ((max_3989 Int)) (and (= n (+ 1 max_3989)) (or (and (= max_3989 n1_3942) (>= n1_3942 n2_3946)) (and (= max_3989 n2_3946) (< n1_3942 n2_3946))))))
(assert (= m_3858 m2_3782))
(assert (= n_3859 n2_3783))
(assert (<= 0 m_3858))
(assert (<= 0 n_3859))
(assert (= (+ 2 n_3859) n))
(assert (= r q_3781))
(assert (or (and (and (and (< q_3781 1) (= m_3858 0)) (= n_3859 0)) (= b_3860 1)) (and (and (and (and (and (<= 0 b_3860) (<= (+ (- 0 n_3859) 2) b_3860)) (<= b_3860 n_3859)) (<= b_3860 2)) (<= 1 m_3858)) (> q_3781 0))))
;Negation of Consequence
(assert (not (or (= m_3858 0) (or (= n_3859 0) (< q_3781 1)))))
(check-sat)