(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bh_16983 () Int)
(declare-fun Anon_16982 () Int)
(declare-fun Anon_16676 () Int)
(declare-fun n_16981 () Int)
(declare-fun tmp_primed () Int)
(declare-fun r_16674 () Int)
(declare-fun x () Int)
(declare-fun v () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun v_bool_534_2200_primed () Int)
(declare-fun bh () Int)
(declare-fun bhr_16677 () Int)
(declare-fun n () Int)
(declare-fun nr_16675 () Int)
(declare-fun Anon_22 () Int)
(declare-fun flted_13_16668 () Int)
(declare-fun v_16669 () Int)
(declare-fun v_primed () Int)
(declare-fun v_bool_539_2199_primed () Int)
(declare-fun x_primed () Int)
(declare-fun Anon_16672 () Int)
(declare-fun bhl_16673 () Int)
(declare-fun nl_16671 () Int)
(declare-fun l_16670 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bh_16983 bhr_16677))
(assert (= Anon_16982 Anon_16676))
(assert (= n_16981 nr_16675))
(assert (= tmp_primed r_16674))
(assert (= x_primed x))
(assert (= v_primed v))
(assert (< tmp_null_primed 1))
(assert (> x_primed 0))
(assert (not (> v_bool_534_2200_primed 0)))
(assert (= bh (+ bhl_16673 1)))
(assert (= bhl_16673 bhr_16677))
(assert (= n (+ (+ nr_16675 1) nl_16671)))
(assert (= Anon_22 0))
(assert (= flted_13_16668 0))
(assert (< v_16669 v_primed))
(assert (not (> v_bool_539_2199_primed 0)))
(assert (= x_primed 1))
(assert (or (and (and (and (= Anon_16672 0) (<= 2 bhl_16673)) (<= 1 nl_16671)) (> l_16670 0)) (or (and (and (and (< l_16670 1) (= nl_16671 0)) (= bhl_16673 1)) (= Anon_16672 0)) (and (and (and (= Anon_16672 1) (<= 1 bhl_16673)) (<= 1 nl_16671)) (> l_16670 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)