(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhr_5450 () Int)
(declare-fun nr_5449 () Int)
(declare-fun nc () Int)
(declare-fun bhl_5447 () Int)
(declare-fun nl_5446 () Int)
(declare-fun nb () Int)
(declare-fun r_5448 () Int)
(declare-fun l_5445 () Int)
(declare-fun v_5444 () Int)
(declare-fun res () Int)
(declare-fun v_node_29_5172_primed () Int)
(declare-fun v_int_29_5378 () Int)
(declare-fun v_int_27_5376 () Int)
(declare-fun v_int_27_5375 () Int)
(declare-fun flted_21_5372 () Int)
(declare-fun flted_21_5373 () Int)
(declare-fun c_primed () Int)
(declare-fun c () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun v_5383 () Int)
(declare-fun v_int_29_5377 () Int)
(declare-fun l_5384 () Int)
(declare-fun a_primed () Int)
(declare-fun r_5387 () Int)
(declare-fun tmp_5379 () Int)
(declare-fun flted_21_5374 () Int)
(declare-fun bha () Int)
(declare-fun na () Int)
(declare-fun a () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhr_5450 bha))
(assert (= nr_5449 nc))
(assert (= bhl_5447 bha))
(assert (= nl_5446 nb))
(assert (= r_5448 c_primed))
(assert (= l_5445 b_primed))
(assert (= v_5444 v_int_27_5375))
(assert (= res v_node_29_5172_primed))
(assert (= v_int_29_5378 0))
(assert (= v_int_29_5377 0))
(assert (= v_int_27_5376 1))
(assert (= v_int_27_5375 0))
(assert (= flted_21_5372 0))
(assert (= flted_21_5373 0))
(assert (= flted_21_5374 1))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= v_5383 v_int_29_5377))
(assert (= l_5384 a_primed))
(assert (= r_5387 tmp_5379))
(assert (or (and (and (and (= flted_21_5374 0) (<= 2 bha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= bha 1)) (= flted_21_5374 0)) (and (and (and (= flted_21_5374 1) (<= 1 bha)) (<= 1 na)) (> a 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)