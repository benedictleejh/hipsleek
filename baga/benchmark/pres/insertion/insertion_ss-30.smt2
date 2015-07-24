(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v () Int)
(declare-fun xl () Int)
(declare-fun sm_1466 () Int)
(declare-fun xs () Int)
(declare-fun n () Int)
(declare-fun flted_15_1468 () Int)
(declare-fun qs_1470 () Int)
(declare-fun lg_1467 () Int)
(declare-fun res () Int)
(declare-fun xl_1500 () Int)
(declare-fun v_primed () Int)
(declare-fun xs_1499 () Int)
(declare-fun n_1498 () Int)
(declare-fun x () Int)
(declare-fun qs_1613 () Int)
(declare-fun x_primed () Int)
(declare-fun sres_1515 () Int)
(declare-fun lres_1516 () Int)
(declare-fun flted_21_1514 () Int)
(declare-fun xn_1606 () Int)
(declare-fun q_1612 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= qs_1470 lg_1467))
(assert (<= 1 flted_15_1468))
(assert (< sm_1466 v_primed))
(assert (< 0 n))
(assert (= v_primed v))
(assert (= lg_1467 xl))
(assert (= sm_1466 xs))
(assert (<= xs qs_1470))
(assert (= (+ flted_15_1468 1) n))
(assert (= n_1498 flted_15_1468))
(assert (= xs_1499 qs_1470))
(assert (= xl_1500 lg_1467))
(assert (= res x_primed))
(assert (<= xs_1499 xl_1500))
(assert (<= 1 n_1498))
(assert (or (and (= lres_1516 v_primed) (>= v_primed xl_1500)) (and (= lres_1516 xl_1500) (< v_primed xl_1500))))
(assert (or (and (= sres_1515 v_primed) (< v_primed xs_1499)) (and (= sres_1515 xs_1499) (>= v_primed xs_1499))))
(assert (= flted_21_1514 (+ 1 n_1498)))
(assert (= x_primed x))
(assert (= qs_1613 sres_1515))
(assert (= x_primed 1))
(assert (not (= xn_1606 x_primed)))
(assert (or (and (and (= lres_1516 sres_1515) (= flted_21_1514 1)) (> xn_1606 0)) (and (and (<= sres_1515 lres_1516) (<= 2 flted_21_1514)) (> xn_1606 0))))
(assert (= q_1612 xn_1606))
;Negation of Consequence
(assert (not (> q_1612 0)))
(check-sat)