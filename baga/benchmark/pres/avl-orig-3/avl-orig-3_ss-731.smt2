(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  unsat) 
;Variables declarations
(declare-fun n2_5259 () Int)
(declare-fun Anon_5256 () Int)
(declare-fun n1_5255 () Int)
(declare-fun height_79_4751 () Int)
(declare-fun v_int_79_5248 () Int)
(declare-fun n_4611 () Int)
(declare-fun b_4501 () Int)
(declare-fun n_4500 () Int)
(declare-fun v_int_54_4458 () Int)
(declare-fun n_3859 () Int)
(declare-fun b_3839 () Int)
(declare-fun n () Int)
(declare-fun resn_3822 () Int)
(declare-fun resb_3823 () Int)
(declare-fun tn_3798 () Int)
(declare-fun b () Int)
(declare-fun n1_3779 () Int)
(declare-fun n2_3783 () Int)
(declare-fun n_3775 () Int)
(declare-fun tn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((resb_5296 Int)) (= (+ resb_5296 n2_5259) (+ 1 n1_5255))))
(assert (exists ((max_5295 Int)) (and (= v_int_79_5248 (+ 1 max_5295)) (or (and (= max_5295 n1_5255) (>= n1_5255 n2_5259)) (and (= max_5295 n2_5259) (< n1_5255 n2_5259))))))
(assert (= n2_5259 n_4611))
(assert (= Anon_5256 b_4501))
(assert (= n1_5255 n_4500))
(assert (not (= v_int_54_4458 2)))
(assert (<= b_4501 2))
(assert (<= 0 b_4501))
(assert (<= 0 n_4500))
(assert (<= 0 n_4611))
(assert (= height_79_4751 n_3775))
(assert (= v_int_79_5248 (+ 1 n_4500)))
(assert (<= n_4611 n_4500))
(assert (<= 0 n_3859))
(assert (= n_4611 n_3859))
(assert (<= b_3839 2))
(assert (<= 0 b_3839))
(assert (<= 0 n))
(assert (= b_4501 b_3839))
(assert (= n_4500 n))
(assert (= (+ v_int_54_4458 n_3859) n))
(assert (<= 0 n2_3783))
(assert (= n_3859 n2_3783))
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
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (exists ((max_5294 Int)) (and (= tn (+ 1 max_5294)) (or (and (= max_5294 n1_3779) (>= n1_3779 n2_3783)) (and (= max_5294 n2_3783) (< n1_3779 n2_3783))))))
(assert (= n_3775 tn))
;Negation of Consequence
(assert (not (< 0 tn)))
(check-sat)