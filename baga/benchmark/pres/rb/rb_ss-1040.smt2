(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun b_primed () Int)
(declare-fun a_primed () Int)
(declare-fun flted_195_9528 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_195_9529 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun r_9542 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_195_9527 () Int)
(declare-fun ha () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_195_9528 0))
(assert (= flted_195_9529 0))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (or (and (and (and (= flted_195_9528 0) (<= 2 ha)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha 1)) (= flted_195_9528 0)) (and (and (and (= flted_195_9528 1) (<= 1 ha)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_195_9529 0) (<= 2 ha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= ha 1)) (= flted_195_9529 0)) (and (and (and (= flted_195_9529 1) (<= 1 ha)) (<= 1 na)) (> a 0)))))
(assert (= flted_195_9527 0))
(assert (= c_primed c))
(assert (= r_9542 c_primed))
(assert (or (and (and (and (= flted_195_9527 0) (<= 2 ha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha 1)) (= flted_195_9527 0)) (and (and (and (= flted_195_9527 1) (<= 1 ha)) (<= 1 nc)) (> c 0)))))
;Negation of Consequence
(assert (not (or (= nc 0) (< c 1))))
(check-sat)