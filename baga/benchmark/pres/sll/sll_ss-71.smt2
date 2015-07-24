(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n () Int)
(declare-fun v_bool_104_1305_primed () Int)
(declare-fun y_2147 () Int)
(declare-fun y () Int)
(declare-fun x () Int)
(declare-fun m1 () Int)
(declare-fun ys1 () Int)
(declare-fun yl1 () Int)
(declare-fun Anon_2135 () Int)
(declare-fun n_2139 () Int)
(declare-fun sm () Int)
(declare-fun lg () Int)
(declare-fun flted_23_2153 () Int)
(declare-fun mi_2154 () Int)
(declare-fun ma_2155 () Int)
(declare-fun flted_11_2134 () Int)
(declare-fun m1_2159 () Int)
(declare-fun ys1_2160 () Int)
(declare-fun yl1_2161 () Int)
(declare-fun x_primed () Int)
(declare-fun Anon_2169 () Int)
(declare-fun Anon_2170 () Int)
(declare-fun flted_101_2168 () Int)
(declare-fun y_primed () Int)
(declare-fun n_2158 () Int)
(declare-fun q_2136 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ flted_11_2134 1) n))
(assert (> v_bool_104_1305_primed 0))
(assert (> x_primed 0))
(assert (= y_2147 y))
(assert (= x_primed x))
(assert (= n_2139 m1))
(assert (= sm ys1))
(assert (= lg yl1))
(assert (<= 0 m1))
(assert (<= ys1 yl1))
(assert (= flted_23_2153 (+ 1 n_2139)))
(assert (or (and (= mi_2154 Anon_2135) (< Anon_2135 sm)) (and (= mi_2154 sm) (>= Anon_2135 sm))))
(assert (or (and (= ma_2155 Anon_2135) (>= Anon_2135 lg)) (and (= ma_2155 lg) (< Anon_2135 lg))))
(assert (<= 0 n_2139))
(assert (<= sm lg))
(assert (= n_2158 flted_11_2134))
(assert (= m1_2159 flted_23_2153))
(assert (= ys1_2160 mi_2154))
(assert (= yl1_2161 ma_2155))
(assert (<= 0 flted_23_2153))
(assert (<= mi_2154 ma_2155))
(assert (<= 0 flted_11_2134))
(assert (= flted_101_2168 (+ m1_2159 n_2158)))
(assert (<= 0 n_2158))
(assert (<= 0 m1_2159))
(assert (<= ys1_2160 yl1_2161))
(assert (= x_primed 1))
(assert (or (and (and (< y_primed 1) (= flted_101_2168 0)) (<= Anon_2169 Anon_2170)) (and (and (<= Anon_2169 Anon_2170) (<= 1 flted_101_2168)) (> y_primed 0))))
(assert (or (and (< q_2136 1) (= n_2158 0)) (and (<= 1 n_2158) (> q_2136 0))))
;Negation of Consequence
(assert (not false))
(check-sat)