(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_25_2114 () Int)
(declare-fun n () Int)
(declare-fun nmin () Int)
(declare-fun nmin2_2120 () Int)
(declare-fun n_2132 () Int)
(declare-fun flted_25_2115 () Int)
(declare-fun nmin1_2118 () Int)
(declare-fun nmin_2133 () Int)
(declare-fun n_2150 () Int)
(declare-fun nmin_2151 () Int)
(declare-fun nmin_2177 () Int)
(declare-fun n_2176 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= nmin2_2120 flted_25_2114))
(assert (<= 0 nmin2_2120))
(assert (< nmin n))
(assert (= (+ flted_25_2114 2) n))
(assert (= (+ flted_25_2115 1) n))
(assert (exists ((min_2185 Int)) (and (= nmin (+ 1 min_2185)) (or (and (= min_2185 nmin1_2118) (< nmin1_2118 nmin2_2120)) (and (= min_2185 nmin2_2120) (>= nmin1_2118 nmin2_2120))))))
(assert (= n_2132 flted_25_2115))
(assert (<= nmin_2151 n_2150))
(assert (<= 0 nmin_2151))
(assert (<= nmin_2133 n_2132))
(assert (<= 0 nmin_2133))
(assert (= nmin_2151 nmin_2133))
(assert (= n_2150 n_2132))
(assert (<= nmin1_2118 flted_25_2115))
(assert (<= 0 nmin1_2118))
(assert (= nmin_2133 nmin1_2118))
(assert (< nmin_2133 n_2150))
(assert (= n_2176 n_2150))
(assert (= nmin_2177 nmin_2151))
;Negation of Consequence
(assert (not (< nmin_2177 n_2176)))
(check-sat)