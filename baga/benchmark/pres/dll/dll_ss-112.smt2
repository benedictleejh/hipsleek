(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun next_42_1654_primed () Int)
(declare-fun prev_42_1653_primed () Int)
(declare-fun val_42_1652_primed () Int)
(declare-fun Anon_2336 () Int)
(declare-fun v_node2_42_1651_primed () Int)
(declare-fun prev_41_2381 () Int)
(declare-fun q_2309 () Int)
(declare-fun x () Int)
(declare-fun a () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun a_primed () Int)
(declare-fun v_bool_37_1676_primed () Int)
(declare-fun p_2305 () Int)
(declare-fun p () Int)
(declare-fun n () Int)
(declare-fun p_2333 () Int)
(declare-fun self_2306 () Int)
(declare-fun flted_12_2307 () Int)
(declare-fun q_2337 () Int)
(declare-fun v_bool_39_1661_primed () Int)
(declare-fun p_2376 () Int)
(declare-fun self_2334 () Int)
(declare-fun flted_12_2335 () Int)
(declare-fun flted_12_2378 () Int)
(declare-fun q_2380 () Int)
(declare-fun x_primed () Int)
(declare-fun self_2377 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= next_42_1654_primed q_2337))
(assert (= prev_42_1653_primed p_2333))
(assert (= val_42_1652_primed Anon_2336))
(assert (= v_node2_42_1651_primed q_2309))
(assert (= prev_41_2381 p_2376))
(assert (= self_2377 q_2337))
(assert (= self_2334 q_2309))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (< a n))
(assert (< 0 a))
(assert (< tmp_null_primed 1))
(assert (= a_primed 1))
(assert (> v_bool_37_1676_primed 0))
(assert (= self_2306 x_primed))
(assert (= p_2305 p))
(assert (= (+ flted_12_2307 1) n))
(assert (= p_2333 self_2306))
(assert (= (+ flted_12_2335 1) flted_12_2307))
(assert (> q_2337 0))
(assert (> v_bool_39_1661_primed 0))
(assert (= p_2376 self_2334))
(assert (= (+ flted_12_2378 1) flted_12_2335))
(assert (or (and (< q_2380 1) (= flted_12_2378 0)) (and (<= 1 flted_12_2378) (> q_2380 0))))
(assert (= x_primed 1))
(assert (= self_2377 2))
(assert (not (= x_primed self_2377)))
;Negation of Consequence
(assert (not false))
(check-sat)