(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun c_primed () Int)
(declare-fun d_primed () Int)
(declare-fun r_10951 () Int)
(declare-fun b_primed () Int)
(declare-fun flted_168_10937 () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
(declare-fun flted_168_10938 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_168_10939 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun l_10948 () Int)
(declare-fun a_primed () Int)
(declare-fun flted_168_10940 () Int)
(declare-fun h () Int)
(declare-fun na () Int)
(declare-fun a () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= d_primed d))
(assert (= flted_168_10939 0))
(assert (= flted_168_10938 0))
(assert (= flted_168_10937 0))
(assert (= r_10951 b_primed))
(assert (or (and (and (and (= flted_168_10937 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_168_10937 0)) (and (and (and (= flted_168_10937 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
(assert (or (and (and (and (= flted_168_10938 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_168_10938 0)) (and (and (and (= flted_168_10938 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_168_10939 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_168_10939 0)) (and (and (and (= flted_168_10939 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
(assert (= flted_168_10940 0))
(assert (= a_primed a))
(assert (= l_10948 a_primed))
(assert (or (and (and (and (= flted_168_10940 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_168_10940 0)) (and (and (and (= flted_168_10940 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
;Negation of Consequence
(assert (not (or (= na 0) (< a 1))))
(check-sat)