(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height_5193 () Int)
(declare-fun v_bool_204_2891_primed () Int)
(declare-fun v_bool_198_2892_primed () Int)
(declare-fun height_5013 () Int)
(declare-fun v_bool_196_2898_primed () Int)
(declare-fun v_bool_170_2899_primed () Int)
(declare-fun Anon_4546 () Int)
(declare-fun m () Int)
(declare-fun height_4545 () Int)
(declare-fun n () Int)
(declare-fun v_bool_166_2900_primed () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun size2_4551 () Int)
(declare-fun height2_4552 () Int)
(declare-fun m_4917 () Int)
(declare-fun n_4918 () Int)
(declare-fun right_195_4933 () Int)
(declare-fun q_4550 () Int)
(declare-fun flted_161_4931 () Int)
(declare-fun Anon_4932 () Int)
(declare-fun m_4940 () Int)
(declare-fun size1_4548 () Int)
(declare-fun height1_4549 () Int)
(declare-fun n_4941 () Int)
(declare-fun size2_5019 () Int)
(declare-fun height2_5020 () Int)
(declare-fun size1_5016 () Int)
(declare-fun height1_5017 () Int)
(declare-fun m_5040 () Int)
(declare-fun n_5041 () Int)
(declare-fun m_5106 () Int)
(declare-fun n_5107 () Int)
(declare-fun m_5023 () Int)
(declare-fun n_5024 () Int)
(declare-fun v_node_205_2884_primed () Int)
(declare-fun p_4547 () Int)
(declare-fun v_node_205_2883_primed () Int)
(declare-fun p_5195 () Int)
(declare-fun v_node_205_2882_primed () Int)
(declare-fun q_5198 () Int)
(declare-fun v_node_205_2881_primed () Int)
(declare-fun q_5018 () Int)
(declare-fun v_int_205_2880_primed () Int)
(declare-fun v_int_205_2879_primed () Int)
(declare-fun v_int_205_2878_primed () Int)
(declare-fun m_5129 () Int)
(declare-fun n_5130 () Int)
(declare-fun size2_5199 () Int)
(declare-fun height2_5200 () Int)
(declare-fun size1_5196 () Int)
(declare-fun height1_5197 () Int)
(declare-fun m_4952 () Int)
(declare-fun n_4953 () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun cm () Int)
(declare-fun cn () Int)
(declare-fun dm () Int)
(declare-fun flted_106_5266 () Int)
(declare-fun flted_106_5267 () Int)
(declare-fun res () Int)
(declare-fun x_primed () Int)
(declare-fun v_node_195_4937 () Int)
(declare-fun p_5015 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m_5106 (+ (+ size2_5199 1) size1_5196)))
(assert (<= height2_5200 (+ 1 height1_5197)))
(assert (<= height1_5197 (+ 1 height2_5200)))
(assert (exists ((max_33 Int)) (and (= n_5107 (+ 1 max_33)) (or (and (= max_33 height1_5197) (>= height1_5197 height2_5200)) (and (= max_33 height2_5200) (< height1_5197 height2_5200))))))
(assert (= height_5193 n_5107))
(assert (> v_bool_204_2891_primed 0))
(assert (not (> v_bool_198_2892_primed 0)))
(assert (<= n_5024 n_5041))
(assert (= m_4940 (+ (+ size2_5019 1) size1_5016)))
(assert (<= height2_5020 (+ 1 height1_5017)))
(assert (<= height1_5017 (+ 1 height2_5020)))
(assert (exists ((max_33 Int)) (and (= n_4941 (+ 1 max_33)) (or (and (= max_33 height1_5017) (>= height1_5017 height2_5020)) (and (= max_33 height2_5020) (< height1_5017 height2_5020))))))
(assert (= height_5013 n_4941))
(assert (> v_bool_196_2898_primed 0))
(assert (not (> v_bool_170_2899_primed 0)))
(assert (< Anon_4546 a_primed))
(assert (= m (+ (+ size2_4551 1) size1_4548)))
(assert (<= height2_4552 (+ 1 height1_4549)))
(assert (<= height1_4549 (+ 1 height2_4552)))
(assert (exists ((max_33 Int)) (and (= n (+ 1 max_33)) (or (and (= max_33 height1_4549) (>= height1_4549 height2_4552)) (and (= max_33 height2_4552) (< height1_4549 height2_4552))))))
(assert (= height_4545 n))
(assert (not (> v_bool_166_2900_primed 0)))
(assert (> x_primed 0))
(assert (< tmp_null_primed 1))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= tmp_primed q_4550))
(assert (= m_4917 size2_4551))
(assert (= n_4918 height2_4552))
(assert (<= 0 size2_4551))
(assert (<= 0 height2_4552))
(assert (= flted_161_4931 (+ 1 m_4917)))
(assert (<= 0 m_4917))
(assert (<= 0 n_4918))
(assert (= right_195_4933 q_4550))
(assert (= m_4940 flted_161_4931))
(assert (= n_4941 Anon_4932))
(assert (<= 0 flted_161_4931))
(assert (<= 0 Anon_4932))
(assert (<= 0 m_4940))
(assert (<= 0 n_4941))
(assert (= m_4952 size1_4548))
(assert (= n_4953 height1_4549))
(assert (<= 0 size1_4548))
(assert (<= 0 height1_4549))
(assert (= (+ 2 n_4953) n_4941))
(assert (= m_5023 size2_5019))
(assert (= n_5024 height2_5020))
(assert (<= 0 size2_5019))
(assert (<= 0 height2_5020))
(assert (= m_5040 size1_5016))
(assert (= n_5041 height1_5017))
(assert (<= 0 size1_5016))
(assert (<= 0 height1_5017))
(assert (= m_5106 m_5040))
(assert (= n_5107 n_5041))
(assert (<= 0 m_5040))
(assert (<= 0 n_5041))
(assert (<= 0 m_5106))
(assert (<= 0 n_5107))
(assert (= (+ n_5130 1) n_5107))
(assert (= m_5129 m_5023))
(assert (= n_5130 n_5024))
(assert (<= 0 m_5023))
(assert (<= 0 n_5024))
(assert (= v_node_205_2884_primed p_4547))
(assert (= v_node_205_2883_primed p_5195))
(assert (= v_node_205_2882_primed q_5198))
(assert (= v_node_205_2881_primed q_5018))
(assert (= v_int_205_2880_primed 1))
(assert (= v_int_205_2879_primed 1))
(assert (= v_int_205_2878_primed 1))
(assert (= am m_4952))
(assert (= an n_4953))
(assert (= bm size1_5196))
(assert (= bn height1_5197))
(assert (= cm size2_5199))
(assert (= cn height2_5200))
(assert (= dm m_5129))
(assert (<= 0 m_5129))
(assert (<= 0 n_5130))
(assert (<= 0 size2_5199))
(assert (<= 0 height2_5200))
(assert (<= 0 size1_5196))
(assert (<= 0 height1_5197))
(assert (<= 0 m_4952))
(assert (<= 0 n_4953))
(assert (= flted_106_5267 (+ (+ (+ (+ dm bm) 3) am) cm)))
(assert (= flted_106_5266 (+ an 2)))
(assert (exists ((an_104 Int)) (<= 0 an_104)))
(assert (<= 0 am))
(assert (<= 0 an))
(assert (<= 0 bm))
(assert (<= 0 bn))
(assert (<= 0 cm))
(assert (<= 0 cn))
(assert (<= 0 dm))
(assert (= x_primed 1))
(assert (= v_node_195_4937 2))
(assert (= p_5015 3))
(assert (or (and (and (< res 1) (= flted_106_5267 0)) (= flted_106_5266 0)) (and (and (<= 1 flted_106_5266) (<= 1 flted_106_5267)) (> res 0))))
(assert (not (= x_primed p_5015)))
(assert (not (= x_primed v_node_195_4937)))
(assert (not (= v_node_195_4937 p_5015)))
;Negation of Consequence
(assert (not false))
(check-sat)