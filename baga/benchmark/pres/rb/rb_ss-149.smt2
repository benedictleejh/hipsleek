(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun l_5935 () Int)
(declare-fun a_primed () Int)
(declare-fun l_6006 () Int)
(declare-fun b_primed () Int)
(declare-fun flted_182_5924 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_182_5925 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun r_6010 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_182_5923 () Int)
(declare-fun ha () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= l_5935 a_primed))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= flted_182_5925 0))
(assert (= flted_182_5924 0))
(assert (= l_6006 b_primed))
(assert (or (and (and (and (= flted_182_5924 0) (<= 2 ha)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha 1)) (= flted_182_5924 0)) (and (and (and (= flted_182_5924 1) (<= 1 ha)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_182_5925 0) (<= 2 ha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= ha 1)) (= flted_182_5925 0)) (and (and (and (= flted_182_5925 1) (<= 1 ha)) (<= 1 na)) (> a 0)))))
(assert (= flted_182_5923 0))
(assert (= c_primed c))
(assert (= r_6010 c_primed))
(assert (or (and (and (and (= flted_182_5923 0) (<= 2 ha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha 1)) (= flted_182_5923 0)) (and (and (and (= flted_182_5923 1) (<= 1 ha)) (<= 1 nc)) (> c 0)))))
;Negation of Consequence
(assert (not (or (= nc 0) (< c 1))))
(check-sat)