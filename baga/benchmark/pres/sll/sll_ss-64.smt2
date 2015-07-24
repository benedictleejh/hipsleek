(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun lg () Int)
(declare-fun ma_1996 () Int)
(declare-fun lg_1978 () Int)
(declare-fun mi_1995 () Int)
(declare-fun ql_1958 () Int)
(declare-fun sm_1977 () Int)
(declare-fun qs_1957 () Int)
(declare-fun qmin_1959 () Int)
(declare-fun v_1979 () Int)
(declare-fun qmin_2086 () Int)
(declare-fun v () Int)
(declare-fun sm () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((ma_2107 Int)) (<= ma_1996 ma_2107)))
(assert (<= ql_1958 lg))
(assert (= lg_1978 ql_1958))
(assert (<= mi_1995 ma_1996))
(assert (<= sm_1977 lg_1978))
(assert (or (and (= ma_1996 v_1979) (>= v_1979 lg_1978)) (and (= ma_1996 lg_1978) (< v_1979 lg_1978))))
(assert (or (and (= mi_1995 v_1979) (< v_1979 sm_1977)) (and (= mi_1995 sm_1977) (>= v_1979 sm_1977))))
(assert (<= qs_1957 ql_1958))
(assert (= sm_1977 qs_1957))
(assert (<= qmin_1959 qs_1957))
(assert (exists ((mi_2108 Int)) (<= mi_2108 qmin_2086)))
(assert (= qmin_2086 qmin_1959))
(assert (< qmin_1959 v))
(assert (<= sm qmin_1959))
(assert (= v_1979 v))
;Negation of Consequence
(assert (not (or (and (<= sm qmin_2086) (<= sm v)) (and (<= v qmin_2086) (<= (+ v 1) sm)))))
(check-sat)