(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_230_2438_primed () Int)
(declare-fun Anon_5422 () Int)
(declare-fun m () Int)
(declare-fun height_5421 () Int)
(declare-fun n () Int)
(declare-fun v_bool_226_2439_primed () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun size2_5427 () Int)
(declare-fun height2_5428 () Int)
(declare-fun m_5915 () Int)
(declare-fun n_5916 () Int)
(declare-fun right_289_5931 () Int)
(declare-fun q_5426 () Int)
(declare-fun flted_220_5929 () Int)
(declare-fun n1_5930 () Int)
(declare-fun size1_5424 () Int)
(declare-fun height1_5425 () Int)
(declare-fun v_int_290_2005_primed () Int)
(declare-fun v_int_290_2004_primed () Int)
(declare-fun x_primed () Int)
(declare-fun n_5939 () Int)
(declare-fun m_5938 () Int)
(declare-fun v_node_289_5935 () Int)
(declare-fun n_5951 () Int)
(declare-fun m_5950 () Int)
(declare-fun p_5423 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (not (> v_bool_230_2438_primed 0)))
(assert (< Anon_5422 a_primed))
(assert (= m (+ (+ size2_5427 1) size1_5424)))
(assert (<= height2_5428 (+ 1 height1_5425)))
(assert (<= height1_5425 (+ 1 height2_5428)))
(assert (exists ((max_33 Int)) (and (= n (+ 1 max_33)) (or (and (= max_33 height1_5425) (>= height1_5425 height2_5428)) (and (= max_33 height2_5428) (< height1_5425 height2_5428))))))
(assert (= height_5421 n))
(assert (not (> v_bool_226_2439_primed 0)))
(assert (> x_primed 0))
(assert (< tmp_null_primed 1))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= tmp_primed q_5426))
(assert (= m_5915 size2_5427))
(assert (= n_5916 height2_5428))
(assert (<= 0 size2_5427))
(assert (<= 0 height2_5428))
(assert (= flted_220_5929 (+ 1 m_5915)))
(assert (<= n_5916 n1_5930))
(assert (<= n1_5930 (+ 1 n_5916)))
(assert (<= 0 m_5915))
(assert (<= 0 n_5916))
(assert (= right_289_5931 q_5426))
(assert (= m_5938 flted_220_5929))
(assert (= n_5939 n1_5930))
(assert (<= 0 flted_220_5929))
(assert (<= 0 n1_5930))
(assert (<= 0 m_5938))
(assert (<= 0 n_5939))
(assert (= m_5950 size1_5424))
(assert (= n_5951 height1_5425))
(assert (<= 0 size1_5424))
(assert (<= 0 height1_5425))
(assert (<= 0 m_5950))
(assert (<= 0 n_5951))
(assert (= (+ v_int_290_2005_primed n_5951) n_5939))
(assert (= v_int_290_2004_primed 2))
(assert (= v_int_290_2005_primed v_int_290_2004_primed))
(assert (= x_primed 1))
(assert (or (and (and (< v_node_289_5935 1) (= m_5938 0)) (= n_5939 0)) (and (and (<= 1 n_5939) (<= 1 m_5938)) (> v_node_289_5935 0))))
(assert (or (and (and (< p_5423 1) (= m_5950 0)) (= n_5951 0)) (and (and (<= 1 n_5951) (<= 1 m_5950)) (> p_5423 0))))
;Negation of Consequence
(assert (not false))
(check-sat)