(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status unsat)
;Variables declarations
(declare-fun m1_5898 () Int)
(declare-fun m2_5902 () Int)
(declare-fun m_4499 () Int)
(declare-fun m_4610 () Int)
(declare-fun flted_115_4473 () Int)
(declare-fun flted_114_4474 () Int)
(declare-fun cm () Int)
(declare-fun bm () Int)
(declare-fun m2_4346 () Int)
(declare-fun m1_4342 () Int)
(declare-fun m_4263 () Int)
(declare-fun dm () Int)
(declare-fun m_4244 () Int)
(declare-fun m2_4239 () Int)
(declare-fun m1_4235 () Int)
(declare-fun am () Int)
(declare-fun m () Int)
(declare-fun flted_43_4115 () Int)
(declare-fun tm_4091 () Int)
(declare-fun m_4152 () Int)
(declare-fun m2_3782 () Int)
(declare-fun m1_3778 () Int)
(declare-fun tm () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 cm))
(assert (<= 0 bm))
(assert (<= 0 dm))
(assert (<= 0 m_4244))
(assert (<= 0 m1_4342))
(assert (<= 0 m2_4346))
(assert (<= 0 m_4263))
(assert (<= 0 m_4610))
(assert (<= 0 m_4499))
(assert (= m1_5898 m_4499))
(assert (= m2_5902 m_4610))
(assert (= m_4499 flted_114_4474))
(assert (<= 0 flted_114_4474))
(assert (= m_4610 flted_115_4473))
(assert (<= 0 flted_115_4473))
(assert (= flted_115_4473 (+ (+ 1 cm) dm)))
(assert (= flted_114_4474 (+ (+ 1 am) bm)))
(assert (= cm m2_4346))
(assert (= bm m1_4342))
(assert (= m_4263 (+ (+ m2_4346 1) m1_4342)))
(assert (= m_4263 m1_4235))
(assert (<= 0 m1_4235))
(assert (= dm m_4244))
(assert (= m_4244 m2_4239))
(assert (<= 0 m2_4239))
(assert (<= 0 am))
(assert (= m (+ (+ m2_4239 1) m1_4235)))
(assert (= am m_4152))
(assert (<= 0 m))
(assert (<= 0 flted_43_4115))
(assert (= m flted_43_4115))
(assert (<= 0 tm_4091))
(assert (< 0 tm_4091))
(assert (= flted_43_4115 (+ 1 tm_4091)))
(assert (<= 0 m_4152))
(assert (= tm_4091 m2_3782))
(assert (<= 0 m2_3782))
(assert (= m_4152 m1_3778))
(assert (<= 0 m1_3778))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (= tm 0))
(assert (<= 0 tm))
;Negation of Consequence
(assert (not false))
(check-sat)