(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_14922 () Int)
(declare-fun r_14920 () Int)
(declare-fun n () Int)
(declare-fun nr_14921 () Int)
(declare-fun bhr_14923 () Int)
(declare-fun bh () Int)
(declare-fun nl_14917 () Int)
(declare-fun bhl_14919 () Int)
(declare-fun bhr_15076 () Int)
(declare-fun bh_14955 () Int)
(declare-fun n_14953 () Int)
(declare-fun nr_15075 () Int)
(declare-fun bhl_15073 () Int)
(declare-fun nl_15072 () Int)
(declare-fun r_15074 () Int)
(declare-fun v_int_402_15081 () Int)
(declare-fun flted_381_16315 () Int)
(declare-fun flted_381_16316 () Int)
(declare-fun nl_16321 () Int)
(declare-fun bhl_16322 () Int)
(declare-fun bh2_16317 () Int)
(declare-fun flted_12_16343 () Int)
(declare-fun bhr_16325 () Int)
(declare-fun nr_16324 () Int)
(declare-fun r_16323 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 1 bhl_14919))
(assert (<= 0 nl_14917))
(assert (< r_14920 1))
(assert (or (and (and (and (= Anon_14922 0) (<= 2 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)) (or (and (and (and (< r_14920 1) (= nr_14921 0)) (= bhr_14923 1)) (= Anon_14922 0)) (and (and (and (= Anon_14922 1) (<= 1 bhr_14923)) (<= 1 nr_14921)) (> r_14920 0)))))
(assert (< r_15074 1))
(assert (= nr_15075 0))
(assert (= bhr_15076 1))
(assert (= n (+ (+ nr_14921 1) nl_14917)))
(assert (= bhl_14919 bhr_14923))
(assert (= bh (+ bhl_14919 1)))
(assert (= n_14953 nl_14917))
(assert (= bh_14955 bhl_14919))
(assert (<= 0 n_14953))
(assert (<= 1 bh_14955))
(assert (= bhr_15076 bh_14955))
(assert (= bhl_15073 bh_14955))
(assert (= n_14953 (+ (+ nr_15075 1) nl_15072)))
(assert (or (= nr_15075 0) (< r_15074 1)))
(assert (= bhl_16322 bhl_15073))
(assert (= nl_16321 nl_15072))
(assert (= r_16323 r_15074))
(assert (= v_int_402_15081 0))
(assert (= v_int_402_15081 1))
(assert (= flted_12_16343 0))
(assert (= flted_381_16315 1))
(assert (= flted_381_16316 (+ (+ nr_16324 1) nl_16321)))
(assert (= bhl_16322 bh2_16317))
(assert (= bhr_16325 bh2_16317))
(assert (or (and (and (and (= flted_12_16343 0) (<= 2 bhr_16325)) (<= 1 nr_16324)) (> r_16323 0)) (or (and (and (and (< r_16323 1) (= nr_16324 0)) (= bhr_16325 1)) (= flted_12_16343 0)) (and (and (and (= flted_12_16343 1) (<= 1 bhr_16325)) (<= 1 nr_16324)) (> r_16323 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)