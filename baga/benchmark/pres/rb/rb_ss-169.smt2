(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nc () Int)
(declare-fun a_primed () Int)
(declare-fun b_primed () Int)
(declare-fun c_primed () Int)
(declare-fun c () Int)
(declare-fun color_primed () Int)
(declare-fun flted_120_6073 () Int)
(declare-fun color () Int)
(declare-fun h_6072 () Int)
(declare-fun v_int_127_4718_primed () Int)
(declare-fun flted_120_6074 () Int)
(declare-fun h () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun Anon_18 () Int)
(declare-fun h_6071 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< c_primed 1))
(assert (= nc 0))
(assert (= h_6072 1))
(assert (= flted_120_6073 0))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= color_primed color))
(assert (= flted_120_6074 0))
(assert (= flted_120_6073 1))
(assert (= color 1))
(assert (= h_6071 h))
(assert (= h_6072 h))
(assert true)
(assert (= v_int_127_4718_primed 0))
(assert (or (and (and (and (= flted_120_6074 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_120_6074 0)) (and (and (and (= flted_120_6074 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= Anon_18 0) (<= 2 h_6071)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h_6071 1)) (= Anon_18 0)) (and (and (and (= Anon_18 1) (<= 1 h_6071)) (<= 1 nb)) (> b 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)