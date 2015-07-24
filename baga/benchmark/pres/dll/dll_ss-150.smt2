(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun next_64_1577_primed () Int)
(declare-fun prev_64_1576_primed () Int)
(declare-fun val_64_1575_primed () Int)
(declare-fun Anon_2591 () Int)
(declare-fun q_2555 () Int)
(declare-fun q_2527 () Int)
(declare-fun x () Int)
(declare-fun a () Int)
(declare-fun a_primed () Int)
(declare-fun v_bool_59_1592_primed () Int)
(declare-fun p_2523 () Int)
(declare-fun p () Int)
(declare-fun n () Int)
(declare-fun p_2551 () Int)
(declare-fun self_2524 () Int)
(declare-fun flted_12_2525 () Int)
(declare-fun v_bool_62_1578_primed () Int)
(declare-fun self_2589 () Int)
(declare-fun l_primed () Int)
(declare-fun p_2588 () Int)
(declare-fun flted_12_2553 () Int)
(declare-fun flted_12_2590 () Int)
(declare-fun q_2592 () Int)
(declare-fun x_primed () Int)
(declare-fun self_2552 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= next_64_1577_primed q_2592))
(assert (= prev_64_1576_primed p_2588))
(assert (= val_64_1575_primed Anon_2591))
(assert (= l_primed q_2555))
(assert (= self_2552 q_2527))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (< a n))
(assert (< 0 a))
(assert (= a_primed 1))
(assert (> v_bool_59_1592_primed 0))
(assert (= self_2524 x_primed))
(assert (= p_2523 p))
(assert (= (+ flted_12_2525 1) n))
(assert (= p_2551 self_2524))
(assert (= (+ flted_12_2553 1) flted_12_2525))
(assert (> l_primed 0))
(assert (> v_bool_62_1578_primed 0))
(assert (= self_2589 l_primed))
(assert (= p_2588 self_2552))
(assert (= (+ flted_12_2590 1) flted_12_2553))
(assert (= x_primed 1))
(assert (= self_2552 2))
(assert (or (and (< q_2592 1) (= flted_12_2590 0)) (and (<= 1 flted_12_2590) (> q_2592 0))))
(assert (not (= x_primed self_2552)))
;Negation of Consequence
(assert (not false))
(check-sat)