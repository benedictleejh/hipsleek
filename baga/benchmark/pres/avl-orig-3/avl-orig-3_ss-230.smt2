(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  unsat) 
;Variables declarations
(declare-fun Anon_49 () Int)
(declare-fun cn () Int)
(declare-fun dn () Int)
(declare-fun ba3_3549 () Int)
(declare-fun cn_3489 () Int)
(declare-fun bn_3493 () Int)
(declare-fun bn () Int)
(declare-fun tmp1_3534 () Int)
(declare-fun resn_3535 () Int)
(declare-fun tmp2_3536 () Int)
(declare-fun an () Int)
(declare-fun an_3491 () Int)
(declare-fun an_3541 () Int)
(declare-fun bn_3545 () Int)
(declare-fun n1_3623 () Int)
(declare-fun n2_3627 () Int)
(declare-fun tmp2_3601 () Int)
(declare-fun tmp1_3599 () Int)
(declare-fun resrn_3537 () Int)
(declare-fun n1_3556 () Int)
(declare-fun n2_3560 () Int)
(declare-fun cn_3548 () Int)
(declare-fun resln_3602 () Int)
(declare-fun resn_3600 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= dn (+ cn 1)))
(assert (<= cn (+ dn 1)))
(assert (<= 0 an))
(assert (<= 0 an_3491))
(assert (<= 0 bn_3493))
(assert (<= 0 cn_3489))
(assert (= Anon_49 resn_3535))
(assert (or (and (= tmp1_3534 cn_3489) (>= cn_3489 bn_3493)) (and (= tmp1_3534 bn_3493) (< cn_3489 bn_3493))))
(assert (<= 0 dn))
(assert (<= 0 bn))
(assert (<= 0 cn))
(assert (= bn_3493 cn))
(assert (= cn_3489 dn))
(assert (<= 0 an_3541))
(assert (<= 0 bn_3545))
(assert (<= ba3_3549 2))
(assert (<= 0 ba3_3549))
(assert (= (+ ba3_3549 n2_3560) (+ 1 n1_3556)))
(assert (or (and (= resrn_3537 (+ n1_3556 1)) (<= n2_3560 n1_3556)) (and (= resrn_3537 (+ n2_3560 1)) (< n1_3556 n2_3560))))
(assert (<= n2_3560 (+ 1 n1_3556)))
(assert (<= n1_3556 (+ n2_3560 1)))
(assert (= n2_3560 cn_3489))
(assert (= n1_3556 bn_3493))
(assert (<= an (+ bn 1)))
(assert (<= bn (+ an 1)))
(assert (= an_3491 bn))
(assert (= resrn_3537 (+ 1 tmp1_3534)))
(assert (= resn_3535 (+ 1 tmp2_3536)))
(assert (or (and (= tmp2_3536 an_3491) (>= an_3491 resrn_3537)) (and (= tmp2_3536 resrn_3537) (< an_3491 resrn_3537))))
(assert (= an_3541 an))
(assert (= bn_3545 an_3491))
(assert (or (and (= tmp1_3599 an_3541) (>= an_3541 bn_3545)) (and (= tmp1_3599 bn_3545) (< an_3541 bn_3545))))
(assert (= n1_3623 an_3541))
(assert (= n2_3627 bn_3545))
(assert (exists ((bb1_3709 Int)) (= (+ bb1_3709 n2_3627) (+ 1 n1_3623))))
(assert (exists ((max_3708 Int)) (and (= resln_3602 (+ 1 max_3708)) (or (and (= max_3708 n1_3623) (>= n1_3623 n2_3627)) (and (= max_3708 n2_3627) (< n1_3623 n2_3627))))))
(assert (or (and (= tmp2_3601 resln_3602) (>= resln_3602 cn_3548)) (and (= tmp2_3601 cn_3548) (< resln_3602 cn_3548))))
(assert (= resn_3600 (+ 1 tmp2_3601)))
(assert (= resln_3602 (+ 1 tmp1_3599)))
(assert (= resrn_3537 cn_3548))
(assert (exists ((max_3707 Int)) (and (= cn_3548 (+ 1 max_3707)) (or (and (= max_3707 n1_3556) (>= n1_3556 n2_3560)) (and (= max_3707 n2_3560) (< n1_3556 n2_3560))))))
(assert (<= 0 cn_3548))
;Negation of Consequence
(assert (not (or (and (= (+ resln_3602 1) resn_3600) (< cn_3548 resn_3600)) (and (= (+ cn_3548 1) resn_3600) (<= (+ resln_3602 2) resn_3600)))))
(check-sat)