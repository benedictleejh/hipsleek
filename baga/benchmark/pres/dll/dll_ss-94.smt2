(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun p_2333 () Int)
(declare-fun flted_12_2307 () Int)
(declare-fun p_2305 () Int)
(declare-fun p () Int)
(declare-fun self_2306 () Int)
(declare-fun v_bool_37_1676_primed () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun n () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun q_2309 () Int)
(declare-fun v_node2_39_1636_primed () Int)
(declare-fun flted_12_2335 () Int)
(declare-fun q_2337 () Int)
(declare-fun x_primed () Int)
(declare-fun self_2334 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ flted_12_2335 1) flted_12_2307))
(assert (= p_2333 self_2306))
(assert (= (+ flted_12_2307 1) n))
(assert (= p_2305 p))
(assert (= self_2306 x_primed))
(assert (> v_bool_37_1676_primed 0))
(assert (= a_primed 1))
(assert (< tmp_null_primed 1))
(assert (< 0 a))
(assert (< a n))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= self_2334 q_2309))
(assert (= v_node2_39_1636_primed q_2337))
(assert (< v_node2_39_1636_primed 1))
(assert (= x_primed 1))
(assert (= self_2334 2))
(assert (or (and (< q_2337 1) (= flted_12_2335 0)) (and (<= 1 flted_12_2335) (> q_2337 0))))
(assert (not (= x_primed self_2334)))
;Negation of Consequence
(assert (not false))
(check-sat)