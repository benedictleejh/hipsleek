(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun prev_202_2200 () Int)
(declare-fun next_200_2089 () Int)
(declare-fun p_2075 () Int)
(declare-fun q () Int)
(declare-fun self_2076 () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun y () Int)
(declare-fun m () Int)
(declare-fun v_bool_199_1375_primed () Int)
(declare-fun v_bool_201_1367_primed () Int)
(declare-fun self_2196 () Int)
(declare-fun p_2195 () Int)
(declare-fun p () Int)
(declare-fun n () Int)
(declare-fun Anon_2218 () Int)
(declare-fun Anon_2078 () Int)
(declare-fun q_2219 () Int)
(declare-fun flted_12_2077 () Int)
(declare-fun q_2079 () Int)
(declare-fun flted_12_2197 () Int)
(declare-fun q_2199 () Int)
(declare-fun y_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= prev_202_2200 p_2195))
(assert (= next_200_2089 q_2079))
(assert (= (+ flted_12_2077 1) m))
(assert (= p_2075 q))
(assert (= self_2076 x_primed))
(assert (= x_primed x))
(assert (= y_primed y))
(assert (< 0 m))
(assert (< q_2079 1))
(assert (> v_bool_199_1375_primed 0))
(assert (> y_primed 0))
(assert (> v_bool_201_1367_primed 0))
(assert (= self_2196 y_primed))
(assert (= p_2195 p))
(assert (= (+ flted_12_2197 1) n))
(assert (= Anon_2218 Anon_2078))
(assert (= q_2219 y_primed))
(assert (or (and (< q_2079 1) (= flted_12_2077 0)) (and (<= 1 flted_12_2077) (> q_2079 0))))
(assert (or (and (< q_2199 1) (= flted_12_2197 0)) (and (<= 1 flted_12_2197) (> q_2199 0))))
(assert (= y_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)