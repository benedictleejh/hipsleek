(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun h_primed () Int)
(declare-fun h_4223 () Int)
(declare-fun n_4207 () Int)
(declare-fun n_4200 () Int)
(declare-fun h_4217 () Int)
(declare-fun an_4176 () Int)
(declare-fun cn () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun h_4197 () Int)
(declare-fun n () Int)
(declare-fun n_4181 () Int)
(declare-fun height2_4235 () Int)
(declare-fun height1_4232 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_4207))
(assert (<= 0 n_4200))
(assert (= h_primed (+ 1 h_4223)))
(assert (or (and (= h_4223 n_4200) (>= n_4200 n_4207)) (and (= h_4223 n_4207) (< n_4200 n_4207))))
(assert (<= 0 an_4176))
(assert (= n_4207 an_4176))
(assert (<= 0 cn))
(assert (= n_4200 cn))
(assert (= h_4217 (+ 1 h_4197)))
(assert (<= 0 bn))
(assert (<= 0 an))
(assert (<= 0 n))
(assert (<= 0 n_4181))
(assert (= an_4176 an))
(assert (<= cn (+ 1 bn)))
(assert (<= (+ 0 bn) (+ cn 1)))
(assert (or (and (= an bn) (>= bn cn)) (and (= an cn) (< bn cn))))
(assert (= n an))
(assert (= n_4181 bn))
(assert (or (and (= h_4197 n) (>= n n_4181)) (and (= h_4197 n_4181) (< n n_4181))))
(assert (= height1_4232 n))
(assert (= height2_4235 n_4181))
;Negation of Consequence
(assert (not (<= height2_4235 (+ height1_4232 1))))
(check-sat)