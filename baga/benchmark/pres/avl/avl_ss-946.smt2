(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun size2_6511 () Int)
(declare-fun size1_6508 () Int)
(declare-fun res () Int)
(declare-fun v_node_227_1427_primed () Int)
(declare-fun a () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_226_2439_primed () Int)
(declare-fun Anon_6506 () Int)
(declare-fun a_primed () Int)
(declare-fun p_6507 () Int)
(declare-fun q_6510 () Int)
(declare-fun tmp_6503 () Int)
(declare-fun v_int_227_6502 () Int)
(declare-fun height1_6509 () Int)
(declare-fun height2_6512 () Int)
(declare-fun n () Int)
(declare-fun m () Int)
(declare-fun x () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= size2_6511 0))
(assert (= height2_6512 0))
(assert (= size1_6508 0))
(assert (= height1_6509 0))
(assert (= res v_node_227_1427_primed))
(assert (= v_int_227_6502 1))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (< tmp_6503 1))
(assert (< x_primed 1))
(assert (> v_bool_226_2439_primed 0))
(assert (= Anon_6506 a_primed))
(assert (= p_6507 tmp_6503))
(assert (= q_6510 tmp_6503))
(assert (exists ((max_33 Int)) (and (= v_int_227_6502 (+ 1 max_33)) (or (and (= max_33 height1_6509) (>= height1_6509 height2_6512)) (and (= max_33 height2_6512) (< height1_6509 height2_6512))))))
(assert (or (and (and (< x 1) (= m 0)) (= n 0)) (and (and (<= 1 n) (<= 1 m)) (> x 0))))
;Negation of Consequence
(assert (not false))
(check-sat)