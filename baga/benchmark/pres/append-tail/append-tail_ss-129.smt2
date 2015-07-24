(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n1_1640 () Int)
(declare-fun r_1513 () Int)
(declare-fun n () Int)
(declare-fun flted_19_1428 () Int)
(declare-fun flted_23_1444 () Int)
(declare-fun r_1430 () Int)
(declare-fun m () Int)
(declare-fun q_1641 () Int)
(declare-fun tx_1427 () Int)
(declare-fun flted_19_1720 () Int)
(declare-fun flted_23_1736 () Int)
(declare-fun r_1722 () Int)
(declare-fun y_primed () Int)
(declare-fun ty_primed () Int)
(declare-fun tx_1402 () Int)
(declare-fun tx () Int)
(declare-fun ty () Int)
(declare-fun ty_1403 () Int)
(declare-fun x_primed () Int)
(declare-fun y () Int)
(declare-fun tx_primed () Int)
(declare-fun tx_1719 () Int)
(declare-fun x () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= n1_1640 flted_23_1444))
(assert (= r_1513 r_1430))
(assert (= (+ flted_19_1428 1) n))
(assert (> r_1430 0))
(assert (= (+ flted_23_1444 1) flted_19_1428))
(assert (or (and (= tx_1427 r_1430) (= flted_23_1444 0)) (and (<= 1 flted_23_1444) (> r_1430 0))))
(assert (= (+ flted_19_1720 1) m))
(assert (> r_1722 0))
(assert (= q_1641 tx_1427))
(assert (= tx_1427 tx_1402))
(assert (= (+ flted_23_1736 1) flted_19_1720))
(assert (not (= tx_primed tx_1719)))
(assert (not (= y tx_primed)))
(assert (not (= y tx_1719)))
(assert (> tx_1719 0))
(assert (> tx_primed 0))
(assert (> y 0))
(assert (or (and (= tx_1719 r_1722) (= flted_23_1736 0)) (and (<= 1 flted_23_1736) (> r_1722 0))))
(assert (= tx_primed tx))
(assert (= y_primed y))
(assert (= ty_primed ty))
(assert (= tx_1402 tx))
(assert (= ty_1403 ty))
(assert (= tx_1719 ty_1403))
(assert (= x_primed x))
(assert (> x 0))
(assert (not (= y x)))
(assert (not (= tx_primed x)))
(assert (not (= tx_1719 x)))
;Negation of Consequence
(assert (not (> x 0)))
(check-sat)