(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_149_1783_primed () Int)
(declare-fun Anon_19 () Int)
(declare-fun left_149_1782_primed () Int)
(declare-fun Anon_18 () Int)
(declare-fun height_149_1781_primed () Int)
(declare-fun Anon_17 () Int)
(declare-fun val_149_1780_primed () Int)
(declare-fun Anon_16 () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun y_primed () Int)
(declare-fun z_primed () Int)
(declare-fun ny () Int)
(declare-fun my () Int)
(declare-fun y () Int)
(declare-fun ny_2585 () Int)
(declare-fun mz () Int)
(declare-fun z () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_149_1783_primed Anon_19))
(assert (= left_149_1782_primed Anon_18))
(assert (= height_149_1781_primed Anon_17))
(assert (= val_149_1780_primed Anon_16))
(assert (= x_primed x))
(assert (= y_primed y))
(assert (= z_primed z))
(assert (> y 0))
(assert (= ny_2585 ny))
(assert (or (and (and (< y 1) (= my 0)) (= ny 0)) (and (and (<= 1 ny) (<= 1 my)) (> y 0))))
(assert (or (and (and (< z 1) (= mz 0)) (= ny_2585 0)) (and (and (<= 1 ny_2585) (<= 1 mz)) (> z 0))))
;Negation of Consequence
(assert (not false))
(check-sat)