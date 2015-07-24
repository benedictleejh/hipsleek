(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n2_5798 () Int)
(declare-fun n1_5794 () Int)
(declare-fun height_118_4740 () Int)
(declare-fun v_int_118_5787 () Int)
(declare-fun n_4598 () Int)
(declare-fun n_4487 () Int)
(declare-fun t2_4472 () Int)
(declare-fun cn () Int)
(declare-fun Anon_38 () Int)
(declare-fun dn () Int)
(declare-fun Anon_35 () Int)
(declare-fun Anon_4212 () Int)
(declare-fun n_4220 () Int)
(declare-fun n_4314 () Int)
(declare-fun b_4240 () Int)
(declare-fun n_4239 () Int)
(declare-fun n2_4322 () Int)
(declare-fun n1_4318 () Int)
(declare-fun h_4467 () Int)
(declare-fun t_4468 () Int)
(declare-fun h2_4471 () Int)
(declare-fun h1_4469 () Int)
(declare-fun t1_4470 () Int)
(declare-fun bn () Int)
(declare-fun n2_4215 () Int)
(declare-fun n1_4211 () Int)
(declare-fun n_4207 () Int)
(declare-fun an () Int)
(declare-fun b_4108 () Int)
(declare-fun n () Int)
(declare-fun resn_4091 () Int)
(declare-fun resb_4092 () Int)
(declare-fun b () Int)
(declare-fun tn_4067 () Int)
(declare-fun n_4128 () Int)
(declare-fun Anon_32 () Int)
(declare-fun n_3750 () Int)
(declare-fun n1_3754 () Int)
(declare-fun n2_3758 () Int)
(declare-fun tn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((resb_5865 Int)) (= (+ resb_5865 n2_5798) (+ 1 n1_5794))))
(assert (exists ((max_5864 Int)) (and (= v_int_118_5787 (+ max_5864 1)) (or (and (= max_5864 n1_5794) (>= n1_5794 n2_5798)) (and (= max_5864 n2_5798) (< n1_5794 n2_5798))))))
(assert (= n2_5798 n_4598))
(assert (= n1_5794 n_4487))
(assert (<= 0 n_4487))
(assert (<= 0 n_4598))
(assert (= height_118_4740 h_4467))
(assert (= v_int_118_5787 (+ 1 n_4487)))
(assert (<= n_4598 n_4487))
(assert (<= 0 h2_4471))
(assert (= n_4598 h2_4471))
(assert (<= 0 h1_4469))
(assert (= n_4487 h1_4469))
(assert (<= 0 cn))
(assert (<= 0 dn))
(assert (or (and (= t2_4472 cn) (>= cn dn)) (and (= t2_4472 dn) (< cn dn))))
(assert (= h2_4471 (+ t2_4472 1)))
(assert (<= 0 n_4220))
(assert (<= 0 n1_4318))
(assert (<= 0 n2_4322))
(assert (= cn n2_4322))
(assert (= Anon_38 n_4314))
(assert (= dn n_4220))
(assert (= Anon_35 n_4207))
(assert (<= b_4240 2))
(assert (<= 0 b_4240))
(assert (<= 0 n_4239))
(assert (<= Anon_4212 2))
(assert (<= 0 Anon_4212))
(assert (<= 0 n1_4211))
(assert (= b_4240 Anon_4212))
(assert (= n_4239 n1_4211))
(assert (<= 0 n2_4215))
(assert (= n_4220 n2_4215))
(assert (<= n_4220 n_4239))
(assert (= n_4314 n_4239))
(assert (= (+ b_4240 n2_4322) (+ 1 n1_4318)))
(assert (<= n1_4318 (+ 1 n2_4322)))
(assert (<= (+ 0 n2_4322) (+ n1_4318 1)))
(assert (exists ((max_5861 Int)) (and (= n_4239 (+ max_5861 1)) (or (and (= max_5861 n1_4318) (>= n1_4318 n2_4322)) (and (= max_5861 n2_4322) (< n1_4318 n2_4322))))))
(assert (= bn n1_4318))
(assert (= h_4467 (+ t_4468 1)))
(assert (or (and (= t_4468 h1_4469) (>= h1_4469 h2_4471)) (and (= t_4468 h2_4471) (< h1_4469 h2_4471))))
(assert (= h1_4469 (+ t1_4470 1)))
(assert (<= 0 bn))
(assert (<= 0 an))
(assert (or (and (= t1_4470 an) (>= an bn)) (and (= t1_4470 bn) (< an bn))))
(assert (exists ((max_5862 Int)) (and (= n (+ max_5862 1)) (or (and (= max_5862 n1_4211) (>= n1_4211 n2_4215)) (and (= max_5862 n2_4215) (< n1_4211 n2_4215))))))
(assert (<= (+ 0 n2_4215) (+ n1_4211 1)))
(assert (<= n1_4211 (+ 1 n2_4215)))
(assert (= (+ b_4108 n2_4215) (+ 1 n1_4211)))
(assert (= n_4207 n))
(assert (= an n_4128))
(assert (= (+ 2 n_4128) n))
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
(assert (<= 0 n_4128))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (= tn_4067 n2_3758))
(assert (<= 0 n2_3758))
(assert (= n_4128 n1_3754))
(assert (<= 0 n1_3754))
(assert (= Anon_32 n_3750))
(assert (= n_3750 tn))
(assert (exists ((max_5863 Int)) (and (= tn (+ max_5863 1)) (or (and (= max_5863 n1_3754) (>= n1_3754 n2_3758)) (and (= max_5863 n2_3758) (< n1_3754 n2_3758))))))
;Negation of Consequence
(assert (not (< 0 tn)))
(check-sat)