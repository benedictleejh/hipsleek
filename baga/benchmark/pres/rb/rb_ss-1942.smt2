(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_13303 () Int)
(declare-fun nl_13302 () Int)
(declare-fun l_13301 () Int)
(declare-fun a_primed () Int)
(declare-fun r_13401 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_209_13281 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_209_13279 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun bhl_13304 () Int)
(declare-fun l_13397 () Int)
(declare-fun b_primed () Int)
(declare-fun flted_209_13280 () Int)
(declare-fun ha () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_13303 flted_209_13281))
(assert (= nl_13302 na))
(assert (= l_13301 a_primed))
(assert (= a_primed a))
(assert (= c_primed c))
(assert (= flted_209_13281 0))
(assert (= flted_209_13279 0))
(assert (= r_13401 c_primed))
(assert (or (and (and (and (= flted_209_13281 0) (<= 2 ha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= ha 1)) (= flted_209_13281 0)) (and (and (and (= flted_209_13281 1) (<= 1 ha)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_209_13279 0) (<= 2 ha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha 1)) (= flted_209_13279 0)) (and (and (and (= flted_209_13279 1) (<= 1 ha)) (<= 1 nc)) (> c 0)))))
(assert (= flted_209_13280 0))
(assert (= bhl_13304 ha))
(assert (= b_primed b))
(assert (= l_13397 b_primed))
(assert (or (and (and (and (= flted_209_13280 0) (<= 2 ha)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha 1)) (= flted_209_13280 0)) (and (and (and (= flted_209_13280 1) (<= 1 ha)) (<= 1 nb)) (> b 0)))))
;Negation of Consequence
(assert (not (or (= nb 0) (< b 1))))
(check-sat)