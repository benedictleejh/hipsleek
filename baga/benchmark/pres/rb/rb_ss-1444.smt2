(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nc_10928 () Int)
(declare-fun c_primed () Int)
(declare-fun d_primed () Int)
(declare-fun r_11116 () Int)
(declare-fun b_primed () Int)
(declare-fun flted_168_10982 () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
(declare-fun flted_168_10983 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_168_10984 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun l_11112 () Int)
(declare-fun a_primed () Int)
(declare-fun flted_168_10985 () Int)
(declare-fun h () Int)
(declare-fun na () Int)
(declare-fun a () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nc_10928 nd))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= d_primed d))
(assert (= flted_168_10984 0))
(assert (= flted_168_10983 0))
(assert (= flted_168_10982 0))
(assert (= r_11116 b_primed))
(assert (or (and (and (and (= flted_168_10982 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_168_10982 0)) (and (and (and (= flted_168_10982 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
(assert (or (and (and (and (= flted_168_10983 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_168_10983 0)) (and (and (and (= flted_168_10983 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_168_10984 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_168_10984 0)) (and (and (and (= flted_168_10984 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
(assert (= flted_168_10985 0))
(assert (= a_primed a))
(assert (= l_11112 a_primed))
(assert (or (and (and (and (= flted_168_10985 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_168_10985 0)) (and (and (and (= flted_168_10985 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
;Negation of Consequence
(assert (not (or (= na 0) (< a 1))))
(check-sat)