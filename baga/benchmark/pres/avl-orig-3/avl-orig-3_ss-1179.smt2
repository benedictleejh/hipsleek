(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun tm_4091 () Int)
(declare-fun tm () Int)
(declare-fun m2_3782 () Int)
(declare-fun m1_3778 () Int)
(declare-fun m_4152 () Int)
(declare-fun p_6419 () Int)
(declare-fun m_4499 () Int)
(declare-fun p_3777 () Int)
(declare-fun flted_44_4119 () Int)
(declare-fun n1_6421 () Int)
(declare-fun v_int_79_6414 () Int)
(declare-fun n2_6425 () Int)
(declare-fun n_4611 () Int)
(declare-fun n_4500 () Int)
(declare-fun v_int_69_4489 () Int)
(declare-fun n () Int)
(declare-fun tn_4092 () Int)
(declare-fun n_4153 () Int)
(declare-fun height_79_4754 () Int)
(declare-fun n_3775 () Int)
(declare-fun tn () Int)
(declare-fun n2_3783 () Int)
(declare-fun n1_3779 () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 tm_4091))
(assert (= tm_4091 0))
(assert (= tm_4091 m2_3782))
(assert (<= 0 m2_3782))
(assert (= n1_6421 0))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (<= 0 m1_3778))
(assert (= m_4152 m1_3778))
(assert (< p_3777 1))
(assert (= m_4499 0))
(assert (= n_4500 0))
(assert (<= 0 n))
(assert (<= 0 m_4499))
(assert (<= 0 m_4152))
(assert (= m_4499 m_4152))
(assert (<= 0 flted_44_4119))
(assert (= p_6419 p_3777))
(assert (or (= m_4499 0) (or (= n_4500 0) (< p_3777 1))))
(assert (not (= v_int_69_4489 2)))
(assert (= flted_44_4119 1))
(assert (= n flted_44_4119))
(assert (exists ((flted_44_6415 Int)) (= (+ flted_44_6415 n2_6425) (+ 1 n1_6421))))
(assert (exists ((max_63 Int)) (and (= v_int_79_6414 (+ 1 max_63)) (or (and (= max_63 n1_6421) (>= n1_6421 n2_6425)) (and (= max_63 n2_6425) (< n1_6421 n2_6425))))))
(assert (= v_int_79_6414 (+ 1 n_4611)))
(assert (= n2_6425 n_4611))
(assert (< n_4500 n_4611))
(assert (<= 0 n_4611))
(assert (= n_4611 n))
(assert (<= 0 n_4500))
(assert (= n_4500 n_4153))
(assert (= (+ v_int_69_4489 n_4153) n))
(assert (<= 0 n_4153))
(assert (<= 0 tn_4092))
(assert (= tn_4092 0))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tn_4092 n2_3783))
(assert (<= 0 n2_3783))
(assert (= n_4153 n1_3779))
(assert (<= 0 n1_3779))
(assert (= height_79_4754 n_3775))
(assert (= n_3775 tn))
(assert (exists ((max_63 Int)) (and (= tn (+ 1 max_63)) (or (and (= max_63 n1_3779) (>= n1_3779 n2_3783)) (and (= max_63 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= b 2))
(assert (<= 0 b))
;Negation of Consequence
(assert (not false))
(check-sat)