(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_26 () Int)
(declare-fun bm () Int)
(declare-fun b () Int)
(declare-fun bn () Int)
(declare-fun l () Int)
(declare-fun Anon_23 () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun a () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (or (and (and (and (< b 1) (= bm 0)) (= bn 0)) (= Anon_26 1)) (and (and (and (and (and (<= 0 Anon_26) (<= (+ (- 0 bn) 2) Anon_26)) (<= Anon_26 bn)) (<= Anon_26 2)) (<= 1 bm)) (> b 0))))
(assert (<= an (+ bn 1)))
(assert (<= bn (+ an 1)))
(assert (= l a))
(assert (or (and (and (and (< a 1) (= am 0)) (= an 0)) (= Anon_23 1)) (and (and (and (and (and (<= 0 Anon_23) (<= (+ (- 0 an) 2) Anon_23)) (<= Anon_23 an)) (<= Anon_23 2)) (<= 1 am)) (> a 0))))
;Negation of Consequence
(assert (not (or (= am 0) (or (= an 0) (< a 1)))))
(check-sat)