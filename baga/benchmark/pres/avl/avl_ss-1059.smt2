(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun s2 () Int)
(declare-fun flted_455_7058 () Int)
(declare-fun s1_7045 () Int)
(declare-fun m () Int)
(declare-fun flted_161_7016 () Int)
(declare-fun flted_455_7039 () Int)
(declare-fun s1_7022 () Int)
(declare-fun s2_7024 () Int)
(declare-fun s2_7047 () Int)
(declare-fun size2_7000 () Int)
(declare-fun size1_6997 () Int)
(declare-fun s1 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 s2))
(assert (<= 0 flted_455_7058))
(assert (<= 0 flted_161_7016))
(assert (= m s2))
(assert (<= 0 s2_7047))
(assert (<= 0 s1_7045))
(assert (= flted_455_7058 (+ s2_7047 s1_7045)))
(assert (<= 0 flted_455_7039))
(assert (= s1_7045 flted_455_7039))
(assert (<= 0 m))
(assert (= flted_161_7016 (+ 1 m)))
(assert (= s1_7022 flted_161_7016))
(assert (<= 0 s2_7024))
(assert (<= 0 s1_7022))
(assert (= flted_455_7039 (+ s2_7024 s1_7022)))
(assert (<= 0 size1_6997))
(assert (= s2_7024 size1_6997))
(assert (= s2_7047 size2_7000))
(assert (<= 0 size2_7000))
(assert (= s1 (+ (+ size2_7000 1) size1_6997)))
;Negation of Consequence
(assert (not (<= 0 s1)))
(check-sat)