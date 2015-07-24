(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun size1_3829 () Int)
(declare-fun height2_3849 () Int)
(declare-fun size2_3848 () Int)
(declare-fun height1_3846 () Int)
(declare-fun size1_3845 () Int)
(declare-fun q_3847 () Int)
(declare-fun q_3810 () Int)
(declare-fun p_3844 () Int)
(declare-fun p_3807 () Int)
(declare-fun Anon_3843 () Int)
(declare-fun Anon_3806 () Int)
(declare-fun height_152_3823 () Int)
(declare-fun Anon_17 () Int)
(declare-fun right_151_3767 () Int)
(declare-fun Anon_19 () Int)
(declare-fun left_150_3764 () Int)
(declare-fun Anon_18 () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun z () Int)
(declare-fun y () Int)
(declare-fun height_3805 () Int)
(declare-fun ny () Int)
(declare-fun height2_3812 () Int)
(declare-fun height1_3809 () Int)
(declare-fun my () Int)
(declare-fun size2_3811 () Int)
(declare-fun size1_3808 () Int)
(declare-fun Anon_3827 () Int)
(declare-fun Anon_16 () Int)
(declare-fun p_3828 () Int)
(declare-fun y_primed () Int)
(declare-fun q_3831 () Int)
(declare-fun z_primed () Int)
(declare-fun size2_3832 () Int)
(declare-fun mz () Int)
(declare-fun ny_3763 () Int)
(declare-fun v_int_152_3824 () Int)
(declare-fun height1_3830 () Int)
(declare-fun height2_3833 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= size1_3829 (+ (+ size2_3848 1) size1_3845)))
(assert (exists ((max_33 Int)) (and (= height1_3830 (+ 1 max_33)) (or (and (= max_33 height1_3846) (>= height1_3846 height2_3849)) (and (= max_33 height2_3849) (< height1_3846 height2_3849))))))
(assert (= height_3805 height1_3830))
(assert (or (and (= height_3805 (+ height1_3846 1)) (<= height2_3849 height1_3846)) (and (= height_3805 (+ height2_3849 1)) (< height1_3846 height2_3849))))
(assert (<= height2_3849 (+ 1 height1_3846)))
(assert (<= height1_3846 (+ 1 height2_3849)))
(assert (= height2_3849 height2_3812))
(assert (= size2_3848 size2_3811))
(assert (= height1_3846 height1_3809))
(assert (= size1_3845 size1_3808))
(assert (= q_3847 q_3810))
(assert (= p_3844 p_3807))
(assert (= Anon_3843 Anon_3806))
(assert (= height_152_3823 Anon_17))
(assert (= v_int_152_3824 (+ 1 height_3805)))
(assert (= right_151_3767 Anon_19))
(assert (= left_150_3764 Anon_18))
(assert (= x_primed x))
(assert (= y_primed y))
(assert (= z_primed z))
(assert (> y 0))
(assert (= ny_3763 ny))
(assert (= height_3805 ny))
(assert (exists ((max_33 Int)) (and (= ny (+ 1 max_33)) (or (and (= max_33 height1_3809) (>= height1_3809 height2_3812)) (and (= max_33 height2_3812) (< height1_3809 height2_3812))))))
(assert (<= height1_3809 (+ 1 height2_3812)))
(assert (<= height2_3812 (+ 1 height1_3809)))
(assert (= my (+ (+ size2_3811 1) size1_3808)))
(assert (= Anon_3827 Anon_16))
(assert (= p_3828 y_primed))
(assert (= q_3831 z_primed))
(assert (= size2_3832 mz))
(assert (= height2_3833 ny_3763))
(assert (exists ((max_33 Int)) (and (= v_int_152_3824 (+ 1 max_33)) (or (and (= max_33 height1_3830) (>= height1_3830 height2_3833)) (and (= max_33 height2_3833) (< height1_3830 height2_3833))))))
;Negation of Consequence
(assert (not false))
(check-sat)