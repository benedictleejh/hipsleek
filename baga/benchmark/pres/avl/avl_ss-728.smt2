(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_273_1880_primed () Int)
(declare-fun left_273_1879_primed () Int)
(declare-fun height_273_1878_primed () Int)
(declare-fun val_273_1877_primed () Int)
(declare-fun v_int_273_1892_primed () Int)
(declare-fun height_271_5832 () Int)
(declare-fun h_primed () Int)
(declare-fun h_5829 () Int)
(declare-fun hr_primed () Int)
(declare-fun height_266_5804 () Int)
(declare-fun h_5801 () Int)
(declare-fun hl_primed () Int)
(declare-fun right_261_5776 () Int)
(declare-fun hlt_primed () Int)
(declare-fun left_259_5759 () Int)
(declare-fun hr_5818 () Int)
(declare-fun right_257_5742 () Int)
(declare-fun left_256_5735 () Int)
(declare-fun q_5542 () Int)
(declare-fun n_5657 () Int)
(declare-fun m_5656 () Int)
(declare-fun m_5560 () Int)
(declare-fun m_5547 () Int)
(declare-fun v_node_233_5461 () Int)
(declare-fun n_5477 () Int)
(declare-fun m_5476 () Int)
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
(declare-fun x_primed () Int)
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
(declare-fun height2_5544 () Int)
(declare-fun height1_5541 () Int)
(declare-fun m_5464 () Int)
(declare-fun size2_5543 () Int)
(declare-fun size1_5540 () Int)
(declare-fun n_5548 () Int)
(declare-fun n_5561 () Int)
(declare-fun v_bool_237_1920_primed () Int)
(declare-fun v_bool_253_1919_primed () Int)
(declare-fun height_5723 () Int)
(declare-fun n_5670 () Int)
(declare-fun height2_5730 () Int)
(declare-fun height1_5727 () Int)
(declare-fun m_5669 () Int)
(declare-fun size2_5729 () Int)
(declare-fun size1_5726 () Int)
(declare-fun Anon_5837 () Int)
(declare-fun Anon_5538 () Int)
(declare-fun p_5838 () Int)
(declare-fun p_5539 () Int)
(declare-fun q_5841 () Int)
(declare-fun p_5725 () Int)
(declare-fun m_5781 () Int)
(declare-fun n_5782 () Int)
(declare-fun m_5747 () Int)
(declare-fun n_5748 () Int)
(declare-fun h_5823 () Int)
(declare-fun height1_5840 () Int)
(declare-fun height2_5843 () Int)
(declare-fun size2_5842 () Int)
(declare-fun size1_5839 () Int)
(declare-fun n_5765 () Int)
(declare-fun m_5764 () Int)
(declare-fun q_5728 () Int)
(declare-fun k2_primed () Int)
(declare-fun n_5810 () Int)
(declare-fun m_5809 () Int)
(declare-fun q_5426 () Int)
(declare-fun n_5834 () Int)
(declare-fun m_5833 () Int)
(declare-fun k1_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_273_1880_primed q_5426))
(assert (= left_273_1879_primed q_5728))
(assert (= height_273_1878_primed h_primed))
(assert (= val_273_1877_primed Anon_5422))
(assert (<= 0 n_5834))
(assert (<= 0 m_5833))
(assert (= v_int_273_1892_primed n_5834))
(assert (> k1_primed 0))
(assert (<= 0 n_5782))
(assert (<= 0 m_5781))
(assert (<= 0 n_5748))
(assert (<= 0 m_5747))
(assert (= height_271_5832 height_5421))
(assert (= h_primed (+ 1 h_5829)))
(assert (or (and (= h_5829 hlt_primed) (>= hlt_primed hr_primed)) (and (= h_5829 hr_primed) (< hlt_primed hr_primed))))
(assert (<= 0 n_5810))
(assert (<= 0 m_5809))
(assert (= hr_primed n_5810))
(assert (<= 0 n_5477))
(assert (<= 0 m_5476))
(assert (= n_5810 n_5477))
(assert (= m_5809 m_5476))
(assert (= height_266_5804 height_5537))
(assert (= h_5823 (+ 1 h_5801)))
(assert (or (and (= h_5801 hl_primed) (>= hl_primed hr_5818)) (and (= h_5801 hr_5818) (< hl_primed hr_5818))))
(assert (= hl_primed n_5782))
(assert (<= 0 n_5657))
(assert (<= 0 m_5656))
(assert (= n_5782 n_5657))
(assert (= m_5781 m_5656))
(assert (= right_261_5776 q_5728))
(assert (<= 0 n_5765))
(assert (<= 0 m_5764))
(assert (= hlt_primed n_5765))
(assert (<= 0 height2_5730))
(assert (<= 0 size2_5729))
(assert (= n_5765 height2_5730))
(assert (= m_5764 size2_5729))
(assert (= left_259_5759 p_5725))
(assert (= hr_5818 n_5748))
(assert (<= 0 height1_5727))
(assert (<= 0 size1_5726))
(assert (= n_5748 height1_5727))
(assert (= m_5747 size1_5726))
(assert (= right_257_5742 q_5542))
(assert (= left_256_5735 v_node_233_5461))
(assert (= k2_primed q_5542))
(assert (= (+ n_5657 1) n_5670))
(assert (<= 0 n_5670))
(assert (<= 0 m_5669))
(assert (<= 0 n_5561))
(assert (<= 0 m_5560))
(assert (= n_5670 n_5561))
(assert (= m_5669 m_5560))
(assert (<= 0 n_5548))
(assert (<= 0 m_5547))
(assert (= n_5657 n_5548))
(assert (= m_5656 m_5547))
(assert (<= 0 height2_5544))
(assert (<= 0 size2_5543))
(assert (= n_5561 height2_5544))
(assert (= m_5560 size2_5543))
(assert (<= 0 height1_5541))
(assert (<= 0 size1_5540))
(assert (= n_5548 height1_5541))
(assert (= m_5547 size1_5540))
(assert (= k1_primed v_node_233_5461))
(assert (= (+ 2 n_5477) n_5465))
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
(assert (<= n_5548 n_5561))
(assert (not (> v_bool_237_1920_primed 0)))
(assert (> v_bool_253_1919_primed 0))
(assert (= height_5723 n_5670))
(assert (exists ((max_33 Int)) (and (= n_5670 (+ 1 max_33)) (or (and (= max_33 height1_5727) (>= height1_5727 height2_5730)) (and (= max_33 height2_5730) (< height1_5727 height2_5730))))))
(assert (<= height1_5727 (+ 1 height2_5730)))
(assert (<= height2_5730 (+ 1 height1_5727)))
(assert (= m_5669 (+ (+ size2_5729 1) size1_5726)))
(assert (= Anon_5837 Anon_5538))
(assert (= p_5838 p_5539))
(assert (= q_5841 p_5725))
(assert (= size1_5839 m_5781))
(assert (= height1_5840 n_5782))
(assert (= size2_5842 m_5747))
(assert (= height2_5843 n_5748))
(assert (<= height1_5840 (+ 1 height2_5843)))
(assert (<= height2_5843 (+ 1 height1_5840)))
(assert (or (and (= h_5823 (+ height1_5840 1)) (<= height2_5843 height1_5840)) (and (= h_5823 (+ height2_5843 1)) (< height1_5840 height2_5843))))
(assert (= h_5823 n_5834))
(assert (exists ((max_33 Int)) (and (= n_5834 (+ 1 max_33)) (or (and (= max_33 height1_5840) (>= height1_5840 height2_5843)) (and (= max_33 height2_5843) (< height1_5840 height2_5843))))))
(assert (= m_5833 (+ (+ size2_5842 1) size1_5839)))
(assert (or (and (and (< q_5728 1) (= m_5764 0)) (= n_5765 0)) (and (and (<= 1 n_5765) (<= 1 m_5764)) (> q_5728 0))))
(assert (= k2_primed 1))
(assert (or (and (and (< q_5426 1) (= m_5809 0)) (= n_5810 0)) (and (and (<= 1 n_5810) (<= 1 m_5809)) (> q_5426 0))))
(assert (or (and (and (< k1_primed 1) (= m_5833 0)) (= n_5834 0)) (and (and (<= 1 n_5834) (<= 1 m_5833)) (> k1_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)