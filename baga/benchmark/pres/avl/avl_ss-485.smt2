(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_4918 () Int)
(declare-fun height_4545 () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun height2_4552 () Int)
(declare-fun size2_4551 () Int)
(declare-fun m_4917 () Int)
(declare-fun size1_4548 () Int)
(declare-fun height1_4549 () Int)
(declare-fun p_5015 () Int)
(declare-fun m_4952 () Int)
(declare-fun p_4547 () Int)
(declare-fun v_int_204_2832_primed () Int)
(declare-fun n_5107 () Int)
(declare-fun m_5106 () Int)
(declare-fun m_5040 () Int)
(declare-fun n_4953 () Int)
(declare-fun Anon_4932 () Int)
(declare-fun flted_161_4931 () Int)
(declare-fun height_5013 () Int)
(declare-fun n_4941 () Int)
(declare-fun height1_5017 () Int)
(declare-fun m_4940 () Int)
(declare-fun size1_5016 () Int)
(declare-fun n_5041 () Int)
(declare-fun size2_5019 () Int)
(declare-fun height2_5020 () Int)
(declare-fun v_node_204_2826_primed () Int)
(declare-fun m_5023 () Int)
(declare-fun n_5024 () Int)
(declare-fun q_5018 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 height1_4549))
(assert (<= 0 size1_4548))
(assert (<= 0 n_4918))
(assert (<= 0 m_4917))
(assert (<= 0 height2_4552))
(assert (<= 0 size2_4551))
(assert (= n_4918 height2_4552))
(assert (= height_4545 n))
(assert (= m (+ (+ size2_4551 1) size1_4548)))
(assert (<= height2_4552 (+ 1 height1_4549)))
(assert (<= height1_4549 (+ 1 height2_4552)))
(assert (exists ((max_5133 Int)) (and (= n (+ 1 max_5133)) (or (and (= max_5133 height1_4549) (>= height1_4549 height2_4552)) (and (= max_5133 height2_4552) (< height1_4549 height2_4552))))))
(assert (= m_4917 size2_4551))
(assert (= flted_161_4931 (+ 1 m_4917)))
(assert (= m_4952 size1_4548))
(assert (= n_4953 height1_4549))
(assert (<= 0 m_4952))
(assert (<= 0 n_4953))
(assert (or (and (and (< p_5015 1) (= m_5106 0)) (= n_5107 0)) (and (and (<= 1 n_5107) (<= 1 m_5106)) (> p_5015 0))))
(assert (or (and (and (< p_4547 1) (= m_4952 0)) (= n_4953 0)) (and (and (<= 1 n_4953) (<= 1 m_4952)) (> p_4547 0))))
(assert (= (+ v_int_204_2832_primed 1) n_5107))
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
(assert (= (+ 2 n_4953) n_4941))
(assert (<= 0 n_4941))
(assert (<= 0 m_4940))
(assert (<= 0 Anon_4932))
(assert (<= 0 flted_161_4931))
(assert (= n_4941 Anon_4932))
(assert (= m_4940 flted_161_4931))
(assert (= height_5013 n_4941))
(assert (exists ((max_5134 Int)) (and (= n_4941 (+ 1 max_5134)) (or (and (= max_5134 height1_5017) (>= height1_5017 height2_5020)) (and (= max_5134 height2_5020) (< height1_5017 height2_5020))))))
(assert (<= height1_5017 (+ 1 height2_5020)))
(assert (<= height2_5020 (+ 1 height1_5017)))
(assert (= m_4940 (+ (+ size2_5019 1) size1_5016)))
(assert (<= n_5024 n_5041))
(assert (= m_5023 size2_5019))
(assert (= n_5024 height2_5020))
(assert (<= 0 m_5023))
(assert (<= 0 n_5024))
(assert (= v_node_204_2826_primed q_5018))
(assert (or (and (and (< q_5018 1) (= m_5023 0)) (= n_5024 0)) (and (and (<= 1 n_5024) (<= 1 m_5023)) (> q_5018 0))))
;Negation of Consequence
(assert (not (or (= m_5023 0) (or (= n_5024 0) (< q_5018 1)))))
(check-sat)