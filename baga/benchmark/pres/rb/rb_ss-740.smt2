(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_8225 () Int)
(declare-fun flted_12_8047 () Int)
(declare-fun bhr_8056 () Int)
(declare-fun r_8054 () Int)
(declare-fun bh () Int)
(declare-fun n () Int)
(declare-fun nr_8055 () Int)
(declare-fun l_8221 () Int)
(declare-fun flted_12_8048 () Int)
(declare-fun bhl_8053 () Int)
(declare-fun nl_8052 () Int)
(declare-fun l_8051 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhr_8056 bh))
(assert (= flted_12_8047 0))
(assert (= r_8225 r_8054))
(assert (or (and (and (and (= flted_12_8047 0) (<= 2 bhr_8056)) (<= 1 nr_8055)) (> r_8054 0)) (or (and (and (and (< r_8054 1) (= nr_8055 0)) (= bhr_8056 1)) (= flted_12_8047 0)) (and (and (and (= flted_12_8047 1) (<= 1 bhr_8056)) (<= 1 nr_8055)) (> r_8054 0)))))
(assert (= flted_12_8048 0))
(assert (= bhl_8053 bh))
(assert (= n (+ (+ nr_8055 1) nl_8052)))
(assert (= l_8221 l_8051))
(assert (or (and (and (and (= flted_12_8048 0) (<= 2 bhl_8053)) (<= 1 nl_8052)) (> l_8051 0)) (or (and (and (and (< l_8051 1) (= nl_8052 0)) (= bhl_8053 1)) (= flted_12_8048 0)) (and (and (and (= flted_12_8048 1) (<= 1 bhl_8053)) (<= 1 nl_8052)) (> l_8051 0)))))
;Negation of Consequence
(assert (not (or (= nl_8052 0) (< l_8051 1))))
(check-sat)