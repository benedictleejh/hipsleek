(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun l_2117 () Int)
(declare-fun nmin_2151 () Int)
(declare-fun n_2150 () Int)
(declare-fun nmin_2133 () Int)
(declare-fun n_2132 () Int)
(declare-fun flted_25_2115 () Int)
(declare-fun n () Int)
(declare-fun nmin () Int)
(declare-fun nmin1_2118 () Int)
(declare-fun nmin2_2120 () Int)
(declare-fun flted_25_2114 () Int)
(declare-fun n_2216 () Int)
(declare-fun nmin_2217 () Int)
(declare-fun aux_primed () Int)
(declare-fun n_2234 () Int)
(declare-fun nmin_2235 () Int)
(declare-fun r_2119 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= n_2150 nmin_2133))
(assert (or (and (and (<= 1 nmin_2151) (<= nmin_2151 n_2150)) (> l_2117 0)) (or (and (and (< l_2117 1) (= n_2150 0)) (= nmin_2151 0)) (and (and (<= 1 nmin_2151) (< nmin_2151 n_2150)) (> l_2117 0)))))
(assert (<= nmin_2151 n_2150))
(assert (<= 0 nmin_2151))
(assert (<= nmin_2133 n_2132))
(assert (<= 0 nmin_2133))
(assert (= nmin_2151 nmin_2133))
(assert (= n_2150 n_2132))
(assert (<= nmin1_2118 flted_25_2115))
(assert (<= 0 nmin1_2118))
(assert (= nmin_2133 nmin1_2118))
(assert (= n_2132 flted_25_2115))
(assert (< nmin n))
(assert (= (+ flted_25_2115 1) n))
(assert (= (+ flted_25_2114 2) n))
(assert (exists ((min_2267 Int)) (and (= nmin (+ 1 min_2267)) (or (and (= min_2267 nmin1_2118) (< nmin1_2118 nmin2_2120)) (and (= min_2267 nmin2_2120) (>= nmin1_2118 nmin2_2120))))))
(assert (<= nmin_2217 n_2216))
(assert (<= 0 nmin_2217))
(assert (<= nmin2_2120 flted_25_2114))
(assert (<= 0 nmin2_2120))
(assert (= nmin_2217 nmin2_2120))
(assert (= n_2216 flted_25_2114))
(assert (< nmin_2217 n_2234))
(assert (= n_2234 n_2216))
(assert (= nmin_2235 nmin_2217))
(assert (<= 0 nmin_2235))
(assert (<= nmin_2235 n_2234))
(assert (= aux_primed r_2119))
(assert (or (and (and (<= 1 nmin_2235) (<= nmin_2235 n_2234)) (> r_2119 0)) (or (and (and (< r_2119 1) (= n_2234 0)) (= nmin_2235 0)) (and (and (<= 1 nmin_2235) (< nmin_2235 n_2234)) (> r_2119 0)))))
;Negation of Consequence
(assert (not (or (= n_2234 0) (or (= nmin_2235 0) (< r_2119 1)))))
(check-sat)