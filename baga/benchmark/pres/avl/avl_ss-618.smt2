(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height_5421 () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun size1_5424 () Int)
(declare-fun height1_5425 () Int)
(declare-fun m_5441 () Int)
(declare-fun n_5442 () Int)
(declare-fun size2_5427 () Int)
(declare-fun height2_5428 () Int)
(declare-fun p_5539 () Int)
(declare-fun m_5476 () Int)
(declare-fun q_5426 () Int)
(declare-fun m_5547 () Int)
(declare-fun n_5477 () Int)
(declare-fun n1_5456 () Int)
(declare-fun flted_220_5455 () Int)
(declare-fun height_5537 () Int)
(declare-fun n_5465 () Int)
(declare-fun height1_5541 () Int)
(declare-fun m_5464 () Int)
(declare-fun size1_5540 () Int)
(declare-fun n_5548 () Int)
(declare-fun size2_5543 () Int)
(declare-fun height2_5544 () Int)
(declare-fun v_node_240_1585_primed () Int)
(declare-fun m_5560 () Int)
(declare-fun n_5561 () Int)
(declare-fun q_5542 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 height2_5428))
(assert (<= 0 size2_5427))
(assert (<= 0 n_5442))
(assert (<= 0 m_5441))
(assert (<= 0 height1_5425))
(assert (<= 0 size1_5424))
(assert (= height_5421 n))
(assert (= m (+ (+ size2_5427 1) size1_5424)))
(assert (<= height2_5428 (+ 1 height1_5425)))
(assert (<= height1_5425 (+ 1 height2_5428)))
(assert (exists ((max_5590 Int)) (and (= n (+ 1 max_5590)) (or (and (= max_5590 height1_5425) (>= height1_5425 height2_5428)) (and (= max_5590 height2_5428) (< height1_5425 height2_5428))))))
(assert (= m_5441 size1_5424))
(assert (= n_5442 height1_5425))
(assert (= flted_220_5455 (+ 1 m_5441)))
(assert (<= n_5442 n1_5456))
(assert (<= n1_5456 (+ 1 n_5442)))
(assert (= m_5476 size2_5427))
(assert (= n_5477 height2_5428))
(assert (<= 0 m_5476))
(assert (<= 0 n_5477))
(assert (or (and (and (< p_5539 1) (= m_5547 0)) (= n_5548 0)) (and (and (<= 1 n_5548) (<= 1 m_5547)) (> p_5539 0))))
(assert (or (and (and (< q_5426 1) (= m_5476 0)) (= n_5477 0)) (and (and (<= 1 n_5477) (<= 1 m_5476)) (> q_5426 0))))
(assert (<= 0 height2_5544))
(assert (<= 0 size2_5543))
(assert (<= 0 n_5548))
(assert (<= 0 m_5547))
(assert (<= 0 height1_5541))
(assert (<= 0 size1_5540))
(assert (= n_5548 height1_5541))
(assert (= m_5547 size1_5540))
(assert (= (+ 2 n_5477) n_5465))
(assert (<= 0 n_5465))
(assert (<= 0 m_5464))
(assert (<= 0 n1_5456))
(assert (<= 0 flted_220_5455))
(assert (= n_5465 n1_5456))
(assert (= m_5464 flted_220_5455))
(assert (= height_5537 n_5465))
(assert (exists ((max_5591 Int)) (and (= n_5465 (+ 1 max_5591)) (or (and (= max_5591 height1_5541) (>= height1_5541 height2_5544)) (and (= max_5591 height2_5544) (< height1_5541 height2_5544))))))
(assert (<= height1_5541 (+ 1 height2_5544)))
(assert (<= height2_5544 (+ 1 height1_5541)))
(assert (= m_5464 (+ (+ size2_5543 1) size1_5540)))
(assert (< n_5561 n_5548))
(assert (= m_5560 size2_5543))
(assert (= n_5561 height2_5544))
(assert (<= 0 m_5560))
(assert (<= 0 n_5561))
(assert (= v_node_240_1585_primed q_5542))
(assert (or (and (and (< q_5542 1) (= m_5560 0)) (= n_5561 0)) (and (and (<= 1 n_5561) (<= 1 m_5560)) (> q_5542 0))))
;Negation of Consequence
(assert (not (or (= m_5560 0) (or (= n_5561 0) (< q_5542 1)))))
(check-sat)