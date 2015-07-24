(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun na_5520 () Int)
(declare-fun bha_5523 () Int)
(declare-fun nr_5546 () Int)
(declare-fun nl_5543 () Int)
(declare-fun r_5545 () Int)
(declare-fun l_5542 () Int)
(declare-fun c_primed () Int)
(declare-fun b_primed () Int)
(declare-fun a_primed () Int)
(declare-fun nb_5521 () Int)
(declare-fun flted_36_5533 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_36_5532 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_36_5531 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun bhl_5544 () Int)
(declare-fun bhr_5547 () Int)
(declare-fun d_primed () Int)
(declare-fun flted_36_5530 () Int)
(declare-fun bha () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= na_5520 (+ (+ nr_5546 1) nl_5543)))
(assert (= bhl_5544 bha_5523))
(assert (= bhr_5547 bha_5523))
(assert (= bhr_5547 bhl_5544))
(assert (= nr_5546 nb))
(assert (= nl_5543 na))
(assert (= r_5545 b_primed))
(assert (= l_5542 a_primed))
(assert (= flted_36_5531 0))
(assert (= flted_36_5532 0))
(assert (= flted_36_5533 0))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= nb_5521 nc))
(assert (or (and (and (and (= flted_36_5533 0) (<= 2 bha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= bha 1)) (= flted_36_5533 0)) (and (and (and (= flted_36_5533 1) (<= 1 bha)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_36_5532 0) (<= 2 bha)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= bha 1)) (= flted_36_5532 0)) (and (and (and (= flted_36_5532 1) (<= 1 bha)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_36_5531 0) (<= 2 bha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= bha 1)) (= flted_36_5531 0)) (and (and (and (= flted_36_5531 1) (<= 1 bha)) (<= 1 nc)) (> c 0)))))
(assert (= flted_36_5530 0))
(assert (= bhl_5544 bha))
(assert (= bhr_5547 bha))
(assert (= d_primed d))
(assert (or (and (and (and (= flted_36_5530 0) (<= 2 bha)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= bha 1)) (= flted_36_5530 0)) (and (and (and (= flted_36_5530 1) (<= 1 bha)) (<= 1 nd)) (> d 0)))))
;Negation of Consequence
(assert (not (or (= nd 0) (< d 1))))
(check-sat)