(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nb () Int)
(declare-fun a_primed () Int)
(declare-fun b_primed () Int)
(declare-fun c_primed () Int)
(declare-fun flted_262_11654 () Int)
(declare-fun flted_262_11653 () Int)
(declare-fun b () Int)
(declare-fun flted_262_11656 () Int)
(declare-fun flted_262_11655 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_262_11652 () Int)
(declare-fun h () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< b_primed 1))
(assert (= nb 0))
(assert (= flted_262_11653 1))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= flted_262_11656 0))
(assert (= flted_262_11655 (+ 1 h)))
(assert (= flted_262_11654 0))
(assert (= flted_262_11653 (+ 1 h)))
(assert (= flted_262_11652 0))
(assert (> b 0))
(assert true)
(assert (or (and (and (and (= flted_262_11656 0) (<= 2 flted_262_11655)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= flted_262_11655 1)) (= flted_262_11656 0)) (and (and (and (= flted_262_11656 1) (<= 1 flted_262_11655)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_262_11652 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_262_11652 0)) (and (and (and (= flted_262_11652 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)