(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bh_13923 () Int)
(declare-fun x_14362 () Int)
(declare-fun x () Int)
(declare-fun x_primed () Int)
(declare-fun r_13896 () Int)
(declare-fun bh () Int)
(declare-fun bhr_13899 () Int)
(declare-fun Anon_13894 () Int)
(declare-fun bhl_13895 () Int)
(declare-fun l_13892 () Int)
(declare-fun n_13921 () Int)
(declare-fun nr_13897 () Int)
(declare-fun nl_13893 () Int)
(declare-fun n () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> x_14362 0))
(assert (< r_13896 1))
(assert (= bh_13923 1))
(assert (<= 1 bh_13923))
(assert (<= 1 bhr_13899))
(assert (= bh_13923 bhr_13899))
(assert (= x_14362 x))
(assert (> x 0))
(assert (= x_primed r_13896))
(assert (or (= n_13921 0) (< r_13896 1)))
(assert (< l_13892 1))
(assert (= bh (+ bhl_13895 1)))
(assert (= bhl_13895 bhr_13899))
(assert (or (and (and (and (= Anon_13894 0) (<= 2 bhl_13895)) (<= 1 nl_13893)) (> l_13892 0)) (or (and (and (and (< l_13892 1) (= nl_13893 0)) (= bhl_13895 1)) (= Anon_13894 0)) (and (and (and (= Anon_13894 1) (<= 1 bhl_13895)) (<= 1 nl_13893)) (> l_13892 0)))))
(assert (= n_13921 0))
(assert (<= 0 n_13921))
(assert (<= 0 nr_13897))
(assert (= n_13921 nr_13897))
(assert (= n (+ (+ nr_13897 1) nl_13893)))
;Negation of Consequence
(assert (not (<= 0 n)))
(check-sat)