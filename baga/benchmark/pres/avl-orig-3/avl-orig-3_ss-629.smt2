(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m1_4764 () Int)
(declare-fun n1_4765 () Int)
(declare-fun Anon_4766 () Int)
(declare-fun res () Int)
(declare-fun v_node_49_2083_primed () Int)
(declare-fun v_int_49_4758 () Int)
(declare-fun x () Int)
(declare-fun t_primed () Int)
(declare-fun v_bool_48_2249_primed () Int)
(declare-fun Anon_4762 () Int)
(declare-fun x_primed () Int)
(declare-fun p_4763 () Int)
(declare-fun q_4767 () Int)
(declare-fun tmp_primed () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun tm () Int)
(declare-fun t () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m1_4764 0))
(assert (= n1_4765 0))
(assert (= Anon_4766 1))
(assert (= res v_node_49_2083_primed))
(assert (= v_int_49_4758 1))
(assert (= t_primed t))
(assert (= x_primed x))
(assert (< tmp_primed 1))
(assert (< t_primed 1))
(assert (> v_bool_48_2249_primed 0))
(assert (= Anon_4762 x_primed))
(assert (= p_4763 tmp_primed))
(assert (= q_4767 tmp_primed))
(assert (or (and (and (and (< t 1) (= tm 0)) (= tn 0)) (= b 1)) (and (and (and (and (and (<= 0 b) (<= (+ (- 0 tn) 2) b)) (<= b tn)) (<= b 2)) (<= 1 tm)) (> t 0))))
;Negation of Consequence
(assert (not false))
(check-sat)