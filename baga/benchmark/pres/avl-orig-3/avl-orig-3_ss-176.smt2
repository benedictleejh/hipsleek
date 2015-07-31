(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun resn_3344 () Int)
(declare-fun tmp2_3345 () Int)
(declare-fun resrn_3346 () Int)
(declare-fun tmp1_3343 () Int)
(declare-fun lr () Int)
(declare-fun resr_3274 () Int)
(declare-fun ll () Int)
(declare-fun resl_3272 () Int)
(declare-fun Anon_43 () Int)
(declare-fun Anon_42 () Int)
(declare-fun Anon_3271 () Int)
(declare-fun Anon_20 () Int)
(declare-fun dm () Int)
(declare-fun r_3282 () Int)
(declare-fun d () Int)
(declare-fun l_3286 () Int)
(declare-fun v_node_103_3295 () Int)
(declare-fun Anon_41 () Int)
(declare-fun Anon_19 () Int)
(declare-fun Anon_40 () Int)
(declare-fun Anon_18 () Int)
(declare-fun left_103_3281 () Int)
(declare-fun resn_3278 () Int)
(declare-fun tmp2_3279 () Int)
(declare-fun tmp1_3277 () Int)
(declare-fun k1 () Int)
(declare-fun ba3 () Int)
(declare-fun Anon_27 () Int)
(declare-fun cn_3236 () Int)
(declare-fun cm_3235 () Int)
(declare-fun cm () Int)
(declare-fun Anon_26 () Int)
(declare-fun bm () Int)
(declare-fun rr () Int)
(declare-fun c () Int)
(declare-fun rl () Int)
(declare-fun b () Int)
(declare-fun Anon_49 () Int)
(declare-fun Anon_25 () Int)
(declare-fun Anon_48 () Int)
(declare-fun Anon_24 () Int)
(declare-fun Anon_23 () Int)
(declare-fun am () Int)
(declare-fun r () Int)
(declare-fun k2 () Int)
(declare-fun l () Int)
(declare-fun a () Int)
(declare-fun Anon_47 () Int)
(declare-fun Anon_22 () Int)
(declare-fun Anon_46 () Int)
(declare-fun Anon_21 () Int)
(declare-fun k3_primed () Int)
(declare-fun k3 () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun dn () Int)
(declare-fun cn () Int)
(declare-fun Anon_3296 () Int)
(declare-fun Anon_3273 () Int)
(declare-fun p_3297 () Int)
(declare-fun resll_3275 () Int)
(declare-fun q_3301 () Int)
(declare-fun reslr_3276 () Int)
(declare-fun am_3231 () Int)
(declare-fun an_3232 () Int)
(declare-fun Anon_3300 () Int)
(declare-fun ba1 () Int)
(declare-fun bm_3233 () Int)
(declare-fun bn_3234 () Int)
(declare-fun Anon_3304 () Int)
(declare-fun ba2 () Int)
(declare-fun resln_3280 () Int)
(declare-fun ba1_3289 () Int)
(declare-fun an_3288 () Int)
(declare-fun n1_3299 () Int)
(declare-fun n2_3303 () Int)
(declare-fun am_3287 () Int)
(declare-fun m2_3302 () Int)
(declare-fun m1_3298 () Int)
(declare-fun resr_3339 () Int)
(declare-fun bn_3291 () Int)
(declare-fun ba2_3292 () Int)
(declare-fun bm_3290 () Int)
(declare-fun resrl_3341 () Int)
(declare-fun cn_3284 () Int)
(declare-fun ba3_3285 () Int)
(declare-fun cm_3283 () Int)
(declare-fun resrr_3342 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= ba2_3292 2))
(assert (<= 0 ba2_3292))
(assert (<= 0 bn_3291))
(assert (<= 0 bm_3290))
(assert (<= ba1_3289 2))
(assert (<= 0 ba1_3289))
(assert (<= 0 an_3288))
(assert (<= 0 am_3287))
(assert (<= ba3_3285 2))
(assert (<= 0 ba3_3285))
(assert (<= 0 cn_3284))
(assert (<= 0 cm_3283))
(assert (or (and (= tmp2_3345 an_3288) (>= an_3288 resrn_3346)) (and (= tmp2_3345 resrn_3346) (< an_3288 resrn_3346))))
(assert (= resn_3344 (+ 1 tmp2_3345)))
(assert (or (and (= tmp1_3343 cn_3284) (>= cn_3284 bn_3291)) (and (= tmp1_3343 bn_3291) (< cn_3284 bn_3291))))
(assert (= resrn_3346 (+ 1 tmp1_3343)))
(assert (> k3_primed 0))
(assert (<= Anon_20 2))
(assert (<= 0 Anon_20))
(assert (<= 0 dn))
(assert (<= 0 dm))
(assert (> v_node_103_3295 0))
(assert (> resl_3272 0))
(assert (<= ba1 2))
(assert (<= 0 ba1))
(assert (<= 0 an_3232))
(assert (<= 0 am_3231))
(assert (<= ba2 2))
(assert (<= 0 ba2))
(assert (<= 0 bn_3234))
(assert (<= 0 bm_3233))
(assert (<= ba3 2))
(assert (<= 0 ba3))
(assert (<= 0 cn_3236))
(assert (<= 0 cm_3235))
(assert (= ba2_3292 ba3))
(assert (= bn_3291 cn_3236))
(assert (= bm_3290 cm_3235))
(assert (= lr resr_3274))
(assert (= ll resl_3272))
(assert (= Anon_43 resn_3278))
(assert (= Anon_42 Anon_3271))
(assert (= ba3_3285 Anon_20))
(assert (= cn_3284 dn))
(assert (= cm_3283 dm))
(assert (= r_3282 d))
(assert (= l_3286 v_node_103_3295))
(assert (= Anon_41 Anon_19))
(assert (= Anon_40 Anon_18))
(assert (= left_103_3281 k1))
(assert (or (and (= tmp2_3279 resln_3280) (>= resln_3280 cn_3236)) (and (= tmp2_3279 cn_3236) (< resln_3280 cn_3236))))
(assert (= resn_3278 (+ 1 tmp2_3279)))
(assert (or (and (= tmp1_3277 an_3232) (>= an_3232 bn_3234)) (and (= tmp1_3277 bn_3234) (< an_3232 bn_3234))))
(assert (= resln_3280 (+ 1 tmp1_3277)))
(assert (> k1 0))
(assert (<= Anon_23 2))
(assert (<= 0 Anon_23))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (> k2 0))
(assert (<= Anon_26 2))
(assert (<= 0 Anon_26))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (<= Anon_27 2))
(assert (<= 0 Anon_27))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (= ba3 Anon_27))
(assert (= cn_3236 cn))
(assert (= cm_3235 cm))
(assert (= ba2 Anon_26))
(assert (= bn_3234 bn))
(assert (= bm_3233 bm))
(assert (= rr c))
(assert (= rl b))
(assert (= Anon_49 Anon_25))
(assert (= Anon_48 Anon_24))
(assert (= ba1 Anon_23))
(assert (= an_3232 an))
(assert (= am_3231 am))
(assert (= r k2))
(assert (= l a))
(assert (= Anon_47 Anon_22))
(assert (= Anon_46 Anon_21))
(assert (= k3_primed k3))
(assert (<= bn (+ an 1)))
(assert (<= an (+ bn 1)))
(assert (<= cn (+ dn 1)))
(assert (<= dn (+ cn 1)))
(assert (= Anon_3296 Anon_3273))
(assert (= p_3297 resll_3275))
(assert (= q_3301 reslr_3276))
(assert (= m1_3298 am_3231))
(assert (= n1_3299 an_3232))
(assert (= Anon_3300 ba1))
(assert (= m2_3302 bm_3233))
(assert (= n2_3303 bn_3234))
(assert (= Anon_3304 ba2))
(assert (<= n1_3299 (+ n2_3303 1)))
(assert (<= n2_3303 (+ 1 n1_3299)))
(assert (or (and (= resln_3280 (+ n1_3299 1)) (<= n2_3303 n1_3299)) (and (= resln_3280 (+ n2_3303 1)) (< n1_3299 n2_3303))))
(assert (= resln_3280 an_3288))
(assert (= (+ ba1_3289 n2_3303) (+ 1 n1_3299)))
(assert (exists ((max_63 Int)) (and (= an_3288 (+ 1 max_63)) (or (and (= max_63 n1_3299) (>= n1_3299 n2_3303)) (and (= max_63 n2_3303) (< n1_3299 n2_3303))))))
(assert (= am_3287 (+ (+ m2_3302 1) m1_3298)))
(assert (= resr_3339 1))
(assert (or (and (and (and (< resrl_3341 1) (= bm_3290 0)) (= bn_3291 0)) (= ba2_3292 1)) (and (and (and (and (and (<= 0 ba2_3292) (<= (+ (- 0 bn_3291) 2) ba2_3292)) (<= ba2_3292 bn_3291)) (<= ba2_3292 2)) (<= 1 bm_3290)) (> resrl_3341 0))))
(assert (or (and (and (and (< resrr_3342 1) (= cm_3283 0)) (= cn_3284 0)) (= ba3_3285 1)) (and (and (and (and (and (<= 0 ba3_3285) (<= (+ (- 0 cn_3284) 2) ba3_3285)) (<= ba3_3285 cn_3284)) (<= ba3_3285 2)) (<= 1 cm_3283)) (> resrr_3342 0))))
;Negation of Consequence
(assert (not false))
(check-sat)