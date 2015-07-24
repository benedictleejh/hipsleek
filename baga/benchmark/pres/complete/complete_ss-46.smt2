(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun l_1730 () Int)
(declare-fun l_1659 () Int)
(declare-fun nmin1_1731 () Int)
(declare-fun res () Int)
(declare-fun v_int_62_1522_primed () Int)
(declare-fun nmin_1675 () Int)
(declare-fun flted_25_1657 () Int)
(declare-fun nmin () Int)
(declare-fun nmin1_1660 () Int)
(declare-fun n () Int)
(declare-fun flted_25_1656 () Int)
(declare-fun nmin2_1662 () Int)
(declare-fun n_1674 () Int)
(declare-fun v_int_62_1719 () Int)
(declare-fun r_1732 () Int)
(declare-fun n_1692 () Int)
(declare-fun nmin_1693 () Int)
(declare-fun r_1661 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ flted_25_1657 1) n))
(assert (= l_1730 l_1659))
(assert (or (and (and (<= 1 nmin_1675) (<= nmin_1675 n_1674)) (> l_1659 0)) (or (and (and (< l_1659 1) (= n_1674 0)) (= nmin_1675 0)) (and (and (<= 1 nmin_1675) (< nmin_1675 n_1674)) (> l_1659 0)))))
(assert (= nmin1_1731 nmin_1675))
(assert (= res v_int_62_1522_primed))
(assert (= v_int_62_1522_primed (+ 1 v_int_62_1719)))
(assert (<= nmin2_1662 flted_25_1656))
(assert (<= 0 nmin2_1662))
(assert (<= nmin_1675 n_1674))
(assert (<= 0 nmin_1675))
(assert (<= nmin1_1660 flted_25_1657))
(assert (<= 0 nmin1_1660))
(assert (= nmin_1675 nmin1_1660))
(assert (= n_1674 flted_25_1657))
(assert (exists ((min_1753 Int)) (and (= nmin (+ 1 min_1753)) (or (and (= min_1753 nmin1_1660) (< nmin1_1660 nmin2_1662)) (and (= min_1753 nmin2_1662) (>= nmin1_1660 nmin2_1662))))))
(assert (= (+ flted_25_1656 2) n))
(assert (= n_1692 flted_25_1656))
(assert (= nmin_1693 nmin2_1662))
(assert (<= 0 nmin_1693))
(assert (<= nmin_1693 n_1692))
(assert (or (< n_1674 n_1692) (= v_int_62_1719 n_1674)))
(assert (or (<= n_1692 n_1674) (= v_int_62_1719 n_1692)))
(assert (= r_1732 r_1661))
(assert (or (and (and (<= 1 nmin_1693) (<= nmin_1693 n_1692)) (> r_1661 0)) (or (and (and (< r_1661 1) (= n_1692 0)) (= nmin_1693 0)) (and (and (<= 1 nmin_1693) (< nmin_1693 n_1692)) (> r_1661 0)))))
;Negation of Consequence
(assert (not (or (= n_1692 0) (or (= nmin_1693 0) (< r_1661 1)))))
(check-sat)