(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status sat)
;Variables declarations
(declare-fun lr () Int)
(declare-fun Anon_43 () Int)
(declare-fun ba3_3285 () Int)
(declare-fun cn_3284 () Int)
(declare-fun cm_3283 () Int)
(declare-fun r_3282 () Int)
(declare-fun Anon_27 () Int)
(declare-fun cm () Int)
(declare-fun Anon_20 () Int)
(declare-fun dm () Int)
(declare-fun d () Int)
(declare-fun ba3 () Int)
(declare-fun cm_3235 () Int)
(declare-fun resr_3274 () Int)
(declare-fun dn () Int)
(declare-fun cn () Int)
(declare-fun resn_3278 () Int)
(declare-fun tmp2_3279 () Int)
(declare-fun cn_3236 () Int)
(declare-fun Anon_26 () Int)
(declare-fun bm () Int)
(declare-fun q_3301 () Int)
(declare-fun ba2 () Int)
(declare-fun bm_3233 () Int)
(declare-fun reslr_3276 () Int)
(declare-fun Anon_23 () Int)
(declare-fun bn () Int)
(declare-fun resln_3280 () Int)
(declare-fun tmp1_3277 () Int)
(declare-fun bn_3234 () Int)
(declare-fun an () Int)
(declare-fun am () Int)
(declare-fun p_3297 () Int)
(declare-fun ba1 () Int)
(declare-fun am_3231 () Int)
(declare-fun an_3232 () Int)
(declare-fun resll_3275 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= lr resr_3274))
(assert (= Anon_43 resn_3278))
(assert (= ba3_3285 Anon_20))
(assert (= cn_3284 dn))
(assert (= cm_3283 dm))
(assert (= r_3282 d))
(assert (<= ba3 2))
(assert (<= 0 ba3))
(assert (<= 0 cm_3235))
(assert (<= Anon_27 2))
(assert (<= 0 Anon_27))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (= ba3 Anon_27))
(assert (= cm_3235 cm))
(assert (or (and (and (and (< d 1) (= dm 0)) (= dn 0)) (= Anon_20 1)) (and (and (and (and (and (<= 0 Anon_20) (<= (+ (- 0 dn) 2) Anon_20)) (<= Anon_20 dn)) (<= Anon_20 2)) (<= 1 dm)) (> d 0))))
(assert (or (and (and (and (< resr_3274 1) (= cm_3235 0)) (= cn_3236 0)) (= ba3 1)) (and (and (and (and (and (<= 0 ba3) (<= (+ (- 0 cn_3236) 2) ba3)) (<= ba3 cn_3236)) (<= ba3 2)) (<= 1 cm_3235)) (> resr_3274 0))))
(assert (<= dn (+ cn 1)))
(assert (<= cn (+ dn 1)))
(assert (= cn_3236 cn))
(assert (= resn_3278 (+ 1 tmp2_3279)))
(assert (<= 0 cn_3236))
(assert (<= ba2 2))
(assert (<= 0 ba2))
(assert (<= 0 bm_3233))
(assert (or (and (= tmp2_3279 resln_3280) (>= resln_3280 cn_3236)) (and (= tmp2_3279 cn_3236) (< resln_3280 cn_3236))))
(assert (<= Anon_23 2))
(assert (<= 0 Anon_23))
(assert (<= Anon_26 2))
(assert (<= 0 Anon_26))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (= ba2 Anon_26))
(assert (= bm_3233 bm))
(assert (= q_3301 reslr_3276))
(assert (or (and (and (and (< reslr_3276 1) (= bm_3233 0)) (= bn_3234 0)) (= ba2 1)) (and (and (and (and (and (<= 0 ba2) (<= (+ (- 0 bn_3234) 2) ba2)) (<= ba2 bn_3234)) (<= ba2 2)) (<= 1 bm_3233)) (> reslr_3276 0))))
(assert (<= an (+ bn 1)))
(assert (<= bn (+ an 1)))
(assert (= ba1 Anon_23))
(assert (= bn_3234 bn))
(assert (<= 0 am))
(assert (<= 0 an))
(assert (= resln_3280 (+ 1 tmp1_3277)))
(assert (<= 0 ba1))
(assert (<= ba1 2))
(assert (<= 0 bn_3234))
(assert (<= 0 an_3232))
(assert (<= 0 am_3231))
(assert (or (and (= tmp1_3277 an_3232) (>= an_3232 bn_3234)) (and (= tmp1_3277 bn_3234) (< an_3232 bn_3234))))
(assert (= an_3232 an))
(assert (= am_3231 am))
(assert (= p_3297 resll_3275))
(assert (or (and (and (and (< resll_3275 1) (= am_3231 0)) (= an_3232 0)) (= ba1 1)) (and (and (and (and (and (<= 0 ba1) (<= (+ (- 0 an_3232) 2) ba1)) (<= ba1 an_3232)) (<= ba1 2)) (<= 1 am_3231)) (> resll_3275 0))))
;Negation of Consequence
(assert (not (or (= am_3231 0) (or (= an_3232 0) (< resll_3275 1)))))
(check-sat)