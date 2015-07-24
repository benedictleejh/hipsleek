(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m () Int)
(declare-fun flted_19_1485 () Int)
(declare-fun x_primed () Int)
(declare-fun ty_primed () Int)
(declare-fun ty () Int)
(declare-fun flted_23_1501 () Int)
(declare-fun r_1487 () Int)
(declare-fun ty_1403 () Int)
(declare-fun x () Int)
(declare-fun tx_1402 () Int)
(declare-fun tx () Int)
(declare-fun y_primed () Int)
(declare-fun tx_1484 () Int)
(declare-fun tx_primed () Int)
(declare-fun y () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ flted_19_1485 1) m))
(assert (= (+ flted_23_1501 1) flted_19_1485))
(assert (= x_primed x))
(assert (= ty_primed ty))
(assert (= ty_1403 ty))
(assert (> r_1487 0))
(assert (not (= tx_primed tx_1484)))
(assert (> tx_1484 0))
(assert (> tx_primed 0))
(assert (or (and (= tx_1484 r_1487) (= flted_23_1501 0)) (and (<= 1 flted_23_1501) (> r_1487 0))))
(assert (= tx_1484 ty_1403))
(assert (= tx_1402 x))
(assert (= tx_1402 tx))
(assert (= tx_primed tx))
(assert (= y_primed y))
(assert (> y 0))
(assert (not (= y tx_1484)))
(assert (not (= y tx_primed)))
;Negation of Consequence
(assert (not (> y 0)))
(check-sat)