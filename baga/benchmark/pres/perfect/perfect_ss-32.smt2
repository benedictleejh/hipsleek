(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_44_1401_primed () Int)
(declare-fun n () Int)
(declare-fun v_bool_40_1402_primed () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun t () Int)
(declare-fun val_45_1606 () Int)
(declare-fun Anon_1591 () Int)
(declare-fun v_int_46_1638 () Int)
(declare-fun flag_46_1610 () Int)
(declare-fun Anon_1592 () Int)
(declare-fun res () Int)
(declare-fun v_boolean_47_1383_primed () Int)
(declare-fun flted_28_1590 () Int)
(declare-fun l_1593 () Int)
(declare-fun flted_28_1589 () Int)
(declare-fun r_1594 () Int)
(declare-fun t_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_44_1401_primed 0))
(assert (= (+ flted_28_1590 1) n))
(assert (= (+ flted_28_1589 1) n))
(assert (not (> v_bool_40_1402_primed 0)))
(assert (> t_primed 0))
(assert (= a_primed a))
(assert (= t_primed t))
(assert (= Anon_1592 0))
(assert (= val_45_1606 Anon_1591))
(assert (= v_int_46_1638 1))
(assert (= flag_46_1610 Anon_1592))
(assert (> v_boolean_47_1383_primed 0))
(assert (= res v_boolean_47_1383_primed))
(assert (or (and (< l_1593 1) (= flted_28_1590 0)) (and (<= 1 flted_28_1590) (> l_1593 0))))
(assert (or (and (< r_1594 1) (= flted_28_1589 0)) (and (<= 1 flted_28_1589) (> r_1594 0))))
(assert (= t_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)