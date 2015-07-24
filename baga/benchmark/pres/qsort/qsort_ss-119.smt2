(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun xsnext_primed () Int)
(declare-fun xsval_primed () Int)
(declare-fun v_bool_81_1352_primed () Int)
(declare-fun n_1951 () Int)
(declare-fun xs () Int)
(declare-fun xs_primed () Int)
(declare-fun v_bool_74_1366_primed () Int)
(declare-fun bg_1943 () Int)
(declare-fun sm_1942 () Int)
(declare-fun bg () Int)
(declare-fun sm () Int)
(declare-fun d_1945 () Int)
(declare-fun flted_9_1944 () Int)
(declare-fun n () Int)
(declare-fun b_primed () Int)
(declare-fun sm_1952 () Int)
(declare-fun a_1971 () Int)
(declare-fun xsnext_1973 () Int)
(declare-fun v_primed () Int)
(declare-fun bg_1953 () Int)
(declare-fun b_1972 () Int)
(declare-fun tmp_2079 () Int)
(declare-fun tmp_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= xsnext_primed xsnext_1973))
(assert (= xsval_primed d_1945))
(assert (not (> v_bool_81_1352_primed 0)))
(assert (< tmp_2079 1))
(assert (<= 0 n_1951))
(assert (= n_1951 (+ b_1972 a_1971)))
(assert (<= 0 flted_9_1944))
(assert (= bg_1953 bg_1943))
(assert (= sm_1952 sm_1942))
(assert (= n_1951 flted_9_1944))
(assert (= v_primed d_1945))
(assert (= xs_primed xs))
(assert (< 0 n))
(assert (> xs_primed 0))
(assert (> v_bool_74_1366_primed 0))
(assert (= bg_1943 bg))
(assert (= sm_1942 sm))
(assert (< d_1945 bg))
(assert (<= sm d_1945))
(assert (= (+ flted_9_1944 1) n))
(assert (> xsnext_1973 0))
(assert (not (> b_primed 0)))
(assert (or (and (< xsnext_1973 1) (= a_1971 0)) (and (and (< sm_1952 v_primed) (<= 1 a_1971)) (> xsnext_1973 0))))
(assert (or (and (< tmp_2079 1) (= b_1972 0)) (and (and (< v_primed bg_1953) (<= 1 b_1972)) (> tmp_2079 0))))
(assert (= tmp_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)