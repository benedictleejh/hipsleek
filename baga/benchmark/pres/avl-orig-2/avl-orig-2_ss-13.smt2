(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_200_1639_primed () Int)
(declare-fun left_200_1638_primed () Int)
(declare-fun height_200_1637_primed () Int)
(declare-fun Anon_48 () Int)
(declare-fun ele_200_1636_primed () Int)
(declare-fun Anon_47 () Int)
(declare-fun k1_primed () Int)
(declare-fun l () Int)
(declare-fun k2_primed () Int)
(declare-fun k2 () Int)
(declare-fun cn () Int)
(declare-fun Anon_46 () Int)
(declare-fun cm () Int)
(declare-fun r () Int)
(declare-fun an () Int)
(declare-fun Anon_49 () Int)
(declare-fun am () Int)
(declare-fun ll () Int)
(declare-fun bn () Int)
(declare-fun Anon_50 () Int)
(declare-fun bm () Int)
(declare-fun lr () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_200_1639_primed lr))
(assert (= left_200_1638_primed ll))
(assert (= height_200_1637_primed Anon_48))
(assert (= ele_200_1636_primed Anon_47))
(assert (= k1_primed l))
(assert (= k2_primed k2))
(assert (= k2 1))
(assert (or (and (and (and (< r 1) (= cm 0)) (= cn 0)) (= Anon_46 1)) (and (and (and (and (and (<= 0 Anon_46) (<= (+ (- 0 cn) 2) Anon_46)) (<= Anon_46 cn)) (<= Anon_46 2)) (<= 1 cm)) (> r 0))))
(assert (or (and (and (and (< ll 1) (= am 0)) (= an 0)) (= Anon_49 1)) (and (and (and (and (and (<= 0 Anon_49) (<= (+ (- 0 an) 2) Anon_49)) (<= Anon_49 an)) (<= Anon_49 2)) (<= 1 am)) (> ll 0))))
(assert (or (and (and (and (< lr 1) (= bm 0)) (= bn 0)) (= Anon_50 1)) (and (and (and (and (and (<= 0 Anon_50) (<= (+ (- 0 bn) 2) Anon_50)) (<= Anon_50 bn)) (<= Anon_50 2)) (<= 1 bm)) (> lr 0))))
;Negation of Consequence
(assert (not false))
(check-sat)