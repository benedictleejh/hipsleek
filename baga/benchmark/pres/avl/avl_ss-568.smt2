(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_233_1461_primed () Int)
(declare-fun left_233_1460_primed () Int)
(declare-fun height_233_1459_primed () Int)
(declare-fun val_233_1458_primed () Int)
(declare-fun n_5442 () Int)
(declare-fun m_5441 () Int)
(declare-fun tmp_primed () Int)
(declare-fun p_5423 () Int)
(declare-fun x () Int)
(declare-fun a () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_226_2439_primed () Int)
(declare-fun height_5421 () Int)
(declare-fun n () Int)
(declare-fun height1_5425 () Int)
(declare-fun m () Int)
(declare-fun size1_5424 () Int)
(declare-fun a_primed () Int)
(declare-fun Anon_5422 () Int)
(declare-fun v_bool_230_2438_primed () Int)
(declare-fun height2_5428 () Int)
(declare-fun size2_5427 () Int)
(declare-fun q_5426 () Int)
(declare-fun n1_5456 () Int)
(declare-fun flted_220_5455 () Int)
(declare-fun v_node_233_1457_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_233_1461_primed q_5426))
(assert (= left_233_1460_primed p_5423))
(assert (= height_233_1459_primed height_5421))
(assert (= val_233_1458_primed Anon_5422))
(assert (<= 0 n_5442))
(assert (<= 0 m_5441))
(assert (<= n1_5456 (+ 1 n_5442)))
(assert (<= n_5442 n1_5456))
(assert (= flted_220_5455 (+ 1 m_5441)))
(assert (<= 0 height1_5425))
(assert (<= 0 size1_5424))
(assert (= n_5442 height1_5425))
(assert (= m_5441 size1_5424))
(assert (= tmp_primed p_5423))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (< tmp_null_primed 1))
(assert (> x_primed 0))
(assert (not (> v_bool_226_2439_primed 0)))
(assert (= height_5421 n))
(assert (exists ((max_33 Int)) (and (= n (+ 1 max_33)) (or (and (= max_33 height1_5425) (>= height1_5425 height2_5428)) (and (= max_33 height2_5428) (< height1_5425 height2_5428))))))
(assert (<= height1_5425 (+ 1 height2_5428)))
(assert (<= height2_5428 (+ 1 height1_5425)))
(assert (= m (+ (+ size2_5427 1) size1_5424)))
(assert (<= a_primed Anon_5422))
(assert (> v_bool_230_2438_primed 0))
(assert (or (and (and (< q_5426 1) (= size2_5427 0)) (= height2_5428 0)) (and (and (<= 1 height2_5428) (<= 1 size2_5427)) (> q_5426 0))))
(assert (or (and (and (< v_node_233_1457_primed 1) (= flted_220_5455 0)) (= n1_5456 0)) (and (and (<= 1 n1_5456) (<= 1 flted_220_5455)) (> v_node_233_1457_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)