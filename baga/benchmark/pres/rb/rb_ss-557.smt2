(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun a_primed () Int)
(declare-fun b_primed () Int)
(declare-fun r_7497 () Int)
(declare-fun d_primed () Int)
(declare-fun nr_7498 () Int)
(declare-fun Anon_7499 () Int)
(declare-fun flted_153_7338 () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
(declare-fun flted_153_7340 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_153_7341 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun bhr_7500 () Int)
(declare-fun l_7493 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_153_7339 () Int)
(declare-fun h () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= d_primed d))
(assert (= flted_153_7341 0))
(assert (= flted_153_7340 0))
(assert (= flted_153_7338 0))
(assert (= r_7497 d_primed))
(assert (= nr_7498 nd))
(assert (= Anon_7499 flted_153_7338))
(assert (or (and (and (and (= flted_153_7338 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_153_7338 0)) (and (and (and (= flted_153_7338 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
(assert (or (and (and (and (= flted_153_7340 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_153_7340 0)) (and (and (and (= flted_153_7340 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_153_7341 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_153_7341 0)) (and (and (and (= flted_153_7341 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (= bhr_7500 h))
(assert (= flted_153_7339 0))
(assert (= c_primed c))
(assert (= l_7493 c_primed))
(assert (or (and (and (and (= flted_153_7339 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_153_7339 0)) (and (and (and (= flted_153_7339 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
;Negation of Consequence
(assert (not (or (= nc 0) (< c 1))))
(check-sat)