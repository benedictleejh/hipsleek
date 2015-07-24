(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_103_1974_primed () Int)
(declare-fun left_103_1973_primed () Int)
(declare-fun height_103_1972_primed () Int)
(declare-fun Anon_19 () Int)
(declare-fun ele_103_1971_primed () Int)
(declare-fun Anon_18 () Int)
(declare-fun resn_3278 () Int)
(declare-fun tmp2_3279 () Int)
(declare-fun resln_3280 () Int)
(declare-fun tmp1_3277 () Int)
(declare-fun Anon_27 () Int)
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
(declare-fun t2_primed () Int)
(declare-fun k1 () Int)
(declare-fun k3_primed () Int)
(declare-fun k3 () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun cn () Int)
(declare-fun dn () Int)
(declare-fun Anon_20 () Int)
(declare-fun dm () Int)
(declare-fun d () Int)
(declare-fun cn_3236 () Int)
(declare-fun ba3 () Int)
(declare-fun cm_3235 () Int)
(declare-fun resr_3274 () Int)
(declare-fun an_3232 () Int)
(declare-fun ba1 () Int)
(declare-fun am_3231 () Int)
(declare-fun resll_3275 () Int)
(declare-fun bn_3234 () Int)
(declare-fun ba2 () Int)
(declare-fun bm_3233 () Int)
(declare-fun reslr_3276 () Int)
(declare-fun v_node_103_1970_primed () Int)
(declare-fun resl_3272 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_103_1974_primed d))
(assert (= left_103_1973_primed k1))
(assert (= height_103_1972_primed Anon_19))
(assert (= ele_103_1971_primed Anon_18))
(assert (<= ba3 2))
(assert (<= 0 ba3))
(assert (<= 0 cn_3236))
(assert (<= 0 cm_3235))
(assert (<= ba2 2))
(assert (<= 0 ba2))
(assert (<= 0 bn_3234))
(assert (<= 0 bm_3233))
(assert (<= ba1 2))
(assert (<= 0 ba1))
(assert (<= 0 an_3232))
(assert (<= 0 am_3231))
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
(assert (= t2_primed k1))
(assert (= k3_primed k3))
(assert (<= bn (+ an 1)))
(assert (<= an (+ bn 1)))
(assert (<= cn (+ dn 1)))
(assert (<= dn (+ cn 1)))
(assert (or (and (and (and (< d 1) (= dm 0)) (= dn 0)) (= Anon_20 1)) (and (and (and (and (and (<= 0 Anon_20) (<= (+ (- 0 dn) 2) Anon_20)) (<= Anon_20 dn)) (<= Anon_20 2)) (<= 1 dm)) (> d 0))))
(assert (= v_node_103_1970_primed 1))
(assert (= resl_3272 2))
(assert (or (and (and (and (< resr_3274 1) (= cm_3235 0)) (= cn_3236 0)) (= ba3 1)) (and (and (and (and (and (<= 0 ba3) (<= (+ (- 0 cn_3236) 2) ba3)) (<= ba3 cn_3236)) (<= ba3 2)) (<= 1 cm_3235)) (> resr_3274 0))))
(assert (or (and (and (and (< resll_3275 1) (= am_3231 0)) (= an_3232 0)) (= ba1 1)) (and (and (and (and (and (<= 0 ba1) (<= (+ (- 0 an_3232) 2) ba1)) (<= ba1 an_3232)) (<= ba1 2)) (<= 1 am_3231)) (> resll_3275 0))))
(assert (or (and (and (and (< reslr_3276 1) (= bm_3233 0)) (= bn_3234 0)) (= ba2 1)) (and (and (and (and (and (<= 0 ba2) (<= (+ (- 0 bn_3234) 2) ba2)) (<= ba2 bn_3234)) (<= ba2 2)) (<= 1 bm_3233)) (> reslr_3276 0))))
(assert (not (= v_node_103_1970_primed resl_3272)))
;Negation of Consequence
(assert (not false))
(check-sat)