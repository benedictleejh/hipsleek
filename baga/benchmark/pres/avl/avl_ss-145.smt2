(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v3_primed () Int)
(declare-fun v3 () Int)
(declare-fun v2_primed () Int)
(declare-fun v2 () Int)
(declare-fun v1_primed () Int)
(declare-fun v1 () Int)
(declare-fun d_primed () Int)
(declare-fun c_primed () Int)
(declare-fun b_primed () Int)
(declare-fun a () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun res () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun bn () Int)
(declare-fun bm () Int)
(declare-fun b () Int)
(declare-fun cn () Int)
(declare-fun cm () Int)
(declare-fun c () Int)
(declare-fun an_4176 () Int)
(declare-fun dm () Int)
(declare-fun d () Int)
(declare-fun n_4178 () Int)
(declare-fun m_4177 () Int)
(declare-fun a_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= an_4176 an))
(assert (<= cn (+ 1 bn)))
(assert (<= (+ 0 bn) (+ cn 1)))
(assert (or (and (= an bn) (>= bn cn)) (and (= an cn) (< bn cn))))
(assert (= v3_primed v3))
(assert (= v2_primed v2))
(assert (= v1_primed v1))
(assert (= d_primed d))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= m am))
(assert (= n an))
(assert (<= 0 am))
(assert (<= 0 an))
(assert (= res n))
(assert (= m_4177 m))
(assert (= n_4178 n))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (or (and (and (< b 1) (= bm 0)) (= bn 0)) (and (and (<= 1 bn) (<= 1 bm)) (> b 0))))
(assert (or (and (and (< c 1) (= cm 0)) (= cn 0)) (and (and (<= 1 cn) (<= 1 cm)) (> c 0))))
(assert (or (and (and (< d 1) (= dm 0)) (= an_4176 0)) (and (and (<= 1 an_4176) (<= 1 dm)) (> d 0))))
(assert (or (and (and (< a_primed 1) (= m_4177 0)) (= n_4178 0)) (and (and (<= 1 n_4178) (<= 1 m_4177)) (> a_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)