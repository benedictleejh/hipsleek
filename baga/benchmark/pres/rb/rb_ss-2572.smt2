(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_14922 () Int)
(declare-fun r_14920 () Int)
(declare-fun n () Int)
(declare-fun nr_14921 () Int)
(declare-fun bhr_14923 () Int)
(declare-fun bh () Int)
(declare-fun bhl_14919 () Int)
(declare-fun r_16227 () Int)
(declare-fun flted_12_15067 () Int)
(declare-fun bhr_15076 () Int)
(declare-fun r_15074 () Int)
(declare-fun bh_14955 () Int)
(declare-fun nl_14917 () Int)
(declare-fun n_14953 () Int)
(declare-fun nr_15075 () Int)
(declare-fun l_16224 () Int)
(declare-fun flted_12_15068 () Int)
(declare-fun bhl_15073 () Int)
(declare-fun nl_15072 () Int)
(declare-fun l_15071 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< r_14920 1))
(assert (or (and (and (and (= Anon_14922 0) (<= 2 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)) (or (and (and (and (< r_14920 1) (= nr_14921 0)) (= bhr_14923 1)) (= Anon_14922 0)) (and (and (and (= Anon_14922 1) (<= 1 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)))))
(assert (<= 1 bhl_14919))
(assert (= n (+ (+ nr_14921 1) nl_14917)))
(assert (= bhl_14919 bhr_14923))
(assert (= bh (+ bhl_14919 1)))
(assert (= bh_14955 bhl_14919))
(assert (<= 1 bh_14955))
(assert (= bhr_15076 bh_14955))
(assert (= flted_12_15067 0))
(assert (= r_16227 r_15074))
(assert (or (and (and (and (= flted_12_15067 0) (<= 2 bhr_15076)) (<= 1 nr_15075)) (> r_15074 0)) (or (and (and (and (< r_15074 1) (= nr_15075 0)) (= bhr_15076 1)) (= flted_12_15067 0)) (and (and (and (= flted_12_15067 1) (<= 1 bhr_15076)) (<= 1 nr_15075)) (> r_15074 0)))))
(assert (= flted_12_15068 0))
(assert (= bhl_15073 bh_14955))
(assert (<= 0 n_14953))
(assert (<= 0 nl_14917))
(assert (= n_14953 nl_14917))
(assert (= n_14953 (+ (+ nr_15075 1) nl_15072)))
(assert (= l_16224 l_15071))
(assert (or (and (and (and (= flted_12_15068 0) (<= 2 bhl_15073)) (<= 1 nl_15072)) (> l_15071 0)) (or (and (and (and (< l_15071 1) (= nl_15072 0)) (= bhl_15073 1)) (= flted_12_15068 0)) (and (and (and (= flted_12_15068 1) (<= 1 bhl_15073)) (<= 1 nl_15072)) (> l_15071 0)))))
;Negation of Consequence
(assert (not (or (= nl_15072 0) (< l_15071 1))))
(check-sat)