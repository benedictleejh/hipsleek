(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nmin () Int)
(declare-fun nmin1_1782 () Int)
(declare-fun nmin2_1784 () Int)
(declare-fun res () Int)
(declare-fun v_int_62_1522_primed () Int)
(declare-fun nmin2_1670 () Int)
(declare-fun nmin1_1668 () Int)
(declare-fun n () Int)
(declare-fun nmin_1693 () Int)
(declare-fun nmin_1675 () Int)
(declare-fun v_int_62_1777 () Int)
(declare-fun flted_26_1664 () Int)
(declare-fun flted_26_1665 () Int)
(declare-fun n_1674 () Int)
(declare-fun n_1692 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((min_32 Int)) (and (= nmin (+ 1 min_32)) (or (and (= min_32 nmin1_1668) (< nmin1_1668 nmin2_1670)) (and (= min_32 nmin2_1670) (>= nmin1_1668 nmin2_1670))))))
(assert (= nmin1_1782 nmin_1675))
(assert (= nmin2_1784 nmin_1693))
(assert (= res v_int_62_1522_primed))
(assert (= v_int_62_1522_primed (+ 1 v_int_62_1777)))
(assert (<= 0 nmin_1693))
(assert (<= nmin2_1670 flted_26_1664))
(assert (<= 0 nmin2_1670))
(assert (= nmin_1693 nmin2_1670))
(assert (<= 0 nmin_1675))
(assert (<= nmin1_1668 flted_26_1665))
(assert (<= 0 nmin1_1668))
(assert (= nmin_1675 nmin1_1668))
(assert (= (+ flted_26_1664 1) n))
(assert (= (+ flted_26_1665 1) n))
(assert (<= nmin_1693 n_1692))
(assert (<= nmin_1675 n_1674))
(assert (or (<= n_1692 n_1674) (= v_int_62_1777 n_1692)))
(assert (or (< n_1674 n_1692) (= v_int_62_1777 n_1674)))
(assert (= n_1692 flted_26_1664))
(assert (= n_1674 flted_26_1665))
(assert (= (+ 1 n_1674) (+ 2 n_1692)))
;Negation of Consequence
(assert (not false))
(check-sat)