(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun p_1856 () Int)
(declare-fun xsnext_1848 () Int)
(declare-fun n () Int)
(declare-fun bg () Int)
(declare-fun sm () Int)
(declare-fun c () Int)
(declare-fun flted_9_1747 () Int)
(declare-fun sm_1745 () Int)
(declare-fun bg_1746 () Int)
(declare-fun d_1748 () Int)
(declare-fun sm_1793 () Int)
(declare-fun d_1855 () Int)
(declare-fun n_1792 () Int)
(declare-fun a_1846 () Int)
(declare-fun c_primed () Int)
(declare-fun bg_1794 () Int)
(declare-fun b_1847 () Int)
(declare-fun res () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= p_1856 xsnext_1848))
(assert (<= 0 flted_9_1747))
(assert (or (and (< xsnext_1848 1) (= a_1846 0)) (and (and (< sm_1793 c_primed) (<= 1 a_1846)) (> xsnext_1848 0))))
(assert (< d_1748 c_primed))
(assert (= (+ flted_9_1747 1) n))
(assert (<= sm d_1748))
(assert (< d_1748 bg))
(assert (= sm_1745 sm))
(assert (= bg_1746 bg))
(assert (<= c bg))
(assert (<= sm c))
(assert (= c_primed c))
(assert (= n_1792 flted_9_1747))
(assert (= sm_1793 sm_1745))
(assert (= bg_1794 bg_1746))
(assert (<= 0 n_1792))
(assert (= d_1855 d_1748))
(assert (<= sm_1793 d_1855))
(assert (< d_1855 c_primed))
(assert (= n_1792 (+ b_1847 a_1846)))
(assert (or (and (< res 1) (= b_1847 0)) (and (and (< c_primed bg_1794) (<= 1 b_1847)) (> res 0))))
;Negation of Consequence
(assert (not (or (= b_1847 0) (< res 1))))
(check-sat)