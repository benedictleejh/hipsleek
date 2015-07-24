(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_1900 () Int)
(declare-fun flted_26_1895 () Int)
(declare-fun n () Int)
(declare-fun nmin () Int)
(declare-fun nmin2_1901 () Int)
(declare-fun v_node2_71_1463_primed () Int)
(declare-fun flted_26_1896 () Int)
(declare-fun nmin1_1899 () Int)
(declare-fun l_1898 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (or (and (and (<= 1 nmin2_1901) (<= nmin2_1901 flted_26_1895)) (> r_1900 0)) (or (and (and (< r_1900 1) (= flted_26_1895 0)) (= nmin2_1901 0)) (and (and (<= 1 nmin2_1901) (< nmin2_1901 flted_26_1895)) (> r_1900 0)))))
(assert (= (+ flted_26_1895 1) n))
(assert (= (+ flted_26_1896 1) n))
(assert (exists ((min_1912 Int)) (and (= nmin (+ 1 min_1912)) (or (and (= min_1912 nmin1_1899) (< nmin1_1899 nmin2_1901)) (and (= min_1912 nmin2_1901) (>= nmin1_1899 nmin2_1901))))))
(assert (= v_node2_71_1463_primed l_1898))
(assert (or (and (and (<= 1 nmin1_1899) (<= nmin1_1899 flted_26_1896)) (> l_1898 0)) (or (and (and (< l_1898 1) (= flted_26_1896 0)) (= nmin1_1899 0)) (and (and (<= 1 nmin1_1899) (< nmin1_1899 flted_26_1896)) (> l_1898 0)))))
;Negation of Consequence
(assert (not (or (= flted_26_1896 0) (or (= nmin1_1899 0) (< l_1898 1)))))
(check-sat)