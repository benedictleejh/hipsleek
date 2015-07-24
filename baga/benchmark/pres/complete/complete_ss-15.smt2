(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_62_1513_primed () Int)
(declare-fun left_62_1512_primed () Int)
(declare-fun val_62_1511_primed () Int)
(declare-fun Anon_1658 () Int)
(declare-fun v_int_62_1518_primed () Int)
(declare-fun t () Int)
(declare-fun t_primed () Int)
(declare-fun v_bool_61_1524_primed () Int)
(declare-fun nmin () Int)
(declare-fun nmin1_1660 () Int)
(declare-fun flted_25_1657 () Int)
(declare-fun n () Int)
(declare-fun nmin2_1662 () Int)
(declare-fun flted_25_1656 () Int)
(declare-fun r_1661 () Int)
(declare-fun nmin_1675 () Int)
(declare-fun n_1674 () Int)
(declare-fun l_1659 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_62_1513_primed r_1661))
(assert (= left_62_1512_primed l_1659))
(assert (= val_62_1511_primed Anon_1658))
(assert (<= nmin_1675 n_1674))
(assert (<= 0 nmin_1675))
(assert (= v_int_62_1518_primed n_1674))
(assert (<= nmin1_1660 flted_25_1657))
(assert (<= 0 nmin1_1660))
(assert (= nmin_1675 nmin1_1660))
(assert (= n_1674 flted_25_1657))
(assert (= t_primed t))
(assert (> t_primed 0))
(assert (> v_bool_61_1524_primed 0))
(assert (exists ((min_30 Int)) (and (= nmin (+ 1 min_30)) (or (and (= min_30 nmin1_1660) (< nmin1_1660 nmin2_1662)) (and (= min_30 nmin2_1662) (>= nmin1_1660 nmin2_1662))))))
(assert (= (+ flted_25_1656 2) n))
(assert (= (+ flted_25_1657 1) n))
(assert (or (and (and (<= 1 nmin2_1662) (<= nmin2_1662 flted_25_1656)) (> r_1661 0)) (or (and (and (< r_1661 1) (= flted_25_1656 0)) (= nmin2_1662 0)) (and (and (<= 1 nmin2_1662) (< nmin2_1662 flted_25_1656)) (> r_1661 0)))))
(assert (or (and (and (<= 1 nmin_1675) (<= nmin_1675 n_1674)) (> l_1659 0)) (or (and (and (< l_1659 1) (= n_1674 0)) (= nmin_1675 0)) (and (and (<= 1 nmin_1675) (< nmin_1675 n_1674)) (> l_1659 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)