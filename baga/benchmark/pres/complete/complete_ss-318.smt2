(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nmin_2151 () Int)
(declare-fun n_2150 () Int)
(declare-fun nmin_2133 () Int)
(declare-fun n_2132 () Int)
(declare-fun flted_26_2123 () Int)
(declare-fun n () Int)
(declare-fun nmin () Int)
(declare-fun nmin1_2126 () Int)
(declare-fun n_2216 () Int)
(declare-fun flted_26_2122 () Int)
(declare-fun nmin2_2128 () Int)
(declare-fun nmin_2217 () Int)
(declare-fun nmin_2235 () Int)
(declare-fun n_2234 () Int)
(declare-fun nmin_2262 () Int)
(declare-fun n_2261 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= n_2150 nmin_2133))
(assert (<= nmin_2151 n_2150))
(assert (<= 0 nmin_2151))
(assert (<= nmin_2133 n_2132))
(assert (<= 0 nmin_2133))
(assert (= nmin_2151 nmin_2133))
(assert (= n_2150 n_2132))
(assert (<= nmin1_2126 flted_26_2123))
(assert (<= 0 nmin1_2126))
(assert (= nmin_2133 nmin1_2126))
(assert (= n_2132 flted_26_2123))
(assert (< nmin n))
(assert (= (+ flted_26_2123 1) n))
(assert (= (+ flted_26_2122 1) n))
(assert (exists ((min_32 Int)) (and (= nmin (+ 1 min_32)) (or (and (= min_32 nmin1_2126) (< nmin1_2126 nmin2_2128)) (and (= min_32 nmin2_2128) (>= nmin1_2126 nmin2_2128))))))
(assert (= n_2216 flted_26_2122))
(assert (<= nmin_2235 n_2234))
(assert (<= 0 nmin_2235))
(assert (<= nmin_2217 n_2216))
(assert (<= 0 nmin_2217))
(assert (= nmin_2235 nmin_2217))
(assert (= n_2234 n_2216))
(assert (<= nmin2_2128 flted_26_2122))
(assert (<= 0 nmin2_2128))
(assert (= nmin_2217 nmin2_2128))
(assert (< nmin_2217 n_2234))
(assert (= nmin_2262 nmin_2235))
(assert (= n_2261 n_2234))
(assert (= nmin_2262 n_2261))
;Negation of Consequence
(assert (not false))
(check-sat)