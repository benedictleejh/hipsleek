(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_22 () Int)
(declare-fun Anon_19 () Int)
(declare-fun n_3750 () Int)
(declare-fun Anon_25 () Int)
(declare-fun b_3814 () Int)
(declare-fun n_3913 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n1_3754 () Int)
(declare-fun tn_3773 () Int)
(declare-fun resb_3798 () Int)
(declare-fun resn_3797 () Int)
(declare-fun n2_3758 () Int)
(declare-fun n () Int)
(declare-fun n_3834 () Int)
(declare-fun Anon_3922 () Int)
(declare-fun n2_3921 () Int)
(declare-fun n1_3917 () Int)
(declare-fun m_3925 () Int)
(declare-fun flted_74_3796 () Int)
(declare-fun tm_3772 () Int)
(declare-fun n_3926 () Int)
(declare-fun n_4020 () Int)
(declare-fun b_3946 () Int)
(declare-fun n_3945 () Int)
(declare-fun n1_4024 () Int)
(declare-fun n2_4028 () Int)
(declare-fun height_118_4735 () Int)
(declare-fun Anon_4432 () Int)
(declare-fun cn () Int)
(declare-fun dn () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun flted_137_4429 () Int)
(declare-fun am () Int)
(declare-fun bm () Int)
(declare-fun m () Int)
(declare-fun m1_3916 () Int)
(declare-fun tm () Int)
(declare-fun m1_3753 () Int)
(declare-fun m2_3757 () Int)
(declare-fun p_5143 () Int)
(declare-fun m1_5144 () Int)
(declare-fun Anon_5146 () Int)
(declare-fun b_4488 () Int)
(declare-fun m_4486 () Int)
(declare-fun ss1_4431 () Int)
(declare-fun n1_5145 () Int)
(declare-fun m_3833 () Int)
(declare-fun m2_3920 () Int)
(declare-fun m_3944 () Int)
(declare-fun m1_4023 () Int)
(declare-fun m2_4027 () Int)
(declare-fun cm () Int)
(declare-fun dm () Int)
(declare-fun h_4435 () Int)
(declare-fun t_4436 () Int)
(declare-fun t1_4438 () Int)
(declare-fun t2_4440 () Int)
(declare-fun h1_4437 () Int)
(declare-fun Anon_4434 () Int)
(declare-fun v_int_118_5138 () Int)
(declare-fun n_4487 () Int)
(declare-fun h2_4439 () Int)
(declare-fun flted_138_4428 () Int)
(declare-fun q_5147 () Int)
(declare-fun b_4599 () Int)
(declare-fun m_4597 () Int)
(declare-fun n_4598 () Int)
(declare-fun ss2_4433 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_22 n_3913))
(assert (= Anon_19 n_3750))
(assert (<= 0 n2_3758))
(assert (<= b_3814 2))
(assert (<= 0 b_3814))
(assert (<= resb_3798 2))
(assert (<= 0 resb_3798))
(assert (<= 0 resn_3797))
(assert (= b_3814 resb_3798))
(assert (<= 0 tn_3773))
(assert (<= 0 n1_3754))
(assert (= n_3750 tn))
(assert (<= 0 n_3834))
(assert (<= 0 n_3926))
(assert (<= 0 m_3925))
(assert (<= 0 n1_4024))
(assert (<= 0 n2_4028))
(assert (= Anon_25 n_4020))
(assert (exists ((max_5171 Int)) (and (= n (+ max_5171 1)) (or (and (= max_5171 n1_3917) (>= n1_3917 n2_3921)) (and (= max_5171 n2_3921) (< n1_3917 n2_3921))))))
(assert (<= (+ 0 n2_3921) (+ n1_3917 1)))
(assert (<= n1_3917 (+ 1 n2_3921)))
(assert (= (+ b_3814 n2_3921) (+ 1 n1_3917)))
(assert (= n_3913 n))
(assert (exists ((max_5170 Int)) (and (= tn (+ max_5170 1)) (or (and (= max_5170 n1_3754) (>= n1_3754 n2_3758)) (and (= max_5170 n2_3758) (< n1_3754 n2_3758))))))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (= tn_3773 n1_3754))
(assert (< 0 tn_3773))
(assert (or (= tn_3773 resn_3797) (and (= resn_3797 (+ 1 tn_3773)) (not (= resb_3798 1)))))
(assert (= n resn_3797))
(assert (<= 0 n))
(assert (= n_3834 n2_3758))
(assert (= (+ 2 n_3834) n))
(assert (= an n_3926))
(assert (= am m_3925))
(assert (= dn n_3834))
(assert (<= b_3946 2))
(assert (<= 0 b_3946))
(assert (<= 0 n_3945))
(assert (<= Anon_3922 2))
(assert (<= 0 Anon_3922))
(assert (<= 0 n2_3921))
(assert (= b_3946 Anon_3922))
(assert (= n_3945 n2_3921))
(assert (<= 0 n1_3917))
(assert (<= 0 m1_3916))
(assert (= n_3926 n1_3917))
(assert (= m_3925 m1_3916))
(assert (<= 0 m2_3757))
(assert (<= 0 m))
(assert (<= 0 flted_74_3796))
(assert (= m flted_74_3796))
(assert (<= 0 tm_3772))
(assert (< 0 tm_3772))
(assert (= flted_74_3796 (+ 1 tm_3772)))
(assert (<= 0 m1_3753))
(assert (= tm_3772 m1_3753))
(assert (<= n_3926 n_3945))
(assert (= n_4020 n_3945))
(assert (= (+ b_3946 n2_4028) (+ 1 n1_4024)))
(assert (<= n1_4024 (+ 1 n2_4028)))
(assert (<= (+ 0 n2_4028) (+ n1_4024 1)))
(assert (exists ((max_5172 Int)) (and (= n_3945 (+ max_5172 1)) (or (and (= max_5172 n1_4024) (>= n1_4024 n2_4028)) (and (= max_5172 n2_4028) (< n1_4024 n2_4028))))))
(assert (= bn n1_4024))
(assert (= cn n2_4028))
(assert (= height_118_4735 h_4435))
(assert (<= Anon_4434 2))
(assert (<= 0 Anon_4434))
(assert (<= b_4488 2))
(assert (<= 0 b_4488))
(assert (<= 0 m_4486))
(assert (<= Anon_4432 2))
(assert (<= 0 Anon_4432))
(assert (<= 0 h1_4437))
(assert (<= 0 flted_137_4429))
(assert (= b_4488 Anon_4432))
(assert (= m_4486 flted_137_4429))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (<= 0 dn))
(assert (<= 0 dm))
(assert (or (and (= t2_4440 cn) (>= cn dn)) (and (= t2_4440 dn) (< cn dn))))
(assert (or (and (= t1_4438 an) (>= an bn)) (and (= t1_4438 bn) (< an bn))))
(assert (= flted_137_4429 (+ (+ 1 am) bm)))
(assert (<= 0 m_3833))
(assert (<= 0 m1_4023))
(assert (<= 0 m2_4027))
(assert (= bm m1_4023))
(assert (= m (+ (+ m2_3920 1) m1_3916)))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (= m_3833 m2_3757))
(assert (= p_5143 ss1_4431))
(assert (= m1_5144 m_4486))
(assert (= Anon_5146 b_4488))
(assert (or (and (and (and (< ss1_4431 1) (= m_4486 0)) (= n_4487 0)) (= b_4488 1)) (and (and (and (and (and (<= 0 b_4488) (<= (+ (- 0 n_4487) 2) b_4488)) (<= b_4488 n_4487)) (<= b_4488 2)) (<= 1 m_4486)) (> ss1_4431 0))))
(assert (= n1_5145 n_4487))
(assert (= dm m_3833))
(assert (<= 0 m_3944))
(assert (<= 0 m2_3920))
(assert (= m_3944 m2_3920))
(assert (= m_3944 (+ (+ m2_4027 1) m1_4023)))
(assert (= cm m2_4027))
(assert (= flted_138_4428 (+ (+ 1 cm) dm)))
(assert (= h_4435 (+ t_4436 1)))
(assert (or (and (= t_4436 h1_4437) (>= h1_4437 h2_4439)) (and (= t_4436 h2_4439) (< h1_4437 h2_4439))))
(assert (= h1_4437 (+ t1_4438 1)))
(assert (= h2_4439 (+ t2_4440 1)))
(assert (= n_4487 h1_4437))
(assert (<= 0 n_4487))
(assert (= b_4599 Anon_4434))
(assert (<= 0 flted_138_4428))
(assert (<= 0 h2_4439))
(assert (<= 0 b_4599))
(assert (<= b_4599 2))
(assert (= v_int_118_5138 (+ 1 n_4487)))
(assert (<= n_4598 n_4487))
(assert (<= 0 n_4598))
(assert (<= 0 m_4597))
(assert (= n_4598 h2_4439))
(assert (= m_4597 flted_138_4428))
(assert (= q_5147 ss2_4433))
(assert (or (and (and (and (< ss2_4433 1) (= m_4597 0)) (= n_4598 0)) (= b_4599 1)) (and (and (and (and (and (<= 0 b_4599) (<= (+ (- 0 n_4598) 2) b_4599)) (<= b_4599 n_4598)) (<= b_4599 2)) (<= 1 m_4597)) (> ss2_4433 0))))
;Negation of Consequence
(assert (not (or (= m_4597 0) (or (= n_4598 0) (< ss2_4433 1)))))
(check-sat)