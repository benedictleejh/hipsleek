(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nmin2_2378 () Int)
(declare-fun nmin1_2376 () Int)
(declare-fun nmin () Int)
(declare-fun flted_25_2115 () Int)
(declare-fun nmin1_2118 () Int)
(declare-fun n_2132 () Int)
(declare-fun nmin_2133 () Int)
(declare-fun nmin_2151 () Int)
(declare-fun nmin1_2206 () Int)
(declare-fun nmin2_2120 () Int)
(declare-fun n () Int)
(declare-fun n_2150 () Int)
(declare-fun nmin_2177 () Int)
(declare-fun n_2176 () Int)
(declare-fun flted_25_2114 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= nmin_2133 n_2132))
(assert (<= 0 nmin_2133))
(assert (<= nmin1_2118 flted_25_2115))
(assert (<= 0 nmin1_2118))
(assert (<= 0 nmin1_2206))
(assert (<= 0 nmin2_2120))
(assert (= nmin2_2378 nmin2_2120))
(assert (= nmin1_2376 nmin1_2206))
(assert (< nmin_2133 n_2150))
(assert (= (+ flted_25_2115 1) n))
(assert (exists ((min_30 Int)) (and (= nmin (+ 1 min_30)) (or (and (= min_30 nmin1_2118) (< nmin1_2118 nmin2_2120)) (and (= min_30 nmin2_2120) (>= nmin1_2118 nmin2_2120))))))
(assert (< nmin n))
(assert (= n_2132 flted_25_2115))
(assert (= nmin_2133 nmin1_2118))
(assert (= n_2150 n_2132))
(assert (= nmin_2151 nmin_2133))
(assert (= nmin_2177 nmin_2151))
(assert (<= 0 nmin_2151))
(assert (<= nmin_2151 n_2150))
(assert (or (= nmin1_2206 nmin_2177) (= nmin1_2206 (+ 1 nmin_2177))))
(assert (<= 0 nmin_2177))
(assert (<= nmin1_2206 n_2176))
(assert (<= nmin2_2120 flted_25_2114))
(assert (= (+ flted_25_2114 2) n))
(assert (= n_2176 n_2150))
(assert (<= nmin_2177 n_2176))
(assert (= (+ 1 n_2176) (+ 1 flted_25_2114)))
;Negation of Consequence
(assert (not false))
(check-sat)