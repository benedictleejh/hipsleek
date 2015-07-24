(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_3383 () Int)
(declare-fun xheight_primed () Int)
(declare-fun n_3367 () Int)
(declare-fun n () Int)
(declare-fun n1_3371 () Int)
(declare-fun n2_3374 () Int)
(declare-fun xleftheight_primed () Int)
(declare-fun n_3403 () Int)
(declare-fun Anon_3397 () Int)
(declare-fun n_3451 () Int)
(declare-fun n_3393 () Int)
(declare-fun n1_3455 () Int)
(declare-fun n2_3458 () Int)
(declare-fun n_3460 () Int)
(declare-fun an () Int)
(declare-fun n_3507 () Int)
(declare-fun n_3469 () Int)
(declare-fun n_3565 () Int)
(declare-fun n_3516 () Int)
(declare-fun n1_3569 () Int)
(declare-fun n2_3572 () Int)
(declare-fun cn () Int)
(declare-fun bn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n2_3374))
(assert (<= 0 n_3383))
(assert (<= 0 n1_3371))
(assert (= n_3383 n1_3371))
(assert (= xheight_primed n_3367))
(assert (= n_3367 n))
(assert (<= (+ 0 n2_3374) (+ n1_3371 1)))
(assert (<= n1_3371 (+ 1 n2_3374)))
(assert (exists ((max_3616 Int)) (and (= n (+ 1 max_3616)) (or (and (= max_3616 n1_3371) (>= n1_3371 n2_3374)) (and (= max_3616 n2_3374) (< n1_3371 n2_3374))))))
(assert (= n_3403 n2_3374))
(assert (<= 0 n_3403))
(assert (<= 0 n_3460))
(assert (<= 0 n2_3458))
(assert (<= 0 n1_3455))
(assert (= xleftheight_primed n_3451))
(assert (= (+ 2 n_3403) n_3393))
(assert (<= 0 n_3393))
(assert (<= 0 Anon_3397))
(assert (= n_3393 Anon_3397))
(assert (= n_3451 n_3393))
(assert (<= n_3460 n_3469))
(assert (<= (+ 0 n2_3458) (+ n1_3455 1)))
(assert (<= n1_3455 (+ 1 n2_3458)))
(assert (exists ((max_3617 Int)) (and (= n_3393 (+ 1 max_3617)) (or (and (= max_3617 n1_3455) (>= n1_3455 n2_3458)) (and (= max_3617 n2_3458) (< n1_3455 n2_3458))))))
(assert (= n_3460 n1_3455))
(assert (= n_3469 n2_3458))
(assert (= n_3507 n_3460))
(assert (<= 0 n_3507))
(assert (<= 0 n1_3569))
(assert (<= 0 n2_3572))
(assert (= an n_3507))
(assert (= (+ n_3507 1) n_3516))
(assert (<= 0 n_3516))
(assert (<= 0 n_3469))
(assert (= n_3516 n_3469))
(assert (= n_3565 n_3516))
(assert (exists ((max_3618 Int)) (and (= n_3516 (+ 1 max_3618)) (or (and (= max_3618 n1_3569) (>= n1_3569 n2_3572)) (and (= max_3618 n2_3572) (< n1_3569 n2_3572))))))
(assert (<= n1_3569 (+ 1 n2_3572)))
(assert (<= (+ 0 n2_3572) (+ n1_3569 1)))
(assert (= bn n1_3569))
(assert (= cn n2_3572))
;Negation of Consequence
(assert (not (<= (+ cn 0) (+ 1 bn))))
(check-sat)