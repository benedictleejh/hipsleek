(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nl_6268 () Int)
(declare-fun l_6433 () Int)
(declare-fun a_primed () Int)
(declare-fun r_6437 () Int)
(declare-fun b_primed () Int)
(declare-fun nl_6434 () Int)
(declare-fun Anon_6435 () Int)
(declare-fun nr_6438 () Int)
(declare-fun Anon_6439 () Int)
(declare-fun flted_119_6221 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun Anon_17 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun bhl_6270 () Int)
(declare-fun bhr_6440 () Int)
(declare-fun bhl_6436 () Int)
(declare-fun h_6218 () Int)
(declare-fun h () Int)
(declare-fun l_6467 () Int)
(declare-fun Anon_6469 () Int)
(declare-fun flted_12_6209 () Int)
(declare-fun l_6212 () Int)
(declare-fun bhl_6470 () Int)
(declare-fun nl_6468 () Int)
(declare-fun bhl_6214 () Int)
(declare-fun h_6219 () Int)
(declare-fun nc () Int)
(declare-fun nl_6213 () Int)
(declare-fun r_6471 () Int)
(declare-fun flted_12_6208 () Int)
(declare-fun bhr_6217 () Int)
(declare-fun nr_6216 () Int)
(declare-fun r_6215 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nl_6268 (+ (+ nr_6438 1) nl_6434)))
(assert (= flted_119_6221 0))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= l_6433 a_primed))
(assert (= r_6437 b_primed))
(assert (= nl_6434 na))
(assert (= Anon_6435 flted_119_6221))
(assert (= nr_6438 nb))
(assert (= Anon_6439 Anon_17))
(assert (or (and (and (and (= flted_119_6221 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_119_6221 0)) (and (and (and (= flted_119_6221 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= Anon_17 0) (<= 2 h_6218)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h_6218 1)) (= Anon_17 0)) (and (and (and (= Anon_17 1) (<= 1 h_6218)) (<= 1 nb)) (> b 0)))))
(assert (= bhl_6270 (+ bhl_6436 1)))
(assert (= bhl_6436 bhr_6440))
(assert (= bhr_6440 h_6218))
(assert (= bhl_6436 h))
(assert (= h_6218 h))
(assert (= h_6219 h))
(assert (= flted_12_6209 0))
(assert (= l_6467 l_6212))
(assert (= Anon_6469 flted_12_6209))
(assert (or (and (and (and (= flted_12_6209 0) (<= 2 bhl_6214)) (<= 1 nl_6213)) (> l_6212 0)) (or (and (and (and (< l_6212 1) (= nl_6213 0)) (= bhl_6214 1)) (= flted_12_6209 0)) (and (and (and (= flted_12_6209 1) (<= 1 bhl_6214)) (<= 1 nl_6213)) (> l_6212 0)))))
(assert (= bhl_6470 bhl_6214))
(assert (= nl_6468 nl_6213))
(assert (= flted_12_6208 0))
(assert (= bhl_6214 h_6219))
(assert (= bhr_6217 h_6219))
(assert (= nc (+ (+ nr_6216 1) nl_6213)))
(assert (= r_6471 r_6215))
(assert (or (and (and (and (= flted_12_6208 0) (<= 2 bhr_6217)) (<= 1 nr_6216)) (> r_6215 0)) (or (and (and (and (< r_6215 1) (= nr_6216 0)) (= bhr_6217 1)) (= flted_12_6208 0)) (and (and (and (= flted_12_6208 1) (<= 1 bhr_6217)) (<= 1 nr_6216)) (> r_6215 0)))))
;Negation of Consequence
(assert (not (or (= nr_6216 0) (< r_6215 1))))
(check-sat)