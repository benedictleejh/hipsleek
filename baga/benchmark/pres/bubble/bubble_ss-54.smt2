(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flag_primed () Int)
(declare-fun val_73_1616 () Int)
(declare-fun val_72_1606 () Int)
(declare-fun Anon_1585 () Int)
(declare-fun Anon_1499 () Int)
(declare-fun tmp_primed () Int)
(declare-fun flted_19_1498 () Int)
(declare-fun xs () Int)
(declare-fun n () Int)
(declare-fun v_bool_62_1389_primed () Int)
(declare-fun n_1512 () Int)
(declare-fun xnv_primed () Int)
(declare-fun xv_primed () Int)
(declare-fun v_bool_69_1380_primed () Int)
(declare-fun flted_19_1584 () Int)
(declare-fun r_1586 () Int)
(declare-fun xs_primed () Int)
(declare-fun r_1500 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> flag_primed 0))
(assert (= val_73_1616 Anon_1585))
(assert (= val_72_1606 Anon_1499))
(assert (= xnv_primed Anon_1585))
(assert (= xv_primed Anon_1499))
(assert (<= 0 n_1512))
(assert (> tmp_primed 0))
(assert (<= 0 flted_19_1498))
(assert (= n_1512 flted_19_1498))
(assert (= (+ flted_19_1498 1) n))
(assert (= xs_primed xs))
(assert (< 0 n))
(assert (> r_1500 0))
(assert (not (> v_bool_62_1389_primed 0)))
(assert (= (+ flted_19_1584 1) n_1512))
(assert (< xnv_primed xv_primed))
(assert (not (> v_bool_69_1380_primed 0)))
(assert (or (and (< r_1586 1) (= flted_19_1584 0)) (and (<= 1 flted_19_1584) (> r_1586 0))))
(assert (= xs_primed 1))
(assert (= r_1500 2))
(assert (not (= xs_primed r_1500)))
;Negation of Consequence
(assert (not false))
(check-sat)