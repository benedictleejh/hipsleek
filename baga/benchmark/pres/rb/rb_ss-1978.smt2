(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun v_node_232_3952_primed () Int)
(declare-fun v_int_232_13436 () Int)
(declare-fun v_int_230_13434 () Int)
(declare-fun v_int_230_13433 () Int)
(declare-fun b_primed () Int)
(declare-fun a_primed () Int)
(declare-fun v_13451 () Int)
(declare-fun v_int_232_13435 () Int)
(declare-fun l_13452 () Int)
(declare-fun r_13456 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_224_13432 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_224_13431 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_224_13430 () Int)
(declare-fun ha () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun tmp_13437 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res v_node_232_3952_primed))
(assert (= v_int_232_13436 0))
(assert (= v_int_232_13435 0))
(assert (= v_int_230_13434 1))
(assert (= v_int_230_13433 0))
(assert (= flted_224_13430 0))
(assert (= flted_224_13431 0))
(assert (= flted_224_13432 0))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= v_13451 v_int_232_13435))
(assert (= l_13452 tmp_13437))
(assert (= r_13456 c_primed))
(assert (or (and (and (and (= flted_224_13432 0) (<= 2 ha)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= ha 1)) (= flted_224_13432 0)) (and (and (and (= flted_224_13432 1) (<= 1 ha)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_224_13431 0) (<= 2 ha)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha 1)) (= flted_224_13431 0)) (and (and (and (= flted_224_13431 1) (<= 1 ha)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_224_13430 0) (<= 2 ha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha 1)) (= flted_224_13430 0)) (and (and (and (= flted_224_13430 1) (<= 1 ha)) (<= 1 nc)) (> c 0)))))
(assert (= tmp_13437 1))
;Negation of Consequence
(assert (not false))
(check-sat)