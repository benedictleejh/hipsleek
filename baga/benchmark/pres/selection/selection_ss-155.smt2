(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun s_1957 () Int)
(declare-fun l_1958 () Int)
(declare-fun mi1_1973 () Int)
(declare-fun l_2014 () Int)
(declare-fun sm_1978 () Int)
(declare-fun lg_1979 () Int)
(declare-fun mi_1980 () Int)
(declare-fun qs_2021 () Int)
(declare-fun sm () Int)
(declare-fun lg () Int)
(declare-fun mi_1959 () Int)
(declare-fun s () Int)
(declare-fun l () Int)
(declare-fun mi_1948 () Int)
(declare-fun mi () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< mi1_1973 l_1958))
(assert (<= s_1957 mi1_1973))
(assert (<= mi_1980 l_2014))
(assert (< mi_1959 l_1958))
(assert (<= s_1957 mi_1959))
(assert (<= mi_1959 mi1_1973))
(assert (= l_1958 l))
(assert (= s_1957 s))
(assert (= l lg))
(assert (= s sm))
(assert (= sm_1978 s_1957))
(assert (= lg_1979 l_1958))
(assert (= mi_1980 mi1_1973))
(assert (< l_2014 lg_1979))
(assert (<= sm_1978 mi_1980))
(assert (< mi_1980 lg_1979))
(assert (= qs_2021 mi_1980))
(assert (<= mi_1948 qs_2021))
(assert (= mi_1948 mi))
(assert (<= sm mi))
(assert (< mi lg))
(assert (= mi_1959 mi_1948))
(assert (<= s mi_1948))
(assert (< mi_1948 l))
;Negation of Consequence
(assert (not (= mi_1948 mi)))
(check-sat)