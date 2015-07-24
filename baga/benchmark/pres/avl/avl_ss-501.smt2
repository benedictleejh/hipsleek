(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_205_2845_primed () Int)
(declare-fun left_205_2844_primed () Int)
(declare-fun height_205_2843_primed () Int)
(declare-fun val_205_2842_primed () Int)
(declare-fun Anon_5014 () Int)
(declare-fun v_node_205_2841_primed () Int)
(declare-fun v_node_195_4937 () Int)
(declare-fun v_node_205_2884_primed () Int)
(declare-fun m_5040 () Int)
(declare-fun m_5023 () Int)
(declare-fun Anon_4932 () Int)
(declare-fun right_195_4933 () Int)
(declare-fun flted_161_4931 () Int)
(declare-fun n_4918 () Int)
(declare-fun m_4917 () Int)
(declare-fun tmp_primed () Int)
(declare-fun q_4550 () Int)
(declare-fun x () Int)
(declare-fun a () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun v_bool_166_2900_primed () Int)
(declare-fun height_4545 () Int)
(declare-fun n () Int)
(declare-fun height2_4552 () Int)
(declare-fun height1_4549 () Int)
(declare-fun m () Int)
(declare-fun size2_4551 () Int)
(declare-fun size1_4548 () Int)
(declare-fun Anon_4546 () Int)
(declare-fun a_primed () Int)
(declare-fun v_bool_170_2899_primed () Int)
(declare-fun v_bool_196_2898_primed () Int)
(declare-fun height_5013 () Int)
(declare-fun n_4941 () Int)
(declare-fun height2_5020 () Int)
(declare-fun height1_5017 () Int)
(declare-fun m_4940 () Int)
(declare-fun size2_5019 () Int)
(declare-fun size1_5016 () Int)
(declare-fun n_5024 () Int)
(declare-fun n_5041 () Int)
(declare-fun v_bool_198_2892_primed () Int)
(declare-fun v_bool_204_2891_primed () Int)
(declare-fun x_primed () Int)
(declare-fun n_4953 () Int)
(declare-fun m_4952 () Int)
(declare-fun p_4547 () Int)
(declare-fun n_5107 () Int)
(declare-fun m_5106 () Int)
(declare-fun p_5015 () Int)
(declare-fun n_5130 () Int)
(declare-fun m_5129 () Int)
(declare-fun q_5018 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_205_2845_primed q_5018))
(assert (= left_205_2844_primed p_5015))
(assert (= height_205_2843_primed height_5013))
(assert (= val_205_2842_primed Anon_5014))
(assert (= v_node_205_2841_primed v_node_195_4937))
(assert (= v_node_205_2884_primed p_4547))
(assert (<= 0 n_5130))
(assert (<= 0 m_5129))
(assert (<= 0 n_5024))
(assert (<= 0 m_5023))
(assert (= n_5130 n_5024))
(assert (= m_5129 m_5023))
(assert (= (+ n_5130 1) n_5107))
(assert (<= 0 n_5107))
(assert (<= 0 m_5106))
(assert (<= 0 n_5041))
(assert (<= 0 m_5040))
(assert (= n_5107 n_5041))
(assert (= m_5106 m_5040))
(assert (<= 0 height1_5017))
(assert (<= 0 size1_5016))
(assert (= n_5041 height1_5017))
(assert (= m_5040 size1_5016))
(assert (<= 0 height2_5020))
(assert (<= 0 size2_5019))
(assert (= n_5024 height2_5020))
(assert (= m_5023 size2_5019))
(assert (= (+ 2 n_4953) n_4941))
(assert (<= 0 n_4953))
(assert (<= 0 m_4952))
(assert (<= 0 height1_4549))
(assert (<= 0 size1_4548))
(assert (= n_4953 height1_4549))
(assert (= m_4952 size1_4548))
(assert (<= 0 n_4941))
(assert (<= 0 m_4940))
(assert (<= 0 Anon_4932))
(assert (<= 0 flted_161_4931))
(assert (= n_4941 Anon_4932))
(assert (= m_4940 flted_161_4931))
(assert (= right_195_4933 q_4550))
(assert (<= 0 n_4918))
(assert (<= 0 m_4917))
(assert (= flted_161_4931 (+ 1 m_4917)))
(assert (<= 0 height2_4552))
(assert (<= 0 size2_4551))
(assert (= n_4918 height2_4552))
(assert (= m_4917 size2_4551))
(assert (= tmp_primed q_4550))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (< tmp_null_primed 1))
(assert (> x_primed 0))
(assert (not (> v_bool_166_2900_primed 0)))
(assert (= height_4545 n))
(assert (exists ((max_33 Int)) (and (= n (+ 1 max_33)) (or (and (= max_33 height1_4549) (>= height1_4549 height2_4552)) (and (= max_33 height2_4552) (< height1_4549 height2_4552))))))
(assert (<= height1_4549 (+ 1 height2_4552)))
(assert (<= height2_4552 (+ 1 height1_4549)))
(assert (= m (+ (+ size2_4551 1) size1_4548)))
(assert (< Anon_4546 a_primed))
(assert (not (> v_bool_170_2899_primed 0)))
(assert (> v_bool_196_2898_primed 0))
(assert (= height_5013 n_4941))
(assert (exists ((max_33 Int)) (and (= n_4941 (+ 1 max_33)) (or (and (= max_33 height1_5017) (>= height1_5017 height2_5020)) (and (= max_33 height2_5020) (< height1_5017 height2_5020))))))
(assert (<= height1_5017 (+ 1 height2_5020)))
(assert (<= height2_5020 (+ 1 height1_5017)))
(assert (= m_4940 (+ (+ size2_5019 1) size1_5016)))
(assert (<= n_5024 n_5041))
(assert (not (> v_bool_198_2892_primed 0)))
(assert (> v_bool_204_2891_primed 0))
(assert (= x_primed 1))
(assert (or (and (and (< p_4547 1) (= m_4952 0)) (= n_4953 0)) (and (and (<= 1 n_4953) (<= 1 m_4952)) (> p_4547 0))))
(assert (or (and (and (< p_5015 1) (= m_5106 0)) (= n_5107 0)) (and (and (<= 1 n_5107) (<= 1 m_5106)) (> p_5015 0))))
(assert (or (and (and (< q_5018 1) (= m_5129 0)) (= n_5130 0)) (and (and (<= 1 n_5130) (<= 1 m_5129)) (> q_5018 0))))
;Negation of Consequence
(assert (not false))
(check-sat)