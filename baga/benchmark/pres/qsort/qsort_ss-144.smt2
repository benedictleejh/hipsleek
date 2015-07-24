(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun b2 () Int)
(declare-fun bg_2066 () Int)
(declare-fun bgres_2089 () Int)
(declare-fun bgres_2113 () Int)
(declare-fun smres_2112 () Int)
(declare-fun sm_2092 () Int)
(declare-fun bg_1953 () Int)
(declare-fun sm_1952 () Int)
(declare-fun bg_1943 () Int)
(declare-fun sm_1942 () Int)
(declare-fun bg () Int)
(declare-fun sm () Int)
(declare-fun smres_2088 () Int)
(declare-fun qs_2129 () Int)
(declare-fun sm_2065 () Int)
(declare-fun d_1945 () Int)
(declare-fun bg_2093 () Int)
(declare-fun v_primed () Int)
(declare-fun s2 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bgres_2089 b2))
(assert (< bgres_2089 bg_2066))
(assert (= bg_2066 bg_1953))
(assert (<= smres_2088 bgres_2089))
(assert (<= smres_2112 bgres_2113))
(assert (< bgres_2113 bg_2093))
(assert (<= sm_2092 smres_2112))
(assert (= sm_2092 sm_1952))
(assert (= bg_1953 bg_1943))
(assert (= sm_1952 sm_1942))
(assert (= bg_1943 bg))
(assert (= sm_1942 sm))
(assert (< d_1945 bg))
(assert (<= sm d_1945))
(assert (<= sm_2065 smres_2088))
(assert (= qs_2129 smres_2088))
(assert (<= s2 qs_2129))
(assert (= v_primed s2))
(assert (<= v_primed qs_2129))
(assert (= sm_2065 v_primed))
(assert (= v_primed d_1945))
(assert (= bg_2093 v_primed))
;Negation of Consequence
(assert (not (= v_primed s2)))
(check-sat)