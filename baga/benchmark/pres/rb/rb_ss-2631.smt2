(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_16227 () Int)
(declare-fun l_16224 () Int)
(declare-fun v_16223 () Int)
(declare-fun v_15070 () Int)
(declare-fun flted_12_15068 () Int)
(declare-fun flted_12_15067 () Int)
(declare-fun bhl_15073 () Int)
(declare-fun v_bool_401_2346_primed () Int)
(declare-fun bh_14955 () Int)
(declare-fun cl_14954 () Int)
(declare-fun Anon_14918 () Int)
(declare-fun n_14953 () Int)
(declare-fun v_14915 () Int)
(declare-fun x () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun v_bool_395_3172_primed () Int)
(declare-fun bh () Int)
(declare-fun bhl_14919 () Int)
(declare-fun n () Int)
(declare-fun nl_14917 () Int)
(declare-fun cl () Int)
(declare-fun flted_13_14914 () Int)
(declare-fun v_bool_397_3171_primed () Int)
(declare-fun v_bool_399_2621_primed () Int)
(declare-fun v_int_402_15081 () Int)
(declare-fun color_402_15077 () Int)
(declare-fun flted_12_15069 () Int)
(declare-fun x_primed () Int)
(declare-fun l_14916 () Int)
(declare-fun bhr_15076 () Int)
(declare-fun nr_15075 () Int)
(declare-fun r_15074 () Int)
(declare-fun nl_15072 () Int)
(declare-fun l_15071 () Int)
(declare-fun bhr_16229 () Int)
(declare-fun nr_16228 () Int)
(declare-fun Anon_14922 () Int)
(declare-fun bhr_14923 () Int)
(declare-fun nr_14921 () Int)
(declare-fun r_14920 () Int)
(declare-fun x_15393 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< l_15071 1))
(assert (= nl_15072 0))
(assert (= bhl_15073 1))
(assert (or (= nr_15075 0) (< r_15074 1)))
(assert (= r_16227 r_15074))
(assert (= l_16224 l_15071))
(assert (= v_16223 v_15070))
(assert (= flted_12_15069 1))
(assert (= flted_12_15068 0))
(assert (= flted_12_15067 0))
(assert (= n_14953 (+ (+ nr_15075 1) nl_15072)))
(assert (= bhl_15073 bh_14955))
(assert (= bhr_15076 bh_14955))
(assert (> v_bool_401_2346_primed 0))
(assert (<= cl_14954 1))
(assert (<= 0 cl_14954))
(assert (<= 1 bh_14955))
(assert (<= 0 n_14953))
(assert (= cl_14954 1))
(assert (<= Anon_14918 1))
(assert (<= 0 Anon_14918))
(assert (<= 1 bhl_14919))
(assert (<= 0 nl_14917))
(assert (= bh_14955 bhl_14919))
(assert (= cl_14954 Anon_14918))
(assert (= n_14953 nl_14917))
(assert (= a_primed v_14915))
(assert (= x_15393 x))
(assert (= a_primed a))
(assert (<= 0 cl))
(assert (<= cl 1))
(assert (> x_15393 0))
(assert (> v_bool_395_3172_primed 0))
(assert (= bh (+ bhl_14919 1)))
(assert (= bhl_14919 bhr_14923))
(assert (= n (+ (+ nr_14921 1) nl_14917)))
(assert (= cl 0))
(assert (= flted_13_14914 0))
(assert (> v_bool_397_3171_primed 0))
(assert (< r_14920 1))
(assert (> v_bool_399_2621_primed 0))
(assert (= v_int_402_15081 0))
(assert (= color_402_15077 flted_12_15069))
(assert (= x_primed l_14916))
(assert (= bhr_15076 1))
(assert (= nr_15075 0))
(assert (< r_15074 1))
(assert (or (= nl_15072 0) (< l_15071 1)))
(assert (= bhr_16229 1))
(assert (= nr_16228 0))
(assert (or (and (and (and (= Anon_14922 0) (<= 2 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)) (or (and (and (and (< r_14920 1) (= nr_14921 0)) (= bhr_14923 1)) (= Anon_14922 0)) (and (and (and (= Anon_14922 1) (<= 1 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)))))
(assert (= x_15393 1))
;Negation of Consequence
(assert (not false))
(check-sat)