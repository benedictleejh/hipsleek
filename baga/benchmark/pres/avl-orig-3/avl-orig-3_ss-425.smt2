(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  unsat) 
;Variables declarations
(declare-fun Anon_36 () Int)
(declare-fun dn () Int)
(declare-fun Anon_33 () Int)
(declare-fun Anon_30 () Int)
(declare-fun Anon_4237 () Int)
(declare-fun n_3775 () Int)
(declare-fun b_4133 () Int)
(declare-fun n_4245 () Int)
(declare-fun n_4339 () Int)
(declare-fun cn () Int)
(declare-fun n_4264 () Int)
(declare-fun b_4265 () Int)
(declare-fun n2_4347 () Int)
(declare-fun n1_4236 () Int)
(declare-fun n2_4240 () Int)
(declare-fun n_4232 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n2_3783 () Int)
(declare-fun tn_4092 () Int)
(declare-fun resb_4117 () Int)
(declare-fun resn_4116 () Int)
(declare-fun n1_3779 () Int)
(declare-fun n () Int)
(declare-fun n_4153 () Int)
(declare-fun n1_4343 () Int)
(declare-fun bn () Int)
(declare-fun an () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_4245))
(assert (= Anon_36 n_4339))
(assert (= dn n_4245))
(assert (= Anon_33 n_4232))
(assert (= Anon_30 n_3775))
(assert (<= b_4265 2))
(assert (<= 0 b_4265))
(assert (<= 0 n_4264))
(assert (<= Anon_4237 2))
(assert (<= 0 Anon_4237))
(assert (<= 0 n1_4236))
(assert (= b_4265 Anon_4237))
(assert (= n_4264 n1_4236))
(assert (<= 0 n2_4240))
(assert (= n_4245 n2_4240))
(assert (<= 0 n1_3779))
(assert (<= b_4133 2))
(assert (<= 0 b_4133))
(assert (<= resb_4117 2))
(assert (<= 0 resb_4117))
(assert (<= 0 resn_4116))
(assert (= b_4133 resb_4117))
(assert (<= 0 tn_4092))
(assert (<= 0 n2_3783))
(assert (= n_3775 tn))
(assert (<= n1_4236 (+ n2_4240 1)))
(assert (<= n2_4240 (+ 1 n1_4236)))
(assert (= (+ b_4133 n2_4240) (+ 1 n1_4236)))
(assert (<= n_4245 n_4264))
(assert (= n_4339 n_4264))
(assert (<= 0 n_4153))
(assert (<= 0 n1_4343))
(assert (<= 0 n2_4347))
(assert (= cn n2_4347))
(assert (exists ((max_4364 Int)) (and (= n_4264 (+ 1 max_4364)) (or (and (= max_4364 n1_4343) (>= n1_4343 n2_4347)) (and (= max_4364 n2_4347) (< n1_4343 n2_4347))))))
(assert (= (+ b_4265 n2_4347) (+ 1 n1_4343)))
(assert (<= n2_4347 (+ 1 n1_4343)))
(assert (<= n1_4343 (+ n2_4347 1)))
(assert (exists ((max_4365 Int)) (and (= n (+ 1 max_4365)) (or (and (= max_4365 n1_4236) (>= n1_4236 n2_4240)) (and (= max_4365 n2_4240) (< n1_4236 n2_4240))))))
(assert (= n_4232 n))
(assert (exists ((max_4366 Int)) (and (= tn (+ 1 max_4366)) (or (and (= max_4366 n1_3779) (>= n1_3779 n2_3783)) (and (= max_4366 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tn_4092 n2_3783))
(assert (< 0 tn_4092))
(assert (or (= tn_4092 resn_4116) (and (= resn_4116 (+ 1 tn_4092)) (not (= resb_4117 1)))))
(assert (= n resn_4116))
(assert (<= 0 n))
(assert (= n_4153 n1_3779))
(assert (= (+ 2 n_4153) n))
(assert (= an n_4153))
(assert (= bn n1_4343))
;Negation of Consequence
(assert (not (<= bn (+ 1 an))))
(check-sat)