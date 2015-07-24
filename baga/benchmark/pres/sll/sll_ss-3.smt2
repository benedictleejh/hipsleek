(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun x () Int)
(declare-fun v () Int)
(declare-fun v_bool_71_1391_primed () Int)
(declare-fun xs () Int)
(declare-fun xl () Int)
(declare-fun n () Int)
(declare-fun v_bool_72_1389_primed () Int)
(declare-fun v_primed () Int)
(declare-fun qmin_1569 () Int)
(declare-fun v_bool_75_1388_primed () Int)
(declare-fun x_primed () Int)
(declare-fun qs_1567 () Int)
(declare-fun ql_1568 () Int)
(declare-fun flted_16_1566 () Int)
(declare-fun q_1570 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= x_primed x))
(assert (= v_primed v))
(assert (> x_primed 0))
(assert (> v_bool_71_1391_primed 0))
(assert (<= xs qmin_1569))
(assert (<= ql_1568 xl))
(assert (<= qmin_1569 qs_1567))
(assert (= (+ flted_16_1566 1) n))
(assert (<= qmin_1569 v_primed))
(assert (not (> v_bool_72_1389_primed 0)))
(assert (not (> v_bool_75_1388_primed 0)))
(assert (not (= v_primed qmin_1569)))
(assert (> v_bool_75_1388_primed 0))
(assert (= x_primed 1))
(assert (or (and (and (< q_1570 1) (= flted_16_1566 0)) (<= qs_1567 ql_1568)) (and (and (<= qs_1567 ql_1568) (<= 1 flted_16_1566)) (> q_1570 0))))
;Negation of Consequence
(assert (not false))
(check-sat)