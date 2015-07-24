(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m1_5155 () Int)
(declare-fun m2_5159 () Int)
(declare-fun m_4499 () Int)
(declare-fun m_4610 () Int)
(declare-fun flted_98_4444 () Int)
(declare-fun flted_97_4445 () Int)
(declare-fun cm () Int)
(declare-fun bm () Int)
(declare-fun m2_4052 () Int)
(declare-fun m1_4048 () Int)
(declare-fun m_3969 () Int)
(declare-fun am () Int)
(declare-fun m_3950 () Int)
(declare-fun m2_3945 () Int)
(declare-fun m1_3941 () Int)
(declare-fun dm () Int)
(declare-fun m () Int)
(declare-fun flted_43_3821 () Int)
(declare-fun tm_3797 () Int)
(declare-fun m_3858 () Int)
(declare-fun m2_3782 () Int)
(declare-fun m1_3778 () Int)
(declare-fun tm () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 cm))
(assert (<= 0 bm))
(assert (<= 0 am))
(assert (<= 0 m_3950))
(assert (<= 0 m1_4048))
(assert (<= 0 m2_4052))
(assert (<= 0 m_3969))
(assert (<= 0 m_4610))
(assert (<= 0 m_4499))
(assert (= m1_5155 m_4499))
(assert (= m2_5159 m_4610))
(assert (= m_4499 flted_97_4445))
(assert (<= 0 flted_97_4445))
(assert (= m_4610 flted_98_4444))
(assert (<= 0 flted_98_4444))
(assert (= flted_98_4444 (+ (+ 1 cm) dm)))
(assert (= flted_97_4445 (+ (+ 1 am) bm)))
(assert (= cm m2_4052))
(assert (= bm m1_4048))
(assert (= m_3969 (+ (+ m2_4052 1) m1_4048)))
(assert (= m_3969 m2_3945))
(assert (<= 0 m2_3945))
(assert (= am m_3950))
(assert (= m_3950 m1_3941))
(assert (<= 0 m1_3941))
(assert (<= 0 dm))
(assert (= m (+ (+ m2_3945 1) m1_3941)))
(assert (= dm m_3858))
(assert (<= 0 m))
(assert (<= 0 flted_43_3821))
(assert (= m flted_43_3821))
(assert (<= 0 tm_3797))
(assert (< 0 tm_3797))
(assert (= flted_43_3821 (+ 1 tm_3797)))
(assert (<= 0 m_3858))
(assert (= tm_3797 m1_3778))
(assert (<= 0 m1_3778))
(assert (= m_3858 m2_3782))
(assert (<= 0 m2_3782))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (= tm 0))
;Negation of Consequence
(assert (not false))
(check-sat)