(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height_79_4747 () Int)
(declare-fun Anon_4968 () Int)
(declare-fun resn_4440 () Int)
(declare-fun Anon_41 () Int)
(declare-fun v_int_79_4956 () Int)
(declare-fun n_3775 () Int)
(declare-fun n1_4963 () Int)
(declare-fun n2_4967 () Int)
(declare-fun b_4612 () Int)
(declare-fun n_4611 () Int)
(declare-fun n2_4622 () Int)
(declare-fun n1_4618 () Int)
(declare-fun tmp2_4441 () Int)
(declare-fun resrn_4442 () Int)
(declare-fun n_4500 () Int)
(declare-fun an () Int)
(declare-fun n_3970 () Int)
(declare-fun n_3951 () Int)
(declare-fun Anon_43 () Int)
(declare-fun n2_3946 () Int)
(declare-fun n1_3942 () Int)
(declare-fun n_3938 () Int)
(declare-fun tmp1_4439 () Int)
(declare-fun bn () Int)
(declare-fun cn () Int)
(declare-fun n_3859 () Int)
(declare-fun b_3839 () Int)
(declare-fun n () Int)
(declare-fun resn_3822 () Int)
(declare-fun resb_3823 () Int)
(declare-fun tn_3798 () Int)
(declare-fun tn () Int)
(declare-fun n2_3783 () Int)
(declare-fun n1_3779 () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= height_79_4747 resn_4440))
(assert (<= 0 n_3951))
(assert (= Anon_4968 b_4612))
(assert (< n_3970 n_3951))
(assert (= resn_4440 (+ 1 tmp2_4441)))
(assert (<= n_4611 n_4500))
(assert (<= b_4612 2))
(assert (<= 0 b_4612))
(assert (<= 0 n_4611))
(assert (<= 0 n_4500))
(assert (= Anon_41 n_3775))
(assert (exists ((flted_44_4957 Int)) (= (+ flted_44_4957 n2_4967) (+ 1 n1_4963))))
(assert (exists ((max_63 Int)) (and (= v_int_79_4956 (+ 1 max_63)) (or (and (= max_63 n1_4963) (>= n1_4963 n2_4967)) (and (= max_63 n2_4967) (< n1_4963 n2_4967))))))
(assert (= v_int_79_4956 (+ 1 n_4500)))
(assert (= n_3775 tn))
(assert (= n1_4963 n_4500))
(assert (= n2_4967 n_4611))
(assert (exists ((max_63 Int)) (and (= n_4611 (+ 1 max_63)) (or (and (= max_63 n1_4618) (>= n1_4618 n2_4622)) (and (= max_63 n2_4622) (< n1_4618 n2_4622))))))
(assert (= (+ b_4612 n2_4622) (+ 1 n1_4618)))
(assert (= resrn_4442 n_4611))
(assert (or (and (= resrn_4442 (+ n1_4618 1)) (<= n2_4622 n1_4618)) (and (= resrn_4442 (+ n2_4622 1)) (< n1_4618 n2_4622))))
(assert (<= n2_4622 (+ 1 n1_4618)))
(assert (<= n1_4618 (+ n2_4622 1)))
(assert (= n2_4622 cn))
(assert (= n1_4618 bn))
(assert (= bn n_3970))
(assert (<= 0 n_3970))
(assert (= resrn_4442 (+ 1 tmp1_4439)))
(assert (or (and (= tmp2_4441 an) (>= an resrn_4442)) (and (= tmp2_4441 resrn_4442) (< an resrn_4442))))
(assert (= n_4500 an))
(assert (<= 0 an))
(assert (= an n_3951))
(assert (= n_3970 n2_3946))
(assert (= n_3951 n1_3942))
(assert (<= n1_3942 (+ n2_3946 1)))
(assert (<= n2_3946 (+ 1 n1_3942)))
(assert (= Anon_43 n_3938))
(assert (<= 0 n2_3946))
(assert (<= 0 n1_3942))
(assert (exists ((max_63 Int)) (and (= n (+ 1 max_63)) (or (and (= max_63 n1_3942) (>= n1_3942 n2_3946)) (and (= max_63 n2_3946) (< n1_3942 n2_3946))))))
(assert (= (+ b_3839 n2_3946) (+ 1 n1_3942)))
(assert (= n_3938 n))
(assert (<= 0 bn))
(assert (<= 0 cn))
(assert (or (and (= tmp1_4439 cn) (>= cn bn)) (and (= tmp1_4439 bn) (< cn bn))))
(assert (<= 0 n_3859))
(assert (= cn n_3859))
(assert (= (+ 2 n_3859) n))
(assert (<= 0 n2_3783))
(assert (= n_3859 n2_3783))
(assert (<= b_3839 2))
(assert (<= 0 b_3839))
(assert (<= 0 n))
(assert (<= resb_3823 2))
(assert (<= 0 resb_3823))
(assert (<= 0 resn_3822))
(assert (= b_3839 resb_3823))
(assert (= n resn_3822))
(assert (<= 0 tn_3798))
(assert (or (= tn_3798 resn_3822) (and (= resn_3822 (+ 1 tn_3798)) (not (= resb_3823 1)))))
(assert (< 0 tn_3798))
(assert (<= 0 n1_3779))
(assert (= tn_3798 n1_3779))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (exists ((max_63 Int)) (and (= tn (+ 1 max_63)) (or (and (= max_63 n1_3779) (>= n1_3779 n2_3783)) (and (= max_63 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= b 2))
(assert (<= 0 b))
;Negation of Consequence
(assert (not false))
(check-sat)