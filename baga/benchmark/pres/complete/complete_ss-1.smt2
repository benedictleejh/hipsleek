(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n () Int)
(declare-fun nmin () Int)
(declare-fun self () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((nmin2 Int)) (and (exists ((r Int)) (exists ((flted_26_36 Int)) (and (= (+ flted_26_36 1) n) (or (and (and (<= 1 nmin2) (<= nmin2 flted_26_36)) (> r 0)) (or (and (and (< r 1) (= flted_26_36 0)) (= nmin2 0)) (and (and (<= 1 nmin2) (< nmin2 flted_26_36)) (> r 0))))))) (exists ((nmin1 Int)) (and (exists ((l Int)) (exists ((flted_26_37 Int)) (and (= (+ flted_26_37 1) n) (or (and (and (<= 1 nmin1) (<= nmin1 flted_26_37)) (> l 0)) (or (and (and (< l 1) (= flted_26_37 0)) (= nmin1 0)) (and (and (<= 1 nmin1) (< nmin1 flted_26_37)) (> l 0))))))) (exists ((min_32 Int)) (and (= nmin (+ 1 min_32)) (or (and (= min_32 nmin1) (< nmin1 nmin2)) (and (= min_32 nmin2) (>= nmin1 nmin2))))))))))
(assert (= self 1))
;Negation of Consequence
(assert (not false))
(check-sat)