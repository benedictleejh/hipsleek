(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun lg_2060 () Int)
(declare-fun sm_2059 () Int)
(declare-fun x () Int)
(declare-fun a () Int)
(declare-fun v_bool_269_1422_primed () Int)
(declare-fun lg_2029 () Int)
(declare-fun lg () Int)
(declare-fun sm () Int)
(declare-fun qs_2031 () Int)
(declare-fun v_bool_273_1421_primed () Int)
(declare-fun v_2032 () Int)
(declare-fun a_primed () Int)
(declare-fun v_bool_287_1420_primed () Int)
(declare-fun sm_2028 () Int)
(declare-fun pl_2030 () Int)
(declare-fun p_2033 () Int)
(declare-fun s_2131 () Int)
(declare-fun l_2132 () Int)
(declare-fun xright_2133 () Int)
(declare-fun x_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= sm_2059 lg_2060))
(assert (<= l_2132 lg_2060))
(assert (<= sm_2059 s_2131))
(assert (<= qs_2031 lg_2029))
(assert (= lg_2060 lg_2029))
(assert (= sm_2059 qs_2031))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (> x_primed 0))
(assert (> v_bool_269_1422_primed 0))
(assert (= lg_2029 lg))
(assert (= sm_2028 sm))
(assert (<= v_2032 qs_2031))
(assert (<= pl_2030 v_2032))
(assert (not (= v_2032 a_primed)))
(assert (not (> v_bool_273_1421_primed 0)))
(assert (< v_2032 a_primed))
(assert (> v_bool_287_1420_primed 0))
(assert (or (and (< p_2033 1) (<= sm_2028 pl_2030)) (and (<= sm_2028 pl_2030) (> p_2033 0))))
(assert (or (and (< xright_2133 1) (<= s_2131 l_2132)) (and (<= s_2131 l_2132) (> xright_2133 0))))
(assert (= x_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)