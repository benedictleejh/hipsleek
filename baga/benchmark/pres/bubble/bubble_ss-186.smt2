(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_2041 () Int)
(declare-fun r_1586 () Int)
(declare-fun Anon_2040 () Int)
(declare-fun v_bool_69_1380_primed () Int)
(declare-fun flted_19_1584 () Int)
(declare-fun v_bool_62_1389_primed () Int)
(declare-fun xs_primed () Int)
(declare-fun xs () Int)
(declare-fun n () Int)
(declare-fun flted_19_1498 () Int)
(declare-fun tmp_2032 () Int)
(declare-fun n_1512 () Int)
(declare-fun val_72_1606 () Int)
(declare-fun Anon_1499 () Int)
(declare-fun val_73_1616 () Int)
(declare-fun flag_2031 () Int)
(declare-fun res () Int)
(declare-fun v_boolean_76_1388_primed () Int)
(declare-fun Anon_2034 () Int)
(declare-fun Anon_1585 () Int)
(declare-fun r_2035 () Int)
(declare-fun r_1500 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= r_2041 r_1586))
(assert (= Anon_2040 Anon_1499))
(assert (not (> v_bool_69_1380_primed 0)))
(assert (< Anon_1585 Anon_1499))
(assert (= (+ flted_19_1584 1) n_1512))
(assert (not (> v_bool_62_1389_primed 0)))
(assert (> r_1500 0))
(assert (< 0 n))
(assert (= xs_primed xs))
(assert (= (+ flted_19_1498 1) n))
(assert (= n_1512 flted_19_1498))
(assert (<= 0 flted_19_1498))
(assert (> tmp_2032 0))
(assert (<= 0 n_1512))
(assert (= val_72_1606 Anon_1499))
(assert (= val_73_1616 Anon_1585))
(assert (> v_boolean_76_1388_primed 0))
(assert (> flag_2031 0))
(assert (= res v_boolean_76_1388_primed))
(assert (= Anon_2034 Anon_1585))
(assert (= r_2035 r_1500))
;Negation of Consequence
(assert (not false))
(check-sat)