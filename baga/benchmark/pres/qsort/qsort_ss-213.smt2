(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun qs_2148 () Int)
(declare-fun q_2147 () Int)
(declare-fun b_2234 () Int)
(declare-fun bg_2066 () Int)
(declare-fun sm_2065 () Int)
(declare-fun xsnext_1973 () Int)
(declare-fun sm () Int)
(declare-fun bg () Int)
(declare-fun v_bool_74_1366_primed () Int)
(declare-fun n () Int)
(declare-fun xs () Int)
(declare-fun d_1945 () Int)
(declare-fun sm_1942 () Int)
(declare-fun bg_1953 () Int)
(declare-fun bg_1943 () Int)
(declare-fun flted_9_1944 () Int)
(declare-fun b_1972 () Int)
(declare-fun n_1951 () Int)
(declare-fun tmp_2090 () Int)
(declare-fun v_bool_81_1352_primed () Int)
(declare-fun sm_1952 () Int)
(declare-fun a_1971 () Int)
(declare-fun sm_2092 () Int)
(declare-fun bg_2093 () Int)
(declare-fun n_2064 () Int)
(declare-fun smres_2088 () Int)
(declare-fun bgres_2089 () Int)
(declare-fun tmp_2077 () Int)
(declare-fun n_2091 () Int)
(declare-fun smres_2112 () Int)
(declare-fun bgres_2113 () Int)
(declare-fun flted_51_2232 () Int)
(declare-fun nn () Int)
(declare-fun s0 () Int)
(declare-fun b0 () Int)
(declare-fun xsnext_2114 () Int)
(declare-fun m () Int)
(declare-fun s2 () Int)
(declare-fun b2 () Int)
(declare-fun tmp_2233 () Int)
(declare-fun xs_2204 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ n_2064 1) m))
(assert (= bgres_2089 b2))
(assert (<= s2 qs_2148))
(assert (= qs_2148 smres_2088))
(assert (= q_2147 tmp_2077))
(assert (not (> b_2234 0)))
(assert (<= 0 n_2064))
(assert (< bgres_2089 bg_2066))
(assert (<= sm_2065 smres_2088))
(assert (<= 0 b_1972))
(assert (= bg_2066 bg_1953))
(assert (= sm_2065 s2))
(assert (= n_2064 b_1972))
(assert (> xsnext_1973 0))
(assert (= (+ flted_9_1944 1) n))
(assert (<= sm d_1945))
(assert (< d_1945 bg))
(assert (= sm_1942 sm))
(assert (= bg_1943 bg))
(assert (> v_bool_74_1366_primed 0))
(assert (> xs_2204 0))
(assert (< 0 n))
(assert (= xs_2204 xs))
(assert (= s2 d_1945))
(assert (= n_1951 flted_9_1944))
(assert (= sm_1952 sm_1942))
(assert (= bg_1953 bg_1943))
(assert (<= 0 flted_9_1944))
(assert (= n_1951 (+ b_1972 a_1971)))
(assert (<= 0 n_1951))
(assert (> tmp_2090 0))
(assert (> v_bool_81_1352_primed 0))
(assert (= n_2091 a_1971))
(assert (= sm_2092 sm_1952))
(assert (= bg_2093 s2))
(assert (<= 0 a_1971))
(assert (<= sm_2092 smres_2112))
(assert (< bgres_2113 bg_2093))
(assert (<= 0 n_2091))
(assert (= nn n_2091))
(assert (= s0 smres_2112))
(assert (= b0 bgres_2113))
(assert (<= 1 n_2064))
(assert (<= smres_2088 bgres_2089))
(assert (> tmp_2077 0))
(assert (<= 1 n_2091))
(assert (<= smres_2112 bgres_2113))
(assert (= flted_51_2232 (+ m nn)))
(assert (<= 1 nn))
(assert (<= s0 b0))
(assert (> xsnext_2114 0))
(assert (<= 1 m))
(assert (<= s2 b2))
(assert (> tmp_2233 0))
(assert (= xs_2204 1))
;Negation of Consequence
(assert (not false))
(check-sat)