(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n2_5903 () Int)
(declare-fun n1_5899 () Int)
(declare-fun height_79_4753 () Int)
(declare-fun v_int_79_5892 () Int)
(declare-fun n_4611 () Int)
(declare-fun n_4500 () Int)
(declare-fun t2_4485 () Int)
(declare-fun cn () Int)
(declare-fun Anon_36 () Int)
(declare-fun dn () Int)
(declare-fun Anon_33 () Int)
(declare-fun Anon_4237 () Int)
(declare-fun n_4245 () Int)
(declare-fun n_4339 () Int)
(declare-fun b_4265 () Int)
(declare-fun n_4264 () Int)
(declare-fun n2_4347 () Int)
(declare-fun n1_4343 () Int)
(declare-fun h_4480 () Int)
(declare-fun t_4481 () Int)
(declare-fun h2_4484 () Int)
(declare-fun h1_4482 () Int)
(declare-fun t1_4483 () Int)
(declare-fun bn () Int)
(declare-fun n2_4240 () Int)
(declare-fun n1_4236 () Int)
(declare-fun n_4232 () Int)
(declare-fun an () Int)
(declare-fun b_4133 () Int)
(declare-fun n () Int)
(declare-fun resn_4116 () Int)
(declare-fun resb_4117 () Int)
(declare-fun b () Int)
(declare-fun tn_4092 () Int)
(declare-fun n_4153 () Int)
(declare-fun Anon_30 () Int)
(declare-fun n_3775 () Int)
(declare-fun n1_3779 () Int)
(declare-fun n2_3783 () Int)
(declare-fun tn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((flted_44_5945 Int)) (= (+ flted_44_5945 n2_5903) (+ 1 n1_5899))))
(assert (exists ((max_5944 Int)) (and (= v_int_79_5892 (+ 1 max_5944)) (or (and (= max_5944 n1_5899) (>= n1_5899 n2_5903)) (and (= max_5944 n2_5903) (< n1_5899 n2_5903))))))
(assert (= n2_5903 n_4611))
(assert (= n1_5899 n_4500))
(assert (<= 0 n_4500))
(assert (<= 0 n_4611))
(assert (= height_79_4753 h_4480))
(assert (= v_int_79_5892 (+ 1 n_4500)))
(assert (<= n_4611 n_4500))
(assert (<= 0 h2_4484))
(assert (= n_4611 h2_4484))
(assert (<= 0 h1_4482))
(assert (= n_4500 h1_4482))
(assert (<= 0 cn))
(assert (<= 0 dn))
(assert (or (and (= t2_4485 cn) (>= cn dn)) (and (= t2_4485 dn) (< cn dn))))
(assert (= h2_4484 (+ t2_4485 1)))
(assert (<= 0 n_4245))
(assert (<= 0 n1_4343))
(assert (<= 0 n2_4347))
(assert (= cn n2_4347))
(assert (= Anon_36 n_4339))
(assert (= dn n_4245))
(assert (= Anon_33 n_4232))
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
(assert (<= n1_4236 (+ n2_4240 1)))
(assert (<= n2_4240 (+ 1 n1_4236)))
(assert (<= n_4245 n_4264))
(assert (= n_4339 n_4264))
(assert (<= n1_4343 (+ n2_4347 1)))
(assert (<= n2_4347 (+ 1 n1_4343)))
(assert (= (+ b_4265 n2_4347) (+ 1 n1_4343)))
(assert (exists ((max_5941 Int)) (and (= n_4264 (+ 1 max_5941)) (or (and (= max_5941 n1_4343) (>= n1_4343 n2_4347)) (and (= max_5941 n2_4347) (< n1_4343 n2_4347))))))
(assert (= bn n1_4343))
(assert (= h_4480 (+ t_4481 1)))
(assert (or (and (= t_4481 h1_4482) (>= h1_4482 h2_4484)) (and (= t_4481 h2_4484) (< h1_4482 h2_4484))))
(assert (= h1_4482 (+ t1_4483 1)))
(assert (<= 0 bn))
(assert (<= 0 an))
(assert (or (and (= t1_4483 an) (>= an bn)) (and (= t1_4483 bn) (< an bn))))
(assert (exists ((max_5942 Int)) (and (= n (+ 1 max_5942)) (or (and (= max_5942 n1_4236) (>= n1_4236 n2_4240)) (and (= max_5942 n2_4240) (< n1_4236 n2_4240))))))
(assert (= (+ b_4133 n2_4240) (+ 1 n1_4236)))
(assert (= n_4232 n))
(assert (= an n_4153))
(assert (= (+ 2 n_4153) n))
(assert (<= b_4133 2))
(assert (<= 0 b_4133))
(assert (<= 0 n))
(assert (<= resb_4117 2))
(assert (<= 0 resb_4117))
(assert (<= 0 resn_4116))
(assert (= b_4133 resb_4117))
(assert (= n resn_4116))
(assert (<= 0 tn_4092))
(assert (or (= tn_4092 resn_4116) (and (= resn_4116 (+ 1 tn_4092)) (not (= resb_4117 1)))))
(assert (< 0 tn_4092))
(assert (<= 0 n_4153))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tn_4092 n2_3783))
(assert (<= 0 n2_3783))
(assert (= n_4153 n1_3779))
(assert (<= 0 n1_3779))
(assert (= Anon_30 n_3775))
(assert (= n_3775 tn))
(assert (exists ((max_5943 Int)) (and (= tn (+ 1 max_5943)) (or (and (= max_5943 n1_3779) (>= n1_3779 n2_3783)) (and (= max_5943 n2_3783) (< n1_3779 n2_3783))))))
;Negation of Consequence
(assert (not (<= 0 tn)))
(check-sat)