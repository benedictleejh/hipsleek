(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun p_2411 () Int)
(declare-fun p () Int)
(declare-fun v_bool_37_1676_primed () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun n () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun q_2415 () Int)
(declare-fun v_int_49_1674_primed () Int)
(declare-fun a_primed () Int)
(declare-fun self_2412 () Int)
(declare-fun flted_12_2413 () Int)
(declare-fun p_2431 () Int)
(declare-fun p_2425 () Int)
(declare-fun n_2426 () Int)
(declare-fun x_primed () Int)
(declare-fun flted_32_2432 () Int)
(declare-fun v_node2_49_1675_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ flted_12_2413 1) n))
(assert (= p_2411 p))
(assert (= self_2412 x_primed))
(assert (not (> v_bool_37_1676_primed 0)))
(assert (not (= a_primed 1)))
(assert (< tmp_null_primed 1))
(assert (< 0 a))
(assert (< a n))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= v_node2_49_1675_primed q_2415))
(assert (= (+ v_int_49_1674_primed 1) a_primed))
(assert (= p_2425 self_2412))
(assert (= n_2426 flted_12_2413))
(assert (<= 0 flted_12_2413))
(assert (= (+ flted_32_2432 1) n_2426))
(assert (= p_2431 p_2425))
(assert (<= 0 n_2426))
(assert (= x_primed 1))
(assert (or (and (< v_node2_49_1675_primed 1) (= flted_32_2432 0)) (and (<= 1 flted_32_2432) (> v_node2_49_1675_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)