(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n () Int)
(declare-fun flted_19_1428 () Int)
(declare-fun ty_primed () Int)
(declare-fun flted_23_1444 () Int)
(declare-fun r_1430 () Int)
(declare-fun tx_1427 () Int)
(declare-fun ty () Int)
(declare-fun tx_1402 () Int)
(declare-fun tx () Int)
(declare-fun x_primed () Int)
(declare-fun ty_1403 () Int)
(declare-fun y_primed () Int)
(declare-fun x () Int)
(declare-fun tx_primed () Int)
(declare-fun y () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ flted_19_1428 1) n))
(assert (= (+ flted_23_1444 1) flted_19_1428))
(assert (= ty_primed ty))
(assert (> r_1430 0))
(assert (not (= x tx_primed)))
(assert (> tx_primed 0))
(assert (> x 0))
(assert (or (and (= tx_1427 r_1430) (= flted_23_1444 0)) (and (<= 1 flted_23_1444) (> r_1430 0))))
(assert (= tx_1427 tx_1402))
(assert (= ty_1403 ty))
(assert (= tx_1402 tx))
(assert (= tx_primed tx))
(assert (= x_primed x))
(assert (= ty_1403 y))
(assert (= y_primed y))
(assert (> y 0))
(assert (not (= x y)))
(assert (not (= tx_primed y)))
;Negation of Consequence
(assert (not (> y 0)))
(check-sat)