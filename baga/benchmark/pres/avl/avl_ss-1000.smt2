(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m_5560 () Int)
(declare-fun m_5669 () Int)
(declare-fun size2_5543 () Int)
(declare-fun size1_5540 () Int)
(declare-fun m_5547 () Int)
(declare-fun size2_5729 () Int)
(declare-fun m_5764 () Int)
(declare-fun m_5809 () Int)
(declare-fun m_5656 () Int)
(declare-fun size1_5726 () Int)
(declare-fun m_5476 () Int)
(declare-fun m_5464 () Int)
(declare-fun flted_220_5455 () Int)
(declare-fun m_5441 () Int)
(declare-fun m_5781 () Int)
(declare-fun m_5747 () Int)
(declare-fun size2_5842 () Int)
(declare-fun size1_5839 () Int)
(declare-fun m_5833 () Int)
(declare-fun size2_5427 () Int)
(declare-fun size1_5424 () Int)
(declare-fun size2_6665 () Int)
(declare-fun size1_6662 () Int)
(declare-fun size1_6633 () Int)
(declare-fun size2_6636 () Int)
(declare-fun m () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 size2_5729))
(assert (<= 0 m_5669))
(assert (<= 0 m_5560))
(assert (= m_5669 m_5560))
(assert (<= 0 m_5547))
(assert (<= 0 size2_5543))
(assert (= m_5560 size2_5543))
(assert (<= 0 size1_5540))
(assert (= m_5669 (+ (+ size2_5729 1) size1_5726)))
(assert (= m_5464 (+ (+ size2_5543 1) size1_5540)))
(assert (= m_5547 size1_5540))
(assert (= m_5656 m_5547))
(assert (= m_5764 size2_5729))
(assert (<= 0 m_5833))
(assert (<= 0 m_5764))
(assert (<= 0 m_5809))
(assert (= size2_6665 m_5809))
(assert (= size1_6662 m_5764))
(assert (<= 0 m_5781))
(assert (<= 0 m_5747))
(assert (<= 0 m_5476))
(assert (= m_5809 m_5476))
(assert (<= 0 m_5656))
(assert (= m_5781 m_5656))
(assert (<= 0 size1_5726))
(assert (= m_5747 size1_5726))
(assert (<= 0 size2_5427))
(assert (= m_5476 size2_5427))
(assert (<= 0 m_5464))
(assert (<= 0 flted_220_5455))
(assert (= m_5464 flted_220_5455))
(assert (<= 0 m_5441))
(assert (= flted_220_5455 (+ 1 m_5441)))
(assert (<= 0 size1_5424))
(assert (= m_5441 size1_5424))
(assert (= size1_5839 m_5781))
(assert (= size2_5842 m_5747))
(assert (= m_5833 (+ (+ size2_5842 1) size1_5839)))
(assert (= size1_6633 m_5833))
(assert (= m (+ (+ size2_5427 1) size1_5424)))
(assert (= size2_6636 (+ (+ size2_6665 1) size1_6662)))
;Negation of Consequence
(assert (not (= (+ (+ size1_6633 size2_6636) 1) (+ m 1))))
(check-sat)