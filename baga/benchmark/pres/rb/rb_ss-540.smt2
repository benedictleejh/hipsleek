(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_int_161_7343 () Int)
(declare-fun v_int_161_7342 () Int)
(declare-fun color_primed () Int)
(declare-fun color () Int)
(declare-fun d_primed () Int)
(declare-fun c_primed () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun a_primed () Int)
(declare-fun nb_7283 () Int)
(declare-fun nb () Int)
(declare-fun Anon_18 () Int)
(declare-fun flted_153_7340 () Int)
(declare-fun flted_153_7341 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_153_7339 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_153_7338 () Int)
(declare-fun h () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
(declare-fun tmp_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= v_int_161_7343 1))
(assert (= v_int_161_7342 0))
(assert (= color 0))
(assert (= flted_153_7338 0))
(assert (= flted_153_7339 0))
(assert (= flted_153_7340 0))
(assert (= flted_153_7341 0))
(assert (= color_primed color))
(assert (= d_primed d))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= nb_7283 nb))
(assert (= Anon_18 flted_153_7340))
(assert (or (and (and (and (= flted_153_7341 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_153_7341 0)) (and (and (and (= flted_153_7341 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_153_7339 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_153_7339 0)) (and (and (and (= flted_153_7339 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_153_7338 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_153_7338 0)) (and (and (and (= flted_153_7338 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
(assert (= tmp_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)