(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun xs () Int)
(declare-fun c () Int)
(declare-fun v_bool_24_1526_primed () Int)
(declare-fun bg () Int)
(declare-fun sm () Int)
(declare-fun n () Int)
(declare-fun d_1748 () Int)
(declare-fun c_primed () Int)
(declare-fun v_bool_28_1525_primed () Int)
(declare-fun xs_primed () Int)
(declare-fun sm_1745 () Int)
(declare-fun bg_1746 () Int)
(declare-fun flted_9_1747 () Int)
(declare-fun p_1749 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= xs_primed xs))
(assert (= c_primed c))
(assert (<= sm c))
(assert (<= c bg))
(assert (> xs_primed 0))
(assert (not (> v_bool_24_1526_primed 0)))
(assert (= bg_1746 bg))
(assert (= sm_1745 sm))
(assert (< d_1748 bg))
(assert (<= sm d_1748))
(assert (= (+ flted_9_1747 1) n))
(assert (not (> v_bool_28_1525_primed 0)))
(assert (< d_1748 c_primed))
(assert (> v_bool_28_1525_primed 0))
(assert (= xs_primed 1))
(assert (or (and (< p_1749 1) (= flted_9_1747 0)) (and (and (< sm_1745 bg_1746) (<= 1 flted_9_1747)) (> p_1749 0))))
;Negation of Consequence
(assert (not false))
(check-sat)