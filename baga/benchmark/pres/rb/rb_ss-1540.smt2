(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun c_primed () Int)
(declare-fun d_primed () Int)
(declare-fun r_11372 () Int)
(declare-fun b_primed () Int)
(declare-fun flted_169_11358 () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
(declare-fun flted_169_11359 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_169_11360 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun l_11369 () Int)
(declare-fun a_primed () Int)
(declare-fun flted_169_11361 () Int)
(declare-fun h () Int)
(declare-fun na () Int)
(declare-fun a () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= d_primed d))
(assert (= flted_169_11360 0))
(assert (= flted_169_11359 0))
(assert (= flted_169_11358 0))
(assert (= r_11372 b_primed))
(assert (or (and (and (and (= flted_169_11358 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_169_11358 0)) (and (and (and (= flted_169_11358 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
(assert (or (and (and (and (= flted_169_11359 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_169_11359 0)) (and (and (and (= flted_169_11359 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_169_11360 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_169_11360 0)) (and (and (and (= flted_169_11360 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
(assert (= flted_169_11361 0))
(assert (= a_primed a))
(assert (= l_11369 a_primed))
(assert (or (and (and (and (= flted_169_11361 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_169_11361 0)) (and (and (and (= flted_169_11361 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
;Negation of Consequence
(assert (not (or (= na 0) (< a 1))))
(check-sat)