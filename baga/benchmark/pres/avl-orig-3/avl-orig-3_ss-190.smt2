(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  unsat) 
;Variables declarations
(declare-fun Anon_43 () Int)
(declare-fun bn () Int)
(declare-fun an () Int)
(declare-fun ba1_3289 () Int)
(declare-fun bn_3234 () Int)
(declare-fun an_3232 () Int)
(declare-fun cn () Int)
(declare-fun tmp1_3277 () Int)
(declare-fun resn_3278 () Int)
(declare-fun tmp2_3279 () Int)
(declare-fun dn () Int)
(declare-fun cn_3236 () Int)
(declare-fun bn_3291 () Int)
(declare-fun cn_3284 () Int)
(declare-fun n1_3371 () Int)
(declare-fun n2_3375 () Int)
(declare-fun tmp2_3345 () Int)
(declare-fun tmp1_3343 () Int)
(declare-fun resln_3280 () Int)
(declare-fun n1_3299 () Int)
(declare-fun n2_3303 () Int)
(declare-fun resrn_3346 () Int)
(declare-fun an_3288 () Int)
(declare-fun resn_3344 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= an (+ bn 1)))
(assert (<= bn (+ an 1)))
(assert (<= 0 dn))
(assert (<= 0 an_3232))
(assert (<= 0 bn_3234))
(assert (<= 0 cn_3236))
(assert (= Anon_43 resn_3278))
(assert (or (and (= tmp1_3277 an_3232) (>= an_3232 bn_3234)) (and (= tmp1_3277 bn_3234) (< an_3232 bn_3234))))
(assert (<= 0 an))
(assert (<= 0 bn))
(assert (<= 0 cn))
(assert (= bn_3234 bn))
(assert (= an_3232 an))
(assert (<= ba1_3289 2))
(assert (<= 0 ba1_3289))
(assert (<= 0 bn_3291))
(assert (<= 0 cn_3284))
(assert (= (+ ba1_3289 n2_3303) (+ 1 n1_3299)))
(assert (or (and (= resln_3280 (+ n1_3299 1)) (<= n2_3303 n1_3299)) (and (= resln_3280 (+ n2_3303 1)) (< n1_3299 n2_3303))))
(assert (<= n2_3303 (+ 1 n1_3299)))
(assert (<= n1_3299 (+ n2_3303 1)))
(assert (= n2_3303 bn_3234))
(assert (= n1_3299 an_3232))
(assert (<= dn (+ cn 1)))
(assert (<= cn (+ dn 1)))
(assert (= cn_3236 cn))
(assert (= resln_3280 (+ 1 tmp1_3277)))
(assert (= resn_3278 (+ 1 tmp2_3279)))
(assert (or (and (= tmp2_3279 resln_3280) (>= resln_3280 cn_3236)) (and (= tmp2_3279 cn_3236) (< resln_3280 cn_3236))))
(assert (= cn_3284 dn))
(assert (= bn_3291 cn_3236))
(assert (or (and (= tmp1_3343 cn_3284) (>= cn_3284 bn_3291)) (and (= tmp1_3343 bn_3291) (< cn_3284 bn_3291))))
(assert (= n1_3371 bn_3291))
(assert (= n2_3375 cn_3284))
(assert (exists ((bb2_3448 Int)) (= (+ bb2_3448 n2_3375) (+ 1 n1_3371))))
(assert (exists ((max_3447 Int)) (and (= resrn_3346 (+ 1 max_3447)) (or (and (= max_3447 n1_3371) (>= n1_3371 n2_3375)) (and (= max_3447 n2_3375) (< n1_3371 n2_3375))))))
(assert (or (and (= tmp2_3345 an_3288) (>= an_3288 resrn_3346)) (and (= tmp2_3345 resrn_3346) (< an_3288 resrn_3346))))
(assert (= resn_3344 (+ 1 tmp2_3345)))
(assert (= resrn_3346 (+ 1 tmp1_3343)))
(assert (= resln_3280 an_3288))
(assert (exists ((max_3446 Int)) (and (= an_3288 (+ 1 max_3446)) (or (and (= max_3446 n1_3299) (>= n1_3299 n2_3303)) (and (= max_3446 n2_3303) (< n1_3299 n2_3303))))))
(assert (<= 0 an_3288))
;Negation of Consequence
(assert (not (or (and (= (+ an_3288 1) resn_3344) (< resrn_3346 resn_3344)) (and (= (+ resrn_3346 1) resn_3344) (<= (+ an_3288 2) resn_3344)))))
(check-sat)