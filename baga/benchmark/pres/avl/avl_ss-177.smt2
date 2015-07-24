(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height2_4235 () Int)
(declare-fun size2_4234 () Int)
(declare-fun height1_4232 () Int)
(declare-fun size1_4231 () Int)
(declare-fun q_4233 () Int)
(declare-fun p_4230 () Int)
(declare-fun Anon_4229 () Int)
(declare-fun v3_primed () Int)
(declare-fun v3 () Int)
(declare-fun v2_primed () Int)
(declare-fun v2 () Int)
(declare-fun v1_primed () Int)
(declare-fun v1 () Int)
(declare-fun d () Int)
(declare-fun c () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun m () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun m_4180 () Int)
(declare-fun n () Int)
(declare-fun n_4181 () Int)
(declare-fun h_4217 () Int)
(declare-fun h_4197 () Int)
(declare-fun cm () Int)
(declare-fun cn () Int)
(declare-fun dm () Int)
(declare-fun an_4176 () Int)
(declare-fun h_primed () Int)
(declare-fun h_4223 () Int)
(declare-fun n_4200 () Int)
(declare-fun m_4199 () Int)
(declare-fun c_primed () Int)
(declare-fun n_4207 () Int)
(declare-fun m_4206 () Int)
(declare-fun d_primed () Int)
(declare-fun tmp2_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= height2_4235 n_4181))
(assert (= size2_4234 m_4180))
(assert (= height1_4232 n))
(assert (= size1_4231 m))
(assert (= q_4233 b_primed))
(assert (= p_4230 a_primed))
(assert (= Anon_4229 v3_primed))
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
(assert (<= 0 m))
(assert (<= 0 n))
(assert (= m_4180 bm))
(assert (= n_4181 bn))
(assert (<= 0 bm))
(assert (<= 0 bn))
(assert (<= 0 m_4180))
(assert (<= 0 n_4181))
(assert (or (and (= h_4197 n) (>= n n_4181)) (and (= h_4197 n_4181) (< n n_4181))))
(assert (= h_4217 (+ 1 h_4197)))
(assert (= m_4199 cm))
(assert (= n_4200 cn))
(assert (<= 0 cm))
(assert (<= 0 cn))
(assert (<= 0 m_4199))
(assert (<= 0 n_4200))
(assert (= m_4206 dm))
(assert (= n_4207 an_4176))
(assert (<= 0 dm))
(assert (<= 0 an_4176))
(assert (<= 0 m_4206))
(assert (<= 0 n_4207))
(assert (or (and (= h_4223 n_4200) (>= n_4200 n_4207)) (and (= h_4223 n_4207) (< n_4200 n_4207))))
(assert (= h_primed (+ 1 h_4223)))
(assert (or (and (and (< c_primed 1) (= m_4199 0)) (= n_4200 0)) (and (and (<= 1 n_4200) (<= 1 m_4199)) (> c_primed 0))))
(assert (or (and (and (< d_primed 1) (= m_4206 0)) (= n_4207 0)) (and (and (<= 1 n_4207) (<= 1 m_4206)) (> d_primed 0))))
(assert (= tmp2_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)