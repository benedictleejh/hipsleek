(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_14922 () Int)
(declare-fun r_14920 () Int)
(declare-fun bh_14955 () Int)
(declare-fun bhr_14923 () Int)
(declare-fun n_14953 () Int)
(declare-fun l_14916 () Int)
(declare-fun nr_14921 () Int)
(declare-fun nl_14917 () Int)
(declare-fun bhl_14919 () Int)
(declare-fun x_15394 () Int)
(declare-fun x () Int)
(declare-fun n () Int)
(declare-fun cl () Int)
(declare-fun bh () Int)
(declare-fun cl_16547 () Int)
(declare-fun bh_16548 () Int)
(declare-fun n_16546 () Int)
(declare-fun x_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< r_14920 1))
(assert (or (and (and (and (= Anon_14922 0) (<= 2 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)) (or (and (and (and (< r_14920 1) (= nr_14921 0)) (= bhr_14923 1)) (= Anon_14922 0)) (and (and (and (= Anon_14922 1) (<= 1 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)))))
(assert (= x_15394 3))
(assert (< l_14916 1))
(assert (= n_14953 0))
(assert (= bh_14955 1))
(assert (<= 1 bh_14955))
(assert (<= 0 n_14953))
(assert (<= 1 bhl_14919))
(assert (<= 0 nl_14917))
(assert (= bh_14955 bhl_14919))
(assert (= n_14953 nl_14917))
(assert (> x_15394 0))
(assert (= bhl_14919 bhr_14923))
(assert (or (= n_14953 0) (< l_14916 1)))
(assert (= x_primed l_14916))
(assert (= cl 0))
(assert (= n (+ (+ nr_14921 1) nl_14917)))
(assert (= bh (+ bhl_14919 1)))
(assert (<= cl 1))
(assert (<= 0 cl))
(assert (= x_15394 x))
(assert (= n_16546 n))
(assert (= cl_16547 cl))
(assert (= bh_16548 bh))
(assert (or (and (and (and (= cl_16547 0) (<= 2 bh_16548)) (<= 1 n_16546)) (> x_primed 0)) (or (and (and (and (< x_primed 1) (= n_16546 0)) (= bh_16548 1)) (= cl_16547 0)) (and (and (and (= cl_16547 1) (<= 1 bh_16548)) (<= 1 n_16546)) (> x_primed 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)