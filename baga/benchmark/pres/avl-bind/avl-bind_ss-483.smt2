(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_160_3396 () Int)
(declare-fun m_3392 () Int)
(declare-fun m_3382 () Int)
(declare-fun m1_3454 () Int)
(declare-fun m2_3457 () Int)
(declare-fun m_3459 () Int)
(declare-fun m_3468 () Int)
(declare-fun m_3402 () Int)
(declare-fun rm () Int)
(declare-fun llm () Int)
(declare-fun lrm () Int)
(declare-fun m2_3373 () Int)
(declare-fun m1_3370 () Int)
(declare-fun flted_50_3914 () Int)
(declare-fun m () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 m_3459))
(assert (<= 0 m_3468))
(assert (<= 0 m_3402))
(assert (<= 0 m2_3457))
(assert (<= 0 m1_3454))
(assert (<= 0 m_3392))
(assert (<= 0 flted_160_3396))
(assert (= m_3392 flted_160_3396))
(assert (<= 0 m_3382))
(assert (= flted_160_3396 (+ 1 m_3382)))
(assert (= m_3392 (+ (+ m2_3457 1) m1_3454)))
(assert (= m_3382 m1_3370))
(assert (<= 0 m1_3370))
(assert (= m_3402 m2_3373))
(assert (<= 0 m2_3373))
(assert (= m_3459 m1_3454))
(assert (= m_3468 m2_3457))
(assert (= llm m_3459))
(assert (= lrm m_3468))
(assert (= rm m_3402))
(assert (<= 0 llm))
(assert (<= 0 lrm))
(assert (<= 0 rm))
(assert (= flted_50_3914 (+ (+ (+ rm llm) 2) lrm)))
(assert (= m (+ (+ m2_3373 1) m1_3370)))
(assert (<= 0 flted_50_3914))
;Negation of Consequence
(assert (not (= flted_50_3914 (+ m 1))))
(check-sat)