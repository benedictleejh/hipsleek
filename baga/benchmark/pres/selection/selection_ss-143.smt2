(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun x_2013 () Int)
(declare-fun x_primed () Int)
(declare-fun lg_1979 () Int)
(declare-fun sm_1978 () Int)
(declare-fun n () Int)
(declare-fun sm () Int)
(declare-fun mi () Int)
(declare-fun lg () Int)
(declare-fun n_1947 () Int)
(declare-fun s () Int)
(declare-fun mi_1948 () Int)
(declare-fun l () Int)
(declare-fun flted_38_1972 () Int)
(declare-fun mi1_1973 () Int)
(declare-fun n_1956 () Int)
(declare-fun s_1957 () Int)
(declare-fun mi_1959 () Int)
(declare-fun l_1958 () Int)
(declare-fun x () Int)
(declare-fun v_bool_61_1369_primed () Int)
(declare-fun mi_1980 () Int)
(declare-fun l_2014 () Int)
(declare-fun n_1977 () Int)
(declare-fun tmp_2012 () Int)
(declare-fun v_node_67_1368_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res v_node_67_1368_primed))
(assert (> x_2013 0))
(assert (< mi_1980 lg_1979))
(assert (<= sm_1978 mi_1980))
(assert (<= 1 n_1977))
(assert (< x_primed 1))
(assert (< l_2014 lg_1979))
(assert (< mi1_1973 l_1958))
(assert (<= s_1957 mi1_1973))
(assert (<= 1 flted_38_1972))
(assert (= mi_1980 mi1_1973))
(assert (= lg_1979 l_1958))
(assert (= sm_1978 s_1957))
(assert (= n_1977 flted_38_1972))
(assert (= n_1947 n))
(assert (= s sm))
(assert (= l lg))
(assert (= mi_1948 mi))
(assert (<= 1 n))
(assert (<= sm mi))
(assert (< mi lg))
(assert (= n_1956 n_1947))
(assert (= s_1957 s))
(assert (= l_1958 l))
(assert (= mi_1959 mi_1948))
(assert (<= 1 n_1947))
(assert (<= s mi_1948))
(assert (< mi_1948 l))
(assert (= (+ flted_38_1972 1) n_1956))
(assert (<= mi_1959 mi1_1973))
(assert (< 1 n_1956))
(assert (<= 1 n_1956))
(assert (<= s_1957 mi_1959))
(assert (< mi_1959 l_1958))
(assert (> x 0))
(assert (not (> v_bool_61_1369_primed 0)))
(assert (or (and (and (= l_2014 mi_1980) (= n_1977 1)) (> tmp_2012 0)) (and (and (<= mi_1980 l_2014) (<= 2 n_1977)) (> tmp_2012 0))))
(assert (= v_node_67_1368_primed 1))
(assert (not (= tmp_2012 v_node_67_1368_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)