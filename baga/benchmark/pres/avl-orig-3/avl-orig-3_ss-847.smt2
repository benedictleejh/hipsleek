(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun v_int_79_5544 () Int)
(declare-fun n1_5551 () Int)
(declare-fun n2_5555 () Int)
(declare-fun flted_44_3825 () Int)
(declare-fun height_79_4749 () Int)
(declare-fun n_4611 () Int)
(declare-fun n_4500 () Int)
(declare-fun v_int_54_4460 () Int)
(declare-fun n () Int)
(declare-fun n_3859 () Int)
(declare-fun tn_3798 () Int)
(declare-fun b () Int)
(declare-fun n_3775 () Int)
(declare-fun n1_3779 () Int)
(declare-fun n2_3783 () Int)
(declare-fun tn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((flted_44_5545 Int)) (= (+ flted_44_5545 n2_5555) (+ 1 n1_5551))))
(assert (exists ((max_63 Int)) (and (= v_int_79_5544 (+ 1 max_63)) (or (and (= max_63 n1_5551) (>= n1_5551 n2_5555)) (and (= max_63 n2_5555) (< n1_5551 n2_5555))))))
(assert (= v_int_79_5544 (+ 1 n_4500)))
(assert (= n1_5551 n_4500))
(assert (= n2_5555 n_4611))
(assert (<= 0 flted_44_3825))
(assert (not (= v_int_54_4460 2)))
(assert (= flted_44_3825 1))
(assert (= n flted_44_3825))
(assert (= height_79_4749 n_3775))
(assert (<= n_4611 n_4500))
(assert (<= 0 n_4611))
(assert (<= 0 n_3859))
(assert (= n_4611 n_3859))
(assert (<= 0 n_4500))
(assert (<= 0 n))
(assert (= n_4500 n))
(assert (= (+ v_int_54_4460 n_3859) n))
(assert (<= 0 n2_3783))
(assert (= n_3859 n2_3783))
(assert (<= 0 tn_3798))
(assert (= tn_3798 0))
(assert (<= 0 n1_3779))
(assert (= tn_3798 n1_3779))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (= n_3775 tn))
(assert (exists ((max_63 Int)) (and (= tn (+ 1 max_63)) (or (and (= max_63 n1_3779) (>= n1_3779 n2_3783)) (and (= max_63 n2_3783) (< n1_3779 n2_3783))))))
(assert (<= 0 tn))
;Negation of Consequence
(assert (not false))
(check-sat)