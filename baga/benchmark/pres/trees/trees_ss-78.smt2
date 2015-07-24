(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_275_1401_primed () Int)
(declare-fun v_bool_273_1421_primed () Int)
(declare-fun sm () Int)
(declare-fun lg () Int)
(declare-fun v_bool_269_1422_primed () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun xval_primed () Int)
(declare-fun v_2032 () Int)
(declare-fun xleft_primed () Int)
(declare-fun xright_2048 () Int)
(declare-fun q_2034 () Int)
(declare-fun qs_2031 () Int)
(declare-fun lg_2029 () Int)
(declare-fun res () Int)
(declare-fun s () Int)
(declare-fun b () Int)
(declare-fun sm_2028 () Int)
(declare-fun pl_2030 () Int)
(declare-fun p_2033 () Int)
(declare-fun s1_2050 () Int)
(declare-fun b_2049 () Int)
(declare-fun xright_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (not (> v_bool_275_1401_primed 0)))
(assert (> xright_2048 0))
(assert (> v_bool_273_1421_primed 0))
(assert (= xval_primed a_primed))
(assert (<= pl_2030 v_2032))
(assert (<= v_2032 qs_2031))
(assert (= sm_2028 sm))
(assert (= lg_2029 lg))
(assert (> v_bool_269_1422_primed 0))
(assert (> x_primed 0))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= xval_primed v_2032))
(assert (= xleft_primed p_2033))
(assert (= xright_2048 q_2034))
(assert (= s qs_2031))
(assert (= b lg_2029))
(assert (<= qs_2031 lg_2029))
(assert (<= s res))
(assert (<= res s1_2050))
(assert (= b_2049 b))
(assert (<= s b))
(assert (or (and (< p_2033 1) (<= sm_2028 pl_2030)) (and (<= sm_2028 pl_2030) (> p_2033 0))))
(assert (or (and (< xright_primed 1) (<= s1_2050 b_2049)) (and (<= s1_2050 b_2049) (> xright_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)