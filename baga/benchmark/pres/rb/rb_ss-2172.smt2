(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhl_14041 () Int)
(declare-fun bhr_14044 () Int)
(declare-fun bh_13923 () Int)
(declare-fun bh () Int)
(declare-fun bhr_13899 () Int)
(declare-fun Anon_13894 () Int)
(declare-fun bhl_13895 () Int)
(declare-fun l_13892 () Int)
(declare-fun r_14627 () Int)
(declare-fun r_14042 () Int)
(declare-fun n () Int)
(declare-fun nl_13893 () Int)
(declare-fun nr_13897 () Int)
(declare-fun n_13921 () Int)
(declare-fun nr_14043 () Int)
(declare-fun nl_14040 () Int)
(declare-fun l_14039 () Int)
(declare-fun flted_12_14648 () Int)
(declare-fun bhl_14626 () Int)
(declare-fun nl_14625 () Int)
(declare-fun l_14624 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhl_14041 1))
(assert (= bhr_14044 1))
(assert (= bhl_14041 bh_13923))
(assert (= bhr_14044 bh_13923))
(assert (<= 1 bh_13923))
(assert (<= 1 bhr_13899))
(assert (= bh_13923 bhr_13899))
(assert (< l_13892 1))
(assert (= bh (+ bhl_13895 1)))
(assert (= bhl_13895 bhr_13899))
(assert (or (and (and (and (= Anon_13894 0) (<= 2 bhl_13895)) (<= 1 nl_13893)) (> l_13892 0)) (or (and (and (and (< l_13892 1) (= nl_13893 0)) (= bhl_13895 1)) (= Anon_13894 0)) (and (and (and (= Anon_13894 1) (<= 1 bhl_13895)) (<= 1 nl_13893)) (> l_13892 0)))))
(assert (< r_14042 1))
(assert (= nr_14043 0))
(assert (= r_14627 r_14042))
(assert (<= 0 nr_13897))
(assert (or (= nr_14043 0) (< r_14042 1)))
(assert (= nl_14040 0))
(assert (= n (+ (+ nr_13897 1) nl_13893)))
(assert (= n_13921 nr_13897))
(assert (<= 0 n_13921))
(assert (= n_13921 (+ (+ nr_14043 1) nl_14040)))
(assert (or (= nl_14040 0) (< l_14039 1)))
(assert (< l_14039 1))
(assert (= l_14624 l_14039))
;Negation of Consequence
(assert (not (or (and (and (and (= flted_12_14648 0) (<= 2 bhl_14626)) (<= 1 nl_14625)) (> l_14624 0)) (or (and (and (and (< l_14624 1) (= nl_14625 0)) (= bhl_14626 1)) (= flted_12_14648 0)) (and (and (and (= flted_12_14648 1) (<= 1 bhl_14626)) (<= 1 nl_14625)) (> l_14624 0))))))
(check-sat)