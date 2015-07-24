(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun q_2517 () Int)
(declare-fun v_node2_172_2512 () Int)
(declare-fun lg () Int)
(declare-fun ma_2457 () Int)
(declare-fun lg_2444 () Int)
(declare-fun mi_2456 () Int)
(declare-fun lg_2405 () Int)
(declare-fun sm_2443 () Int)
(declare-fun a () Int)
(declare-fun qs_2407 () Int)
(declare-fun v_2515 () Int)
(declare-fun a_primed () Int)
(declare-fun v_2408 () Int)
(declare-fun sm () Int)
(declare-fun p_2516 () Int)
(declare-fun sm_2404 () Int)
(declare-fun pl_2406 () Int)
(declare-fun p_2409 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_node2_172_2512 0))
(assert (= q_2517 v_node2_172_2512))
(assert (or (and (< v_node2_172_2512 1) (<= mi_2456 ma_2457)) (and (<= mi_2456 ma_2457) (> v_node2_172_2512 0))))
(assert (= lg_2405 lg))
(assert (= lg_2444 lg_2405))
(assert (<= sm_2443 lg_2444))
(assert (or (and (= ma_2457 lg_2444) (>= lg_2444 a_primed)) (and (= ma_2457 a_primed) (< lg_2444 a_primed))))
(assert (or (and (= mi_2456 sm_2443) (< sm_2443 a_primed)) (and (= mi_2456 a_primed) (>= sm_2443 a_primed))))
(assert (<= qs_2407 lg_2405))
(assert (= sm_2443 qs_2407))
(assert (= a_primed a))
(assert (<= v_2408 qs_2407))
(assert (= v_2515 v_2408))
(assert (< v_2408 a_primed))
(assert (<= pl_2406 v_2408))
(assert (= sm_2404 sm))
(assert (= p_2516 p_2409))
(assert (or (and (< p_2409 1) (<= sm_2404 pl_2406)) (and (<= sm_2404 pl_2406) (> p_2409 0))))
;Negation of Consequence
(assert (not (< p_2409 1)))
(check-sat)