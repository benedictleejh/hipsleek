(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun next_94_1530_primed () Int)
(declare-fun prev_94_1529_primed () Int)
(declare-fun val_94_1528_primed () Int)
(declare-fun Anon_2914 () Int)
(declare-fun q_2878 () Int)
(declare-fun q_2850 () Int)
(declare-fun p_2846 () Int)
(declare-fun p () Int)
(declare-fun x () Int)
(declare-fun n () Int)
(declare-fun p_2874 () Int)
(declare-fun self_2847 () Int)
(declare-fun flted_12_2848 () Int)
(declare-fun v_bool_92_1531_primed () Int)
(declare-fun self_2912 () Int)
(declare-fun tmp2_primed () Int)
(declare-fun p_2911 () Int)
(declare-fun self_2875 () Int)
(declare-fun flted_12_2876 () Int)
(declare-fun flted_12_2913 () Int)
(declare-fun q_2915 () Int)
(declare-fun x_primed () Int)
(declare-fun tmp1_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= next_94_1530_primed q_2915))
(assert (= prev_94_1529_primed p_2911))
(assert (= val_94_1528_primed Anon_2914))
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
(assert (> tmp2_primed 0))
(assert (> v_bool_92_1531_primed 0))
(assert (= self_2912 tmp2_primed))
(assert (= p_2911 self_2875))
(assert (= (+ flted_12_2913 1) flted_12_2876))
(assert (= x_primed 1))
(assert (= tmp1_primed 2))
(assert (or (and (< q_2915 1) (= flted_12_2913 0)) (and (<= 1 flted_12_2913) (> q_2915 0))))
(assert (not (= x_primed tmp1_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)