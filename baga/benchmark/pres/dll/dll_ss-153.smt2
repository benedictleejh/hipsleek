(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun p_2613 () Int)
(declare-fun p () Int)
(declare-fun v_bool_59_1592_primed () Int)
(declare-fun n () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun q_2617 () Int)
(declare-fun v_int_74_1590_primed () Int)
(declare-fun a_primed () Int)
(declare-fun self_2614 () Int)
(declare-fun flted_12_2615 () Int)
(declare-fun p_2633 () Int)
(declare-fun p_2627 () Int)
(declare-fun n_2628 () Int)
(declare-fun x_primed () Int)
(declare-fun flted_56_2634 () Int)
(declare-fun v_node2_74_1591_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= (+ flted_12_2615 1) n))
(assert (= p_2613 p))
(assert (= self_2614 x_primed))
(assert (not (> v_bool_59_1592_primed 0)))
(assert (not (= a_primed 1)))
(assert (< 0 a))
(assert (< a n))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= v_node2_74_1591_primed q_2617))
(assert (= (+ v_int_74_1590_primed 1) a_primed))
(assert (= p_2627 self_2614))
(assert (= n_2628 flted_12_2615))
(assert (<= 0 flted_12_2615))
(assert (= (+ flted_56_2634 1) n_2628))
(assert (= p_2633 p_2627))
(assert (<= 0 n_2628))
(assert (= x_primed 1))
(assert (or (and (< v_node2_74_1591_primed 1) (= flted_56_2634 0)) (and (<= 1 flted_56_2634) (> v_node2_74_1591_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)