(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun next_57_1436_primed () Int)
(declare-fun val_57_1435_primed () Int)
(declare-fun x () Int)
(declare-fun y_primed () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_55_1443_primed () Int)
(declare-fun b0 () Int)
(declare-fun sm_1631 () Int)
(declare-fun s0 () Int)
(declare-fun nn () Int)
(declare-fun qs_1635 () Int)
(declare-fun lg_1632 () Int)
(declare-fun flted_14_1633 () Int)
(declare-fun s2 () Int)
(declare-fun b2 () Int)
(declare-fun m () Int)
(declare-fun q_1634 () Int)
(declare-fun y () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= next_57_1436_primed q_1634))
(assert (= val_57_1435_primed sm_1631))
(assert (= x_primed x))
(assert (= y_primed y))
(assert (<= b0 s2))
(assert (> x_primed 0))
(assert (not (> v_bool_55_1443_primed 0)))
(assert (= lg_1632 b0))
(assert (= sm_1631 s0))
(assert (<= s0 qs_1635))
(assert (= (+ flted_14_1633 1) nn))
(assert (or (and (and (= lg_1632 qs_1635) (= flted_14_1633 1)) (> q_1634 0)) (and (and (<= qs_1635 lg_1632) (<= 2 flted_14_1633)) (> q_1634 0))))
(assert (or (and (and (= b2 s2) (= m 1)) (> y 0)) (and (and (<= s2 b2) (<= 2 m)) (> y 0))))
(assert (not (= q_1634 y)))
;Negation of Consequence
(assert (not false))
(check-sat)