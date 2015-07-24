(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun mx2_3341 () Int)
(declare-fun mx1_3340 () Int)
(declare-fun mx4_3401 () Int)
(declare-fun mx3_3400 () Int)
(declare-fun mx2 () Int)
(declare-fun mx1 () Int)
(declare-fun mx () Int)
(declare-fun mx2_3249 () Int)
(declare-fun mx1_3246 () Int)
(declare-fun d_3243 () Int)
(declare-fun maxi_3402 () Int)
(declare-fun tmp_primed () Int)
(declare-fun v_primed () Int)
(declare-fun tval_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 mx3_3400))
(assert (<= 0 mx4_3401))
(assert (= mx2_3341 mx4_3401))
(assert (= mx1_3340 mx3_3400))
(assert (<= 0 mx2))
(assert (<= 0 mx1))
(assert (or (and (= maxi_3402 mx1) (>= mx1 mx2)) (and (= maxi_3402 mx2) (< mx1 mx2))))
(assert (<= mx4_3401 mx2))
(assert (<= mx3_3400 mx1))
(assert (<= 0 mx1_3246))
(assert (<= 0 mx2_3249))
(assert (= mx2 mx2_3249))
(assert (= mx1 mx1_3246))
(assert (<= d_3243 mx))
(assert (<= mx2_3249 d_3243))
(assert (<= mx1_3246 d_3243))
(assert (<= 0 d_3243))
(assert (= tval_primed d_3243))
(assert (<= 0 v_primed))
(assert (<= v_primed maxi_3402))
(assert (= tmp_primed tval_primed))
;Negation of Consequence
(assert (not (<= v_primed tval_primed)))
(check-sat)