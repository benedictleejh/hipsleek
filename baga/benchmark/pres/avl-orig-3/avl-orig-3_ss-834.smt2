(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_5433 () Int)
(declare-fun height_79_4750 () Int)
(declare-fun b_4501 () Int)
(declare-fun b_3839 () Int)
(declare-fun n_3775 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n1_3779 () Int)
(declare-fun tn_3798 () Int)
(declare-fun resb_3823 () Int)
(declare-fun resn_3822 () Int)
(declare-fun n2_3783 () Int)
(declare-fun v_int_54_4458 () Int)
(declare-fun n_3859 () Int)
(declare-fun n () Int)
(declare-fun n_4500 () Int)
(declare-fun n_4611 () Int)
(declare-fun v_int_79_5425 () Int)
(declare-fun n1_5432 () Int)
(declare-fun n2_5436 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_5433 b_4501))
(assert (not (= v_int_54_4458 2)))
(assert (= height_79_4750 n_3775))
(assert (<= b_4501 2))
(assert (<= 0 b_4501))
(assert (<= b_3839 2))
(assert (<= 0 b_3839))
(assert (= b_4501 b_3839))
(assert (<= 0 n2_3783))
(assert (<= resb_3823 2))
(assert (<= 0 resb_3823))
(assert (<= 0 resn_3822))
(assert (= b_3839 resb_3823))
(assert (<= 0 tn_3798))
(assert (<= 0 n1_3779))
(assert (= n_3775 tn))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (exists ((max_63 Int)) (and (= tn (+ 1 max_63)) (or (and (= max_63 n1_3779) (>= n1_3779 n2_3783)) (and (= max_63 n2_3783) (< n1_3779 n2_3783))))))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tn_3798 n1_3779))
(assert (< 0 tn_3798))
(assert (or (= tn_3798 resn_3822) (and (= resn_3822 (+ 1 tn_3798)) (not (= resb_3823 1)))))
(assert (= n resn_3822))
(assert (= n_3859 n2_3783))
(assert (= (+ v_int_54_4458 n_3859) n))
(assert (< n_4500 n_4611))
(assert (<= 0 n_4611))
(assert (<= 0 n_3859))
(assert (= n_4611 n_3859))
(assert (<= 0 n_4500))
(assert (<= 0 n))
(assert (= n_4500 n))
(assert (= v_int_79_5425 (+ 1 n_4611)))
(assert (= n1_5432 n_4500))
(assert (= n2_5436 n_4611))
(assert (exists ((max_63 Int)) (and (= v_int_79_5425 (+ 1 max_63)) (or (and (= max_63 n1_5432) (>= n1_5432 n2_5436)) (and (= max_63 n2_5436) (< n1_5432 n2_5436))))))
(assert (exists ((flted_44_5426 Int)) (= (+ flted_44_5426 n2_5436) (+ 1 n1_5432))))
(assert (or (and (= v_int_79_5425 (+ 1 n1_5432)) (<= n2_5436 n1_5432)) (and (= v_int_79_5425 (+ 1 n2_5436)) (< n1_5432 n2_5436))))
;Negation of Consequence
(assert (not false))
(check-sat)