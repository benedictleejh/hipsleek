(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_6061 () Int)
(declare-fun height_79_4757 () Int)
(declare-fun b_4612 () Int)
(declare-fun b_4133 () Int)
(declare-fun n_3775 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n2_3783 () Int)
(declare-fun tn_4092 () Int)
(declare-fun resb_4117 () Int)
(declare-fun resn_4116 () Int)
(declare-fun n1_3779 () Int)
(declare-fun v_int_69_4487 () Int)
(declare-fun n () Int)
(declare-fun n_4153 () Int)
(declare-fun n_4500 () Int)
(declare-fun n_4611 () Int)
(declare-fun v_int_79_6049 () Int)
(declare-fun n1_6056 () Int)
(declare-fun n2_6060 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_6061 b_4612))
(assert (not (= v_int_69_4487 2)))
(assert (= height_79_4757 n_3775))
(assert (<= b_4612 2))
(assert (<= 0 b_4612))
(assert (<= b_4133 2))
(assert (<= 0 b_4133))
(assert (= b_4612 b_4133))
(assert (<= 0 n1_3779))
(assert (<= resb_4117 2))
(assert (<= 0 resb_4117))
(assert (<= 0 resn_4116))
(assert (= b_4133 resb_4117))
(assert (<= 0 tn_4092))
(assert (<= 0 n2_3783))
(assert (= n_3775 tn))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (exists ((max_63 Int)) (and (= tn (+ 1 max_63)) (or (and (= max_63 n1_3779) (>= n1_3779 n2_3783)) (and (= max_63 n2_3783) (< n1_3779 n2_3783))))))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tn_4092 n2_3783))
(assert (< 0 tn_4092))
(assert (or (= tn_4092 resn_4116) (and (= resn_4116 (+ 1 tn_4092)) (not (= resb_4117 1)))))
(assert (= n resn_4116))
(assert (= n_4153 n1_3779))
(assert (= (+ v_int_69_4487 n_4153) n))
(assert (<= n_4611 n_4500))
(assert (<= 0 n_4611))
(assert (<= 0 n))
(assert (= n_4611 n))
(assert (<= 0 n_4500))
(assert (<= 0 n_4153))
(assert (= n_4500 n_4153))
(assert (= v_int_79_6049 (+ 1 n_4500)))
(assert (= n1_6056 n_4500))
(assert (= n2_6060 n_4611))
(assert (exists ((max_63 Int)) (and (= v_int_79_6049 (+ 1 max_63)) (or (and (= max_63 n1_6056) (>= n1_6056 n2_6060)) (and (= max_63 n2_6060) (< n1_6056 n2_6060))))))
(assert (exists ((flted_44_6050 Int)) (= (+ flted_44_6050 n2_6060) (+ 1 n1_6056))))
(assert (or (and (= v_int_79_6049 (+ 1 n1_6056)) (<= n2_6060 n1_6056)) (and (= v_int_79_6049 (+ 1 n2_6060)) (< n1_6056 n2_6060))))
;Negation of Consequence
(assert (not false))
(check-sat)