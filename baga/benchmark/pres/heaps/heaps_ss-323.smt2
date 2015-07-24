(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m2_2526 () Int)
(declare-fun m1_2525 () Int)
(declare-fun m3_2527 () Int)
(declare-fun m2_2533 () Int)
(declare-fun m1_2530 () Int)
(declare-fun m2_2365 () Int)
(declare-fun m1_primed () Int)
(declare-fun m2_primed () Int)
(declare-fun m2 () Int)
(declare-fun m1 () Int)
(declare-fun m2_2479 () Int)
(declare-fun m2_2772 () Int)
(declare-fun m1_2364 () Int)
(declare-fun m3_2480 () Int)
(declare-fun m2_2486 () Int)
(declare-fun m1_2483 () Int)
(declare-fun m1_2478 () Int)
(declare-fun m1_2769 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 m2_2526))
(assert (<= 0 m1_2525))
(assert (= m2_2526 m2_2533))
(assert (= m1_2525 m1_2530))
(assert (<= m3_2527 1))
(assert (<= 0 m3_2527))
(assert (= (+ m3_2527 m2_2533) m1_2530))
(assert (<= 0 m2_2479))
(assert (= m2_2365 (+ (+ m2_2533 1) m1_2530)))
(assert (not (= m2_primed 0)))
(assert (not (= m1_primed 0)))
(assert (= m2_2365 m2))
(assert (= m1_primed m1))
(assert (= m2_primed m2))
(assert (<= (+ 0 m2) m1))
(assert (<= m1 (+ 1 m2)))
(assert (= m1_2364 m1))
(assert (= m2_2479 m2_2486))
(assert (<= m3_2480 1))
(assert (<= 0 m3_2480))
(assert (= m2_2772 m2_2486))
(assert (= m1_2364 (+ (+ m2_2486 1) m1_2483)))
(assert (= (+ m3_2480 m2_2486) m1_2483))
(assert (= m1_2478 m1_2483))
(assert (= m1_2769 m1_2483))
(assert (<= 0 m1_2478))
;Negation of Consequence
(assert (not (= m1_2478 m1_2769)))
(check-sat)