(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun val_48_3963 () Int)
(declare-fun mx1_4109 () Int)
(declare-fun mx1_3852 () Int)
(declare-fun mx () Int)
(declare-fun v () Int)
(declare-fun d_3849 () Int)
(declare-fun mx2_3855 () Int)
(declare-fun tmpv_3946 () Int)
(declare-fun mx_3926 () Int)
(declare-fun v_primed () Int)
(declare-fun ma_3939 () Int)
(declare-fun mx2_4112 () Int)
(declare-fun d_4106 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= val_48_3963 d_3849))
(assert (<= 0 mx_3926))
(assert (<= 0 mx2_3855))
(assert (<= 0 mx1_3852))
(assert (<= 0 ma_3939))
(assert (= mx1_4109 mx1_3852))
(assert (< d_3849 v_primed))
(assert (<= 0 d_3849))
(assert (<= mx1_3852 d_3849))
(assert (<= mx2_3855 d_3849))
(assert (<= d_3849 mx))
(assert (<= 0 v))
(assert (= v_primed v))
(assert (= tmpv_3946 d_3849))
(assert (= mx_3926 mx2_3855))
(assert (or (and (<= mx_3926 tmpv_3946) (= ma_3939 tmpv_3946)) (= ma_3939 mx_3926)))
(assert (= d_4106 v_primed))
(assert (= mx2_4112 ma_3939))
;Negation of Consequence
(assert (not (<= mx2_4112 d_4106)))
(check-sat)