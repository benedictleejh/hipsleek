(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_1669 () Int)
(declare-fun r_1594 () Int)
(declare-fun l_1668 () Int)
(declare-fun l_1593 () Int)
(declare-fun Anon_1667 () Int)
(declare-fun Anon_1666 () Int)
(declare-fun Anon_1591 () Int)
(declare-fun res () Int)
(declare-fun v_boolean_53_1399_primed () Int)
(declare-fun n_1628 () Int)
(declare-fun v_bool_44_1401_primed () Int)
(declare-fun Anon_1592 () Int)
(declare-fun flted_28_1589 () Int)
(declare-fun n () Int)
(declare-fun v_bool_40_1402_primed () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun t_primed () Int)
(declare-fun t () Int)
(declare-fun flted_28_1590 () Int)
(declare-fun n_1616 () Int)
(declare-fun v_bool_50_1400_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= r_1669 r_1594))
(assert (= l_1668 l_1593))
(assert (= Anon_1667 Anon_1592))
(assert (= Anon_1666 Anon_1591))
(assert (= res v_boolean_53_1399_primed))
(assert (<= 0 n_1628))
(assert (<= 0 flted_28_1589))
(assert (= n_1628 flted_28_1589))
(assert (not (> v_bool_44_1401_primed 0)))
(assert (not (= Anon_1592 0)))
(assert (= (+ flted_28_1590 1) n))
(assert (= (+ flted_28_1589 1) n))
(assert (not (> v_bool_40_1402_primed 0)))
(assert (> t_primed 0))
(assert (= a_primed a))
(assert (= t_primed t))
(assert (= n_1616 flted_28_1590))
(assert (<= 0 flted_28_1590))
(assert (<= 0 n_1616))
(assert (not (> v_bool_50_1400_primed 0)))
;Negation of Consequence
(assert (not false))
(check-sat)