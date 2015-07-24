(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_49_3266 () Int)
(declare-fun flted_49_3265 () Int)
(declare-fun n () Int)
(declare-fun lln () Int)
(declare-fun h_3282 () Int)
(declare-fun n1_3305 () Int)
(declare-fun n2_3308 () Int)
(declare-fun h_3286 () Int)
(declare-fun n1_3292 () Int)
(declare-fun n2_3295 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 flted_49_3265))
(assert (<= 0 lln))
(assert (<= 0 flted_49_3266))
(assert (<= 0 n))
(assert (or (and (= h_3282 (+ n1_3305 1)) (<= n2_3308 n1_3305)) (and (= h_3282 (+ n2_3308 1)) (< n1_3305 n2_3308))))
(assert (<= (+ 0 n2_3308) (+ n1_3305 1)))
(assert (<= n1_3305 (+ 1 n2_3308)))
(assert (= n2_3308 n))
(assert (= n1_3305 flted_49_3266))
(assert (= (+ flted_49_3265 1) lln))
(assert (= (+ flted_49_3266 1) lln))
(assert (= n flted_49_3265))
(assert (= h_3282 (+ 1 n)))
(assert (exists ((max_3332 Int)) (and (= h_3286 (+ 1 max_3332)) (or (and (= max_3332 n1_3292) (>= n1_3292 n2_3295)) (and (= max_3332 n2_3295) (< n1_3292 n2_3295))))))
(assert (= n1_3292 lln))
(assert (= h_3286 (+ 1 h_3282)))
(assert (= h_3282 n2_3295))
(assert (exists ((max_3331 Int)) (and (= n2_3295 (+ 1 max_3331)) (or (and (= max_3331 n1_3305) (>= n1_3305 n2_3308)) (and (= max_3331 n2_3308) (< n1_3305 n2_3308))))))
;Negation of Consequence
(assert (not (or (and (= h_3286 (+ 1 n1_3292)) (<= n2_3295 n1_3292)) (and (= h_3286 (+ 1 n2_3295)) (< n1_3292 n2_3295)))))
(check-sat)