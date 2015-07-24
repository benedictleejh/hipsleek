(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_164_1528_primed () Int)
(declare-fun v_2408 () Int)
(declare-fun sm () Int)
(declare-fun lg () Int)
(declare-fun v_bool_160_1529_primed () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun qs_2407 () Int)
(declare-fun lg_2405 () Int)
(declare-fun a_primed () Int)
(declare-fun sm_2443 () Int)
(declare-fun lg_2444 () Int)
(declare-fun right_172_2458 () Int)
(declare-fun q_2410 () Int)
(declare-fun res () Int)
(declare-fun sm_2404 () Int)
(declare-fun pl_2406 () Int)
(declare-fun p_2409 () Int)
(declare-fun mi_2456 () Int)
(declare-fun ma_2457 () Int)
(declare-fun v_node2_172_2512 () Int)
(declare-fun x_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (not (> v_bool_164_1528_primed 0)))
(assert (< v_2408 a_primed))
(assert (<= pl_2406 v_2408))
(assert (<= v_2408 qs_2407))
(assert (= sm_2404 sm))
(assert (= lg_2405 lg))
(assert (not (> v_bool_160_1529_primed 0)))
(assert (> x_primed 0))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= sm_2443 qs_2407))
(assert (= lg_2444 lg_2405))
(assert (<= qs_2407 lg_2405))
(assert (> v_node2_172_2512 0))
(assert (or (and (= mi_2456 sm_2443) (< sm_2443 a_primed)) (and (= mi_2456 a_primed) (>= sm_2443 a_primed))))
(assert (or (and (= ma_2457 lg_2444) (>= lg_2444 a_primed)) (and (= ma_2457 a_primed) (< lg_2444 a_primed))))
(assert (<= sm_2443 lg_2444))
(assert (= right_172_2458 q_2410))
(assert (= res x_primed))
(assert (or (and (< p_2409 1) (<= sm_2404 pl_2406)) (and (<= sm_2404 pl_2406) (> p_2409 0))))
(assert (or (and (< v_node2_172_2512 1) (<= mi_2456 ma_2457)) (and (<= mi_2456 ma_2457) (> v_node2_172_2512 0))))
(assert (= x_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)