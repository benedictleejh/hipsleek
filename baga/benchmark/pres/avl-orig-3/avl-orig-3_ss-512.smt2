(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun resn_4440 () Int)
(declare-fun v_int_79_2270_primed () Int)
(declare-fun n_4500 () Int)
(declare-fun tmp2_4441 () Int)
(declare-fun an () Int)
(declare-fun Anon_43 () Int)
(declare-fun Anon_41 () Int)
(declare-fun n_3775 () Int)
(declare-fun n_3951 () Int)
(declare-fun b_3839 () Int)
(declare-fun n1_3942 () Int)
(declare-fun n_3938 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n1_3779 () Int)
(declare-fun tn_3798 () Int)
(declare-fun resb_3823 () Int)
(declare-fun resn_3822 () Int)
(declare-fun n2_3783 () Int)
(declare-fun n () Int)
(declare-fun n2_3946 () Int)
(declare-fun n_3859 () Int)
(declare-fun n_3970 () Int)
(declare-fun resrn_4442 () Int)
(declare-fun tmp1_4439 () Int)
(declare-fun bn () Int)
(declare-fun cn () Int)
(declare-fun n2_4622 () Int)
(declare-fun n1_4618 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_4500))
(assert (= resn_4440 (+ 1 tmp2_4441)))
(assert (= v_int_79_2270_primed n_4500))
(assert (<= 0 an))
(assert (= n_4500 an))
(assert (or (and (= tmp2_4441 an) (>= an resrn_4442)) (and (= tmp2_4441 resrn_4442) (< an resrn_4442))))
(assert (<= 0 n_3859))
(assert (<= 0 n_3951))
(assert (<= 0 n_3970))
(assert (= an n_3951))
(assert (= Anon_43 n_3938))
(assert (= Anon_41 n_3775))
(assert (<= 0 n2_3946))
(assert (<= 0 n1_3942))
(assert (= n_3951 n1_3942))
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
(assert (<= 0 bn))
(assert (<= 0 cn))
(assert (< n_3970 n_3951))
(assert (exists ((max_4641 Int)) (and (= n (+ 1 max_4641)) (or (and (= max_4641 n1_3942) (>= n1_3942 n2_3946)) (and (= max_4641 n2_3946) (< n1_3942 n2_3946))))))
(assert (= (+ b_3839 n2_3946) (+ 1 n1_3942)))
(assert (<= n2_3946 (+ 1 n1_3942)))
(assert (<= n1_3942 (+ n2_3946 1)))
(assert (= n_3938 n))
(assert (exists ((max_4642 Int)) (and (= tn (+ 1 max_4642)) (or (and (= max_4642 n1_3779) (>= n1_3779 n2_3783)) (and (= max_4642 n2_3783) (< n1_3779 n2_3783))))))
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
(assert (= n_3970 n2_3946))
(assert (= cn n_3859))
(assert (= bn n_3970))
(assert (= resrn_4442 (+ 1 tmp1_4439)))
(assert (or (and (= tmp1_4439 cn) (>= cn bn)) (and (= tmp1_4439 bn) (< cn bn))))
(assert (= n1_4618 bn))
(assert (= n2_4622 cn))
;Negation of Consequence
(assert (not (<= n2_4622 (+ n1_4618 1))))
(check-sat)