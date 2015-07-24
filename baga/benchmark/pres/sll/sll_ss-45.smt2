(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun x () Int)
(declare-fun vn_primed () Int)
(declare-fun v_bool_48_1444_primed () Int)
(declare-fun sm () Int)
(declare-fun lg () Int)
(declare-fun n () Int)
(declare-fun qmin_1959 () Int)
(declare-fun v () Int)
(declare-fun v_bool_52_1443_primed () Int)
(declare-fun qs_1957 () Int)
(declare-fun ql_1958 () Int)
(declare-fun flted_16_1956 () Int)
(declare-fun q_1960 () Int)
(declare-fun x_primed () Int)
(declare-fun vn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= x_primed x))
(assert (= vn_primed vn))
(assert (> x_primed 0))
(assert (not (> v_bool_48_1444_primed 0)))
(assert (<= sm qmin_1959))
(assert (<= ql_1958 lg))
(assert (<= qmin_1959 qs_1957))
(assert (= (+ flted_16_1956 1) n))
(assert (< qmin_1959 v))
(assert (not (> v_bool_52_1443_primed 0)))
(assert (= x_primed 1))
(assert (or (and (and (< q_1960 1) (= flted_16_1956 0)) (<= qs_1957 ql_1958)) (and (and (<= qs_1957 ql_1958) (<= 1 flted_16_1956)) (> q_1960 0))))
(assert (= vn 2))
(assert (not (= x_primed vn)))
;Negation of Consequence
(assert (not false))
(check-sat)