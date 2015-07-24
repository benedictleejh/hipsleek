(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_5548 () Int)
(declare-fun m_5547 () Int)
(declare-fun v_node_237_1534_primed () Int)
(declare-fun p_5539 () Int)
(declare-fun v_node_233_5461 () Int)
(declare-fun left_233_5457 () Int)
(declare-fun n1_5456 () Int)
(declare-fun flted_220_5455 () Int)
(declare-fun n_5442 () Int)
(declare-fun m_5441 () Int)
(declare-fun tmp_primed () Int)
(declare-fun p_5423 () Int)
(declare-fun x () Int)
(declare-fun a () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun v_bool_226_2439_primed () Int)
(declare-fun height_5421 () Int)
(declare-fun n () Int)
(declare-fun height2_5428 () Int)
(declare-fun height1_5425 () Int)
(declare-fun m () Int)
(declare-fun size2_5427 () Int)
(declare-fun size1_5424 () Int)
(declare-fun a_primed () Int)
(declare-fun Anon_5422 () Int)
(declare-fun v_bool_230_2438_primed () Int)
(declare-fun v_bool_234_1932_primed () Int)
(declare-fun height_5537 () Int)
(declare-fun n_5465 () Int)
(declare-fun height1_5541 () Int)
(declare-fun m_5464 () Int)
(declare-fun size1_5540 () Int)
(declare-fun height2_5544 () Int)
(declare-fun size2_5543 () Int)
(declare-fun q_5542 () Int)
(declare-fun n_5477 () Int)
(declare-fun m_5476 () Int)
(declare-fun q_5426 () Int)
(declare-fun x_primed () Int)
(declare-fun k1_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= n_5548 height1_5541))
(assert (= m_5547 size1_5540))
(assert (= v_node_237_1534_primed p_5539))
(assert (= k1_primed v_node_233_5461))
(assert (= (+ 2 n_5477) n_5465))
(assert (<= 0 n_5477))
(assert (<= 0 m_5476))
(assert (<= 0 height2_5428))
(assert (<= 0 size2_5427))
(assert (= n_5477 height2_5428))
(assert (= m_5476 size2_5427))
(assert (<= 0 n_5465))
(assert (<= 0 m_5464))
(assert (<= 0 n1_5456))
(assert (<= 0 flted_220_5455))
(assert (= n_5465 n1_5456))
(assert (= m_5464 flted_220_5455))
(assert (= left_233_5457 p_5423))
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
(assert (> v_bool_234_1932_primed 0))
(assert (= height_5537 n_5465))
(assert (exists ((max_33 Int)) (and (= n_5465 (+ 1 max_33)) (or (and (= max_33 height1_5541) (>= height1_5541 height2_5544)) (and (= max_33 height2_5544) (< height1_5541 height2_5544))))))
(assert (<= height1_5541 (+ 1 height2_5544)))
(assert (<= height2_5544 (+ 1 height1_5541)))
(assert (= m_5464 (+ (+ size2_5543 1) size1_5540)))
(assert (= x_primed 1))
(assert (= k1_primed 2))
(assert (or (and (and (< q_5542 1) (= size2_5543 0)) (= height2_5544 0)) (and (and (<= 1 height2_5544) (<= 1 size2_5543)) (> q_5542 0))))
(assert (or (and (and (< q_5426 1) (= m_5476 0)) (= n_5477 0)) (and (and (<= 1 n_5477) (<= 1 m_5476)) (> q_5426 0))))
(assert (not (= x_primed k1_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)