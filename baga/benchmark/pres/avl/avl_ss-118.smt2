(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height2_4070 () Int)
(declare-fun size2_4069 () Int)
(declare-fun height1_4067 () Int)
(declare-fun size1_4066 () Int)
(declare-fun q_4068 () Int)
(declare-fun p_4065 () Int)
(declare-fun Anon_4064 () Int)
(declare-fun height2_4047 () Int)
(declare-fun size2_4046 () Int)
(declare-fun height1_4044 () Int)
(declare-fun size1_4043 () Int)
(declare-fun q_4045 () Int)
(declare-fun p_4042 () Int)
(declare-fun Anon_4041 () Int)
(declare-fun v3_primed () Int)
(declare-fun v3 () Int)
(declare-fun v2_primed () Int)
(declare-fun v2 () Int)
(declare-fun v1_primed () Int)
(declare-fun v1 () Int)
(declare-fun d_primed () Int)
(declare-fun d () Int)
(declare-fun c_primed () Int)
(declare-fun c () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun h_4029 () Int)
(declare-fun h_4009 () Int)
(declare-fun cm () Int)
(declare-fun cn () Int)
(declare-fun dm () Int)
(declare-fun an_3988 () Int)
(declare-fun h_primed () Int)
(declare-fun h_4035 () Int)
(declare-fun m_3992 () Int)
(declare-fun n_3993 () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun v_int_95_3376_primed () Int)
(declare-fun m_4018 () Int)
(declare-fun n_4019 () Int)
(declare-fun m_4011 () Int)
(declare-fun n_4012 () Int)
(declare-fun res () Int)
(declare-fun m_4060 () Int)
(declare-fun n_4061 () Int)
(declare-fun n_4038 () Int)
(declare-fun m_4037 () Int)
(declare-fun tmp1_primed () Int)
(declare-fun n_4092 () Int)
(declare-fun m_4091 () Int)
(declare-fun tmp2_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m_4060 (+ (+ size2_4069 1) size1_4066)))
(assert (exists ((max_33 Int)) (and (= n_4061 (+ 1 max_33)) (or (and (= max_33 height1_4067) (>= height1_4067 height2_4070)) (and (= max_33 height2_4070) (< height1_4067 height2_4070))))))
(assert (= h_primed n_4061))
(assert (or (and (= h_primed (+ height1_4067 1)) (<= height2_4070 height1_4067)) (and (= h_primed (+ height2_4070 1)) (< height1_4067 height2_4070))))
(assert (<= height2_4070 (+ 1 height1_4067)))
(assert (<= height1_4067 (+ 1 height2_4070)))
(assert (= height2_4070 n_4019))
(assert (= size2_4069 m_4018))
(assert (= height1_4067 n_4012))
(assert (= size1_4066 m_4011))
(assert (= q_4068 d_primed))
(assert (= p_4065 c_primed))
(assert (= Anon_4064 v3_primed))
(assert (= m_4037 (+ (+ size2_4046 1) size1_4043)))
(assert (exists ((max_33 Int)) (and (= n_4038 (+ 1 max_33)) (or (and (= max_33 height1_4044) (>= height1_4044 height2_4047)) (and (= max_33 height2_4047) (< height1_4044 height2_4047))))))
(assert (= h_4029 n_4038))
(assert (or (and (= h_4029 (+ height1_4044 1)) (<= height2_4047 height1_4044)) (and (= h_4029 (+ height2_4047 1)) (< height1_4044 height2_4047))))
(assert (<= height2_4047 (+ 1 height1_4044)))
(assert (<= height1_4044 (+ 1 height2_4047)))
(assert (= height2_4047 n_3993))
(assert (= size2_4046 m_3992))
(assert (= height1_4044 n))
(assert (= size1_4043 m))
(assert (= q_4045 b_primed))
(assert (= p_4042 a_primed))
(assert (= Anon_4041 v1_primed))
(assert (= an_3988 an))
(assert (<= bn (+ 1 cn)))
(assert (<= (+ 0 cn) (+ bn 1)))
(assert (or (and (= an bn) (>= bn cn)) (and (= an cn) (< bn cn))))
(assert (= v3_primed v3))
(assert (= v2_primed v2))
(assert (= v1_primed v1))
(assert (= d_primed d))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= m am))
(assert (= n an))
(assert (<= 0 am))
(assert (<= 0 an))
(assert (= m_3992 bm))
(assert (= n_3993 bn))
(assert (<= 0 bm))
(assert (<= 0 bn))
(assert (or (and (= h_4009 n) (>= n n_3993)) (and (= h_4009 n_3993) (< n n_3993))))
(assert (= h_4029 (+ 1 h_4009)))
(assert (= m_4011 cm))
(assert (= n_4012 cn))
(assert (<= 0 cm))
(assert (<= 0 cn))
(assert (= m_4018 dm))
(assert (= n_4019 an_3988))
(assert (<= 0 dm))
(assert (<= 0 an_3988))
(assert (or (and (= h_4035 n_4012) (>= n_4012 n_4019)) (and (= h_4035 n_4019) (< n_4012 n_4019))))
(assert (= h_primed (+ 1 h_4035)))
(assert (<= 0 m_3992))
(assert (<= 0 n_3993))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (> tmp1_primed 0))
(assert (= v_int_95_3376_primed n_4038))
(assert (<= 0 m_4037))
(assert (<= 0 n_4038))
(assert (<= 0 m_4018))
(assert (<= 0 n_4019))
(assert (<= 0 m_4011))
(assert (<= 0 n_4012))
(assert (> tmp2_primed 0))
(assert (= res n_4061))
(assert (= m_4091 m_4060))
(assert (= n_4092 n_4061))
(assert (<= 0 m_4060))
(assert (<= 0 n_4061))
(assert (or (and (and (< tmp1_primed 1) (= m_4037 0)) (= n_4038 0)) (and (and (<= 1 n_4038) (<= 1 m_4037)) (> tmp1_primed 0))))
(assert (or (and (and (< tmp2_primed 1) (= m_4091 0)) (= n_4092 0)) (and (and (<= 1 n_4092) (<= 1 m_4091)) (> tmp2_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)