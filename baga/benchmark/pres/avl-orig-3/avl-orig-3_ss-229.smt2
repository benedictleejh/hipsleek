(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_3561 () Int)
(declare-fun n2_3560 () Int)
(declare-fun m2_3559 () Int)
(declare-fun Anon_3557 () Int)
(declare-fun n1_3556 () Int)
(declare-fun m1_3555 () Int)
(declare-fun q_3558 () Int)
(declare-fun resrr_3533 () Int)
(declare-fun p_3554 () Int)
(declare-fun resrl_3532 () Int)
(declare-fun Anon_3553 () Int)
(declare-fun Anon_3531 () Int)
(declare-fun k1 () Int)
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
(declare-fun tmp1_3534 () Int)
(declare-fun tmp2_3536 () Int)
(declare-fun resrn_3537 () Int)
(declare-fun right_119_3538 () Int)
(declare-fun k2 () Int)
(declare-fun Anon_46 () Int)
(declare-fun Anon_29 () Int)
(declare-fun Anon_47 () Int)
(declare-fun Anon_30 () Int)
(declare-fun l_3539 () Int)
(declare-fun a () Int)
(declare-fun r_3543 () Int)
(declare-fun Anon_48 () Int)
(declare-fun Anon_3528 () Int)
(declare-fun Anon_49 () Int)
(declare-fun resn_3535 () Int)
(declare-fun rl () Int)
(declare-fun resl_3529 () Int)
(declare-fun rr () Int)
(declare-fun cm_3488 () Int)
(declare-fun cn_3489 () Int)
(declare-fun ba3 () Int)
(declare-fun bm_3492 () Int)
(declare-fun bn_3493 () Int)
(declare-fun ba2 () Int)
(declare-fun resr_3530 () Int)
(declare-fun am_3490 () Int)
(declare-fun an_3491 () Int)
(declare-fun ba1 () Int)
(declare-fun v_node_119_3552 () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun Anon_31 () Int)
(declare-fun k1_primed () Int)
(declare-fun tmp1_3588 () Int)
(declare-fun resn_3589 () Int)
(declare-fun tmp2_3590 () Int)
(declare-fun resln_3591 () Int)
(declare-fun am_3540 () Int)
(declare-fun an_3541 () Int)
(declare-fun ba1_3542 () Int)
(declare-fun bm_3544 () Int)
(declare-fun bn_3545 () Int)
(declare-fun ba2_3546 () Int)
(declare-fun cm_3547 () Int)
(declare-fun cn_3548 () Int)
(declare-fun ba3_3549 () Int)
(declare-fun cn_3574 () Int)
(declare-fun ba3_3575 () Int)
(declare-fun cm_3573 () Int)
(declare-fun resr_3585 () Int)
(declare-fun an_3577 () Int)
(declare-fun ba1_3578 () Int)
(declare-fun am_3576 () Int)
(declare-fun resll_3586 () Int)
(declare-fun bn_3580 () Int)
(declare-fun ba2_3581 () Int)
(declare-fun bm_3579 () Int)
(declare-fun reslr_3587 () Int)
(declare-fun res () Int)
(declare-fun resl_3583 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= cm_3547 (+ (+ m2_3559 1) m1_3555)))
(assert (exists ((max_63 Int)) (and (= cn_3548 (+ 1 max_63)) (or (and (= max_63 n1_3556) (>= n1_3556 n2_3560)) (and (= max_63 n2_3560) (< n1_3556 n2_3560))))))
(assert (= (+ ba3_3549 n2_3560) (+ 1 n1_3556)))
(assert (= resrn_3537 cn_3548))
(assert (or (and (= resrn_3537 (+ n1_3556 1)) (<= n2_3560 n1_3556)) (and (= resrn_3537 (+ n2_3560 1)) (< n1_3556 n2_3560))))
(assert (<= n2_3560 (+ 1 n1_3556)))
(assert (<= n1_3556 (+ n2_3560 1)))
(assert (= Anon_3561 ba3))
(assert (= n2_3560 cn_3489))
(assert (= m2_3559 cm_3488))
(assert (= Anon_3557 ba2))
(assert (= n1_3556 bn_3493))
(assert (= m1_3555 bm_3492))
(assert (= q_3558 resrr_3533))
(assert (= p_3554 resrl_3532))
(assert (= Anon_3553 Anon_3531))
(assert (<= dn (+ cn 1)))
(assert (<= cn (+ dn 1)))
(assert (<= an (+ bn 1)))
(assert (<= bn (+ an 1)))
(assert (= k1_primed k1))
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
(assert (= resrn_3537 (+ 1 tmp1_3534)))
(assert (or (and (= tmp1_3534 cn_3489) (>= cn_3489 bn_3493)) (and (= tmp1_3534 bn_3493) (< cn_3489 bn_3493))))
(assert (= resn_3535 (+ 1 tmp2_3536)))
(assert (or (and (= tmp2_3536 an_3491) (>= an_3491 resrn_3537)) (and (= tmp2_3536 resrn_3537) (< an_3491 resrn_3537))))
(assert (= right_119_3538 k2))
(assert (= Anon_46 Anon_29))
(assert (= Anon_47 Anon_30))
(assert (= l_3539 a))
(assert (= r_3543 v_node_119_3552))
(assert (= am_3540 am))
(assert (= an_3541 an))
(assert (= ba1_3542 Anon_31))
(assert (= Anon_48 Anon_3528))
(assert (= Anon_49 resn_3535))
(assert (= rl resl_3529))
(assert (= rr resr_3530))
(assert (= bm_3544 am_3490))
(assert (= bn_3545 an_3491))
(assert (= ba2_3546 ba1))
(assert (<= 0 cm_3488))
(assert (<= 0 cn_3489))
(assert (<= 0 ba3))
(assert (<= ba3 2))
(assert (<= 0 bm_3492))
(assert (<= 0 bn_3493))
(assert (<= 0 ba2))
(assert (<= ba2 2))
(assert (> resr_3530 0))
(assert (<= 0 am_3490))
(assert (<= 0 an_3491))
(assert (<= 0 ba1))
(assert (<= ba1 2))
(assert (> v_node_119_3552 0))
(assert (<= 0 am))
(assert (<= 0 an))
(assert (<= 0 Anon_31))
(assert (<= Anon_31 2))
(assert (> k1_primed 0))
(assert (= resln_3591 (+ 1 tmp1_3588)))
(assert (or (and (= tmp1_3588 an_3541) (>= an_3541 bn_3545)) (and (= tmp1_3588 bn_3545) (< an_3541 bn_3545))))
(assert (= resn_3589 (+ 1 tmp2_3590)))
(assert (or (and (= tmp2_3590 resln_3591) (>= resln_3591 cn_3548)) (and (= tmp2_3590 cn_3548) (< resln_3591 cn_3548))))
(assert (= cm_3573 cm_3547))
(assert (= cn_3574 cn_3548))
(assert (= ba3_3575 ba3_3549))
(assert (= am_3576 am_3540))
(assert (= an_3577 an_3541))
(assert (= ba1_3578 ba1_3542))
(assert (= bm_3579 bm_3544))
(assert (= bn_3580 bn_3545))
(assert (= ba2_3581 ba2_3546))
(assert (<= 0 am_3540))
(assert (<= 0 an_3541))
(assert (<= 0 ba1_3542))
(assert (<= ba1_3542 2))
(assert (<= 0 bm_3544))
(assert (<= 0 bn_3545))
(assert (<= 0 ba2_3546))
(assert (<= ba2_3546 2))
(assert (<= 0 cm_3547))
(assert (<= 0 cn_3548))
(assert (<= 0 ba3_3549))
(assert (<= ba3_3549 2))
(assert (= res 1))
(assert (= resl_3583 2))
(assert (or (and (and (and (< resr_3585 1) (= cm_3573 0)) (= cn_3574 0)) (= ba3_3575 1)) (and (and (and (and (and (<= 0 ba3_3575) (<= (+ (- 0 cn_3574) 2) ba3_3575)) (<= ba3_3575 cn_3574)) (<= ba3_3575 2)) (<= 1 cm_3573)) (> resr_3585 0))))
(assert (or (and (and (and (< resll_3586 1) (= am_3576 0)) (= an_3577 0)) (= ba1_3578 1)) (and (and (and (and (and (<= 0 ba1_3578) (<= (+ (- 0 an_3577) 2) ba1_3578)) (<= ba1_3578 an_3577)) (<= ba1_3578 2)) (<= 1 am_3576)) (> resll_3586 0))))
(assert (or (and (and (and (< reslr_3587 1) (= bm_3579 0)) (= bn_3580 0)) (= ba2_3581 1)) (and (and (and (and (and (<= 0 ba2_3581) (<= (+ (- 0 bn_3580) 2) ba2_3581)) (<= ba2_3581 bn_3580)) (<= ba2_3581 2)) (<= 1 bm_3579)) (> reslr_3587 0))))
(assert (not (= res resl_3583)))
;Negation of Consequence
(assert (not false))
(check-sat)