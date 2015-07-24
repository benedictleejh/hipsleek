(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun c_primed () Int)
(declare-fun a_primed () Int)
(declare-fun na_8515 () Int)
(declare-fun flted_238_8359 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_238_8356 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun h_8518 () Int)
(declare-fun flted_238_8355 () Int)
(declare-fun h () Int)
(declare-fun Anon_8353 () Int)
(declare-fun v_node_249_3866_primed () Int)
(declare-fun v_node_249_3865_primed () Int)
(declare-fun flted_12_8490 () Int)
(declare-fun r_8497 () Int)
(declare-fun cl () Int)
(declare-fun r_8351 () Int)
(declare-fun nd () Int)
(declare-fun nc_8517 () Int)
(declare-fun bh () Int)
(declare-fun n () Int)
(declare-fun nb () Int)
(declare-fun nr_8352 () Int)
(declare-fun bhr_8354 () Int)
(declare-fun flted_238_8357 () Int)
(declare-fun nl_8348 () Int)
(declare-fun bhl_8350 () Int)
(declare-fun bhr_8499 () Int)
(declare-fun bh_8378 () Int)
(declare-fun n_8376 () Int)
(declare-fun nr_8498 () Int)
(declare-fun v_node_249_3867_primed () Int)
(declare-fun flted_12_8491 () Int)
(declare-fun bhl_8496 () Int)
(declare-fun nl_8495 () Int)
(declare-fun l_8494 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> c 0))
(assert (= flted_238_8356 0))
(assert (= flted_238_8359 0))
(assert (= c_primed c))
(assert (= a_primed a))
(assert (= na_8515 na))
(assert (or (and (and (and (= flted_238_8359 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_238_8359 0)) (and (and (and (= flted_238_8359 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_238_8356 0) (<= 2 flted_238_8355)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= flted_238_8355 1)) (= flted_238_8356 0)) (and (and (and (= flted_238_8356 1) (<= 1 flted_238_8355)) (<= 1 nc)) (> c 0)))))
(assert (= h_8518 h))
(assert (<= Anon_8353 1))
(assert (<= 0 Anon_8353))
(assert (= flted_12_8490 0))
(assert (<= 1 bhl_8350))
(assert (<= 0 nl_8348))
(assert (= flted_238_8355 (+ 1 h)))
(assert (= flted_238_8357 (+ 1 h)))
(assert (= cl Anon_8353))
(assert (= cl 0))
(assert (<= 0 cl))
(assert (<= cl 1))
(assert (= v_node_249_3866_primed r_8497))
(assert (= v_node_249_3865_primed r_8351))
(assert (or (and (and (and (= flted_12_8490 0) (<= 2 bhr_8499)) (<= 1 nr_8498)) (> r_8497 0)) (or (and (and (and (< r_8497 1) (= nr_8498 0)) (= bhr_8499 1)) (= flted_12_8490 0)) (and (and (and (= flted_12_8490 1) (<= 1 bhr_8499)) (<= 1 nr_8498)) (> r_8497 0)))))
(assert (or (and (and (and (= cl 0) (<= 2 bh)) (<= 1 n)) (> r_8351 0)) (or (and (and (and (< r_8351 1) (= n 0)) (= bh 1)) (= cl 0)) (and (and (and (= cl 1) (<= 1 bh)) (<= 1 n)) (> r_8351 0)))))
(assert (= nd n))
(assert (= nc_8517 nr_8498))
(assert (<= 1 bh))
(assert (<= 0 n))
(assert (<= 1 bhr_8354))
(assert (<= 0 nr_8352))
(assert (= bh bhr_8354))
(assert (= n nr_8352))
(assert (= nb (+ (+ nr_8352 1) nl_8348)))
(assert (= bhl_8350 bhr_8354))
(assert (= flted_238_8357 (+ bhl_8350 1)))
(assert (= n_8376 nl_8348))
(assert (= bh_8378 bhl_8350))
(assert (<= 0 n_8376))
(assert (<= 1 bh_8378))
(assert (= bhr_8499 bh_8378))
(assert (= bhl_8496 bh_8378))
(assert (= flted_12_8491 0))
(assert (= n_8376 (+ (+ nr_8498 1) nl_8495)))
(assert (= v_node_249_3867_primed l_8494))
(assert (or (and (and (and (= flted_12_8491 0) (<= 2 bhl_8496)) (<= 1 nl_8495)) (> l_8494 0)) (or (and (and (and (< l_8494 1) (= nl_8495 0)) (= bhl_8496 1)) (= flted_12_8491 0)) (and (and (and (= flted_12_8491 1) (<= 1 bhl_8496)) (<= 1 nl_8495)) (> l_8494 0)))))
;Negation of Consequence
(assert (not (or (= nl_8495 0) (< l_8494 1))))
(check-sat)