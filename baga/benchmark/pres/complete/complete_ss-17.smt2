(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun l_1659 () Int)
(declare-fun v_int_62_1518_primed () Int)
(declare-fun nmin_1675 () Int)
(declare-fun n_1674 () Int)
(declare-fun flted_25_1657 () Int)
(declare-fun n () Int)
(declare-fun nmin () Int)
(declare-fun nmin1_1660 () Int)
(declare-fun v_node2_62_1515_primed () Int)
(declare-fun flted_25_1656 () Int)
(declare-fun nmin2_1662 () Int)
(declare-fun r_1661 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (or (and (and (<= 1 nmin_1675) (<= nmin_1675 n_1674)) (> l_1659 0)) (or (and (and (< l_1659 1) (= n_1674 0)) (= nmin_1675 0)) (and (and (<= 1 nmin_1675) (< nmin_1675 n_1674)) (> l_1659 0)))))
(assert (<= nmin_1675 n_1674))
(assert (<= 0 nmin_1675))
(assert (= v_int_62_1518_primed n_1674))
(assert (<= nmin1_1660 flted_25_1657))
(assert (<= 0 nmin1_1660))
(assert (= nmin_1675 nmin1_1660))
(assert (= n_1674 flted_25_1657))
(assert (= (+ flted_25_1657 1) n))
(assert (= (+ flted_25_1656 2) n))
(assert (exists ((min_1696 Int)) (and (= nmin (+ 1 min_1696)) (or (and (= min_1696 nmin1_1660) (< nmin1_1660 nmin2_1662)) (and (= min_1696 nmin2_1662) (>= nmin1_1660 nmin2_1662))))))
(assert (= v_node2_62_1515_primed r_1661))
(assert (or (and (and (<= 1 nmin2_1662) (<= nmin2_1662 flted_25_1656)) (> r_1661 0)) (or (and (and (< r_1661 1) (= flted_25_1656 0)) (= nmin2_1662 0)) (and (and (<= 1 nmin2_1662) (< nmin2_1662 flted_25_1656)) (> r_1661 0)))))
;Negation of Consequence
(assert (not (or (= flted_25_1656 0) (or (= nmin2_1662 0) (< r_1661 1)))))
(check-sat)