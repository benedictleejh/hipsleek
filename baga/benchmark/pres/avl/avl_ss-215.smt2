(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height2_4305 () Int)
(declare-fun height1_4302 () Int)
(declare-fun h_4296 () Int)
(declare-fun h_4292 () Int)
(declare-fun h_4223 () Int)
(declare-fun n_4207 () Int)
(declare-fun n_4249 () Int)
(declare-fun h_4286 () Int)
(declare-fun height2_4258 () Int)
(declare-fun height1_4255 () Int)
(declare-fun n_4226 () Int)
(declare-fun h_4217 () Int)
(declare-fun height2_4235 () Int)
(declare-fun height1_4232 () Int)
(declare-fun an_4176 () Int)
(declare-fun h_4197 () Int)
(declare-fun n () Int)
(declare-fun n_4200 () Int)
(declare-fun n_4181 () Int)
(declare-fun an () Int)
(declare-fun cn () Int)
(declare-fun bn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((max_4339 Int)) (and (= h_4296 (+ 1 max_4339)) (or (and (= max_4339 height1_4302) (>= height1_4302 height2_4305)) (and (= max_4339 height2_4305) (< height1_4302 height2_4305))))))
(assert (= height2_4305 n_4249))
(assert (= height1_4302 n_4226))
(assert (= h_4296 (+ 1 h_4292)))
(assert (or (and (= h_4292 n_4226) (>= n_4226 n_4249)) (and (= h_4292 n_4249) (< n_4226 n_4249))))
(assert (<= 0 n_4200))
(assert (<= 0 n_4207))
(assert (<= 0 n))
(assert (= h_4286 (+ 1 h_4223)))
(assert (or (and (= h_4223 n_4200) (>= n_4200 n_4207)) (and (= h_4223 n_4207) (< n_4200 n_4207))))
(assert (<= 0 an_4176))
(assert (= n_4207 an_4176))
(assert (= h_4217 (+ 1 h_4197)))
(assert (= height2_4258 n_4207))
(assert (<= 0 n_4226))
(assert (<= 0 n_4249))
(assert (exists ((max_4337 Int)) (and (= n_4249 (+ 1 max_4337)) (or (and (= max_4337 height1_4255) (>= height1_4255 height2_4258)) (and (= max_4337 height2_4258) (< height1_4255 height2_4258))))))
(assert (= h_4286 n_4249))
(assert (or (and (= h_4286 (+ height1_4255 1)) (<= height2_4258 height1_4255)) (and (= h_4286 (+ height2_4258 1)) (< height1_4255 height2_4258))))
(assert (<= height2_4258 (+ 1 height1_4255)))
(assert (<= height1_4255 (+ 1 height2_4258)))
(assert (= height1_4255 n_4200))
(assert (exists ((max_4338 Int)) (and (= n_4226 (+ 1 max_4338)) (or (and (= max_4338 height1_4232) (>= height1_4232 height2_4235)) (and (= max_4338 height2_4235) (< height1_4232 height2_4235))))))
(assert (= h_4217 n_4226))
(assert (or (and (= h_4217 (+ height1_4232 1)) (<= height2_4235 height1_4232)) (and (= h_4217 (+ height2_4235 1)) (< height1_4232 height2_4235))))
(assert (<= height2_4235 (+ 1 height1_4232)))
(assert (<= height1_4232 (+ 1 height2_4235)))
(assert (= height2_4235 n_4181))
(assert (= height1_4232 n))
(assert (= an_4176 an))
(assert (= n an))
(assert (<= 0 an))
(assert (or (and (= h_4197 n) (>= n n_4181)) (and (= h_4197 n_4181) (< n n_4181))))
(assert (= n_4200 cn))
(assert (<= 0 cn))
(assert (<= 0 n_4181))
(assert (<= 0 bn))
(assert (= n_4181 bn))
(assert (or (and (= an bn) (>= bn cn)) (and (= an cn) (< bn cn))))
(assert (<= (+ 0 bn) (+ cn 1)))
(assert (<= cn (+ 1 bn)))
;Negation of Consequence
(assert (not (<= 0 bn)))
(check-sat)