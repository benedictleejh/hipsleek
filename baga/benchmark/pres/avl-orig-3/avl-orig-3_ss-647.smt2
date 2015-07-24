(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_41 () Int)
(declare-fun n_3775 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n1_3779 () Int)
(declare-fun tn_3798 () Int)
(declare-fun n2_3783 () Int)
(declare-fun height_79_4747 () Int)
(declare-fun Anon_43 () Int)
(declare-fun n_3859 () Int)
(declare-fun resb_3823 () Int)
(declare-fun resn_3822 () Int)
(declare-fun n_3938 () Int)
(declare-fun bn () Int)
(declare-fun cn () Int)
(declare-fun Anon_4874 () Int)
(declare-fun b_4612 () Int)
(declare-fun n1_4618 () Int)
(declare-fun n2_4622 () Int)
(declare-fun n_3970 () Int)
(declare-fun n () Int)
(declare-fun b_3839 () Int)
(declare-fun n2_3946 () Int)
(declare-fun n1_3942 () Int)
(declare-fun n_3951 () Int)
(declare-fun tmp1_4439 () Int)
(declare-fun resn_4440 () Int)
(declare-fun tmp2_4441 () Int)
(declare-fun resrn_4442 () Int)
(declare-fun an () Int)
(declare-fun n_4500 () Int)
(declare-fun n_4611 () Int)
(declare-fun v_int_79_4862 () Int)
(declare-fun n1_4869 () Int)
(declare-fun n2_4873 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_41 n_3775))
(assert (<= 0 n2_3783))
(assert (<= 0 tn_3798))
(assert (<= 0 n1_3779))
(assert (= n_3775 tn))
(assert (exists ((max_4905 Int)) (and (= tn (+ 1 max_4905)) (or (and (= max_4905 n1_3779) (>= n1_3779 n2_3783)) (and (= max_4905 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tn_3798 n1_3779))
(assert (< 0 tn_3798))
(assert (or (= tn_3798 resn_3822) (and (= resn_3822 (+ 1 tn_3798)) (not (= resb_3823 1)))))
(assert (= n_3859 n2_3783))
(assert (= height_79_4747 resn_4440))
(assert (<= 0 bn))
(assert (<= 0 cn))
(assert (<= 0 an))
(assert (or (and (= tmp1_4439 cn) (>= cn bn)) (and (= tmp1_4439 bn) (< cn bn))))
(assert (<= 0 n_3859))
(assert (<= 0 n_3951))
(assert (<= 0 n_3970))
(assert (= bn n_3970))
(assert (= Anon_43 n_3938))
(assert (= cn n_3859))
(assert (<= 0 n2_3946))
(assert (= n_3970 n2_3946))
(assert (<= 0 n1_3942))
(assert (= (+ 2 n_3859) n))
(assert (<= b_3839 2))
(assert (<= 0 b_3839))
(assert (<= 0 n))
(assert (<= resb_3823 2))
(assert (<= 0 resb_3823))
(assert (<= 0 resn_3822))
(assert (= b_3839 resb_3823))
(assert (= n resn_3822))
(assert (= n_3938 n))
(assert (= n1_4618 bn))
(assert (= n2_4622 cn))
(assert (<= n1_4618 (+ n2_4622 1)))
(assert (<= n2_4622 (+ 1 n1_4618)))
(assert (<= 0 n_4500))
(assert (<= b_4612 2))
(assert (<= 0 b_4612))
(assert (<= 0 n_4611))
(assert (= Anon_4874 b_4612))
(assert (exists ((max_4903 Int)) (and (= n_4611 (+ 1 max_4903)) (or (and (= max_4903 n1_4618) (>= n1_4618 n2_4622)) (and (= max_4903 n2_4622) (< n1_4618 n2_4622))))))
(assert (= (+ b_4612 n2_4622) (+ 1 n1_4618)))
(assert (= resrn_4442 n_4611))
(assert (or (and (= resrn_4442 (+ n1_4618 1)) (<= n2_4622 n1_4618)) (and (= resrn_4442 (+ n2_4622 1)) (< n1_4618 n2_4622))))
(assert (< n_3970 n_3951))
(assert (exists ((max_4904 Int)) (and (= n (+ 1 max_4904)) (or (and (= max_4904 n1_3942) (>= n1_3942 n2_3946)) (and (= max_4904 n2_3946) (< n1_3942 n2_3946))))))
(assert (= (+ b_3839 n2_3946) (+ 1 n1_3942)))
(assert (<= n2_3946 (+ 1 n1_3942)))
(assert (<= n1_3942 (+ n2_3946 1)))
(assert (= n_3951 n1_3942))
(assert (= an n_3951))
(assert (= resrn_4442 (+ 1 tmp1_4439)))
(assert (= resn_4440 (+ 1 tmp2_4441)))
(assert (or (and (= tmp2_4441 an) (>= an resrn_4442)) (and (= tmp2_4441 resrn_4442) (< an resrn_4442))))
(assert (= n_4500 an))
(assert (<= n_4611 n_4500))
(assert (= v_int_79_4862 (+ 1 n_4500)))
(assert (= n1_4869 n_4500))
(assert (= n2_4873 n_4611))
;Negation of Consequence
(assert (not (or (and (= v_int_79_4862 (+ 1 n1_4869)) (<= n2_4873 n1_4869)) (and (= v_int_79_4862 (+ 1 n2_4873)) (< n1_4869 n2_4873)))))
(check-sat)