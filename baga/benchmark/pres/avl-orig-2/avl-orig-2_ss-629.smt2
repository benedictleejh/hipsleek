(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun m1_4752 () Int)
(declare-fun n1_4753 () Int)
(declare-fun Anon_4754 () Int)
(declare-fun res () Int)
(declare-fun v_node_83_2046_primed () Int)
(declare-fun v_int_83_4745 () Int)
(declare-fun x () Int)
(declare-fun t_primed () Int)
(declare-fun v_bool_80_2243_primed () Int)
(declare-fun Anon_4750 () Int)
(declare-fun x_primed () Int)
(declare-fun p_4751 () Int)
(declare-fun q_4755 () Int)
(declare-fun tmp_4746 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun tm () Int)
(declare-fun t () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= m1_4752 0))
(assert (= n1_4753 0))
(assert (= Anon_4754 1))
(assert (= res v_node_83_2046_primed))
(assert (= v_int_83_4745 1))
(assert (= t_primed t))
(assert (= x_primed x))
(assert (< tmp_4746 1))
(assert (< t_primed 1))
(assert (> v_bool_80_2243_primed 0))
(assert (= Anon_4750 x_primed))
(assert (= p_4751 tmp_4746))
(assert (= q_4755 tmp_4746))
(assert (or (and (and (and (< t 1) (= tm 0)) (= tn 0)) (= b 1)) (and (and (and (and (and (<= 0 b) (<= (+ (- 0 tn) 2) b)) (<= b tn)) (<= b 2)) (<= 1 tm)) (> t 0))))
;Negation of Consequence
(assert (not false))
(check-sat)