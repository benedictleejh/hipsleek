(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_4918 () Int)
(declare-fun height_4545 () Int)
(declare-fun n () Int)
(declare-fun height2_4552 () Int)
(declare-fun height1_4549 () Int)
(declare-fun p_4547 () Int)
(declare-fun m () Int)
(declare-fun size1_4548 () Int)
(declare-fun size2_4551 () Int)
(declare-fun m_4917 () Int)
(declare-fun v_node_196_2707_primed () Int)
(declare-fun flted_161_4931 () Int)
(declare-fun Anon_4932 () Int)
(declare-fun v_node_195_4937 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_4918))
(assert (<= 0 height2_4552))
(assert (= n_4918 height2_4552))
(assert (= height_4545 n))
(assert (<= height2_4552 (+ 1 height1_4549)))
(assert (<= height1_4549 (+ 1 height2_4552)))
(assert (exists ((max_4944 Int)) (and (= n (+ 1 max_4944)) (or (and (= max_4944 height1_4549) (>= height1_4549 height2_4552)) (and (= max_4944 height2_4552) (< height1_4549 height2_4552))))))
(assert (or (and (and (< p_4547 1) (= size1_4548 0)) (= height1_4549 0)) (and (and (<= 1 height1_4549) (<= 1 size1_4548)) (> p_4547 0))))
(assert (= m (+ (+ size2_4551 1) size1_4548)))
(assert (<= 0 m_4917))
(assert (<= 0 size2_4551))
(assert (= m_4917 size2_4551))
(assert (= flted_161_4931 (+ 1 m_4917)))
(assert (= v_node_196_2707_primed v_node_195_4937))
(assert (or (and (and (< v_node_195_4937 1) (= flted_161_4931 0)) (= Anon_4932 0)) (and (and (<= 1 Anon_4932) (<= 1 flted_161_4931)) (> v_node_195_4937 0))))
;Negation of Consequence
(assert (not (or (= flted_161_4931 0) (or (= Anon_4932 0) (< v_node_195_4937 1)))))
(check-sat)