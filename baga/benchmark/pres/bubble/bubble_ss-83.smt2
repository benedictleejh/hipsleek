(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_69_1380_primed () Int)
(declare-fun Anon_1499 () Int)
(declare-fun sm_1578 () Int)
(declare-fun s_1525 () Int)
(declare-fun l_1526 () Int)
(declare-fun v_bool_62_1389_primed () Int)
(declare-fun xs_primed () Int)
(declare-fun xs () Int)
(declare-fun n () Int)
(declare-fun flted_19_1498 () Int)
(declare-fun n_1512 () Int)
(declare-fun tmp_1724 () Int)
(declare-fun flag_1723 () Int)
(declare-fun res () Int)
(declare-fun v_boolean_76_1388_primed () Int)
(declare-fun q_1730 () Int)
(declare-fun qs_1582 () Int)
(declare-fun lg_1579 () Int)
(declare-fun flted_10_1580 () Int)
(declare-fun r_1500 () Int)
(declare-fun q_1581 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_69_1380_primed 0))
(assert (<= Anon_1499 sm_1578))
(assert (= (+ flted_10_1580 1) n_1512))
(assert (> q_1581 0))
(assert (<= s_1525 qs_1582))
(assert (= sm_1578 s_1525))
(assert (= lg_1579 l_1526))
(assert (not (> v_bool_62_1389_primed 0)))
(assert (> r_1500 0))
(assert (< 0 n))
(assert (= xs_primed xs))
(assert (= (+ flted_19_1498 1) n))
(assert (= n_1512 flted_19_1498))
(assert (<= 0 flted_19_1498))
(assert (<= 0 n_1512))
(assert (not (> v_boolean_76_1388_primed 0)))
(assert (not (> tmp_1724 0)))
(assert (not (> flag_1723 0)))
(assert (= res v_boolean_76_1388_primed))
(assert (= q_1730 r_1500))
(assert (= r_1500 1))
(assert (or (and (and (= lg_1579 qs_1582) (= flted_10_1580 1)) (> q_1581 0)) (and (and (<= qs_1582 lg_1579) (<= 2 flted_10_1580)) (> q_1581 0))))
(assert (not (= r_1500 q_1581)))
;Negation of Consequence
(assert (not false))
(check-sat)