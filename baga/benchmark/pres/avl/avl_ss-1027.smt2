(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m_6291 () Int)
(declare-fun size2_6843 () Int)
(declare-fun m_6416 () Int)
(declare-fun size1_6422 () Int)
(declare-fun size2_6425 () Int)
(declare-fun size2_6256 () Int)
(declare-fun m_6336 () Int)
(declare-fun size1_6253 () Int)
(declare-fun m_6194 () Int)
(declare-fun m_6175 () Int)
(declare-fun m_6034 () Int)
(declare-fun m_6021 () Int)
(declare-fun m_6274 () Int)
(declare-fun size1_6840 () Int)
(declare-fun m_6360 () Int)
(declare-fun size2_6369 () Int)
(declare-fun size1_6366 () Int)
(declare-fun size2_6017 () Int)
(declare-fun size1_6014 () Int)
(declare-fun m_6308 () Int)
(declare-fun m_5950 () Int)
(declare-fun m_5938 () Int)
(declare-fun flted_220_5929 () Int)
(declare-fun m_5915 () Int)
(declare-fun size2_5427 () Int)
(declare-fun size1_5424 () Int)
(declare-fun m () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 m_6416))
(assert (<= 0 m_6291))
(assert (<= 0 size2_6256))
(assert (= m_6291 size2_6256))
(assert (= size1_6422 m_6291))
(assert (= size2_6843 m_6416))
(assert (= m_6416 (+ (+ size2_6425 1) size1_6422)))
(assert (= size2_6425 m_6336))
(assert (= m_6175 (+ (+ size2_6256 1) size1_6253)))
(assert (<= 0 m_6360))
(assert (<= 0 m_6336))
(assert (<= 0 m_6274))
(assert (<= 0 m_6194))
(assert (= m_6336 m_6194))
(assert (<= 0 size1_6253))
(assert (= m_6274 size1_6253))
(assert (<= 0 m_6021))
(assert (= m_6194 m_6021))
(assert (<= 0 m_6175))
(assert (<= 0 m_6034))
(assert (= m_6175 m_6034))
(assert (<= 0 size1_6014))
(assert (= m_6034 size1_6014))
(assert (<= 0 size2_6017))
(assert (= m_6021 size2_6017))
(assert (= size2_6369 m_6274))
(assert (= size1_6840 m_6360))
(assert (= m_6360 (+ (+ size2_6369 1) size1_6366)))
(assert (= size1_6366 m_6308))
(assert (= m_5938 (+ (+ size2_6017 1) size1_6014)))
(assert (<= 0 m_6308))
(assert (<= 0 m_5950))
(assert (= m_6308 m_5950))
(assert (<= 0 size1_5424))
(assert (= m_5950 size1_5424))
(assert (<= 0 m_5938))
(assert (<= 0 flted_220_5929))
(assert (= m_5938 flted_220_5929))
(assert (<= 0 m_5915))
(assert (= flted_220_5929 (+ 1 m_5915)))
(assert (<= 0 size2_5427))
(assert (= m_5915 size2_5427))
(assert (= m (+ (+ size2_5427 1) size1_5424)))
;Negation of Consequence
(assert (not (<= 0 m)))
(check-sat)