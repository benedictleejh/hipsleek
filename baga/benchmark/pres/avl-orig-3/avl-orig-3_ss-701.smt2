(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_22 () Int)
(declare-fun Anon_19 () Int)
(declare-fun n_3775 () Int)
(declare-fun Anon_25 () Int)
(declare-fun b_3839 () Int)
(declare-fun n_3938 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n1_3779 () Int)
(declare-fun tn_3798 () Int)
(declare-fun resb_3823 () Int)
(declare-fun resn_3822 () Int)
(declare-fun n2_3783 () Int)
(declare-fun n () Int)
(declare-fun n_3859 () Int)
(declare-fun Anon_3947 () Int)
(declare-fun n2_3946 () Int)
(declare-fun n1_3942 () Int)
(declare-fun n_3951 () Int)
(declare-fun n_4045 () Int)
(declare-fun b_3971 () Int)
(declare-fun n_3970 () Int)
(declare-fun n1_4049 () Int)
(declare-fun n2_4053 () Int)
(declare-fun height_79_4748 () Int)
(declare-fun cn () Int)
(declare-fun dn () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun h_4451 () Int)
(declare-fun t_4452 () Int)
(declare-fun t1_4454 () Int)
(declare-fun t2_4456 () Int)
(declare-fun h1_4453 () Int)
(declare-fun h2_4455 () Int)
(declare-fun n_4500 () Int)
(declare-fun n_4611 () Int)
(declare-fun v_int_79_5055 () Int)
(declare-fun n1_5062 () Int)
(declare-fun n2_5066 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_22 n_3938))
(assert (= Anon_19 n_3775))
(assert (<= 0 n2_3783))
(assert (<= b_3839 2))
(assert (<= 0 b_3839))
(assert (<= resb_3823 2))
(assert (<= 0 resb_3823))
(assert (<= 0 resn_3822))
(assert (= b_3839 resb_3823))
(assert (<= 0 tn_3798))
(assert (<= 0 n1_3779))
(assert (= n_3775 tn))
(assert (<= 0 n_3859))
(assert (<= 0 n_3951))
(assert (<= 0 n1_4049))
(assert (<= 0 n2_4053))
(assert (= Anon_25 n_4045))
(assert (exists ((max_5097 Int)) (and (= n (+ 1 max_5097)) (or (and (= max_5097 n1_3942) (>= n1_3942 n2_3946)) (and (= max_5097 n2_3946) (< n1_3942 n2_3946))))))
(assert (= (+ b_3839 n2_3946) (+ 1 n1_3942)))
(assert (<= n2_3946 (+ 1 n1_3942)))
(assert (<= n1_3942 (+ n2_3946 1)))
(assert (= n_3938 n))
(assert (exists ((max_5096 Int)) (and (= tn (+ 1 max_5096)) (or (and (= max_5096 n1_3779) (>= n1_3779 n2_3783)) (and (= max_5096 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tn_3798 n1_3779))
(assert (< 0 tn_3798))
(assert (or (= tn_3798 resn_3822) (and (= resn_3822 (+ 1 tn_3798)) (not (= resb_3823 1)))))
(assert (= n resn_3822))
(assert (<= 0 n))
(assert (= n_3859 n2_3783))
(assert (= (+ 2 n_3859) n))
(assert (= an n_3951))
(assert (= dn n_3859))
(assert (<= b_3971 2))
(assert (<= 0 b_3971))
(assert (<= 0 n_3970))
(assert (<= Anon_3947 2))
(assert (<= 0 Anon_3947))
(assert (<= 0 n2_3946))
(assert (= b_3971 Anon_3947))
(assert (= n_3970 n2_3946))
(assert (<= 0 n1_3942))
(assert (= n_3951 n1_3942))
(assert (<= n_3951 n_3970))
(assert (= n_4045 n_3970))
(assert (<= n1_4049 (+ n2_4053 1)))
(assert (<= n2_4053 (+ 1 n1_4049)))
(assert (= (+ b_3971 n2_4053) (+ 1 n1_4049)))
(assert (exists ((max_5098 Int)) (and (= n_3970 (+ 1 max_5098)) (or (and (= max_5098 n1_4049) (>= n1_4049 n2_4053)) (and (= max_5098 n2_4053) (< n1_4049 n2_4053))))))
(assert (= bn n1_4049))
(assert (= cn n2_4053))
(assert (= height_79_4748 h_4451))
(assert (<= 0 h2_4455))
(assert (<= 0 h1_4453))
(assert (<= 0 cn))
(assert (<= 0 bn))
(assert (<= 0 an))
(assert (<= 0 dn))
(assert (or (and (= t2_4456 cn) (>= cn dn)) (and (= t2_4456 dn) (< cn dn))))
(assert (or (and (= t1_4454 an) (>= an bn)) (and (= t1_4454 bn) (< an bn))))
(assert (<= 0 n_4500))
(assert (<= 0 n_4611))
(assert (= h_4451 (+ t_4452 1)))
(assert (or (and (= t_4452 h1_4453) (>= h1_4453 h2_4455)) (and (= t_4452 h2_4455) (< h1_4453 h2_4455))))
(assert (= h1_4453 (+ t1_4454 1)))
(assert (= h2_4455 (+ t2_4456 1)))
(assert (= n_4500 h1_4453))
(assert (= n_4611 h2_4455))
(assert (<= n_4611 n_4500))
(assert (= v_int_79_5055 (+ 1 n_4500)))
(assert (= n1_5062 n_4500))
(assert (= n2_5066 n_4611))
;Negation of Consequence
(assert (not (or (and (= v_int_79_5055 (+ 1 n1_5062)) (<= n2_5066 n1_5062)) (and (= v_int_79_5055 (+ 1 n2_5066)) (< n1_5062 n2_5066)))))
(check-sat)