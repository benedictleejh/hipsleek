(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m2_4239 () Int)
(declare-fun m1_4235 () Int)
(declare-fun m_4244 () Int)
(declare-fun cm () Int)
(declare-fun m_4263 () Int)
(declare-fun m_4152 () Int)
(declare-fun m () Int)
(declare-fun flted_43_4115 () Int)
(declare-fun tm_4091 () Int)
(declare-fun am () Int)
(declare-fun bm () Int)
(declare-fun m2_4529 () Int)
(declare-fun m1_4525 () Int)
(declare-fun m_4610 () Int)
(declare-fun m_4499 () Int)
(declare-fun m2_3782 () Int)
(declare-fun m1_3778 () Int)
(declare-fun m1_5611 () Int)
(declare-fun m2_5615 () Int)
(declare-fun tm () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 m_4244))
(assert (<= 0 m1_4235))
(assert (<= 0 m2_4239))
(assert (= m (+ (+ m2_4239 1) m1_4235)))
(assert (= m_4244 m2_4239))
(assert (= m_4263 m1_4235))
(assert (= cm m_4244))
(assert (<= 0 m_4499))
(assert (<= 0 m_4610))
(assert (<= 0 cm))
(assert (= m_4610 cm))
(assert (<= 0 am))
(assert (<= 0 bm))
(assert (<= 0 m_4152))
(assert (<= 0 m_4263))
(assert (= bm m_4263))
(assert (= am m_4152))
(assert (<= 0 m1_3778))
(assert (= m_4152 m1_3778))
(assert (<= 0 m))
(assert (<= 0 flted_43_4115))
(assert (= m flted_43_4115))
(assert (<= 0 tm_4091))
(assert (< 0 tm_4091))
(assert (= flted_43_4115 (+ 1 tm_4091)))
(assert (<= 0 m2_3782))
(assert (= tm_4091 m2_3782))
(assert (= m1_4525 am))
(assert (= m2_4529 bm))
(assert (= m_4499 (+ (+ m2_4529 1) m1_4525)))
(assert (= m2_5615 m_4610))
(assert (= m1_5611 m_4499))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
;Negation of Consequence
(assert (not (= (+ (+ m1_5611 m2_5615) 1) (+ tm 1))))
(check-sat)