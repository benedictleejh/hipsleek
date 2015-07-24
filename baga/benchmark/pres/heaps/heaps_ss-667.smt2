(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v () Int)
(declare-fun v_primed () Int)
(declare-fun mx1_3852 () Int)
(declare-fun l_3850 () Int)
(declare-fun m1_3846 () Int)
(declare-fun m3_3848 () Int)
(declare-fun mx () Int)
(declare-fun d_3849 () Int)
(declare-fun n () Int)
(declare-fun m1_3851 () Int)
(declare-fun m2_3854 () Int)
(declare-fun tmp_primed () Int)
(declare-fun mx2_3855 () Int)
(declare-fun m2_3847 () Int)
(declare-fun r_3853 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= v_primed v))
(assert (<= 0 v))
(assert (<= v_primed d_3849))
(assert (<= 0 d_3849))
(assert (<= mx1_3852 d_3849))
(assert (or (and (and (< l_3850 1) (= m1_3846 0)) (= mx1_3852 0)) (and (and (<= 0 mx1_3852) (<= 1 m1_3846)) (> l_3850 0))))
(assert (= m1_3846 m1_3851))
(assert (<= m3_3848 1))
(assert (<= 0 m3_3848))
(assert (= (+ m3_3848 m2_3854) m1_3851))
(assert (<= d_3849 mx))
(assert (<= mx2_3855 d_3849))
(assert (= n (+ (+ m2_3854 1) m1_3851)))
(assert (< m2_3854 m1_3851))
(assert (= m2_3847 m2_3854))
(assert (= tmp_primed r_3853))
(assert (or (and (and (< r_3853 1) (= m2_3847 0)) (= mx2_3855 0)) (and (and (<= 0 mx2_3855) (<= 1 m2_3847)) (> r_3853 0))))
;Negation of Consequence
(assert (not (or (= m2_3847 0) (< r_3853 1))))
(check-sat)