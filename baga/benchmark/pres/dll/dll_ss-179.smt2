(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun q_2850 () Int)
(declare-fun p_2846 () Int)
(declare-fun p () Int)
(declare-fun x () Int)
(declare-fun n () Int)
(declare-fun self_2875 () Int)
(declare-fun p_2874 () Int)
(declare-fun self_2847 () Int)
(declare-fun flted_12_2848 () Int)
(declare-fun tmp2_primed () Int)
(declare-fun v_bool_92_1531_primed () Int)
(declare-fun flted_12_2876 () Int)
(declare-fun q_2878 () Int)
(declare-fun x_primed () Int)
(declare-fun tmp1_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= tmp2_primed q_2878))
(assert (= tmp1_primed q_2850))
(assert (= (+ flted_12_2848 1) n))
(assert (= p_2846 p))
(assert (= self_2847 x_primed))
(assert (= x_primed x))
(assert (< 1 n))
(assert (= self_2875 tmp1_primed))
(assert (= p_2874 self_2847))
(assert (= (+ flted_12_2876 1) flted_12_2848))
(assert (> v_bool_92_1531_primed 0))
(assert (> tmp2_primed 0))
(assert (not (> v_bool_92_1531_primed 0)))
(assert (= x_primed 1))
(assert (= tmp1_primed 2))
(assert (or (and (< q_2878 1) (= flted_12_2876 0)) (and (<= 1 flted_12_2876) (> q_2878 0))))
(assert (not (= x_primed tmp1_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)