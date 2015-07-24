(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_6337 () Int)
(declare-fun m_6336 () Int)
(declare-fun v_node_329_2339_primed () Int)
(declare-fun q_6016 () Int)
(declare-fun height_327_6331 () Int)
(declare-fun h_primed () Int)
(declare-fun h_6328 () Int)
(declare-fun hl_primed () Int)
(declare-fun right_322_6303 () Int)
(declare-fun hlt_primed () Int)
(declare-fun left_320_6286 () Int)
(declare-fun hr_primed () Int)
(declare-fun left_318_6269 () Int)
(declare-fun right_317_6262 () Int)
(declare-fun p_6013 () Int)
(declare-fun m_6194 () Int)
(declare-fun n_6195 () Int)
(declare-fun m_6034 () Int)
(declare-fun m_6021 () Int)
(declare-fun v_node_289_5935 () Int)
(declare-fun n_5951 () Int)
(declare-fun m_5950 () Int)
(declare-fun right_289_5931 () Int)
(declare-fun n1_5930 () Int)
(declare-fun flted_220_5929 () Int)
(declare-fun n_5916 () Int)
(declare-fun m_5915 () Int)
(declare-fun tmp_primed () Int)
(declare-fun q_5426 () Int)
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
(declare-fun Anon_5422 () Int)
(declare-fun a_primed () Int)
(declare-fun v_bool_230_2438_primed () Int)
(declare-fun v_bool_290_2437_primed () Int)
(declare-fun height_6011 () Int)
(declare-fun n_5939 () Int)
(declare-fun height2_6018 () Int)
(declare-fun height1_6015 () Int)
(declare-fun m_5938 () Int)
(declare-fun size2_6017 () Int)
(declare-fun size1_6014 () Int)
(declare-fun n_6022 () Int)
(declare-fun n_6035 () Int)
(declare-fun v_bool_293_2425_primed () Int)
(declare-fun v_bool_313_2424_primed () Int)
(declare-fun height_6250 () Int)
(declare-fun n_6176 () Int)
(declare-fun height2_6257 () Int)
(declare-fun height1_6254 () Int)
(declare-fun m_6175 () Int)
(declare-fun size2_6256 () Int)
(declare-fun size1_6253 () Int)
(declare-fun n_6275 () Int)
(declare-fun m_6274 () Int)
(declare-fun p_6252 () Int)
(declare-fun n_6292 () Int)
(declare-fun m_6291 () Int)
(declare-fun q_6255 () Int)
(declare-fun n_6309 () Int)
(declare-fun m_6308 () Int)
(declare-fun p_5423 () Int)
(declare-fun k1_primed () Int)
(declare-fun k2_primed () Int)
(declare-fun x_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= n_6337 n_6195))
(assert (= m_6336 m_6194))
(assert (= v_node_329_2339_primed q_6016))
(assert (= height_327_6331 height_5421))
(assert (= h_primed (+ 1 h_6328)))
(assert (or (and (= h_6328 hl_primed) (>= hl_primed hr_primed)) (and (= h_6328 hr_primed) (< hl_primed hr_primed))))
(assert (<= 0 n_6309))
(assert (<= 0 m_6308))
(assert (= hl_primed n_6309))
(assert (<= 0 n_5951))
(assert (<= 0 m_5950))
(assert (= n_6309 n_5951))
(assert (= m_6308 m_5950))
(assert (= right_322_6303 q_6255))
(assert (<= 0 n_6292))
(assert (<= 0 m_6291))
(assert (= hlt_primed n_6292))
(assert (<= 0 height2_6257))
(assert (<= 0 size2_6256))
(assert (= n_6292 height2_6257))
(assert (= m_6291 size2_6256))
(assert (= left_320_6286 p_6252))
(assert (<= 0 n_6275))
(assert (<= 0 m_6274))
(assert (= hr_primed n_6275))
(assert (<= 0 height1_6254))
(assert (<= 0 size1_6253))
(assert (= n_6275 height1_6254))
(assert (= m_6274 size1_6253))
(assert (= left_318_6269 p_6013))
(assert (= right_317_6262 v_node_289_5935))
(assert (= k2_primed p_6013))
(assert (<= 0 n_6195))
(assert (<= 0 m_6194))
(assert (<= 0 n_6022))
(assert (<= 0 m_6021))
(assert (= n_6195 n_6022))
(assert (= m_6194 m_6021))
(assert (= (+ n_6195 1) n_6176))
(assert (<= 0 n_6176))
(assert (<= 0 m_6175))
(assert (<= 0 n_6035))
(assert (<= 0 m_6034))
(assert (= n_6176 n_6035))
(assert (= m_6175 m_6034))
(assert (<= 0 height1_6015))
(assert (<= 0 size1_6014))
(assert (= n_6035 height1_6015))
(assert (= m_6034 size1_6014))
(assert (<= 0 height2_6018))
(assert (<= 0 size2_6017))
(assert (= n_6022 height2_6018))
(assert (= m_6021 size2_6017))
(assert (= k1_primed v_node_289_5935))
(assert (= (+ 2 n_5951) n_5939))
(assert (<= 0 height1_5425))
(assert (<= 0 size1_5424))
(assert (= n_5951 height1_5425))
(assert (= m_5950 size1_5424))
(assert (<= 0 n_5939))
(assert (<= 0 m_5938))
(assert (<= 0 n1_5930))
(assert (<= 0 flted_220_5929))
(assert (= n_5939 n1_5930))
(assert (= m_5938 flted_220_5929))
(assert (= right_289_5931 q_5426))
(assert (<= 0 n_5916))
(assert (<= 0 m_5915))
(assert (<= n1_5930 (+ 1 n_5916)))
(assert (<= n_5916 n1_5930))
(assert (= flted_220_5929 (+ 1 m_5915)))
(assert (<= 0 height2_5428))
(assert (<= 0 size2_5427))
(assert (= n_5916 height2_5428))
(assert (= m_5915 size2_5427))
(assert (= tmp_primed q_5426))
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
(assert (< Anon_5422 a_primed))
(assert (not (> v_bool_230_2438_primed 0)))
(assert (> v_bool_290_2437_primed 0))
(assert (= height_6011 n_5939))
(assert (exists ((max_33 Int)) (and (= n_5939 (+ 1 max_33)) (or (and (= max_33 height1_6015) (>= height1_6015 height2_6018)) (and (= max_33 height2_6018) (< height1_6015 height2_6018))))))
(assert (<= height1_6015 (+ 1 height2_6018)))
(assert (<= height2_6018 (+ 1 height1_6015)))
(assert (= m_5938 (+ (+ size2_6017 1) size1_6014)))
(assert (<= n_6022 n_6035))
(assert (not (> v_bool_293_2425_primed 0)))
(assert (> v_bool_313_2424_primed 0))
(assert (= height_6250 n_6176))
(assert (exists ((max_33 Int)) (and (= n_6176 (+ 1 max_33)) (or (and (= max_33 height1_6254) (>= height1_6254 height2_6257)) (and (= max_33 height2_6257) (< height1_6254 height2_6257))))))
(assert (<= height1_6254 (+ 1 height2_6257)))
(assert (<= height2_6257 (+ 1 height1_6254)))
(assert (= m_6175 (+ (+ size2_6256 1) size1_6253)))
(assert (= k1_primed 1))
(assert (or (and (and (< p_6252 1) (= m_6274 0)) (= n_6275 0)) (and (and (<= 1 n_6275) (<= 1 m_6274)) (> p_6252 0))))
(assert (or (and (and (< q_6255 1) (= m_6291 0)) (= n_6292 0)) (and (and (<= 1 n_6292) (<= 1 m_6291)) (> q_6255 0))))
(assert (= k2_primed 2))
(assert (or (and (and (< p_5423 1) (= m_6308 0)) (= n_6309 0)) (and (and (<= 1 n_6309) (<= 1 m_6308)) (> p_5423 0))))
(assert (= x_primed 3))
(assert (not (= k1_primed x_primed)))
(assert (not (= k1_primed k2_primed)))
(assert (not (= k2_primed x_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)