(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun q_1675 () Int)
(declare-fun r_1649 () Int)
(declare-fun Anon_1648 () Int)
(declare-fun Anon_1445 () Int)
(declare-fun next_41_1446 () Int)
(declare-fun flted_23_1443 () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun tx_primed () Int)
(declare-fun y_primed () Int)
(declare-fun y () Int)
(declare-fun ty_primed () Int)
(declare-fun tx () Int)
(declare-fun ty_1403 () Int)
(declare-fun ty () Int)
(declare-fun tx_1402 () Int)
(declare-fun flted_19_1428 () Int)
(declare-fun n () Int)
(declare-fun Anon_1512 () Int)
(declare-fun Anon_1429 () Int)
(declare-fun r_1513 () Int)
(declare-fun r_1430 () Int)
(declare-fun q_1641 () Int)
(declare-fun tx_1427 () Int)
(declare-fun n1_1640 () Int)
(declare-fun flted_23_1444 () Int)
(declare-fun flted_23_1669 () Int)
(declare-fun flted_23_1670 () Int)
(declare-fun m () Int)
(declare-fun n2_1676 () Int)
(declare-fun n1_1674 () Int)
(declare-fun n2_1642 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= n1_1674 flted_23_1670))
(assert (= q_1675 ty_1403))
(assert (= r_1649 y_primed))
(assert (= Anon_1648 Anon_1445))
(assert (= next_41_1446 flted_23_1443))
(assert (= (+ flted_23_1444 1) flted_19_1428))
(assert (< flted_23_1443 1))
(assert (= x_primed x))
(assert (= tx_primed tx))
(assert (= y_primed y))
(assert (= ty_primed ty))
(assert (= tx_1402 tx))
(assert (= ty_1403 ty))
(assert (= tx_1427 tx_1402))
(assert (> r_1430 0))
(assert (= (+ flted_19_1428 1) n))
(assert (= Anon_1512 Anon_1429))
(assert (= r_1513 r_1430))
(assert (= q_1641 tx_1427))
(assert (= n1_1640 flted_23_1444))
(assert (< flted_23_1669 1))
(assert (= (+ flted_23_1670 1) m))
(assert (= n2_1676 0))
(assert (= (+ (+ n2_1676 n1_1674) 1) n2_1642))
;Negation of Consequence
(assert (not false))
(check-sat)