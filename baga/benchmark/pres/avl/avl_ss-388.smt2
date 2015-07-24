(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_184_2642_primed () Int)
(declare-fun left_184_2641_primed () Int)
(declare-fun height_184_2640_primed () Int)
(declare-fun val_184_2639_primed () Int)
(declare-fun Anon_4838 () Int)
(declare-fun v_node_184_2638_primed () Int)
(declare-fun q_4666 () Int)
(declare-fun v_node_184_2671_primed () Int)
(declare-fun m_4688 () Int)
(declare-fun m_4671 () Int)
(declare-fun Anon_4580 () Int)
(declare-fun left_173_4581 () Int)
(declare-fun flted_161_4579 () Int)
(declare-fun n_4566 () Int)
(declare-fun m_4565 () Int)
(declare-fun tmp_primed () Int)
(declare-fun p_4547 () Int)
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
(declare-fun a_primed () Int)
(declare-fun Anon_4546 () Int)
(declare-fun v_bool_170_2899_primed () Int)
(declare-fun v_bool_175_2685_primed () Int)
(declare-fun height_4661 () Int)
(declare-fun n_4589 () Int)
(declare-fun height2_4668 () Int)
(declare-fun height1_4665 () Int)
(declare-fun m_4588 () Int)
(declare-fun size2_4667 () Int)
(declare-fun size1_4664 () Int)
(declare-fun n_4672 () Int)
(declare-fun n_4689 () Int)
(declare-fun v_bool_177_2679_primed () Int)
(declare-fun v_bool_183_2678_primed () Int)
(declare-fun height_4837 () Int)
(declare-fun n_4772 () Int)
(declare-fun m_4771 () Int)
(declare-fun n_4601 () Int)
(declare-fun m_4600 () Int)
(declare-fun q_4550 () Int)
(declare-fun n_4755 () Int)
(declare-fun m_4754 () Int)
(declare-fun p_4663 () Int)
(declare-fun height1_4841 () Int)
(declare-fun size1_4840 () Int)
(declare-fun p_4839 () Int)
(declare-fun height2_4844 () Int)
(declare-fun size2_4843 () Int)
(declare-fun q_4842 () Int)
(declare-fun x_primed () Int)
(declare-fun v_node_173_4585 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_184_2642_primed q_4842))
(assert (= left_184_2641_primed p_4839))
(assert (= height_184_2640_primed height_4837))
(assert (= val_184_2639_primed Anon_4838))
(assert (= v_node_184_2638_primed q_4666))
(assert (= v_node_184_2671_primed p_4663))
(assert (= (+ n_4755 1) n_4772))
(assert (<= 0 n_4772))
(assert (<= 0 m_4771))
(assert (<= 0 n_4689))
(assert (<= 0 m_4688))
(assert (= n_4772 n_4689))
(assert (= m_4771 m_4688))
(assert (<= 0 n_4755))
(assert (<= 0 m_4754))
(assert (<= 0 n_4672))
(assert (<= 0 m_4671))
(assert (= n_4755 n_4672))
(assert (= m_4754 m_4671))
(assert (<= 0 height2_4668))
(assert (<= 0 size2_4667))
(assert (= n_4689 height2_4668))
(assert (= m_4688 size2_4667))
(assert (<= 0 height1_4665))
(assert (<= 0 size1_4664))
(assert (= n_4672 height1_4665))
(assert (= m_4671 size1_4664))
(assert (= (+ 2 n_4601) n_4589))
(assert (<= 0 n_4601))
(assert (<= 0 m_4600))
(assert (<= 0 height2_4552))
(assert (<= 0 size2_4551))
(assert (= n_4601 height2_4552))
(assert (= m_4600 size2_4551))
(assert (<= 0 n_4589))
(assert (<= 0 m_4588))
(assert (<= 0 Anon_4580))
(assert (<= 0 flted_161_4579))
(assert (= n_4589 Anon_4580))
(assert (= m_4588 flted_161_4579))
(assert (= left_173_4581 p_4547))
(assert (<= 0 n_4566))
(assert (<= 0 m_4565))
(assert (= flted_161_4579 (+ 1 m_4565)))
(assert (<= 0 height1_4549))
(assert (<= 0 size1_4548))
(assert (= n_4566 height1_4549))
(assert (= m_4565 size1_4548))
(assert (= tmp_primed p_4547))
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
(assert (<= a_primed Anon_4546))
(assert (> v_bool_170_2899_primed 0))
(assert (> v_bool_175_2685_primed 0))
(assert (= height_4661 n_4589))
(assert (exists ((max_33 Int)) (and (= n_4589 (+ 1 max_33)) (or (and (= max_33 height1_4665) (>= height1_4665 height2_4668)) (and (= max_33 height2_4668) (< height1_4665 height2_4668))))))
(assert (<= height1_4665 (+ 1 height2_4668)))
(assert (<= height2_4668 (+ 1 height1_4665)))
(assert (= m_4588 (+ (+ size2_4667 1) size1_4664)))
(assert (<= n_4672 n_4689))
(assert (not (> v_bool_177_2679_primed 0)))
(assert (> v_bool_183_2678_primed 0))
(assert (= height_4837 n_4772))
(assert (exists ((max_33 Int)) (and (= n_4772 (+ 1 max_33)) (or (and (= max_33 height1_4841) (>= height1_4841 height2_4844)) (and (= max_33 height2_4844) (< height1_4841 height2_4844))))))
(assert (<= height1_4841 (+ 1 height2_4844)))
(assert (<= height2_4844 (+ 1 height1_4841)))
(assert (= m_4771 (+ (+ size2_4843 1) size1_4840)))
(assert (= x_primed 1))
(assert (= v_node_173_4585 2))
(assert (or (and (and (< q_4550 1) (= m_4600 0)) (= n_4601 0)) (and (and (<= 1 n_4601) (<= 1 m_4600)) (> q_4550 0))))
(assert (or (and (and (< p_4663 1) (= m_4754 0)) (= n_4755 0)) (and (and (<= 1 n_4755) (<= 1 m_4754)) (> p_4663 0))))
(assert (or (and (and (< p_4839 1) (= size1_4840 0)) (= height1_4841 0)) (and (and (<= 1 height1_4841) (<= 1 size1_4840)) (> p_4839 0))))
(assert (or (and (and (< q_4842 1) (= size2_4843 0)) (= height2_4844 0)) (and (and (<= 1 height2_4844) (<= 1 size2_4843)) (> q_4842 0))))
(assert (not (= x_primed v_node_173_4585)))
;Negation of Consequence
(assert (not false))
(check-sat)