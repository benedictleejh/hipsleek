(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_48 () Int)
(declare-fun bn () Int)
(declare-fun an () Int)
(declare-fun an_3195 () Int)
(declare-fun bn_3197 () Int)
(declare-fun Anon_49 () Int)
(declare-fun n1_3265 () Int)
(declare-fun n2_3269 () Int)
(declare-fun cn () Int)
(declare-fun tmp1_3246 () Int)
(declare-fun resn_3247 () Int)
(declare-fun tmp2_3248 () Int)
(declare-fun resln_3249 () Int)
(declare-fun dn () Int)
(declare-fun cn_3199 () Int)
(declare-fun resn_3313 () Int)
(declare-fun cn_3253 () Int)
(declare-fun bn_3258 () Int)
(declare-fun tmp2_3314 () Int)
(declare-fun an_3256 () Int)
(declare-fun tmp1_3312 () Int)
(declare-fun resrn_3315 () Int)
(declare-fun n1_3340 () Int)
(declare-fun n2_3344 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= an (+ bn 1)))
(assert (<= bn (+ an 1)))
(assert (<= Anon_49 2))
(assert (<= 0 Anon_49))
(assert (<= 0 dn))
(assert (<= 0 an_3195))
(assert (<= 0 bn_3197))
(assert (<= 0 cn_3199))
(assert (= Anon_48 resn_3247))
(assert (or (and (= tmp1_3246 an_3195) (>= an_3195 bn_3197)) (and (= tmp1_3246 bn_3197) (< an_3195 bn_3197))))
(assert (<= 0 an))
(assert (<= 0 bn))
(assert (<= 0 cn))
(assert (= bn_3197 bn))
(assert (= an_3195 an))
(assert (= n1_3265 an_3195))
(assert (= n2_3269 bn_3197))
(assert (<= n1_3265 (+ 1 n2_3269)))
(assert (<= (+ 0 n2_3269) (+ n1_3265 1)))
(assert (<= 0 an_3256))
(assert (<= 0 bn_3258))
(assert (<= 0 cn_3253))
(assert (exists ((max_3418 Int)) (and (= an_3256 (+ max_3418 1)) (or (and (= max_3418 n1_3265) (>= n1_3265 n2_3269)) (and (= max_3418 n2_3269) (< n1_3265 n2_3269))))))
(assert (= (+ Anon_49 n2_3269) (+ 1 n1_3265)))
(assert (= resln_3249 an_3256))
(assert (or (and (= resln_3249 (+ n1_3265 1)) (<= n2_3269 n1_3265)) (and (= resln_3249 (+ n2_3269 1)) (< n1_3265 n2_3269))))
(assert (<= dn (+ cn 1)))
(assert (<= cn (+ dn 1)))
(assert (= cn_3199 cn))
(assert (= resln_3249 (+ 1 tmp1_3246)))
(assert (= resn_3247 (+ 1 tmp2_3248)))
(assert (or (and (= tmp2_3248 resln_3249) (>= resln_3249 cn_3199)) (and (= tmp2_3248 cn_3199) (< resln_3249 cn_3199))))
(assert (= cn_3253 dn))
(assert (= bn_3258 cn_3199))
(assert (or (and (= tmp1_3312 cn_3253) (>= cn_3253 bn_3258)) (and (= tmp1_3312 bn_3258) (< cn_3253 bn_3258))))
(assert (= resn_3313 (+ 1 tmp2_3314)))
(assert (exists ((Anon_3420 Int)) (= (+ Anon_3420 n2_3344) (+ 1 n1_3340))))
(assert (exists ((max_3419 Int)) (and (= resrn_3315 (+ max_3419 1)) (or (and (= max_3419 n1_3340) (>= n1_3340 n2_3344)) (and (= max_3419 n2_3344) (< n1_3340 n2_3344))))))
(assert (= n2_3344 cn_3253))
(assert (= n1_3340 bn_3258))
(assert (or (and (= tmp2_3314 an_3256) (>= an_3256 resrn_3315)) (and (= tmp2_3314 resrn_3315) (< an_3256 resrn_3315))))
(assert (= resrn_3315 (+ 1 tmp1_3312)))
;Negation of Consequence
(assert (not (or (and (= resrn_3315 (+ 1 n1_3340)) (<= n2_3344 n1_3340)) (and (= resrn_3315 (+ 1 n2_3344)) (< n1_3340 n2_3344)))))
(check-sat)