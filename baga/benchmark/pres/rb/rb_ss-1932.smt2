(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_13294 () Int)
(declare-fun tmp_13286 () Int)
(declare-fun l_13291 () Int)
(declare-fun v_13290 () Int)
(declare-fun a_primed () Int)
(declare-fun b () Int)
(declare-fun c () Int)
(declare-fun flted_209_13280 () Int)
(declare-fun flted_209_13279 () Int)
(declare-fun v_int_216_13283 () Int)
(declare-fun v_int_218_13284 () Int)
(declare-fun v_int_218_13285 () Int)
(declare-fun res () Int)
(declare-fun v_node_218_4017_primed () Int)
(declare-fun v_13351 () Int)
(declare-fun v_int_216_13282 () Int)
(declare-fun l_13352 () Int)
(declare-fun b_primed () Int)
(declare-fun r_13355 () Int)
(declare-fun c_primed () Int)
(declare-fun nb () Int)
(declare-fun nc () Int)
(declare-fun bhr_13357 () Int)
(declare-fun bhl_13354 () Int)
(declare-fun bhr_13296 () Int)
(declare-fun nr_13295 () Int)
(declare-fun nr_13356 () Int)
(declare-fun nl_13353 () Int)
(declare-fun flted_209_13281 () Int)
(declare-fun ha () Int)
(declare-fun na () Int)
(declare-fun a () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= r_13294 tmp_13286))
(assert (= l_13291 a_primed))
(assert (= v_13290 v_int_218_13284))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= flted_209_13281 0))
(assert (= flted_209_13280 0))
(assert (= flted_209_13279 0))
(assert (= v_int_216_13282 0))
(assert (= v_int_216_13283 1))
(assert (= v_int_218_13284 0))
(assert (= v_int_218_13285 0))
(assert (= res v_node_218_4017_primed))
(assert (= v_13351 v_int_216_13282))
(assert (= l_13352 b_primed))
(assert (= r_13355 c_primed))
(assert (= nl_13353 nb))
(assert (= bhl_13354 ha))
(assert (= nr_13356 nc))
(assert (= bhr_13357 ha))
(assert (= bhr_13357 bhl_13354))
(assert (= bhr_13357 bhr_13296))
(assert (= bhl_13354 bhr_13296))
(assert (= nr_13295 (+ (+ nr_13356 1) nl_13353)))
(assert (or (and (and (and (= flted_209_13281 0) (<= 2 ha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= ha 1)) (= flted_209_13281 0)) (and (and (and (= flted_209_13281 1) (<= 1 ha)) (<= 1 na)) (> a 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)