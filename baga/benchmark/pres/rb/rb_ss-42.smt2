(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhl_5397 () Int)
(declare-fun Anon_5396 () Int)
(declare-fun nl_5395 () Int)
(declare-fun na () Int)
(declare-fun r_5398 () Int)
(declare-fun tmp_5379 () Int)
(declare-fun l_5394 () Int)
(declare-fun v_5393 () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun b () Int)
(declare-fun c () Int)
(declare-fun flted_21_5374 () Int)
(declare-fun flted_21_5373 () Int)
(declare-fun flted_21_5372 () Int)
(declare-fun v_int_27_5376 () Int)
(declare-fun v_int_29_5377 () Int)
(declare-fun v_int_29_5378 () Int)
(declare-fun res () Int)
(declare-fun v_node_29_5172_primed () Int)
(declare-fun v_5479 () Int)
(declare-fun v_int_27_5375 () Int)
(declare-fun l_5480 () Int)
(declare-fun b_primed () Int)
(declare-fun r_5483 () Int)
(declare-fun c_primed () Int)
(declare-fun nb () Int)
(declare-fun nc () Int)
(declare-fun bha () Int)
(declare-fun bhr_5485 () Int)
(declare-fun bhl_5482 () Int)
(declare-fun bhr_5401 () Int)
(declare-fun nr_5399 () Int)
(declare-fun nr_5484 () Int)
(declare-fun nl_5481 () Int)
(declare-fun Anon_5400 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhl_5397 bha))
(assert (= Anon_5396 flted_21_5374))
(assert (= nl_5395 na))
(assert (= r_5398 tmp_5379))
(assert (= l_5394 a_primed))
(assert (= v_5393 v_int_29_5377))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= flted_21_5374 1))
(assert (= flted_21_5373 0))
(assert (= flted_21_5372 0))
(assert (= v_int_27_5375 0))
(assert (= v_int_27_5376 1))
(assert (= v_int_29_5377 0))
(assert (= v_int_29_5378 0))
(assert (= res v_node_29_5172_primed))
(assert (= v_5479 v_int_27_5375))
(assert (= l_5480 b_primed))
(assert (= r_5483 c_primed))
(assert (= nl_5481 nb))
(assert (= bhl_5482 bha))
(assert (= nr_5484 nc))
(assert (= bhr_5485 bha))
(assert (= bhr_5485 bhl_5482))
(assert (= bhr_5485 bhr_5401))
(assert (= bhl_5482 bhr_5401))
(assert (= nr_5399 (+ (+ nr_5484 1) nl_5481)))
(assert (= Anon_5400 1))
;Negation of Consequence
(assert (not false))
(check-sat)