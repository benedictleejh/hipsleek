(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_49_3265 () Int)
(declare-fun flted_49_3266 () Int)
(declare-fun n () Int)
(declare-fun n1_3305 () Int)
(declare-fun n2_3308 () Int)
(declare-fun h_3282 () Int)
(declare-fun lln () Int)
(declare-fun h_3286 () Int)
(declare-fun n1_3292 () Int)
(declare-fun n2_3295 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 lln))
(assert (<= 0 flted_49_3266))
(assert (<= 0 n))
(assert (= h_3282 (+ 1 n)))
(assert (<= 0 flted_49_3265))
(assert (= n flted_49_3265))
(assert (= (+ flted_49_3266 1) lln))
(assert (= (+ flted_49_3265 1) lln))
(assert (= n1_3305 flted_49_3266))
(assert (= n2_3308 n))
(assert (<= n1_3305 (+ 1 n2_3308)))
(assert (<= (+ 0 n2_3308) (+ n1_3305 1)))
(assert (or (and (= h_3282 (+ n1_3305 1)) (<= n2_3308 n1_3305)) (and (= h_3282 (+ n2_3308 1)) (< n1_3305 n2_3308))))
(assert (exists ((max_3320 Int)) (and (= n2_3295 (+ 1 max_3320)) (or (and (= max_3320 n1_3305) (>= n1_3305 n2_3308)) (and (= max_3320 n2_3308) (< n1_3305 n2_3308))))))
(assert (= h_3282 n2_3295))
(assert (= h_3286 (+ 1 h_3282)))
(assert (= n1_3292 lln))
;Negation of Consequence
(assert (not (or (and (= h_3286 (+ 1 n1_3292)) (<= n2_3295 n1_3292)) (and (= h_3286 (+ 1 n2_3295)) (< n1_3292 n2_3295)))))
(check-sat)