(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status unsat)
;Variables declarations
(declare-fun m1_4962 () Int)
(declare-fun m2_4966 () Int)
(declare-fun m_4610 () Int)
(declare-fun m2_4621 () Int)
(declare-fun m1_4617 () Int)
(declare-fun bm () Int)
(declare-fun m_4499 () Int)
(declare-fun am () Int)
(declare-fun m_3969 () Int)
(declare-fun m_3950 () Int)
(declare-fun m2_3945 () Int)
(declare-fun m1_3941 () Int)
(declare-fun cm () Int)
(declare-fun m_3858 () Int)
(declare-fun m () Int)
(declare-fun flted_43_3821 () Int)
(declare-fun tm_3797 () Int)
(declare-fun m2_3782 () Int)
(declare-fun m1_3778 () Int)
(declare-fun tm () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 m_3950))
(assert (<= 0 m_4610))
(assert (<= 0 bm))
(assert (<= 0 m_4499))
(assert (= m1_4962 m_4499))
(assert (= m2_4966 m_4610))
(assert (= m_4610 (+ (+ m2_4621 1) m1_4617)))
(assert (= m2_4621 cm))
(assert (= m1_4617 bm))
(assert (= bm m_3969))
(assert (<= 0 m_3969))
(assert (= m_4499 am))
(assert (<= 0 am))
(assert (= am m_3950))
(assert (= m_3969 m2_3945))
(assert (= m_3950 m1_3941))
(assert (<= 0 m2_3945))
(assert (<= 0 m1_3941))
(assert (= m (+ (+ m2_3945 1) m1_3941)))
(assert (<= 0 cm))
(assert (<= 0 m_3858))
(assert (= cm m_3858))
(assert (<= 0 m2_3782))
(assert (= m_3858 m2_3782))
(assert (<= 0 m))
(assert (<= 0 flted_43_3821))
(assert (= m flted_43_3821))
(assert (<= 0 tm_3797))
(assert (< 0 tm_3797))
(assert (= flted_43_3821 (+ 1 tm_3797)))
(assert (<= 0 m1_3778))
(assert (= tm_3797 m1_3778))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (= tm 0))
;Negation of Consequence
(assert (not false))
(check-sat)