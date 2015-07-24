(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun d_2681 () Int)
(declare-fun mx1_2423 () Int)
(declare-fun mx2_2426 () Int)
(declare-fun d_2435 () Int)
(declare-fun d () Int)
(declare-fun d_2420 () Int)
(declare-fun v_primed () Int)
(declare-fun mx1 () Int)
(declare-fun d_primed () Int)
(declare-fun v () Int)
(declare-fun mx2 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= mx1_2423 0))
(assert (exists ((mx3_2715 Int)) (<= d_2681 mx3_2715)))
(assert (= mx2_2426 0))
(assert (= d_2681 d_2420))
(assert (<= 0 d_2420))
(assert (<= mx1_2423 d_2420))
(assert (<= mx2_2426 d_2420))
(assert (= d_primed v_primed))
(assert (= d_2435 d))
(assert (= v_primed v))
(assert (<= mx1 d))
(assert (<= mx2 d))
(assert (<= 0 v))
(assert (<= v d))
(assert (<= d_2420 mx1))
(assert (<= d_2420 v_primed))
(assert (= mx2 0))
;Negation of Consequence
(assert (not (or (and (and (< mx2 mx1) (<= d_primed mx1)) (<= v mx1)) (or (and (and (< mx2 v) (< mx1 v)) (<= d_primed v)) (and (and (<= mx1 mx2) (<= d_primed mx2)) (<= v mx2))))))
(check-sat)