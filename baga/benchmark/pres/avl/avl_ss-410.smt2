(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
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
(declare-fun m () Int)
(declare-fun size2_4551 () Int)
(declare-fun Anon_4546 () Int)
(declare-fun a_primed () Int)
(declare-fun v_bool_170_2899_primed () Int)
(declare-fun x_primed () Int)
(declare-fun height1_4549 () Int)
(declare-fun size1_4548 () Int)
(declare-fun p_4547 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
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
(assert (= x_primed 1))
(assert (or (and (and (< p_4547 1) (= size1_4548 0)) (= height1_4549 0)) (and (and (<= 1 height1_4549) (<= 1 size1_4548)) (> p_4547 0))))
;Negation of Consequence
(assert (not false))
(check-sat)