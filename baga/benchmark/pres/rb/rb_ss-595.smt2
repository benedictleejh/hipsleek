(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun d_primed () Int)
(declare-fun c_primed () Int)
(declare-fun a_primed () Int)
(declare-fun flted_154_7524 () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
(declare-fun flted_154_7525 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_154_7527 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun b_primed () Int)
(declare-fun flted_154_7526 () Int)
(declare-fun h () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_154_7524 0))
(assert (= flted_154_7525 0))
(assert (= flted_154_7527 0))
(assert (= d_primed d))
(assert (= c_primed c))
(assert (= a_primed a))
(assert (or (and (and (and (= flted_154_7524 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_154_7524 0)) (and (and (and (= flted_154_7524 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
(assert (or (and (and (and (= flted_154_7525 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_154_7525 0)) (and (and (and (= flted_154_7525 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_154_7527 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_154_7527 0)) (and (and (and (= flted_154_7527 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (= flted_154_7526 0))
(assert (= b_primed b))
(assert (or (and (and (and (= flted_154_7526 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_154_7526 0)) (and (and (and (= flted_154_7526 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
;Negation of Consequence
(assert (not (or (= nb 0) (< b 1))))
(check-sat)