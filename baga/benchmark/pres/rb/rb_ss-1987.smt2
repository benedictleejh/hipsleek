(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_13456 () Int)
(declare-fun c_primed () Int)
(declare-fun r_13552 () Int)
(declare-fun b_primed () Int)
(declare-fun nr_13553 () Int)
(declare-fun Anon_13554 () Int)
(declare-fun flted_224_13431 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_224_13430 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun bhr_13555 () Int)
(declare-fun l_13548 () Int)
(declare-fun a_primed () Int)
(declare-fun flted_224_13432 () Int)
(declare-fun ha () Int)
(declare-fun na () Int)
(declare-fun a () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= r_13456 c_primed))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= flted_224_13431 0))
(assert (= flted_224_13430 0))
(assert (= r_13552 b_primed))
(assert (= nr_13553 nb))
(assert (= Anon_13554 flted_224_13431))
(assert (or (and (and (and (= flted_224_13431 0) (<= 2 ha)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha 1)) (= flted_224_13431 0)) (and (and (and (= flted_224_13431 1) (<= 1 ha)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_224_13430 0) (<= 2 ha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha 1)) (= flted_224_13430 0)) (and (and (and (= flted_224_13430 1) (<= 1 ha)) (<= 1 nc)) (> c 0)))))
(assert (= bhr_13555 ha))
(assert (= flted_224_13432 0))
(assert (= a_primed a))
(assert (= l_13548 a_primed))
(assert (or (and (and (and (= flted_224_13432 0) (<= 2 ha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= ha 1)) (= flted_224_13432 0)) (and (and (and (= flted_224_13432 1) (<= 1 ha)) (<= 1 na)) (> a 0)))))
;Negation of Consequence
(assert (not (or (= na 0) (< a 1))))
(check-sat)