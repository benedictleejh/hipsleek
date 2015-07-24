(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nmin2_2371 () Int)
(declare-fun nmin1_2369 () Int)
(declare-fun r_2370 () Int)
(declare-fun r_2119 () Int)
(declare-fun l_2368 () Int)
(declare-fun aux_2364 () Int)
(declare-fun Anon_2367 () Int)
(declare-fun Anon_2116 () Int)
(declare-fun v_bool_88_1429_primed () Int)
(declare-fun flted_25_2114 () Int)
(declare-fun nmin2_2120 () Int)
(declare-fun v_bool_83_1430_primed () Int)
(declare-fun nmin () Int)
(declare-fun n () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun t_primed () Int)
(declare-fun t () Int)
(declare-fun nmin1_2118 () Int)
(declare-fun flted_25_2115 () Int)
(declare-fun nmin_2133 () Int)
(declare-fun n_2132 () Int)
(declare-fun nmin_2151 () Int)
(declare-fun n_2150 () Int)
(declare-fun nmin1_2206 () Int)
(declare-fun nmin_2177 () Int)
(declare-fun n_2176 () Int)
(declare-fun left_91_2209 () Int)
(declare-fun l_2117 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nmin2_2371 nmin2_2120))
(assert (= nmin1_2369 nmin1_2206))
(assert (= r_2370 r_2119))
(assert (= l_2368 aux_2364))
(assert (= Anon_2367 Anon_2116))
(assert (> v_bool_88_1429_primed 0))
(assert (< nmin_2133 n_2150))
(assert (= (+ flted_25_2115 1) n))
(assert (= (+ flted_25_2114 2) n))
(assert (exists ((min_30 Int)) (and (= nmin (+ 1 min_30)) (or (and (= min_30 nmin1_2118) (< nmin1_2118 nmin2_2120)) (and (= min_30 nmin2_2120) (>= nmin1_2118 nmin2_2120))))))
(assert (not (> v_bool_83_1430_primed 0)))
(assert (> t_primed 0))
(assert (< nmin n))
(assert (= v_primed v))
(assert (= t_primed t))
(assert (= n_2132 flted_25_2115))
(assert (= nmin_2133 nmin1_2118))
(assert (<= 0 nmin1_2118))
(assert (<= nmin1_2118 flted_25_2115))
(assert (= n_2150 n_2132))
(assert (= nmin_2151 nmin_2133))
(assert (<= 0 nmin_2133))
(assert (<= nmin_2133 n_2132))
(assert (= n_2176 n_2150))
(assert (= nmin_2177 nmin_2151))
(assert (<= 0 nmin_2151))
(assert (<= nmin_2151 n_2150))
(assert (or (= nmin1_2206 nmin_2177) (= nmin1_2206 (+ 1 nmin_2177))))
(assert (<= 0 nmin_2177))
(assert (<= nmin_2177 n_2176))
(assert (= left_91_2209 l_2117))
;Negation of Consequence
(assert (not false))
(check-sat)