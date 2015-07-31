(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun right_133_1681_primed () Int)
(declare-fun left_133_1680_primed () Int)
(declare-fun height_133_1679_primed () Int)
(declare-fun Anon_41 () Int)
(declare-fun ele_133_1678_primed () Int)
(declare-fun Anon_40 () Int)
(declare-fun v_node_133_1677_primed () Int)
(declare-fun k1_primed () Int)
(declare-fun k2_primed () Int)
(declare-fun k2 () Int)
(declare-fun cn () Int)
(declare-fun ba3 () Int)
(declare-fun cm () Int)
(declare-fun r () Int)
(declare-fun l () Int)
(declare-fun an () Int)
(declare-fun ba1 () Int)
(declare-fun am () Int)
(declare-fun ll () Int)
(declare-fun bn () Int)
(declare-fun ba2 () Int)
(declare-fun bm () Int)
(declare-fun lr () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_133_1681_primed r))
(assert (= left_133_1680_primed l))
(assert (= height_133_1679_primed Anon_41))
(assert (= ele_133_1678_primed Anon_40))
(assert (= v_node_133_1677_primed lr))
(assert (= k1_primed l))
(assert (= k2_primed k2))
(assert (or (and (and (and (< r 1) (= cm 0)) (= cn 0)) (= ba3 1)) (and (and (and (and (and (<= 0 ba3) (<= (+ (- 0 cn) 2) ba3)) (<= ba3 cn)) (<= ba3 2)) (<= 1 cm)) (> r 0))))
(assert (= l 1))
(assert (or (and (and (and (< ll 1) (= am 0)) (= an 0)) (= ba1 1)) (and (and (and (and (and (<= 0 ba1) (<= (+ (- 0 an) 2) ba1)) (<= ba1 an)) (<= ba1 2)) (<= 1 am)) (> ll 0))))
(assert (or (and (and (and (< lr 1) (= bm 0)) (= bn 0)) (= ba2 1)) (and (and (and (and (and (<= 0 ba2) (<= (+ (- 0 bn) 2) ba2)) (<= ba2 bn)) (<= ba2 2)) (<= 1 bm)) (> lr 0))))
;Negation of Consequence
(assert (not false))
(check-sat)