(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height_79_4755 () Int)
(declare-fun tn_4092 () Int)
(declare-fun n_3775 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n2_3783 () Int)
(declare-fun flted_44_4119 () Int)
(declare-fun n1_3779 () Int)
(declare-fun v_int_69_4489 () Int)
(declare-fun n_4153 () Int)
(declare-fun n () Int)
(declare-fun v_int_79_6287 () Int)
(declare-fun n_4500 () Int)
(declare-fun n_4611 () Int)
(declare-fun n2_6298 () Int)
(declare-fun n1_6294 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= height_79_4755 n_3775))
(assert (<= 0 n))
(assert (<= 0 n_4153))
(assert (<= 0 n1_3779))
(assert (<= 0 flted_44_4119))
(assert (<= 0 tn_4092))
(assert (= tn_4092 0))
(assert (<= 0 n2_3783))
(assert (= tn_4092 n2_3783))
(assert (= n_3775 tn))
(assert (<= 0 n_4500))
(assert (<= 0 n_4611))
(assert (not (= v_int_69_4489 2)))
(assert (exists ((max_6312 Int)) (and (= tn (+ 1 max_6312)) (or (and (= max_6312 n1_3779) (>= n1_3779 n2_3783)) (and (= max_6312 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= flted_44_4119 1))
(assert (= n flted_44_4119))
(assert (= n_4153 n1_3779))
(assert (= (+ v_int_69_4489 n_4153) n))
(assert (= n_4500 n_4153))
(assert (= n_4611 n))
(assert (<= n_4611 n_4500))
(assert (= v_int_79_6287 (+ 1 n_4500)))
(assert (= n1_6294 n_4500))
(assert (= n2_6298 n_4611))
;Negation of Consequence
(assert (not (<= n2_6298 (+ n1_6294 1))))
(check-sat)