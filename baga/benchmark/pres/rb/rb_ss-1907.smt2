(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun a_primed () Int)
(declare-fun b_primed () Int)
(declare-fun c_primed () Int)
(declare-fun v_int_216_4014_primed () Int)
(declare-fun v_int_216_4013_primed () Int)
(declare-fun v_int_218_4016_primed () Int)
(declare-fun v_int_218_4015_primed () Int)
(declare-fun res () Int)
(declare-fun flted_209_198 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_209_197 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_209_196 () Int)
(declare-fun ha () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun tmp_primed () Int)
(declare-fun v_node_218_4017_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= flted_209_198 0))
(assert (= flted_209_197 0))
(assert (= flted_209_196 0))
(assert true)
(assert (= v_int_216_4014_primed 0))
(assert (= v_int_216_4013_primed 1))
(assert (= v_int_218_4016_primed 0))
(assert (= v_int_218_4015_primed 0))
(assert (= res v_node_218_4017_primed))
(assert (or (and (and (and (= flted_209_198 0) (<= 2 ha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= ha 1)) (= flted_209_198 0)) (and (and (and (= flted_209_198 1) (<= 1 ha)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_209_197 0) (<= 2 ha)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha 1)) (= flted_209_197 0)) (and (and (and (= flted_209_197 1) (<= 1 ha)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_209_196 0) (<= 2 ha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha 1)) (= flted_209_196 0)) (and (and (and (= flted_209_196 1) (<= 1 ha)) (<= 1 nc)) (> c 0)))))
(assert (= tmp_primed 1))
(assert (= v_node_218_4017_primed 2))
(assert (not (= tmp_primed v_node_218_4017_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)