(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_1499 () Int)
(declare-fun tmp_primed () Int)
(declare-fun flted_19_1498 () Int)
(declare-fun xs () Int)
(declare-fun n () Int)
(declare-fun v_bool_62_1389_primed () Int)
(declare-fun sm_1575 () Int)
(declare-fun n_1512 () Int)
(declare-fun s_1525 () Int)
(declare-fun l_1526 () Int)
(declare-fun flted_9_1576 () Int)
(declare-fun xv_primed () Int)
(declare-fun xnv_primed () Int)
(declare-fun v_bool_69_1380_primed () Int)
(declare-fun xs_primed () Int)
(declare-fun r_1500 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= xnv_primed sm_1575))
(assert (= xv_primed Anon_1499))
(assert (<= 0 n_1512))
(assert (not (> tmp_primed 0)))
(assert (<= 0 flted_19_1498))
(assert (= n_1512 flted_19_1498))
(assert (= (+ flted_19_1498 1) n))
(assert (= xs_primed xs))
(assert (< 0 n))
(assert (> r_1500 0))
(assert (not (> v_bool_62_1389_primed 0)))
(assert (= sm_1575 s_1525))
(assert (= n_1512 1))
(assert (= s_1525 l_1526))
(assert (< flted_9_1576 1))
(assert (<= xv_primed xnv_primed))
(assert (> v_bool_69_1380_primed 0))
(assert (= xs_primed 1))
(assert (= r_1500 2))
(assert (not (= xs_primed r_1500)))
;Negation of Consequence
(assert (not false))
(check-sat)