(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun mx2_4137 () Int)
(declare-fun mx1_4134 () Int)
(declare-fun ma_3996 () Int)
(declare-fun mx_3983 () Int)
(declare-fun v () Int)
(declare-fun mx2_3855 () Int)
(declare-fun mx1_3852 () Int)
(declare-fun v_primed () Int)
(declare-fun d_4131 () Int)
(declare-fun d_3849 () Int)
(declare-fun mx () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((ma_4150 Int)) (<= d_4131 ma_4150)))
(assert (= mx2_4137 mx2_3855))
(assert (= mx1_4134 ma_3996))
(assert (<= 0 ma_3996))
(assert (<= 0 mx2_3855))
(assert (<= 0 mx_3983))
(assert (or (and (<= mx_3983 v_primed) (= ma_3996 v_primed)) (= ma_3996 mx_3983)))
(assert (<= 0 mx1_3852))
(assert (= mx_3983 mx1_3852))
(assert (= v_primed v))
(assert (<= 0 v))
(assert (<= mx2_3855 d_3849))
(assert (<= mx1_3852 d_3849))
(assert (<= 0 d_3849))
(assert (<= v_primed d_3849))
(assert (= d_4131 d_3849))
(assert (<= d_3849 mx))
;Negation of Consequence
(assert (not (<= 0 mx)))
(check-sat)