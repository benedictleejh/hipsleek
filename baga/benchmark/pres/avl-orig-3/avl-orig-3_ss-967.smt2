(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  unsat) 
;Variables declarations
(declare-fun Anon_6003 () Int)
(declare-fun n2_6002 () Int)
(declare-fun n1_5998 () Int)
(declare-fun height_79_4757 () Int)
(declare-fun v_int_79_5991 () Int)
(declare-fun b_4612 () Int)
(declare-fun n_4611 () Int)
(declare-fun n_4500 () Int)
(declare-fun v_int_69_4487 () Int)
(declare-fun n_4153 () Int)
(declare-fun b_4133 () Int)
(declare-fun n () Int)
(declare-fun resn_4116 () Int)
(declare-fun resb_4117 () Int)
(declare-fun tn_4092 () Int)
(declare-fun b () Int)
(declare-fun n1_3779 () Int)
(declare-fun n2_3783 () Int)
(declare-fun n_3775 () Int)
(declare-fun tn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((resb_6024 Int)) (= (+ resb_6024 n2_6002) (+ 1 n1_5998))))
(assert (exists ((max_6023 Int)) (and (= v_int_79_5991 (+ 1 max_6023)) (or (and (= max_6023 n1_5998) (>= n1_5998 n2_6002)) (and (= max_6023 n2_6002) (< n1_5998 n2_6002))))))
(assert (= Anon_6003 b_4612))
(assert (= n2_6002 n_4611))
(assert (= n1_5998 n_4500))
(assert (not (= v_int_69_4487 2)))
(assert (<= 0 n_4500))
(assert (<= b_4612 2))
(assert (<= 0 b_4612))
(assert (<= 0 n_4611))
(assert (= height_79_4757 n_3775))
(assert (= v_int_79_5991 (+ 1 n_4500)))
(assert (<= n_4611 n_4500))
(assert (<= b_4133 2))
(assert (<= 0 b_4133))
(assert (<= 0 n))
(assert (= b_4612 b_4133))
(assert (= n_4611 n))
(assert (<= 0 n_4153))
(assert (= n_4500 n_4153))
(assert (= (+ v_int_69_4487 n_4153) n))
(assert (<= 0 n1_3779))
(assert (= n_4153 n1_3779))
(assert (<= resb_4117 2))
(assert (<= 0 resb_4117))
(assert (<= 0 resn_4116))
(assert (= b_4133 resb_4117))
(assert (= n resn_4116))
(assert (<= 0 tn_4092))
(assert (or (= tn_4092 resn_4116) (and (= resn_4116 (+ 1 tn_4092)) (not (= resb_4117 1)))))
(assert (< 0 tn_4092))
(assert (<= 0 n2_3783))
(assert (= tn_4092 n2_3783))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (exists ((max_6022 Int)) (and (= tn (+ 1 max_6022)) (or (and (= max_6022 n1_3779) (>= n1_3779 n2_3783)) (and (= max_6022 n2_3783) (< n1_3779 n2_3783))))))
(assert (= n_3775 tn))
;Negation of Consequence
(assert (not (<= 0 tn)))
(check-sat)