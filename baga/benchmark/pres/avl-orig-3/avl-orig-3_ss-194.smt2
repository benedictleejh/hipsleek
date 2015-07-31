(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun right_119_1847_primed () Int)
(declare-fun left_119_1846_primed () Int)
(declare-fun height_119_1845_primed () Int)
(declare-fun Anon_30 () Int)
(declare-fun ele_119_1844_primed () Int)
(declare-fun Anon_29 () Int)
(declare-fun k1_primed () Int)
(declare-fun k1 () Int)
(declare-fun an () Int)
(declare-fun Anon_31 () Int)
(declare-fun am () Int)
(declare-fun a () Int)
(declare-fun dn () Int)
(declare-fun Anon_34 () Int)
(declare-fun dm () Int)
(declare-fun d () Int)
(declare-fun bn () Int)
(declare-fun Anon_37 () Int)
(declare-fun bm () Int)
(declare-fun b () Int)
(declare-fun cn () Int)
(declare-fun Anon_38 () Int)
(declare-fun cm () Int)
(declare-fun c () Int)
(declare-fun k2 () Int)
(declare-fun k3 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_119_1847_primed k2))
(assert (= left_119_1846_primed a))
(assert (= height_119_1845_primed Anon_30))
(assert (= ele_119_1844_primed Anon_29))
(assert (= k1_primed k1))
(assert (<= bn (+ an 1)))
(assert (<= an (+ bn 1)))
(assert (<= cn (+ dn 1)))
(assert (<= dn (+ cn 1)))
(assert (or (and (and (and (< a 1) (= am 0)) (= an 0)) (= Anon_31 1)) (and (and (and (and (and (<= 0 Anon_31) (<= (+ (- 0 an) 2) Anon_31)) (<= Anon_31 an)) (<= Anon_31 2)) (<= 1 am)) (> a 0))))
(assert (= k2 1))
(assert (or (and (and (and (< d 1) (= dm 0)) (= dn 0)) (= Anon_34 1)) (and (and (and (and (and (<= 0 Anon_34) (<= (+ (- 0 dn) 2) Anon_34)) (<= Anon_34 dn)) (<= Anon_34 2)) (<= 1 dm)) (> d 0))))
(assert (= k3 2))
(assert (or (and (and (and (< b 1) (= bm 0)) (= bn 0)) (= Anon_37 1)) (and (and (and (and (and (<= 0 Anon_37) (<= (+ (- 0 bn) 2) Anon_37)) (<= Anon_37 bn)) (<= Anon_37 2)) (<= 1 bm)) (> b 0))))
(assert (or (and (and (and (< c 1) (= cm 0)) (= cn 0)) (= Anon_38 1)) (and (and (and (and (and (<= 0 Anon_38) (<= (+ (- 0 cn) 2) Anon_38)) (<= Anon_38 cn)) (<= Anon_38 2)) (<= 1 cm)) (> c 0))))
(assert (not (= k2 k3)))
;Negation of Consequence
(assert (not false))
(check-sat)