(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun size2_6017 () Int)
(declare-fun size1_6014 () Int)
(declare-fun m_6034 () Int)
(declare-fun left_297_6071 () Int)
(declare-fun m_6060 () Int)
(declare-fun p_6013 () Int)
(declare-fun m_6021 () Int)
(declare-fun q_6016 () Int)
(declare-fun hr_primed () Int)
(declare-fun n_6061 () Int)
(declare-fun n_6035 () Int)
(declare-fun n_6022 () Int)
(declare-fun m_5938 () Int)
(declare-fun n1_5930 () Int)
(declare-fun flted_220_5929 () Int)
(declare-fun n_5916 () Int)
(declare-fun m_5915 () Int)
(declare-fun height_5421 () Int)
(declare-fun n () Int)
(declare-fun height2_5428 () Int)
(declare-fun m () Int)
(declare-fun size2_5427 () Int)
(declare-fun height_6011 () Int)
(declare-fun height1_6015 () Int)
(declare-fun height2_6018 () Int)
(declare-fun size1_5424 () Int)
(declare-fun height1_5425 () Int)
(declare-fun n_5939 () Int)
(declare-fun v_node_299_2094_primed () Int)
(declare-fun m_5950 () Int)
(declare-fun n_5951 () Int)
(declare-fun p_5423 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 m_6034))
(assert (<= 0 size1_6014))
(assert (<= 0 size2_6017))
(assert (< n_6035 n_6022))
(assert (= m_5938 (+ (+ size2_6017 1) size1_6014)))
(assert (<= height2_6018 (+ 1 height1_6015)))
(assert (<= height1_6015 (+ 1 height2_6018)))
(assert (= m_6021 size2_6017))
(assert (<= 0 m_6021))
(assert (= m_6034 size1_6014))
(assert (= m_6060 m_6034))
(assert (<= 0 m_6060))
(assert (= left_297_6071 p_6013))
(assert (or (and (and (< p_6013 1) (= m_6060 0)) (= n_6061 0)) (and (and (<= 1 n_6061) (<= 1 m_6060)) (> p_6013 0))))
(assert (or (and (and (< q_6016 1) (= m_6021 0)) (= n_6022 0)) (and (and (<= 1 n_6022) (<= 1 m_6021)) (> q_6016 0))))
(assert (<= 0 n_6061))
(assert (= hr_primed n_6061))
(assert (<= 0 n_6035))
(assert (= n_6061 n_6035))
(assert (<= 0 height1_6015))
(assert (= n_6035 height1_6015))
(assert (<= 0 n_6022))
(assert (<= 0 height2_6018))
(assert (= n_6022 height2_6018))
(assert (<= 0 height1_5425))
(assert (<= 0 size1_5424))
(assert (<= 0 n_5939))
(assert (<= 0 m_5938))
(assert (<= 0 n1_5930))
(assert (<= 0 flted_220_5929))
(assert (= n_5939 n1_5930))
(assert (= m_5938 flted_220_5929))
(assert (<= 0 n_5916))
(assert (<= 0 m_5915))
(assert (<= n1_5930 (+ 1 n_5916)))
(assert (<= n_5916 n1_5930))
(assert (= flted_220_5929 (+ 1 m_5915)))
(assert (<= 0 height2_5428))
(assert (<= 0 size2_5427))
(assert (= n_5916 height2_5428))
(assert (= m_5915 size2_5427))
(assert (= height_5421 n))
(assert (exists ((max_6080 Int)) (and (= n (+ 1 max_6080)) (or (and (= max_6080 height1_5425) (>= height1_5425 height2_5428)) (and (= max_6080 height2_5428) (< height1_5425 height2_5428))))))
(assert (<= height1_5425 (+ 1 height2_5428)))
(assert (<= height2_5428 (+ 1 height1_5425)))
(assert (= m (+ (+ size2_5427 1) size1_5424)))
(assert (= height_6011 n_5939))
(assert (exists ((max_6081 Int)) (and (= n_5939 (+ 1 max_6081)) (or (and (= max_6081 height1_6015) (>= height1_6015 height2_6018)) (and (= max_6081 height2_6018) (< height1_6015 height2_6018))))))
(assert (= m_5950 size1_5424))
(assert (= n_5951 height1_5425))
(assert (<= 0 m_5950))
(assert (<= 0 n_5951))
(assert (= (+ 2 n_5951) n_5939))
(assert (= v_node_299_2094_primed p_5423))
(assert (or (and (and (< p_5423 1) (= m_5950 0)) (= n_5951 0)) (and (and (<= 1 n_5951) (<= 1 m_5950)) (> p_5423 0))))
;Negation of Consequence
(assert (not (or (= m_5950 0) (or (= n_5951 0) (< p_5423 1)))))
(check-sat)