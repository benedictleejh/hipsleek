(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun c_primed () Int)
(declare-fun d_primed () Int)
(declare-fun r_5556 () Int)
(declare-fun b_primed () Int)
(declare-fun nr_5557 () Int)
(declare-fun Anon_5558 () Int)
(declare-fun flted_36_5532 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_36_5530 () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
(declare-fun flted_36_5531 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun bhr_5559 () Int)
(declare-fun l_5552 () Int)
(declare-fun a_primed () Int)
(declare-fun flted_36_5533 () Int)
(declare-fun bha () Int)
(declare-fun na () Int)
(declare-fun a () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= d_primed d))
(assert (= flted_36_5532 0))
(assert (= flted_36_5531 0))
(assert (= flted_36_5530 0))
(assert (= r_5556 b_primed))
(assert (= nr_5557 nb))
(assert (= Anon_5558 flted_36_5532))
(assert (or (and (and (and (= flted_36_5532 0) (<= 2 bha)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= bha 1)) (= flted_36_5532 0)) (and (and (and (= flted_36_5532 1) (<= 1 bha)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_36_5530 0) (<= 2 bha)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= bha 1)) (= flted_36_5530 0)) (and (and (and (= flted_36_5530 1) (<= 1 bha)) (<= 1 nd)) (> d 0)))))
(assert (or (and (and (and (= flted_36_5531 0) (<= 2 bha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= bha 1)) (= flted_36_5531 0)) (and (and (and (= flted_36_5531 1) (<= 1 bha)) (<= 1 nc)) (> c 0)))))
(assert (= bhr_5559 bha))
(assert (= flted_36_5533 0))
(assert (= a_primed a))
(assert (= l_5552 a_primed))
(assert (or (and (and (and (= flted_36_5533 0) (<= 2 bha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= bha 1)) (= flted_36_5533 0)) (and (and (and (= flted_36_5533 1) (<= 1 bha)) (<= 1 na)) (> a 0)))))
;Negation of Consequence
(assert (not (or (= na 0) (< a 1))))
(check-sat)