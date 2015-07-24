(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height2_3693 () Int)
(declare-fun nx_3673 () Int)
(declare-fun tmp_3684 () Int)
(declare-fun tmp_3681 () Int)
(declare-fun nx () Int)
(declare-fun height_3665 () Int)
(declare-fun height2_3672 () Int)
(declare-fun height1_3669 () Int)
(declare-fun height1_3690 () Int)
(declare-fun height1_3706 () Int)
(declare-fun height2_3709 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 nx_3673))
(assert (= height2_3693 nx_3673))
(assert (= nx_3673 nx))
(assert (<= 0 height1_3669))
(assert (<= 0 height2_3672))
(assert (= tmp_3684 (+ 1 tmp_3681)))
(assert (= tmp_3681 height_3665))
(assert (<= height2_3672 (+ 1 height1_3669)))
(assert (<= height1_3669 (+ 1 height2_3672)))
(assert (exists ((max_3732 Int)) (and (= nx (+ 1 max_3732)) (or (and (= max_3732 height1_3669) (>= height1_3669 height2_3672)) (and (= max_3732 height2_3672) (< height1_3669 height2_3672))))))
(assert (= height_3665 nx))
(assert (exists ((max_3733 Int)) (and (= height1_3690 (+ 1 max_3733)) (or (and (= max_3733 height1_3706) (>= height1_3706 height2_3709)) (and (= max_3733 height2_3709) (< height1_3706 height2_3709))))))
(assert (= height_3665 height1_3690))
(assert (or (and (= height_3665 (+ height1_3706 1)) (<= height2_3709 height1_3706)) (and (= height_3665 (+ height2_3709 1)) (< height1_3706 height2_3709))))
(assert (<= height2_3709 (+ 1 height1_3706)))
(assert (<= height1_3706 (+ 1 height2_3709)))
(assert (= height2_3709 height2_3672))
(assert (= height1_3706 height1_3669))
;Negation of Consequence
(assert (not (or (and (= height1_3690 (+ height1_3706 1)) (<= height2_3709 height1_3706)) (and (= height1_3690 (+ height2_3709 1)) (< height1_3706 height2_3709)))))
(check-sat)