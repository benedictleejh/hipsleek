(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_62_1578_primed () Int)
(declare-fun p_2551 () Int)
(declare-fun flted_12_2525 () Int)
(declare-fun p_2523 () Int)
(declare-fun p () Int)
(declare-fun self_2524 () Int)
(declare-fun v_bool_59_1592_primed () Int)
(declare-fun n () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun next_67_2597 () Int)
(declare-fun q_2527 () Int)
(declare-fun flted_12_2553 () Int)
(declare-fun q_2555 () Int)
(declare-fun self_2552 () Int)
(declare-fun x_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (not (> v_bool_62_1578_primed 0)))
(assert (< q_2555 1))
(assert (= (+ flted_12_2553 1) flted_12_2525))
(assert (= p_2551 self_2524))
(assert (= (+ flted_12_2525 1) n))
(assert (= p_2523 p))
(assert (= self_2524 x_primed))
(assert (> v_bool_59_1592_primed 0))
(assert (= a_primed 1))
(assert (< 0 a))
(assert (< a n))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= self_2552 q_2527))
(assert (= next_67_2597 q_2527))
(assert (= self_2552 1))
(assert (or (and (< q_2555 1) (= flted_12_2553 0)) (and (<= 1 flted_12_2553) (> q_2555 0))))
(assert (= x_primed 2))
(assert (not (= self_2552 x_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)