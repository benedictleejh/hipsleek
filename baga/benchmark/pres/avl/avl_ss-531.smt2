(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun size1_4664 () Int)
(declare-fun size2_4667 () Int)
(declare-fun m_4671 () Int)
(declare-fun m_4688 () Int)
(declare-fun flted_51_5301 () Int)
(declare-fun llm () Int)
(declare-fun lrm () Int)
(declare-fun rm () Int)
(declare-fun m_4588 () Int)
(declare-fun flted_161_4579 () Int)
(declare-fun m_4565 () Int)
(declare-fun m_4600 () Int)
(declare-fun size2_4551 () Int)
(declare-fun size1_4548 () Int)
(declare-fun m () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 m_4671))
(assert (<= 0 m_4688))
(assert (<= 0 size2_4667))
(assert (<= 0 size1_4664))
(assert (<= 0 flted_51_5301))
(assert (= m_4588 (+ (+ size2_4667 1) size1_4664)))
(assert (= m_4671 size1_4664))
(assert (= m_4688 size2_4667))
(assert (= llm m_4671))
(assert (= lrm m_4688))
(assert (<= 0 rm))
(assert (<= 0 lrm))
(assert (<= 0 llm))
(assert (= flted_51_5301 (+ (+ (+ rm llm) 2) lrm)))
(assert (<= 0 m_4600))
(assert (= rm m_4600))
(assert (<= 0 m_4588))
(assert (<= 0 flted_161_4579))
(assert (= m_4588 flted_161_4579))
(assert (<= 0 m_4565))
(assert (= flted_161_4579 (+ 1 m_4565)))
(assert (= m_4565 size1_4548))
(assert (<= 0 size1_4548))
(assert (= m_4600 size2_4551))
(assert (<= 0 size2_4551))
(assert (= m (+ (+ size2_4551 1) size1_4548)))
;Negation of Consequence
(assert (not (<= 0 m)))
(check-sat)