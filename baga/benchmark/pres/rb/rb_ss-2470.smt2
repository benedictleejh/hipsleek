(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_408_2354_primed () Int)
(declare-fun left_408_2353_primed () Int)
(declare-fun color_408_2352_primed () Int)
(declare-fun val_408_2351_primed () Int)
(declare-fun v_14915 () Int)
(declare-fun x () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun x_primed () Int)
(declare-fun v_bool_395_3172_primed () Int)
(declare-fun bh () Int)
(declare-fun n () Int)
(declare-fun cl () Int)
(declare-fun flted_13_14914 () Int)
(declare-fun v_bool_397_3171_primed () Int)
(declare-fun v_bool_399_2621_primed () Int)
(declare-fun Anon_14918 () Int)
(declare-fun bhl_14919 () Int)
(declare-fun nl_14917 () Int)
(declare-fun l_14916 () Int)
(declare-fun Anon_14922 () Int)
(declare-fun bhr_14923 () Int)
(declare-fun nr_14921 () Int)
(declare-fun r_14920 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_408_2354_primed r_14920))
(assert (= left_408_2353_primed l_14916))
(assert (= color_408_2352_primed flted_13_14914))
(assert (= val_408_2351_primed v_14915))
(assert (= a_primed v_14915))
(assert (= x_primed x))
(assert (= a_primed a))
(assert (<= 0 cl))
(assert (<= cl 1))
(assert (> x_primed 0))
(assert (> v_bool_395_3172_primed 0))
(assert (= bh (+ bhl_14919 1)))
(assert (= bhl_14919 bhr_14923))
(assert (= n (+ (+ nr_14921 1) nl_14917)))
(assert (= cl 0))
(assert (= flted_13_14914 0))
(assert (> v_bool_397_3171_primed 0))
(assert (> r_14920 0))
(assert (not (> v_bool_399_2621_primed 0)))
(assert (or (and (and (and (= Anon_14918 0) (<= 2 bhl_14919)) (<= 1 nl_14917)) (> l_14916 0)) (or (and (and (and (< l_14916 1) (= nl_14917 0)) (= bhl_14919 1)) (= Anon_14918 0)) (and (and (and (= Anon_14918 1) (<= 1 bhl_14919)) (<= 1 nl_14917)) (> l_14916 0)))))
(assert (or (and (and (and (= Anon_14922 0) (<= 2 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)) (or (and (and (and (< r_14920 1) (= nr_14921 0)) (= bhr_14923 1)) (= Anon_14922 0)) (and (and (and (= Anon_14922 1) (<= 1 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)