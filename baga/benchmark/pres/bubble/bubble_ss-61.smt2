(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_69_1380_primed () Int)
(declare-fun Anon_1499 () Int)
(declare-fun flted_9_1576 () Int)
(declare-fun l_1526 () Int)
(declare-fun sm_1575 () Int)
(declare-fun s_1525 () Int)
(declare-fun v_bool_62_1389_primed () Int)
(declare-fun xs_primed () Int)
(declare-fun xs () Int)
(declare-fun n () Int)
(declare-fun flted_19_1498 () Int)
(declare-fun n_1512 () Int)
(declare-fun tmp_1664 () Int)
(declare-fun flag_1663 () Int)
(declare-fun res () Int)
(declare-fun v_boolean_76_1388_primed () Int)
(declare-fun q_1670 () Int)
(declare-fun r_1500 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_69_1380_primed 0))
(assert (<= Anon_1499 sm_1575))
(assert (< flted_9_1576 1))
(assert (= s_1525 l_1526))
(assert (= n_1512 1))
(assert (= sm_1575 s_1525))
(assert (not (> v_bool_62_1389_primed 0)))
(assert (> r_1500 0))
(assert (< 0 n))
(assert (= xs_primed xs))
(assert (= (+ flted_19_1498 1) n))
(assert (= n_1512 flted_19_1498))
(assert (<= 0 flted_19_1498))
(assert (<= 0 n_1512))
(assert (not (> v_boolean_76_1388_primed 0)))
(assert (not (> tmp_1664 0)))
(assert (not (> flag_1663 0)))
(assert (= res v_boolean_76_1388_primed))
(assert (= q_1670 r_1500))
;Negation of Consequence
(assert (not false))
(check-sat)