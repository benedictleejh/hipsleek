(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun cl () Int)
(declare-fun n () Int)
(declare-fun bh () Int)
(declare-fun v_bool_87_4884_primed () Int)
(declare-fun x () Int)
(declare-fun flted_12_13628 () Int)
(declare-fun v_int_90_4880_primed () Int)
(declare-fun v_int_90_4879_primed () Int)
(declare-fun x_primed () Int)
(declare-fun flted_12_13627 () Int)
(declare-fun bhl_13632 () Int)
(declare-fun nl_13631 () Int)
(declare-fun l_13630 () Int)
(declare-fun flted_12_13626 () Int)
(declare-fun bhr_13635 () Int)
(declare-fun nr_13634 () Int)
(declare-fun r_13633 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_12_13628 1))
(assert (= flted_12_13627 0))
(assert (= flted_12_13626 0))
(assert (= cl 1))
(assert (= n (+ (+ nr_13634 1) nl_13631)))
(assert (= bhl_13632 bh))
(assert (= bhr_13635 bh))
(assert (not (> v_bool_87_4884_primed 0)))
(assert (> x_primed 0))
(assert (= x_primed x))
(assert (= v_int_90_4880_primed flted_12_13628))
(assert (= v_int_90_4879_primed 0))
(assert (= v_int_90_4880_primed v_int_90_4879_primed))
(assert (= x_primed 1))
(assert (or (and (and (and (= flted_12_13627 0) (<= 2 bhl_13632)) (<= 1 nl_13631)) (> l_13630 0)) (or (and (and (and (< l_13630 1) (= nl_13631 0)) (= bhl_13632 1)) (= flted_12_13627 0)) (and (and (and (= flted_12_13627 1) (<= 1 bhl_13632)) (<= 1 nl_13631)) (> l_13630 0)))))
(assert (or (and (and (and (= flted_12_13626 0) (<= 2 bhr_13635)) (<= 1 nr_13634)) (> r_13633 0)) (or (and (and (and (< r_13633 1) (= nr_13634 0)) (= bhr_13635 1)) (= flted_12_13626 0)) (and (and (and (= flted_12_13626 1) (<= 1 bhr_13635)) (<= 1 nr_13634)) (> r_13633 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)