(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun p_2495 () Int)
(declare-fun v_node2_167_2491 () Int)
(declare-fun sm () Int)
(declare-fun ma_2437 () Int)
(declare-fun mi_2436 () Int)
(declare-fun sm_2423 () Int)
(declare-fun sm_2404 () Int)
(declare-fun lg_2424 () Int)
(declare-fun a () Int)
(declare-fun v_2494 () Int)
(declare-fun a_primed () Int)
(declare-fun pl_2406 () Int)
(declare-fun v_2408 () Int)
(declare-fun lg () Int)
(declare-fun q_2496 () Int)
(declare-fun qs_2407 () Int)
(declare-fun lg_2405 () Int)
(declare-fun q_2410 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_node2_167_2491 0))
(assert (= p_2495 v_node2_167_2491))
(assert (or (and (< v_node2_167_2491 1) (<= mi_2436 ma_2437)) (and (<= mi_2436 ma_2437) (> v_node2_167_2491 0))))
(assert (= sm_2404 sm))
(assert (= sm_2423 sm_2404))
(assert (<= sm_2423 lg_2424))
(assert (or (and (= ma_2437 lg_2424) (>= lg_2424 a_primed)) (and (= ma_2437 a_primed) (< lg_2424 a_primed))))
(assert (or (and (= mi_2436 sm_2423) (< sm_2423 a_primed)) (and (= mi_2436 a_primed) (>= sm_2423 a_primed))))
(assert (<= sm_2404 pl_2406))
(assert (= lg_2424 pl_2406))
(assert (= a_primed a))
(assert (= v_2494 v_2408))
(assert (<= a_primed v_2408))
(assert (<= pl_2406 v_2408))
(assert (<= v_2408 qs_2407))
(assert (= lg_2405 lg))
(assert (= q_2496 q_2410))
(assert (or (and (< q_2410 1) (<= qs_2407 lg_2405)) (and (<= qs_2407 lg_2405) (> q_2410 0))))
;Negation of Consequence
(assert (not (< q_2410 1)))
(check-sat)