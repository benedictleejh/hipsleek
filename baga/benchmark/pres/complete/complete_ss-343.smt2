(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n () Int)
(declare-fun nmin () Int)
(declare-fun flted_25_2115 () Int)
(declare-fun nmin1_2118 () Int)
(declare-fun n_2132 () Int)
(declare-fun nmin_2133 () Int)
(declare-fun flted_25_2114 () Int)
(declare-fun nmin2_2120 () Int)
(declare-fun n_2216 () Int)
(declare-fun nmin_2217 () Int)
(declare-fun nmin_2235 () Int)
(declare-fun n_2234 () Int)
(declare-fun nmin_2302 () Int)
(declare-fun nmin_2151 () Int)
(declare-fun n_2150 () Int)
(declare-fun n_2301 () Int)
(declare-fun nmin_2314 () Int)
(declare-fun n_2313 () Int)
(declare-fun nmin_2341 () Int)
(declare-fun n_2340 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= nmin_2217 n_2216))
(assert (<= 0 nmin_2217))
(assert (<= nmin2_2120 flted_25_2114))
(assert (<= 0 nmin2_2120))
(assert (<= nmin_2133 n_2132))
(assert (<= 0 nmin_2133))
(assert (<= nmin1_2118 flted_25_2115))
(assert (<= 0 nmin1_2118))
(assert (< nmin n))
(assert (<= n_2234 nmin_2217))
(assert (<= n_2150 nmin_2133))
(assert (= (+ flted_25_2115 1) n))
(assert (= (+ flted_25_2114 2) n))
(assert (exists ((min_30 Int)) (and (= nmin (+ 1 min_30)) (or (and (= min_30 nmin1_2118) (< nmin1_2118 nmin2_2120)) (and (= min_30 nmin2_2120) (>= nmin1_2118 nmin2_2120))))))
(assert (= n_2132 flted_25_2115))
(assert (= nmin_2133 nmin1_2118))
(assert (= n_2150 n_2132))
(assert (= nmin_2151 nmin_2133))
(assert (= n_2216 flted_25_2114))
(assert (= nmin_2217 nmin2_2120))
(assert (= n_2234 n_2216))
(assert (= nmin_2235 nmin_2217))
(assert (= nmin_2302 nmin_2151))
(assert (<= 0 nmin_2151))
(assert (<= 0 nmin_2302))
(assert (<= nmin_2314 n_2313))
(assert (<= 0 nmin_2314))
(assert (<= nmin_2235 n_2234))
(assert (<= 0 nmin_2235))
(assert (= nmin_2314 nmin_2235))
(assert (= n_2313 n_2234))
(assert (<= nmin_2302 n_2301))
(assert (<= nmin_2151 n_2150))
(assert (= n_2301 n_2150))
(assert (not (= n_2301 n_2313)))
(assert (= nmin_2341 nmin_2314))
(assert (= n_2340 n_2313))
(assert (< nmin_2341 n_2340))
;Negation of Consequence
(assert (not false))
(check-sat)