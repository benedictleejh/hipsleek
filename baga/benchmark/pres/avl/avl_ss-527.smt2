(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_177_2679_primed () Int)
(declare-fun height_4661 () Int)
(declare-fun v_bool_175_2685_primed () Int)
(declare-fun v_bool_170_2899_primed () Int)
(declare-fun Anon_4546 () Int)
(declare-fun m () Int)
(declare-fun height_4545 () Int)
(declare-fun n () Int)
(declare-fun v_bool_166_2900_primed () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun x () Int)
(declare-fun size1_4548 () Int)
(declare-fun height1_4549 () Int)
(declare-fun m_4565 () Int)
(declare-fun n_4566 () Int)
(declare-fun left_173_4581 () Int)
(declare-fun p_4547 () Int)
(declare-fun flted_161_4579 () Int)
(declare-fun Anon_4580 () Int)
(declare-fun m_4588 () Int)
(declare-fun size2_4551 () Int)
(declare-fun height2_4552 () Int)
(declare-fun n_4589 () Int)
(declare-fun size1_4664 () Int)
(declare-fun height1_4665 () Int)
(declare-fun size2_4667 () Int)
(declare-fun height2_4668 () Int)
(declare-fun m_4600 () Int)
(declare-fun n_4601 () Int)
(declare-fun m_4688 () Int)
(declare-fun n_4689 () Int)
(declare-fun m_4671 () Int)
(declare-fun n_4672 () Int)
(declare-fun llm () Int)
(declare-fun lln () Int)
(declare-fun lrm () Int)
(declare-fun rm () Int)
(declare-fun res () Int)
(declare-fun flted_51_4743 () Int)
(declare-fun flted_51_4744 () Int)
(declare-fun v_node_179_2579_primed () Int)
(declare-fun x_primed () Int)
(declare-fun v_node_173_4585 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_177_2679_primed 0))
(assert (< n_4689 n_4672))
(assert (= m_4588 (+ (+ size2_4667 1) size1_4664)))
(assert (<= height2_4668 (+ 1 height1_4665)))
(assert (<= height1_4665 (+ 1 height2_4668)))
(assert (exists ((max_33 Int)) (and (= n_4589 (+ 1 max_33)) (or (and (= max_33 height1_4665) (>= height1_4665 height2_4668)) (and (= max_33 height2_4668) (< height1_4665 height2_4668))))))
(assert (= height_4661 n_4589))
(assert (> v_bool_175_2685_primed 0))
(assert (> v_bool_170_2899_primed 0))
(assert (<= a_primed Anon_4546))
(assert (= m (+ (+ size2_4551 1) size1_4548)))
(assert (<= height2_4552 (+ 1 height1_4549)))
(assert (<= height1_4549 (+ 1 height2_4552)))
(assert (exists ((max_33 Int)) (and (= n (+ 1 max_33)) (or (and (= max_33 height1_4549) (>= height1_4549 height2_4552)) (and (= max_33 height2_4552) (< height1_4549 height2_4552))))))
(assert (= height_4545 n))
(assert (not (> v_bool_166_2900_primed 0)))
(assert (> x_primed 0))
(assert (= a_primed a))
(assert (= x_primed x))
(assert (= m_4565 size1_4548))
(assert (= n_4566 height1_4549))
(assert (<= 0 size1_4548))
(assert (<= 0 height1_4549))
(assert (= flted_161_4579 (+ 1 m_4565)))
(assert (<= 0 m_4565))
(assert (<= 0 n_4566))
(assert (= left_173_4581 p_4547))
(assert (= m_4588 flted_161_4579))
(assert (= n_4589 Anon_4580))
(assert (<= 0 flted_161_4579))
(assert (<= 0 Anon_4580))
(assert (<= 0 m_4588))
(assert (<= 0 n_4589))
(assert (= m_4600 size2_4551))
(assert (= n_4601 height2_4552))
(assert (<= 0 size2_4551))
(assert (<= 0 height2_4552))
(assert (= (+ 2 n_4601) n_4589))
(assert (= m_4671 size1_4664))
(assert (= n_4672 height1_4665))
(assert (<= 0 size1_4664))
(assert (<= 0 height1_4665))
(assert (= m_4688 size2_4667))
(assert (= n_4689 height2_4668))
(assert (<= 0 size2_4667))
(assert (<= 0 height2_4668))
(assert (= llm m_4671))
(assert (= lln n_4672))
(assert (= lrm m_4688))
(assert (= rm m_4600))
(assert (<= 0 m_4600))
(assert (<= 0 n_4601))
(assert (<= 0 m_4688))
(assert (<= 0 n_4689))
(assert (<= 0 m_4671))
(assert (<= 0 n_4672))
(assert (= flted_51_4744 (+ (+ (+ rm llm) 2) lrm)))
(assert (= flted_51_4743 (+ lln 1)))
(assert (exists ((flted_50_125 Int)) (<= 0 flted_50_125)))
(assert (exists ((flted_50_124 Int)) (<= 0 flted_50_124)))
(assert (<= 0 llm))
(assert (<= 0 lln))
(assert (<= 0 lrm))
(assert (<= 0 rm))
(assert (= res v_node_179_2579_primed))
(assert (= x_primed 1))
(assert (= v_node_173_4585 2))
(assert (or (and (and (< v_node_179_2579_primed 1) (= flted_51_4744 0)) (= flted_51_4743 0)) (and (and (<= 1 flted_51_4743) (<= 1 flted_51_4744)) (> v_node_179_2579_primed 0))))
(assert (not (= x_primed v_node_173_4585)))
;Negation of Consequence
(assert (not false))
(check-sat)