(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_595_2198_primed () Int)
(declare-fun v_bool_539_2199_primed () Int)
(declare-fun v_16669 () Int)
(declare-fun flted_13_16668 () Int)
(declare-fun Anon_22 () Int)
(declare-fun n () Int)
(declare-fun bh () Int)
(declare-fun v_bool_534_2200_primed () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun nr_16675 () Int)
(declare-fun bhr_16677 () Int)
(declare-fun Anon_16676 () Int)
(declare-fun n_16981 () Int)
(declare-fun bh_16983 () Int)
(declare-fun Anon_16982 () Int)
(declare-fun right_592_17010 () Int)
(declare-fun r_16674 () Int)
(declare-fun v_node_592_17018 () Int)
(declare-fun flted_529_17007 () Int)
(declare-fun bh1_17009 () Int)
(declare-fun Anon_17008 () Int)
(declare-fun res () Int)
(declare-fun n_17034 () Int)
(declare-fun bh_17035 () Int)
(declare-fun cl () Int)
(declare-fun Anon_16672 () Int)
(declare-fun bhl_16673 () Int)
(declare-fun nl_16671 () Int)
(declare-fun l_16670 () Int)
(declare-fun x_primed () Int)
(declare-fun cl_17039 () Int)
(declare-fun bh_17040 () Int)
(declare-fun n_17038 () Int)
(declare-fun v_node_597_2013_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_595_2198_primed 0))
(assert (not (> v_bool_539_2199_primed 0)))
(assert (< v_16669 v_primed))
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
(assert (= tmp_primed r_16674))
(assert (= n_16981 nr_16675))
(assert (= Anon_16982 Anon_16676))
(assert (= bh_16983 bhr_16677))
(assert (<= 0 nr_16675))
(assert (<= 1 bhr_16677))
(assert (<= 0 Anon_16676))
(assert (<= Anon_16676 1))
(assert (= flted_529_17007 (+ 1 n_16981)))
(assert (> v_node_592_17018 0))
(assert (<= bh_16983 bh1_17009))
(assert (<= bh1_17009 bh_16983))
(assert (<= 0 n_16981))
(assert (<= 1 bh_16983))
(assert (<= 0 Anon_16982))
(assert (<= Anon_16982 1))
(assert (= right_592_17010 r_16674))
(assert (= v_node_597_2013_primed v_node_592_17018))
(assert (= n_17034 flted_529_17007))
(assert (= cl Anon_17008))
(assert (= bh_17035 bh1_17009))
(assert (<= 0 flted_529_17007))
(assert (<= 1 bh1_17009))
(assert (<= 0 Anon_17008))
(assert (<= Anon_17008 1))
(assert (= cl 1))
(assert (> res 0))
(assert (= n_17038 n_17034))
(assert (= cl_17039 cl))
(assert (= bh_17040 bh_17035))
(assert (<= 0 n_17034))
(assert (<= 1 bh_17035))
(assert (<= 0 cl))
(assert (<= cl 1))
(assert (or (and (and (and (= Anon_16672 0) (<= 2 bhl_16673)) (<= 1 nl_16671)) (> l_16670 0)) (or (and (and (and (< l_16670 1) (= nl_16671 0)) (= bhl_16673 1)) (= Anon_16672 0)) (and (and (and (= Anon_16672 1) (<= 1 bhl_16673)) (<= 1 nl_16671)) (> l_16670 0)))))
(assert (= x_primed 1))
(assert (or (and (and (and (= cl_17039 0) (<= 2 bh_17040)) (<= 1 n_17038)) (> v_node_597_2013_primed 0)) (or (and (and (and (< v_node_597_2013_primed 1) (= n_17038 0)) (= bh_17040 1)) (= cl_17039 0)) (and (and (and (= cl_17039 1) (<= 1 bh_17040)) (<= 1 n_17038)) (> v_node_597_2013_primed 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)