(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_539_2199_primed () Int)
(declare-fun v_16669 () Int)
(declare-fun Anon_22 () Int)
(declare-fun n () Int)
(declare-fun bh () Int)
(declare-fun v_bool_534_2200_primed () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun nl_16671 () Int)
(declare-fun bhl_16673 () Int)
(declare-fun Anon_16672 () Int)
(declare-fun n_16695 () Int)
(declare-fun bh_16697 () Int)
(declare-fun Anon_16696 () Int)
(declare-fun left_542_16724 () Int)
(declare-fun l_16670 () Int)
(declare-fun flted_13_16668 () Int)
(declare-fun v_int_545_1787_primed () Int)
(declare-fun v_int_545_1786_primed () Int)
(declare-fun Anon_16676 () Int)
(declare-fun bhr_16677 () Int)
(declare-fun nr_16675 () Int)
(declare-fun r_16674 () Int)
(declare-fun Anon_16722 () Int)
(declare-fun bh1_16723 () Int)
(declare-fun flted_529_16721 () Int)
(declare-fun v_node_542_16732 () Int)
(declare-fun x_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_539_2199_primed 0))
(assert (<= v_primed v_16669))
(assert (= flted_13_16668 0))
(assert (= Anon_22 0))
(assert (= n (+ (+ nr_16675 1) nl_16671)))
(assert (= bhl_16673 bhr_16677))
(assert (= bh (+ bhl_16673 1)))
(assert (not (> v_bool_534_2200_primed 0)))
(assert (> x_primed 0))
(assert (< tmp_null_primed 1))
(assert (= v_primed v))
(assert (= x_primed x))
(assert (= tmp_primed l_16670))
(assert (= n_16695 nl_16671))
(assert (= Anon_16696 Anon_16672))
(assert (= bh_16697 bhl_16673))
(assert (<= 0 nl_16671))
(assert (<= 1 bhl_16673))
(assert (<= 0 Anon_16672))
(assert (<= Anon_16672 1))
(assert (= flted_529_16721 (+ 1 n_16695)))
(assert (> v_node_542_16732 0))
(assert (<= bh_16697 bh1_16723))
(assert (<= bh1_16723 bh_16697))
(assert (<= 0 n_16695))
(assert (<= 1 bh_16697))
(assert (<= 0 Anon_16696))
(assert (<= Anon_16696 1))
(assert (= left_542_16724 l_16670))
(assert (= v_int_545_1787_primed flted_13_16668))
(assert (= v_int_545_1786_primed 0))
(assert (not (= v_int_545_1787_primed v_int_545_1786_primed)))
(assert (or (and (and (and (= Anon_16676 0) (<= 2 bhr_16677)) (<= 1 nr_16675)) (> r_16674 0)) (or (and (and (and (< r_16674 1) (= nr_16675 0)) (= bhr_16677 1)) (= Anon_16676 0)) (and (and (and (= Anon_16676 1) (<= 1 bhr_16677)) (<= 1 nr_16675)) (> r_16674 0)))))
(assert (or (and (and (and (= Anon_16722 0) (<= 2 bh1_16723)) (<= 1 flted_529_16721)) (> v_node_542_16732 0)) (or (and (and (and (< v_node_542_16732 1) (= flted_529_16721 0)) (= bh1_16723 1)) (= Anon_16722 0)) (and (and (and (= Anon_16722 1) (<= 1 bh1_16723)) (<= 1 flted_529_16721)) (> v_node_542_16732 0)))))
(assert (= x_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)