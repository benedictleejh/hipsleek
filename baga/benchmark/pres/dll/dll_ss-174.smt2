(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_2628 () Int)
(declare-fun p_2627 () Int)
(declare-fun v_int_74_2681 () Int)
(declare-fun x () Int)
(declare-fun a () Int)
(declare-fun a_primed () Int)
(declare-fun v_bool_59_1592_primed () Int)
(declare-fun self_2614 () Int)
(declare-fun p_2613 () Int)
(declare-fun p () Int)
(declare-fun flted_12_2615 () Int)
(declare-fun n () Int)
(declare-fun x_primed () Int)
(declare-fun flted_56_2680 () Int)
(declare-fun q_2617 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_2628))
(assert (= (+ flted_56_2680 1) n_2628))
(assert (<= 0 flted_12_2615))
(assert (= n_2628 flted_12_2615))
(assert (= p_2627 self_2614))
(assert (= (+ v_int_74_2681 1) a_primed))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (< a n))
(assert (< 0 a))
(assert (not (= a_primed 1)))
(assert (not (> v_bool_59_1592_primed 0)))
(assert (= self_2614 x_primed))
(assert (= p_2613 p))
(assert (= (+ flted_12_2615 1) n))
(assert (= x_primed 1))
(assert (or (and (< q_2617 1) (= flted_56_2680 0)) (and (<= 1 flted_56_2680) (> q_2617 0))))
;Negation of Consequence
(assert (not false))
(check-sat)