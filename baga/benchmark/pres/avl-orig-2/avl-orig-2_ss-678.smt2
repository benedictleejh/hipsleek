(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun tm () Int)
(declare-fun m1_3753 () Int)
(declare-fun tm_3772 () Int)
(declare-fun m2_3757 () Int)
(declare-fun height_118_4734 () Int)
(declare-fun m_3833 () Int)
(declare-fun m_3944 () Int)
(declare-fun flted_74_3796 () Int)
(declare-fun bm () Int)
(declare-fun cm () Int)
(declare-fun m2_4955 () Int)
(declare-fun Anon_4953 () Int)
(declare-fun m1_4951 () Int)
(declare-fun q_4954 () Int)
(declare-fun p_4950 () Int)
(declare-fun m2_4608 () Int)
(declare-fun m1_4604 () Int)
(declare-fun m () Int)
(declare-fun m2_3920 () Int)
(declare-fun m1_3916 () Int)
(declare-fun m_3925 () Int)
(declare-fun resn_4424 () Int)
(declare-fun am () Int)
(declare-fun Anon_4416 () Int)
(declare-fun b_4488 () Int)
(declare-fun m_4486 () Int)
(declare-fun resl_4415 () Int)
(declare-fun m_4597 () Int)
(declare-fun resr_4417 () Int)
(declare-fun tmp2_4425 () Int)
(declare-fun an () Int)
(declare-fun Anon_48 () Int)
(declare-fun n_4487 () Int)
(declare-fun v_int_118_4945 () Int)
(declare-fun n1_4952 () Int)
(declare-fun Anon_4957 () Int)
(declare-fun n2_4956 () Int)
(declare-fun b_4599 () Int)
(declare-fun n_4598 () Int)
(declare-fun n2_4609 () Int)
(declare-fun n1_4605 () Int)
(declare-fun n_3926 () Int)
(declare-fun n1_3917 () Int)
(declare-fun n_3913 () Int)
(declare-fun n2_3921 () Int)
(declare-fun n_3945 () Int)
(declare-fun resrn_4426 () Int)
(declare-fun tmp1_4423 () Int)
(declare-fun bn () Int)
(declare-fun cn () Int)
(declare-fun Anon_45 () Int)
(declare-fun n_3834 () Int)
(declare-fun b_3814 () Int)
(declare-fun n () Int)
(declare-fun resn_3797 () Int)
(declare-fun resb_3798 () Int)
(declare-fun tn_3773 () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
(declare-fun n2_3758 () Int)
(declare-fun n1_3754 () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 m2_3757))
(assert (<= 0 tm_3772))
(assert (< 0 tm_3772))
(assert (<= 0 m1_3753))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (= tm_3772 m1_3753))
(assert (= flted_74_3796 (+ 1 tm_3772)))
(assert (= m_3833 m2_3757))
(assert (= height_118_4734 resn_4424))
(assert (<= 0 bm))
(assert (<= 0 cm))
(assert (<= Anon_4416 2))
(assert (<= 0 Anon_4416))
(assert (<= 0 am))
(assert (<= 0 m_3833))
(assert (<= 0 m_3925))
(assert (<= 0 m_3944))
(assert (= bm m_3944))
(assert (= cm m_3833))
(assert (<= 0 m2_3920))
(assert (= m_3944 m2_3920))
(assert (<= 0 m1_3916))
(assert (<= 0 m))
(assert (<= 0 flted_74_3796))
(assert (= m flted_74_3796))
(assert (= m1_4604 bm))
(assert (= m2_4608 cm))
(assert (= m2_4955 m_4597))
(assert (= Anon_4953 b_4488))
(assert (= m1_4951 m_4486))
(assert (= q_4954 resr_4417))
(assert (= p_4950 resl_4415))
(assert (= m_4597 (+ (+ m2_4608 1) m1_4604)))
(assert (= m (+ (+ m2_3920 1) m1_3916)))
(assert (= m_3925 m1_3916))
(assert (= am m_3925))
(assert (= resn_4424 (+ 1 tmp2_4425)))
(assert (= m_4486 am))
(assert (= b_4488 Anon_4416))
(assert (<= 0 m_4486))
(assert (<= 0 b_4488))
(assert (<= b_4488 2))
(assert (> resr_4417 0))
(assert (<= 0 m_4597))
(assert (or (and (and (and (< resl_4415 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> resl_4415 0))))
(assert (or (and (and (and (< resr_4417 1) (= m_4597 0)) (= n_4598 0)) (= b_4599 1)) (and (and (and (and (and (<= 0 b_4599) (<= (+ (- 0 n_4598) 2) b_4599)) (<= b_4599 n_4598)) (<= b_4599 2)) (<= 1 m_4597)) (> resr_4417 0))))
(assert (= v_int_118_4945 (+ 1 n_4487)))
(assert (<= n_4598 n_4487))
(assert (<= b_4599 2))
(assert (<= 0 b_4599))
(assert (<= 0 n_4598))
(assert (<= 0 n_4487))
(assert (<= 0 an))
(assert (= n_4487 an))
(assert (or (and (= tmp2_4425 an) (>= an resrn_4426)) (and (= tmp2_4425 resrn_4426) (< an resrn_4426))))
(assert (<= 0 n_3926))
(assert (<= 0 n_3945))
(assert (= an n_3926))
(assert (= Anon_48 n_3913))
(assert (<= 0 n2_3921))
(assert (<= 0 n1_3917))
(assert (= n_3926 n1_3917))
(assert (= n1_4952 n_4487))
(assert (exists ((flted_76_5038 Int)) (= (+ flted_76_5038 n2_4956) (+ 1 n1_4952))))
(assert (exists ((max_5037 Int)) (and (= v_int_118_4945 (+ max_5037 1)) (or (and (= max_5037 n1_4952) (>= n1_4952 n2_4956)) (and (= max_5037 n2_4956) (< n1_4952 n2_4956))))))
(assert (= Anon_4957 b_4599))
(assert (= n2_4956 n_4598))
(assert (exists ((max_5036 Int)) (and (= n_4598 (+ max_5036 1)) (or (and (= max_5036 n1_4605) (>= n1_4605 n2_4609)) (and (= max_5036 n2_4609) (< n1_4605 n2_4609))))))
(assert (= (+ b_4599 n2_4609) (+ 1 n1_4605)))
(assert (= resrn_4426 n_4598))
(assert (or (and (= resrn_4426 (+ n1_4605 1)) (<= n2_4609 n1_4605)) (and (= resrn_4426 (+ n2_4609 1)) (< n1_4605 n2_4609))))
(assert (<= (+ 0 n2_4609) (+ n1_4605 1)))
(assert (<= n1_4605 (+ 1 n2_4609)))
(assert (= n2_4609 cn))
(assert (= n1_4605 bn))
(assert (< n_3945 n_3926))
(assert (exists ((max_5035 Int)) (and (= n (+ max_5035 1)) (or (and (= max_5035 n1_3917) (>= n1_3917 n2_3921)) (and (= max_5035 n2_3921) (< n1_3917 n2_3921))))))
(assert (<= (+ 0 n2_3921) (+ n1_3917 1)))
(assert (<= n1_3917 (+ 1 n2_3921)))
(assert (= (+ b_3814 n2_3921) (+ 1 n1_3917)))
(assert (= n_3913 n))
(assert (= n_3945 n2_3921))
(assert (= bn n_3945))
(assert (= resrn_4426 (+ 1 tmp1_4423)))
(assert (<= 0 bn))
(assert (<= 0 cn))
(assert (or (and (= tmp1_4423 cn) (>= cn bn)) (and (= tmp1_4423 bn) (< cn bn))))
(assert (<= 0 n_3834))
(assert (= cn n_3834))
(assert (= Anon_45 n_3750))
(assert (= (+ 2 n_3834) n))
(assert (<= 0 n2_3758))
(assert (= n_3834 n2_3758))
(assert (<= b_3814 2))
(assert (<= 0 b_3814))
(assert (<= 0 n))
(assert (<= resb_3798 2))
(assert (<= 0 resb_3798))
(assert (<= 0 resn_3797))
(assert (= b_3814 resb_3798))
(assert (= n resn_3797))
(assert (<= 0 tn_3773))
(assert (or (= tn_3773 resn_3797) (and (= resn_3797 (+ 1 tn_3773)) (not (= resb_3798 1)))))
(assert (< 0 tn_3773))
(assert (<= 0 n1_3754))
(assert (= tn_3773 n1_3754))
(assert (= n_3750 tn))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (exists ((max_5034 Int)) (and (= tn (+ max_5034 1)) (or (and (= max_5034 n1_3754) (>= n1_3754 n2_3758)) (and (= max_5034 n2_3758) (< n1_3754 n2_3758))))))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
;Negation of Consequence
(assert (not (<= b 2)))
(check-sat)