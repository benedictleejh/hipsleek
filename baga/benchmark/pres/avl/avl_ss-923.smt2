(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_int_334_2396_primed () Int)
(declare-fun height_327_6331 () Int)
(declare-fun m_5950 () Int)
(declare-fun x () Int)
(declare-fun height_5421 () Int)
(declare-fun m_6308 () Int)
(declare-fun m_6274 () Int)
(declare-fun size2_6369 () Int)
(declare-fun size1_6366 () Int)
(declare-fun m_6360 () Int)
(declare-fun x_primed () Int)
(declare-fun n_6361 () Int)
(declare-fun height2_6370 () Int)
(declare-fun height1_6367 () Int)
(declare-fun size1_6253 () Int)
(declare-fun m () Int)
(declare-fun size1_5424 () Int)
(declare-fun n () Int)
(declare-fun size2_5427 () Int)
(declare-fun height2_5428 () Int)
(declare-fun m_5915 () Int)
(declare-fun n_5916 () Int)
(declare-fun height1_5425 () Int)
(declare-fun height_332_6359 () Int)
(declare-fun h_primed () Int)
(declare-fun h_6350 () Int)
(declare-fun h_6328 () Int)
(declare-fun hl_primed () Int)
(declare-fun n_6309 () Int)
(declare-fun right_322_6303 () Int)
(declare-fun size2_6256 () Int)
(declare-fun hr_6345 () Int)
(declare-fun n_6275 () Int)
(declare-fun m_6175 () Int)
(declare-fun m_6034 () Int)
(declare-fun n_5951 () Int)
(declare-fun n1_5930 () Int)
(declare-fun flted_220_5929 () Int)
(declare-fun height_6011 () Int)
(declare-fun p_6421 () Int)
(declare-fun size1_6422 () Int)
(declare-fun m_6291 () Int)
(declare-fun q_6255 () Int)
(declare-fun height1_6423 () Int)
(declare-fun height1_6254 () Int)
(declare-fun height_6250 () Int)
(declare-fun m_5938 () Int)
(declare-fun size1_6014 () Int)
(declare-fun n_5939 () Int)
(declare-fun size2_6017 () Int)
(declare-fun height2_6018 () Int)
(declare-fun height1_6015 () Int)
(declare-fun n_6035 () Int)
(declare-fun n_6176 () Int)
(declare-fun m_6021 () Int)
(declare-fun n_6022 () Int)
(declare-fun height2_6257 () Int)
(declare-fun n_6292 () Int)
(declare-fun h_6356 () Int)
(declare-fun hlt_primed () Int)
(declare-fun hr_primed () Int)
(declare-fun n_6195 () Int)
(declare-fun m_6194 () Int)
(declare-fun q_6424 () Int)
(declare-fun m_6336 () Int)
(declare-fun n_6337 () Int)
(declare-fun q_6016 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_6361))
(assert (<= 0 m_6360))
(assert (= v_int_334_2396_primed n_6361))
(assert (> x_primed 0))
(assert (<= 0 m_6308))
(assert (<= 0 m_6274))
(assert (= height_327_6331 height_5421))
(assert (<= 0 m_5950))
(assert (= m_6308 m_5950))
(assert (<= 0 size1_6253))
(assert (= m_6274 size1_6253))
(assert (<= 0 height1_5425))
(assert (<= 0 size1_5424))
(assert (= m_5950 size1_5424))
(assert (<= 0 n_5916))
(assert (<= 0 m_5915))
(assert (<= 0 height2_5428))
(assert (<= 0 size2_5427))
(assert (= x_primed x))
(assert (= height_5421 n))
(assert (= size1_6366 m_6308))
(assert (= size2_6369 m_6274))
(assert (= m_6360 (+ (+ size2_6369 1) size1_6366)))
(assert (or (and (and (< x_primed 1) (= m_6360 0)) (= n_6361 0)) (and (and (<= 1 n_6361) (<= 1 m_6360)) (> x_primed 0))))
(assert (exists ((max_6449 Int)) (and (= n_6361 (+ 1 max_6449)) (or (and (= max_6449 height1_6367) (>= height1_6367 height2_6370)) (and (= max_6449 height2_6370) (< height1_6367 height2_6370))))))
(assert (= h_6350 n_6361))
(assert (or (and (= h_6350 (+ height1_6367 1)) (<= height2_6370 height1_6367)) (and (= h_6350 (+ height2_6370 1)) (< height1_6367 height2_6370))))
(assert (<= height2_6370 (+ 1 height1_6367)))
(assert (<= height1_6367 (+ 1 height2_6370)))
(assert (= height2_6370 n_6275))
(assert (= height1_6367 n_6309))
(assert (= m_6175 (+ (+ size2_6256 1) size1_6253)))
(assert (= m (+ (+ size2_5427 1) size1_5424)))
(assert (<= height2_5428 (+ 1 height1_5425)))
(assert (<= height1_5425 (+ 1 height2_5428)))
(assert (exists ((max_6452 Int)) (and (= n (+ 1 max_6452)) (or (and (= max_6452 height1_5425) (>= height1_5425 height2_5428)) (and (= max_6452 height2_5428) (< height1_5425 height2_5428))))))
(assert (= m_5915 size2_5427))
(assert (= n_5916 height2_5428))
(assert (= flted_220_5929 (+ 1 m_5915)))
(assert (<= n_5916 n1_5930))
(assert (<= n1_5930 (+ 1 n_5916)))
(assert (= n_5951 height1_5425))
(assert (<= 0 n_6309))
(assert (<= 0 n_6275))
(assert (= height_332_6359 height_6011))
(assert (= h_primed (+ 1 h_6356)))
(assert (= h_6350 (+ 1 h_6328)))
(assert (or (and (= h_6328 hl_primed) (>= hl_primed hr_6345)) (and (= h_6328 hr_6345) (< hl_primed hr_6345))))
(assert (= hl_primed n_6309))
(assert (<= 0 n_5951))
(assert (= n_6309 n_5951))
(assert (= right_322_6303 q_6255))
(assert (<= 0 n_6292))
(assert (<= 0 m_6291))
(assert (<= 0 height2_6257))
(assert (<= 0 size2_6256))
(assert (= m_6291 size2_6256))
(assert (= hr_6345 n_6275))
(assert (<= 0 height1_6254))
(assert (= n_6275 height1_6254))
(assert (<= 0 n_6022))
(assert (<= 0 m_6021))
(assert (<= 0 m_6175))
(assert (<= 0 n_6035))
(assert (<= 0 m_6034))
(assert (= m_6175 m_6034))
(assert (<= 0 height1_6015))
(assert (<= 0 size1_6014))
(assert (= m_6034 size1_6014))
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
(assert (= p_6421 q_6255))
(assert (= size1_6422 m_6291))
(assert (or (and (and (< q_6255 1) (= m_6291 0)) (= n_6292 0)) (and (and (<= 1 n_6292) (<= 1 m_6291)) (> q_6255 0))))
(assert (= height1_6423 n_6292))
(assert (<= height2_6257 (+ 1 height1_6254)))
(assert (<= height1_6254 (+ 1 height2_6257)))
(assert (exists ((max_6450 Int)) (and (= n_6176 (+ 1 max_6450)) (or (and (= max_6450 height1_6254) (>= height1_6254 height2_6257)) (and (= max_6450 height2_6257) (< height1_6254 height2_6257))))))
(assert (= height_6250 n_6176))
(assert (<= n_6022 n_6035))
(assert (= m_5938 (+ (+ size2_6017 1) size1_6014)))
(assert (<= height2_6018 (+ 1 height1_6015)))
(assert (<= height1_6015 (+ 1 height2_6018)))
(assert (exists ((max_6451 Int)) (and (= n_5939 (+ 1 max_6451)) (or (and (= max_6451 height1_6015) (>= height1_6015 height2_6018)) (and (= max_6451 height2_6018) (< height1_6015 height2_6018))))))
(assert (= m_6021 size2_6017))
(assert (= n_6022 height2_6018))
(assert (= n_6035 height1_6015))
(assert (= n_6176 n_6035))
(assert (<= 0 n_6176))
(assert (= (+ n_6195 1) n_6176))
(assert (= m_6194 m_6021))
(assert (= n_6195 n_6022))
(assert (= n_6292 height2_6257))
(assert (= hlt_primed n_6292))
(assert (<= 0 m_6194))
(assert (<= 0 n_6195))
(assert (or (and (= h_6356 hlt_primed) (>= hlt_primed hr_primed)) (and (= h_6356 hr_primed) (< hlt_primed hr_primed))))
(assert (<= 0 n_6337))
(assert (<= 0 m_6336))
(assert (= hr_primed n_6337))
(assert (= n_6337 n_6195))
(assert (= m_6336 m_6194))
(assert (= q_6424 q_6016))
(assert (or (and (and (< q_6016 1) (= m_6336 0)) (= n_6337 0)) (and (and (<= 1 n_6337) (<= 1 m_6336)) (> q_6016 0))))
;Negation of Consequence
(assert (not (or (= m_6336 0) (or (= n_6337 0) (< q_6016 1)))))
(check-sat)