(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nl_6766 () Int)
(declare-fun l_6803 () Int)
(declare-fun a_primed () Int)
(declare-fun r_6807 () Int)
(declare-fun b_primed () Int)
(declare-fun nl_6804 () Int)
(declare-fun Anon_6805 () Int)
(declare-fun nr_6808 () Int)
(declare-fun Anon_6809 () Int)
(declare-fun flted_120_6235 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun Anon_18 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun bhl_6767 () Int)
(declare-fun bhr_6810 () Int)
(declare-fun bhl_6806 () Int)
(declare-fun h_6232 () Int)
(declare-fun h () Int)
(declare-fun r_6841 () Int)
(declare-fun flted_12_6222 () Int)
(declare-fun bhr_6231 () Int)
(declare-fun r_6229 () Int)
(declare-fun h_6233 () Int)
(declare-fun nc () Int)
(declare-fun nr_6230 () Int)
(declare-fun l_6837 () Int)
(declare-fun flted_12_6223 () Int)
(declare-fun bhl_6228 () Int)
(declare-fun nl_6227 () Int)
(declare-fun l_6226 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nl_6766 (+ (+ nr_6808 1) nl_6804)))
(assert (= flted_120_6235 0))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= l_6803 a_primed))
(assert (= r_6807 b_primed))
(assert (= nl_6804 na))
(assert (= Anon_6805 flted_120_6235))
(assert (= nr_6808 nb))
(assert (= Anon_6809 Anon_18))
(assert (or (and (and (and (= flted_120_6235 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_120_6235 0)) (and (and (and (= flted_120_6235 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= Anon_18 0) (<= 2 h_6232)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h_6232 1)) (= Anon_18 0)) (and (and (and (= Anon_18 1) (<= 1 h_6232)) (<= 1 nb)) (> b 0)))))
(assert (= bhl_6767 (+ bhl_6806 1)))
(assert (= bhl_6806 bhr_6810))
(assert (= bhr_6810 h_6232))
(assert (= bhl_6806 h))
(assert (= h_6232 h))
(assert (= h_6233 h))
(assert (= bhr_6231 h_6233))
(assert (= flted_12_6222 0))
(assert (= r_6841 r_6229))
(assert (or (and (and (and (= flted_12_6222 0) (<= 2 bhr_6231)) (<= 1 nr_6230)) (> r_6229 0)) (or (and (and (and (< r_6229 1) (= nr_6230 0)) (= bhr_6231 1)) (= flted_12_6222 0)) (and (and (and (= flted_12_6222 1) (<= 1 bhr_6231)) (<= 1 nr_6230)) (> r_6229 0)))))
(assert (= flted_12_6223 0))
(assert (= bhl_6228 h_6233))
(assert (= nc (+ (+ nr_6230 1) nl_6227)))
(assert (= l_6837 l_6226))
(assert (or (and (and (and (= flted_12_6223 0) (<= 2 bhl_6228)) (<= 1 nl_6227)) (> l_6226 0)) (or (and (and (and (< l_6226 1) (= nl_6227 0)) (= bhl_6228 1)) (= flted_12_6223 0)) (and (and (and (= flted_12_6223 1) (<= 1 bhl_6228)) (<= 1 nl_6227)) (> l_6226 0)))))
;Negation of Consequence
(assert (not (or (= nl_6227 0) (< l_6226 1))))
(check-sat)