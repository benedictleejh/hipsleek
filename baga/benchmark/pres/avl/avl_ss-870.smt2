(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height_5421 () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun size2_5427 () Int)
(declare-fun height2_5428 () Int)
(declare-fun m_5915 () Int)
(declare-fun n_5916 () Int)
(declare-fun size1_5424 () Int)
(declare-fun height1_5425 () Int)
(declare-fun m_5950 () Int)
(declare-fun p_5423 () Int)
(declare-fun n_5951 () Int)
(declare-fun n1_5930 () Int)
(declare-fun flted_220_5929 () Int)
(declare-fun height_6011 () Int)
(declare-fun m_5938 () Int)
(declare-fun n_5939 () Int)
(declare-fun size2_6017 () Int)
(declare-fun height2_6018 () Int)
(declare-fun size1_6014 () Int)
(declare-fun height1_6015 () Int)
(declare-fun m_6021 () Int)
(declare-fun m_6194 () Int)
(declare-fun q_6016 () Int)
(declare-fun q_6255 () Int)
(declare-fun n_6022 () Int)
(declare-fun n_6195 () Int)
(declare-fun n_6035 () Int)
(declare-fun m_6034 () Int)
(declare-fun height_6250 () Int)
(declare-fun m_6175 () Int)
(declare-fun size2_6256 () Int)
(declare-fun n_6176 () Int)
(declare-fun height2_6257 () Int)
(declare-fun v_node_319_2261_primed () Int)
(declare-fun size1_6253 () Int)
(declare-fun height1_6254 () Int)
(declare-fun p_6252 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 height1_5425))
(assert (<= 0 size1_5424))
(assert (<= 0 n_5916))
(assert (<= 0 m_5915))
(assert (<= 0 height2_5428))
(assert (<= 0 size2_5427))
(assert (= height_5421 n))
(assert (= m (+ (+ size2_5427 1) size1_5424)))
(assert (<= height2_5428 (+ 1 height1_5425)))
(assert (<= height1_5425 (+ 1 height2_5428)))
(assert (exists ((max_6278 Int)) (and (= n (+ 1 max_6278)) (or (and (= max_6278 height1_5425) (>= height1_5425 height2_5428)) (and (= max_6278 height2_5428) (< height1_5425 height2_5428))))))
(assert (= m_5915 size2_5427))
(assert (= n_5916 height2_5428))
(assert (= flted_220_5929 (+ 1 m_5915)))
(assert (<= n_5916 n1_5930))
(assert (<= n1_5930 (+ 1 n_5916)))
(assert (= m_5950 size1_5424))
(assert (= n_5951 height1_5425))
(assert (<= 0 m_5950))
(assert (<= 0 n_5951))
(assert (or (and (and (< p_5423 1) (= m_5950 0)) (= n_5951 0)) (and (and (<= 1 n_5951) (<= 1 m_5950)) (> p_5423 0))))
(assert (<= 0 m_6021))
(assert (<= 0 height1_6015))
(assert (<= 0 size1_6014))
(assert (<= 0 height2_6018))
(assert (<= 0 size2_6017))
(assert (= (+ 2 n_5951) n_5939))
(assert (<= 0 n_5939))
(assert (<= 0 m_5938))
(assert (<= 0 n1_5930))
(assert (<= 0 flted_220_5929))
(assert (= n_5939 n1_5930))
(assert (= m_5938 flted_220_5929))
(assert (= height_6011 n_5939))
(assert (<= n_6022 n_6035))
(assert (= m_5938 (+ (+ size2_6017 1) size1_6014)))
(assert (<= height2_6018 (+ 1 height1_6015)))
(assert (<= height1_6015 (+ 1 height2_6018)))
(assert (exists ((max_6279 Int)) (and (= n_5939 (+ 1 max_6279)) (or (and (= max_6279 height1_6015) (>= height1_6015 height2_6018)) (and (= max_6279 height2_6018) (< height1_6015 height2_6018))))))
(assert (= m_6021 size2_6017))
(assert (= n_6022 height2_6018))
(assert (= m_6034 size1_6014))
(assert (= n_6035 height1_6015))
(assert (= m_6194 m_6021))
(assert (<= 0 m_6194))
(assert (or (and (and (< q_6016 1) (= m_6194 0)) (= n_6195 0)) (and (and (<= 1 n_6195) (<= 1 m_6194)) (> q_6016 0))))
(assert (or (and (and (< q_6255 1) (= size2_6256 0)) (= height2_6257 0)) (and (and (<= 1 height2_6257) (<= 1 size2_6256)) (> q_6255 0))))
(assert (<= 0 n_6195))
(assert (<= 0 n_6022))
(assert (= n_6195 n_6022))
(assert (= (+ n_6195 1) n_6176))
(assert (<= 0 n_6176))
(assert (<= 0 m_6175))
(assert (<= 0 n_6035))
(assert (<= 0 m_6034))
(assert (= n_6176 n_6035))
(assert (= m_6175 m_6034))
(assert (= height_6250 n_6176))
(assert (= m_6175 (+ (+ size2_6256 1) size1_6253)))
(assert (<= height2_6257 (+ 1 height1_6254)))
(assert (<= height1_6254 (+ 1 height2_6257)))
(assert (exists ((max_6280 Int)) (and (= n_6176 (+ 1 max_6280)) (or (and (= max_6280 height1_6254) (>= height1_6254 height2_6257)) (and (= max_6280 height2_6257) (< height1_6254 height2_6257))))))
(assert (= v_node_319_2261_primed p_6252))
(assert (or (and (and (< p_6252 1) (= size1_6253 0)) (= height1_6254 0)) (and (and (<= 1 height1_6254) (<= 1 size1_6253)) (> p_6252 0))))
;Negation of Consequence
(assert (not (or (= size1_6253 0) (or (= height1_6254 0) (< p_6252 1)))))
(check-sat)