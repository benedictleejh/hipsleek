(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height_118_4739 () Int)
(declare-fun resn_4456 () Int)
(declare-fun tmp2_4457 () Int)
(declare-fun cn () Int)
(declare-fun Anon_60 () Int)
(declare-fun n_4598 () Int)
(declare-fun v_int_118_5594 () Int)
(declare-fun n2_5605 () Int)
(declare-fun Anon_5602 () Int)
(declare-fun n1_5601 () Int)
(declare-fun b_4488 () Int)
(declare-fun n_4487 () Int)
(declare-fun n2_4517 () Int)
(declare-fun n1_4513 () Int)
(declare-fun n_4220 () Int)
(declare-fun n2_4215 () Int)
(declare-fun n_4207 () Int)
(declare-fun n1_4211 () Int)
(declare-fun n_4239 () Int)
(declare-fun resln_4458 () Int)
(declare-fun tmp1_4455 () Int)
(declare-fun bn () Int)
(declare-fun an () Int)
(declare-fun Anon_57 () Int)
(declare-fun n_4128 () Int)
(declare-fun b_4108 () Int)
(declare-fun n () Int)
(declare-fun resn_4091 () Int)
(declare-fun resb_4092 () Int)
(declare-fun tn_4067 () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
(declare-fun n2_3758 () Int)
(declare-fun n1_3754 () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= height_118_4739 resn_4456))
(assert (= resn_4456 (+ 1 tmp2_4457)))
(assert (<= b_4488 2))
(assert (<= 0 b_4488))
(assert (<= 0 n_4487))
(assert (<= 0 n_4598))
(assert (= v_int_118_5594 (+ 1 n_4487)))
(assert (<= n_4598 n_4487))
(assert (<= 0 cn))
(assert (= n_4598 cn))
(assert (or (and (= tmp2_4457 resln_4458) (>= resln_4458 cn)) (and (= tmp2_4457 cn) (< resln_4458 cn))))
(assert (<= 0 n_4239))
(assert (<= 0 n_4220))
(assert (= cn n_4220))
(assert (= Anon_60 n_4207))
(assert (<= 0 n1_4211))
(assert (<= 0 n2_4215))
(assert (= n_4220 n2_4215))
(assert (= n2_5605 n_4598))
(assert (exists ((resb_5652 Int)) (= (+ resb_5652 n2_5605) (+ 1 n1_5601))))
(assert (exists ((max_5651 Int)) (and (= v_int_118_5594 (+ max_5651 1)) (or (and (= max_5651 n1_5601) (>= n1_5601 n2_5605)) (and (= max_5651 n2_5605) (< n1_5601 n2_5605))))))
(assert (= Anon_5602 b_4488))
(assert (= n1_5601 n_4487))
(assert (exists ((max_5650 Int)) (and (= n_4487 (+ max_5650 1)) (or (and (= max_5650 n1_4513) (>= n1_4513 n2_4517)) (and (= max_5650 n2_4517) (< n1_4513 n2_4517))))))
(assert (= (+ b_4488 n2_4517) (+ 1 n1_4513)))
(assert (= resln_4458 n_4487))
(assert (or (and (= resln_4458 (+ n1_4513 1)) (<= n2_4517 n1_4513)) (and (= resln_4458 (+ n2_4517 1)) (< n1_4513 n2_4517))))
(assert (<= (+ 0 n2_4517) (+ n1_4513 1)))
(assert (<= n1_4513 (+ 1 n2_4517)))
(assert (= n2_4517 bn))
(assert (= n1_4513 an))
(assert (< n_4239 n_4220))
(assert (exists ((max_5649 Int)) (and (= n (+ max_5649 1)) (or (and (= max_5649 n1_4211) (>= n1_4211 n2_4215)) (and (= max_5649 n2_4215) (< n1_4211 n2_4215))))))
(assert (<= (+ 0 n2_4215) (+ n1_4211 1)))
(assert (<= n1_4211 (+ 1 n2_4215)))
(assert (= (+ b_4108 n2_4215) (+ 1 n1_4211)))
(assert (= n_4207 n))
(assert (= n_4239 n1_4211))
(assert (= bn n_4239))
(assert (= resln_4458 (+ 1 tmp1_4455)))
(assert (<= 0 an))
(assert (<= 0 bn))
(assert (or (and (= tmp1_4455 an) (>= an bn)) (and (= tmp1_4455 bn) (< an bn))))
(assert (<= 0 n_4128))
(assert (= an n_4128))
(assert (= Anon_57 n_3750))
(assert (= (+ 2 n_4128) n))
(assert (<= 0 n1_3754))
(assert (= n_4128 n1_3754))
(assert (<= b_4108 2))
(assert (<= 0 b_4108))
(assert (<= 0 n))
(assert (<= resb_4092 2))
(assert (<= 0 resb_4092))
(assert (<= 0 resn_4091))
(assert (= b_4108 resb_4092))
(assert (= n resn_4091))
(assert (<= 0 tn_4067))
(assert (or (= tn_4067 resn_4091) (and (= resn_4091 (+ 1 tn_4067)) (not (= resb_4092 1)))))
(assert (< 0 tn_4067))
(assert (<= 0 n2_3758))
(assert (= tn_4067 n2_3758))
(assert (= n_3750 tn))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (exists ((max_5648 Int)) (and (= tn (+ max_5648 1)) (or (and (= max_5648 n1_3754) (>= n1_3754 n2_3758)) (and (= max_5648 n2_3758) (< n1_3754 n2_3758))))))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
;Negation of Consequence
(assert (not (<= 0 b)))
(check-sat)