(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height2_4408 () Int)
(declare-fun size2_4407 () Int)
(declare-fun rlm () Int)
(declare-fun height1_4405 () Int)
(declare-fun size1_4404 () Int)
(declare-fun q_4406 () Int)
(declare-fun p_4403 () Int)
(declare-fun Anon_4402 () Int)
(declare-fun ln_4365 () Int)
(declare-fun rl_primed () Int)
(declare-fun rl () Int)
(declare-fun l_primed () Int)
(declare-fun l () Int)
(declare-fun lm () Int)
(declare-fun ln () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun h_4386 () Int)
(declare-fun h_4382 () Int)
(declare-fun res () Int)
(declare-fun v_node_43_3531_primed () Int)
(declare-fun Anon_4389 () Int)
(declare-fun v_4384 () Int)
(declare-fun p_4390 () Int)
(declare-fun tmp_4385 () Int)
(declare-fun q_4393 () Int)
(declare-fun rr_primed () Int)
(declare-fun flted_33_4366 () Int)
(declare-fun rrm () Int)
(declare-fun rr () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= height2_4408 ln_4365))
(assert (= size2_4407 rlm))
(assert (= height1_4405 n))
(assert (= size1_4404 m))
(assert (= q_4406 rl_primed))
(assert (= p_4403 l_primed))
(assert (= Anon_4402 v_4384))
(assert (= v_4384 10))
(assert (= ln_4365 ln))
(assert (= flted_33_4366 (+ 1 ln)))
(assert (= rr_primed rr))
(assert (= rl_primed rl))
(assert (= l_primed l))
(assert (= m lm))
(assert (= n ln))
(assert (<= 0 lm))
(assert (<= 0 ln))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (= h_4382 (+ 1 n)))
(assert (= h_4386 (+ 1 h_4382)))
(assert (= res v_node_43_3531_primed))
(assert (= Anon_4389 v_4384))
(assert (= p_4390 tmp_4385))
(assert (= q_4393 rr_primed))
(assert (or (and (and (< rr 1) (= rrm 0)) (= flted_33_4366 0)) (and (and (<= 1 flted_33_4366) (<= 1 rrm)) (> rr 0))))
;Negation of Consequence
(assert (not false))
(check-sat)