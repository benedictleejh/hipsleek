(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun v_node_536_1755_primed () Int)
(declare-fun v_int_536_17261 () Int)
(declare-fun v () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_534_2200_primed () Int)
(declare-fun v_17276 () Int)
(declare-fun v_primed () Int)
(declare-fun l_17277 () Int)
(declare-fun r_17281 () Int)
(declare-fun tmp_17262 () Int)
(declare-fun Anon_22 () Int)
(declare-fun bh () Int)
(declare-fun n () Int)
(declare-fun x () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res v_node_536_1755_primed))
(assert (= v_int_536_17261 1))
(assert (= x_primed x))
(assert (= v_primed v))
(assert (< tmp_17262 1))
(assert (< x_primed 1))
(assert (> v_bool_534_2200_primed 0))
(assert (= v_17276 v_primed))
(assert (= l_17277 tmp_17262))
(assert (= r_17281 tmp_17262))
(assert (or (and (and (and (= Anon_22 0) (<= 2 bh)) (<= 1 n)) (> x 0)) (or (and (and (and (< x 1) (= n 0)) (= bh 1)) (= Anon_22 0)) (and (and (and (= Anon_22 1) (<= 1 bh)) (<= 1 n)) (> x 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)