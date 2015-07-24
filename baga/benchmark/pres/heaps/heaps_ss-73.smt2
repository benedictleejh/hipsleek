(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_2160 () Int)
(declare-fun tright_2153 () Int)
(declare-fun r_2051 () Int)
(declare-fun m2_2045 () Int)
(declare-fun m1_2044 () Int)
(declare-fun m3_2046 () Int)
(declare-fun n () Int)
(declare-fun l_2157 () Int)
(declare-fun tleft_2152 () Int)
(declare-fun m2_2161 () Int)
(declare-fun tnright_2151 () Int)
(declare-fun m2_2052 () Int)
(declare-fun m1_2049 () Int)
(declare-fun tnleft_2150 () Int)
(declare-fun m1_2158 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< tright_2153 1))
(assert (= r_2160 tright_2153))
(assert (<= 0 m1_2044))
(assert (< r_2051 1))
(assert (= m2_2045 0))
(assert (or (= tnright_2151 0) (< tright_2153 1)))
(assert (< tleft_2152 1))
(assert (or (= m2_2045 0) (< r_2051 1)))
(assert (= m2_2052 0))
(assert (not (= m1_2049 0)))
(assert (< 0 n))
(assert (= m2_2045 m2_2052))
(assert (= m1_2044 m1_2049))
(assert (<= m3_2046 1))
(assert (<= 0 m3_2046))
(assert (= (+ m3_2046 m2_2052) m1_2049))
(assert (= n (+ (+ m2_2052 1) m1_2049)))
(assert (= l_2157 tleft_2152))
(assert (= tnright_2151 0))
(assert (or (= tnleft_2150 0) (< tleft_2152 1)))
(assert (= m2_2161 tnright_2151))
(assert (<= tnleft_2150 (+ 1 tnright_2151)))
(assert (<= (+ 0 tnright_2151) tnleft_2150))
(assert (= (+ (+ 1 tnleft_2150) tnright_2151) (+ m2_2052 m1_2049)))
(assert (= tnleft_2150 0))
(assert (= m1_2158 tnleft_2150))
;Negation of Consequence
(assert (not (= 0 m1_2158)))
(check-sat)