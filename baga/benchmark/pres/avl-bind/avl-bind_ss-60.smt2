(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun v_int_26_2399_primed () Int)
(declare-fun p_2772 () Int)
(declare-fun p_2756 () Int)
(declare-fun n1_2774 () Int)
(declare-fun m1_2773 () Int)
(declare-fun n_2754 () Int)
(declare-fun n () Int)
(declare-fun n1_2758 () Int)
(declare-fun m () Int)
(declare-fun m1_2757 () Int)
(declare-fun q_2775 () Int)
(declare-fun m2_2760 () Int)
(declare-fun n2_2761 () Int)
(declare-fun q_2759 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res v_int_26_2399_primed))
(assert (= v_int_26_2399_primed n_2754))
(assert (= p_2772 p_2756))
(assert (or (and (and (< p_2756 1) (= m1_2757 0)) (= n1_2758 0)) (and (and (<= 1 n1_2758) (<= 1 m1_2757)) (> p_2756 0))))
(assert (= n1_2774 n1_2758))
(assert (= m1_2773 m1_2757))
(assert (= n_2754 n))
(assert (exists ((max_2788 Int)) (and (= n (+ 1 max_2788)) (or (and (= max_2788 n1_2758) (>= n1_2758 n2_2761)) (and (= max_2788 n2_2761) (< n1_2758 n2_2761))))))
(assert (<= n1_2758 (+ 1 n2_2761)))
(assert (<= (+ 0 n2_2761) (+ n1_2758 1)))
(assert (= m (+ (+ m2_2760 1) m1_2757)))
(assert (= q_2775 q_2759))
(assert (or (and (and (< q_2759 1) (= m2_2760 0)) (= n2_2761 0)) (and (and (<= 1 n2_2761) (<= 1 m2_2760)) (> q_2759 0))))
;Negation of Consequence
(assert (not (or (= m2_2760 0) (or (= n2_2761 0) (< q_2759 1)))))
(check-sat)