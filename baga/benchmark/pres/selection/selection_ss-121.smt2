(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun tmp_null_primed () Int)
(declare-fun n () Int)
(declare-fun sm () Int)
(declare-fun mi () Int)
(declare-fun lg () Int)
(declare-fun x () Int)
(declare-fun minimum_primed () Int)
(declare-fun n_1947 () Int)
(declare-fun s () Int)
(declare-fun mi_1948 () Int)
(declare-fun l () Int)
(declare-fun x_primed () Int)
(declare-fun n_1956 () Int)
(declare-fun s_1957 () Int)
(declare-fun mi_1959 () Int)
(declare-fun l_1958 () Int)
(declare-fun x_1964 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< tmp_null_primed 1))
(assert (= x_1964 x))
(assert (= n_1947 n))
(assert (= s sm))
(assert (= l lg))
(assert (= mi_1948 mi))
(assert (<= 1 n))
(assert (<= sm mi))
(assert (< mi lg))
(assert (> x 0))
(assert (= minimum_primed mi_1948))
(assert (= n_1956 n_1947))
(assert (= s_1957 s))
(assert (= l_1958 l))
(assert (= mi_1959 mi_1948))
(assert (<= 1 n_1947))
(assert (<= s mi_1948))
(assert (< mi_1948 l))
(assert (< x_primed 1))
(assert (= n_1956 1))
(assert (<= 1 n_1956))
(assert (<= s_1957 mi_1959))
(assert (< mi_1959 l_1958))
(assert (> x_1964 0))
;Negation of Consequence
(assert (not false))
(check-sat)