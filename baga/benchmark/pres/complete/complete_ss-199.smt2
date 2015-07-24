(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_2127 () Int)
(declare-fun flted_26_2122 () Int)
(declare-fun n () Int)
(declare-fun nmin () Int)
(declare-fun nmin2_2128 () Int)
(declare-fun v_node2_88_1332_primed () Int)
(declare-fun flted_26_2123 () Int)
(declare-fun nmin1_2126 () Int)
(declare-fun l_2125 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (or (and (and (<= 1 nmin2_2128) (<= nmin2_2128 flted_26_2122)) (> r_2127 0)) (or (and (and (< r_2127 1) (= flted_26_2122 0)) (= nmin2_2128 0)) (and (and (<= 1 nmin2_2128) (< nmin2_2128 flted_26_2122)) (> r_2127 0)))))
(assert (< nmin n))
(assert (= (+ flted_26_2122 1) n))
(assert (= (+ flted_26_2123 1) n))
(assert (exists ((min_2139 Int)) (and (= nmin (+ 1 min_2139)) (or (and (= min_2139 nmin1_2126) (< nmin1_2126 nmin2_2128)) (and (= min_2139 nmin2_2128) (>= nmin1_2126 nmin2_2128))))))
(assert (= v_node2_88_1332_primed l_2125))
(assert (or (and (and (<= 1 nmin1_2126) (<= nmin1_2126 flted_26_2123)) (> l_2125 0)) (or (and (and (< l_2125 1) (= flted_26_2123 0)) (= nmin1_2126 0)) (and (and (<= 1 nmin1_2126) (< nmin1_2126 flted_26_2123)) (> l_2125 0)))))
;Negation of Consequence
(assert (not (or (= flted_26_2123 0) (or (= nmin1_2126 0) (< l_2125 1)))))
(check-sat)