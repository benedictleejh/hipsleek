(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun tmp_2506 () Int)
(declare-fun n1_2512 () Int)
(declare-fun n2_2531 () Int)
(declare-fun n1_2528 () Int)
(declare-fun tmp_2503 () Int)
(declare-fun n2_2515 () Int)
(declare-fun n1_2491 () Int)
(declare-fun n2_2494 () Int)
(declare-fun n_2487 () Int)
(declare-fun nx_2495 () Int)
(declare-fun nx () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((max_2565 Int)) (and (= tmp_2506 (+ 1 max_2565)) (or (and (= max_2565 n1_2512) (>= n1_2512 n2_2515)) (and (= max_2565 n2_2515) (< n1_2512 n2_2515))))))
(assert (= tmp_2506 (+ 1 tmp_2503)))
(assert (<= 0 n1_2491))
(assert (<= 0 n2_2494))
(assert (<= 0 nx_2495))
(assert (exists ((max_2563 Int)) (and (= n1_2512 (+ 1 max_2563)) (or (and (= max_2563 n1_2528) (>= n1_2528 n2_2531)) (and (= max_2563 n2_2531) (< n1_2528 n2_2531))))))
(assert (= n_2487 n1_2512))
(assert (or (and (= n_2487 (+ n1_2528 1)) (<= n2_2531 n1_2528)) (and (= n_2487 (+ n2_2531 1)) (< n1_2528 n2_2531))))
(assert (<= (+ 0 n2_2531) (+ n1_2528 1)))
(assert (<= n1_2528 (+ 1 n2_2531)))
(assert (= n2_2531 n2_2494))
(assert (= n1_2528 n1_2491))
(assert (<= n1_2491 (+ 1 n2_2494)))
(assert (<= (+ 0 n2_2494) (+ n1_2491 1)))
(assert (= tmp_2503 n_2487))
(assert (= n2_2515 nx_2495))
(assert (exists ((max_2564 Int)) (and (= nx (+ 1 max_2564)) (or (and (= max_2564 n1_2491) (>= n1_2491 n2_2494)) (and (= max_2564 n2_2494) (< n1_2491 n2_2494))))))
(assert (= n_2487 nx))
(assert (= nx_2495 nx))
;Negation of Consequence
(assert (not (<= 0 nx)))
(check-sat)