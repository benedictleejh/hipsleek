(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v () Int)
(declare-fun x () Int)
(declare-fun vn_primed () Int)
(declare-fun v_bool_48_1444_primed () Int)
(declare-fun sm () Int)
(declare-fun lg () Int)
(declare-fun qmin_1959 () Int)
(declare-fun n () Int)
(declare-fun res () Int)
(declare-fun v_int_52_1432_primed () Int)
(declare-fun v_int_52_1431_primed () Int)
(declare-fun qs_1957 () Int)
(declare-fun ql_1958 () Int)
(declare-fun flted_16_1956 () Int)
(declare-fun q_1960 () Int)
(declare-fun x_primed () Int)
(declare-fun vn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= v_int_52_1431_primed qmin_1959))
(assert (= v_int_52_1432_primed v))
(assert (= x_primed x))
(assert (= vn_primed vn))
(assert (> x_primed 0))
(assert (not (> v_bool_48_1444_primed 0)))
(assert (<= sm qmin_1959))
(assert (<= ql_1958 lg))
(assert (<= qmin_1959 qs_1957))
(assert (= (+ flted_16_1956 1) n))
(assert (> res 0))
(assert (<= v_int_52_1432_primed v_int_52_1431_primed))
(assert (= x_primed 1))
(assert (or (and (and (< q_1960 1) (= flted_16_1956 0)) (<= qs_1957 ql_1958)) (and (and (<= qs_1957 ql_1958) (<= 1 flted_16_1956)) (> q_1960 0))))
(assert (= vn 2))
(assert (not (= x_primed vn)))
;Negation of Consequence
(assert (not false))
(check-sat)