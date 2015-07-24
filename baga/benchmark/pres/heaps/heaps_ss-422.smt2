(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun mx2_3012 () Int)
(declare-fun mx1_3009 () Int)
(declare-fun d_3006 () Int)
(declare-fun mx2_2994 () Int)
(declare-fun mx1_2991 () Int)
(declare-fun mx2_2487 () Int)
(declare-fun mx1_2484 () Int)
(declare-fun mx2_2534 () Int)
(declare-fun mx1_2531 () Int)
(declare-fun d_2528 () Int)
(declare-fun d_2481 () Int)
(declare-fun v () Int)
(declare-fun mx2 () Int)
(declare-fun mx1 () Int)
(declare-fun d_2613 () Int)
(declare-fun d () Int)
(declare-fun v_primed () Int)
(declare-fun d_2988 () Int)
(declare-fun d_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((mx4_3047 Int)) (<= d_3006 mx4_3047)))
(assert (= mx2_3012 mx2_2534))
(assert (= mx1_3009 mx1_2531))
(assert (= d_3006 d_2528))
(assert (= mx2_2994 mx2_2487))
(assert (= mx1_2991 mx1_2484))
(assert (<= 0 mx1_2484))
(assert (<= 0 mx2_2487))
(assert (<= 0 mx1_2531))
(assert (<= 0 mx2_2534))
(assert (= v_primed v))
(assert (<= 0 v))
(assert (<= d_2481 mx1))
(assert (<= mx2_2487 d_2481))
(assert (<= mx1_2484 d_2481))
(assert (<= 0 d_2481))
(assert (<= d_2528 mx2))
(assert (<= mx2_2534 d_2528))
(assert (<= mx1_2531 d_2528))
(assert (<= 0 d_2528))
(assert (< d_2481 d_2528))
(assert (<= d_2528 v_primed))
(assert (exists ((mx3_3046 Int)) (<= d_2988 mx3_3046)))
(assert (= d_2988 d_2481))
(assert (<= v d))
(assert (<= mx2 d))
(assert (<= mx1 d))
(assert (= d_2613 d))
(assert (= d_primed v_primed))
;Negation of Consequence
(assert (not (<= d_2988 d_primed)))
(check-sat)