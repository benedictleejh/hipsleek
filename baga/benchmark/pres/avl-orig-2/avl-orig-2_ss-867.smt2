(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n2_5544 () Int)
(declare-fun n1_5540 () Int)
(declare-fun flted_76_3800 () Int)
(declare-fun height_118_4736 () Int)
(declare-fun v_int_118_5533 () Int)
(declare-fun n_4598 () Int)
(declare-fun n_4487 () Int)
(declare-fun v_int_89_4444 () Int)
(declare-fun n () Int)
(declare-fun n_3834 () Int)
(declare-fun tn_3773 () Int)
(declare-fun b () Int)
(declare-fun n1_3754 () Int)
(declare-fun n2_3758 () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 flted_76_3800))
(assert (exists ((flted_76_5575 Int)) (= (+ flted_76_5575 n2_5544) (+ 1 n1_5540))))
(assert (exists ((max_5574 Int)) (and (= v_int_118_5533 (+ max_5574 1)) (or (and (= max_5574 n1_5540) (>= n1_5540 n2_5544)) (and (= max_5574 n2_5544) (< n1_5540 n2_5544))))))
(assert (= n2_5544 n_4598))
(assert (= n1_5540 n_4487))
(assert (not (= v_int_89_4444 2)))
(assert (= flted_76_3800 1))
(assert (= n flted_76_3800))
(assert (<= 0 n_4487))
(assert (<= 0 n_4598))
(assert (= height_118_4736 n_3750))
(assert (= v_int_118_5533 (+ 1 n_4487)))
(assert (<= n_4598 n_4487))
(assert (<= 0 n_3834))
(assert (= n_4598 n_3834))
(assert (<= 0 n))
(assert (= n_4487 n))
(assert (= (+ v_int_89_4444 n_3834) n))
(assert (<= 0 n2_3758))
(assert (= n_3834 n2_3758))
(assert (<= 0 tn_3773))
(assert (= tn_3773 0))
(assert (<= 0 n1_3754))
(assert (= tn_3773 n1_3754))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (exists ((max_5573 Int)) (and (= tn (+ max_5573 1)) (or (and (= max_5573 n1_3754) (>= n1_3754 n2_3758)) (and (= max_5573 n2_3758) (< n1_3754 n2_3758))))))
(assert (= n_3750 tn))
;Negation of Consequence
(assert (not (= tn 0)))
(check-sat)