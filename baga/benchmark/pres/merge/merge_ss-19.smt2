(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v () Int)
(declare-fun v_primed () Int)
(declare-fun sm_1785 () Int)
(declare-fun res () Int)
(declare-fun n () Int)
(declare-fun xs () Int)
(declare-fun xl () Int)
(declare-fun x () Int)
(declare-fun q_1890 () Int)
(declare-fun qs_1789 () Int)
(declare-fun lg_1786 () Int)
(declare-fun flted_22_1787 () Int)
(declare-fun v_node_122_1331_primed () Int)
(declare-fun x_primed () Int)
(declare-fun q_1788 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= v_primed v))
(assert (<= v_primed sm_1785))
(assert (< 0 n))
(assert (= sm_1785 xs))
(assert (not (= x_primed v_node_122_1331_primed)))
(assert (> v_node_122_1331_primed 0))
(assert (> x_primed 0))
(assert (= res v_node_122_1331_primed))
(assert (= (+ flted_22_1787 1) n))
(assert (<= xs qs_1789))
(assert (= lg_1786 xl))
(assert (= x_primed x))
(assert (= q_1890 x_primed))
(assert (or (and (and (= lg_1786 qs_1789) (= flted_22_1787 1)) (> q_1788 0)) (and (and (<= qs_1789 lg_1786) (<= 2 flted_22_1787)) (> q_1788 0))))
(assert (not (= q_1788 v_node_122_1331_primed)))
(assert (not (= q_1788 x_primed)))
;Negation of Consequence
(assert (not (< q_1788 1)))
(check-sat)