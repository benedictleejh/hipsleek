(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun na_10926 () Int)
(declare-fun ha () Int)
(declare-fun nr_11188 () Int)
(declare-fun nl_11185 () Int)
(declare-fun r_11187 () Int)
(declare-fun l_11184 () Int)
(declare-fun c_primed () Int)
(declare-fun b_primed () Int)
(declare-fun a_primed () Int)
(declare-fun flted_169_11176 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_169_11175 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_169_11174 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun bhl_11186 () Int)
(declare-fun bhr_11189 () Int)
(declare-fun d_primed () Int)
(declare-fun flted_169_11173 () Int)
(declare-fun h () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= na_10926 (+ (+ nr_11188 1) nl_11185)))
(assert (= bhl_11186 ha))
(assert (= bhr_11189 ha))
(assert (= bhr_11189 bhl_11186))
(assert (= nr_11188 nb))
(assert (= nl_11185 na))
(assert (= r_11187 b_primed))
(assert (= l_11184 a_primed))
(assert (= flted_169_11174 0))
(assert (= flted_169_11175 0))
(assert (= flted_169_11176 0))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (or (and (and (and (= flted_169_11176 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_169_11176 0)) (and (and (and (= flted_169_11176 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_169_11175 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_169_11175 0)) (and (and (and (= flted_169_11175 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_169_11174 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_169_11174 0)) (and (and (and (= flted_169_11174 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (= flted_169_11173 0))
(assert (= bhl_11186 h))
(assert (= bhr_11189 h))
(assert (= d_primed d))
(assert (or (and (and (and (= flted_169_11173 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_169_11173 0)) (and (and (and (= flted_169_11173 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
;Negation of Consequence
(assert (not (or (= nd 0) (< d 1))))
(check-sat)