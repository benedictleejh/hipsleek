(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_5396 () Int)
(declare-fun nl_5395 () Int)
(declare-fun l_5394 () Int)
(declare-fun a_primed () Int)
(declare-fun r_5483 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_21_5374 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_21_5372 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun bhl_5397 () Int)
(declare-fun l_5480 () Int)
(declare-fun b_primed () Int)
(declare-fun flted_21_5373 () Int)
(declare-fun bha () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_5396 flted_21_5374))
(assert (= nl_5395 na))
(assert (= l_5394 a_primed))
(assert (= a_primed a))
(assert (= c_primed c))
(assert (= flted_21_5374 1))
(assert (= flted_21_5372 0))
(assert (= r_5483 c_primed))
(assert (or (and (and (and (= flted_21_5374 0) (<= 2 bha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= bha 1)) (= flted_21_5374 0)) (and (and (and (= flted_21_5374 1) (<= 1 bha)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_21_5372 0) (<= 2 bha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= bha 1)) (= flted_21_5372 0)) (and (and (and (= flted_21_5372 1) (<= 1 bha)) (<= 1 nc)) (> c 0)))))
(assert (= flted_21_5373 0))
(assert (= bhl_5397 bha))
(assert (= b_primed b))
(assert (= l_5480 b_primed))
(assert (or (and (and (and (= flted_21_5373 0) (<= 2 bha)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= bha 1)) (= flted_21_5373 0)) (and (and (and (= flted_21_5373 1) (<= 1 bha)) (<= 1 nb)) (> b 0)))))
;Negation of Consequence
(assert (not (or (= nb 0) (< b 1))))
(check-sat)