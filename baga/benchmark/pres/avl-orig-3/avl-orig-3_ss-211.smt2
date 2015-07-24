(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun k1_primed () Int)
(declare-fun v_node_119_1849_primed () Int)
(declare-fun Anon_40 () Int)
(declare-fun Anon_32 () Int)
(declare-fun Anon_41 () Int)
(declare-fun Anon_33 () Int)
(declare-fun l () Int)
(declare-fun r () Int)
(declare-fun d () Int)
(declare-fun Anon_42 () Int)
(declare-fun Anon_35 () Int)
(declare-fun Anon_43 () Int)
(declare-fun Anon_36 () Int)
(declare-fun ll () Int)
(declare-fun b () Int)
(declare-fun lr () Int)
(declare-fun c () Int)
(declare-fun cm () Int)
(declare-fun cn () Int)
(declare-fun Anon_38 () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun Anon_37 () Int)
(declare-fun k3 () Int)
(declare-fun dm () Int)
(declare-fun dn () Int)
(declare-fun Anon_34 () Int)
(declare-fun k2 () Int)
(declare-fun tmp1_3511 () Int)
(declare-fun resn_3512 () Int)
(declare-fun tmp2_3513 () Int)
(declare-fun resrn_3514 () Int)
(declare-fun cm_3488 () Int)
(declare-fun cn_3489 () Int)
(declare-fun ba3 () Int)
(declare-fun am_3490 () Int)
(declare-fun an_3491 () Int)
(declare-fun ba1 () Int)
(declare-fun bm_3492 () Int)
(declare-fun bn_3493 () Int)
(declare-fun ba2 () Int)
(declare-fun an () Int)
(declare-fun Anon_31 () Int)
(declare-fun am () Int)
(declare-fun a () Int)
(declare-fun an_3497 () Int)
(declare-fun ba1_3498 () Int)
(declare-fun am_3496 () Int)
(declare-fun resl_3506 () Int)
(declare-fun bn_3500 () Int)
(declare-fun ba2_3501 () Int)
(declare-fun bm_3499 () Int)
(declare-fun resrl_3509 () Int)
(declare-fun cn_3503 () Int)
(declare-fun ba3_3504 () Int)
(declare-fun cm_3502 () Int)
(declare-fun resrr_3510 () Int)
(declare-fun k1 () Int)
(declare-fun res () Int)
(declare-fun resr_3507 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= dn (+ cn 1)))
(assert (<= cn (+ dn 1)))
(assert (<= an (+ bn 1)))
(assert (<= bn (+ an 1)))
(assert (= k1_primed k1))
(assert (= v_node_119_1849_primed k2))
(assert (= Anon_40 Anon_32))
(assert (= Anon_41 Anon_33))
(assert (= l k3))
(assert (= r d))
(assert (= cm_3488 dm))
(assert (= cn_3489 dn))
(assert (= ba3 Anon_34))
(assert (= Anon_42 Anon_35))
(assert (= Anon_43 Anon_36))
(assert (= ll b))
(assert (= lr c))
(assert (= am_3490 bm))
(assert (= an_3491 bn))
(assert (= ba1 Anon_37))
(assert (= bm_3492 cm))
(assert (= bn_3493 cn))
(assert (= ba2 Anon_38))
(assert (<= 0 cm))
(assert (<= 0 cn))
(assert (<= 0 Anon_38))
(assert (<= Anon_38 2))
(assert (<= 0 bm))
(assert (<= 0 bn))
(assert (<= 0 Anon_37))
(assert (<= Anon_37 2))
(assert (> k3 0))
(assert (<= 0 dm))
(assert (<= 0 dn))
(assert (<= 0 Anon_34))
(assert (<= Anon_34 2))
(assert (> k2 0))
(assert (= resrn_3514 (+ 1 tmp1_3511)))
(assert (or (and (= tmp1_3511 cn_3489) (>= cn_3489 bn_3493)) (and (= tmp1_3511 bn_3493) (< cn_3489 bn_3493))))
(assert (= resn_3512 (+ 1 tmp2_3513)))
(assert (or (and (= tmp2_3513 an_3491) (>= an_3491 resrn_3514)) (and (= tmp2_3513 resrn_3514) (< an_3491 resrn_3514))))
(assert (= am_3496 am_3490))
(assert (= an_3497 an_3491))
(assert (= ba1_3498 ba1))
(assert (= bm_3499 bm_3492))
(assert (= bn_3500 bn_3493))
(assert (= ba2_3501 ba2))
(assert (= cm_3502 cm_3488))
(assert (= cn_3503 cn_3489))
(assert (= ba3_3504 ba3))
(assert (<= 0 cm_3488))
(assert (<= 0 cn_3489))
(assert (<= 0 ba3))
(assert (<= ba3 2))
(assert (<= 0 am_3490))
(assert (<= 0 an_3491))
(assert (<= 0 ba1))
(assert (<= ba1 2))
(assert (<= 0 bm_3492))
(assert (<= 0 bn_3493))
(assert (<= 0 ba2))
(assert (<= ba2 2))
(assert (= k1 1))
(assert (or (and (and (and (< a 1) (= am 0)) (= an 0)) (= Anon_31 1)) (and (and (and (and (and (<= 0 Anon_31) (<= (+ (- 0 an) 2) Anon_31)) (<= Anon_31 an)) (<= Anon_31 2)) (<= 1 am)) (> a 0))))
(assert (= res 2))
(assert (or (and (and (and (< resl_3506 1) (= am_3496 0)) (= an_3497 0)) (= ba1_3498 1)) (and (and (and (and (and (<= 0 ba1_3498) (<= (+ (- 0 an_3497) 2) ba1_3498)) (<= ba1_3498 an_3497)) (<= ba1_3498 2)) (<= 1 am_3496)) (> resl_3506 0))))
(assert (= resr_3507 3))
(assert (or (and (and (and (< resrl_3509 1) (= bm_3499 0)) (= bn_3500 0)) (= ba2_3501 1)) (and (and (and (and (and (<= 0 ba2_3501) (<= (+ (- 0 bn_3500) 2) ba2_3501)) (<= ba2_3501 bn_3500)) (<= ba2_3501 2)) (<= 1 bm_3499)) (> resrl_3509 0))))
(assert (or (and (and (and (< resrr_3510 1) (= cm_3502 0)) (= cn_3503 0)) (= ba3_3504 1)) (and (and (and (and (and (<= 0 ba3_3504) (<= (+ (- 0 cn_3503) 2) ba3_3504)) (<= ba3_3504 cn_3503)) (<= ba3_3504 2)) (<= 1 cm_3502)) (> resrr_3510 0))))
(assert (not (= k1 resr_3507)))
(assert (not (= k1 res)))
(assert (not (= res resr_3507)))
;Negation of Consequence
(assert (not false))
(check-sat)