(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_48 () Int)
(declare-fun Anon_45 () Int)
(declare-fun n_3750 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n1_3754 () Int)
(declare-fun tn_3773 () Int)
(declare-fun resn_3797 () Int)
(declare-fun resb_3798 () Int)
(declare-fun n2_3758 () Int)
(declare-fun n_3913 () Int)
(declare-fun height_118_4734 () Int)
(declare-fun Anon_4957 () Int)
(declare-fun n () Int)
(declare-fun b_3814 () Int)
(declare-fun n1_3917 () Int)
(declare-fun n2_3921 () Int)
(declare-fun n_3926 () Int)
(declare-fun resn_4424 () Int)
(declare-fun tmp2_4425 () Int)
(declare-fun an () Int)
(declare-fun tmp1_4423 () Int)
(declare-fun n_3945 () Int)
(declare-fun n_3834 () Int)
(declare-fun bn () Int)
(declare-fun cn () Int)
(declare-fun resrn_4426 () Int)
(declare-fun b_4599 () Int)
(declare-fun n1_4605 () Int)
(declare-fun n2_4609 () Int)
(declare-fun n_4487 () Int)
(declare-fun n_4598 () Int)
(declare-fun n2_4956 () Int)
(declare-fun n1_4952 () Int)
(declare-fun v_int_118_4945 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_48 n_3913))
(assert (= Anon_45 n_3750))
(assert (<= 0 n2_3758))
(assert (<= resb_3798 2))
(assert (<= 0 resb_3798))
(assert (<= 0 resn_3797))
(assert (<= 0 tn_3773))
(assert (<= 0 n1_3754))
(assert (= n_3750 tn))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (exists ((max_79 Int)) (and (= tn (+ max_79 1)) (or (and (= max_79 n1_3754) (>= n1_3754 n2_3758)) (and (= max_79 n2_3758) (< n1_3754 n2_3758))))))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= tn_3773 n1_3754))
(assert (< 0 tn_3773))
(assert (or (= tn_3773 resn_3797) (and (= resn_3797 (+ 1 tn_3773)) (not (= resb_3798 1)))))
(assert (= n resn_3797))
(assert (= b_3814 resb_3798))
(assert (<= 0 n))
(assert (<= 0 b_3814))
(assert (<= b_3814 2))
(assert (= n_3834 n2_3758))
(assert (= (+ 2 n_3834) n))
(assert (= n_3913 n))
(assert (= height_118_4734 resn_4424))
(assert (<= 0 n_3926))
(assert (<= 0 n2_3921))
(assert (<= 0 n1_3917))
(assert (= Anon_4957 b_4599))
(assert (< n_3945 n_3926))
(assert (exists ((max_79 Int)) (and (= n (+ max_79 1)) (or (and (= max_79 n1_3917) (>= n1_3917 n2_3921)) (and (= max_79 n2_3921) (< n1_3917 n2_3921))))))
(assert (<= (+ 0 n2_3921) (+ n1_3917 1)))
(assert (<= n1_3917 (+ 1 n2_3921)))
(assert (= (+ b_3814 n2_3921) (+ 1 n1_3917)))
(assert (= n_3926 n1_3917))
(assert (= n_3945 n2_3921))
(assert (= an n_3926))
(assert (= resn_4424 (+ 1 tmp2_4425)))
(assert (<= n_4598 n_4487))
(assert (<= b_4599 2))
(assert (<= 0 b_4599))
(assert (<= 0 n_4598))
(assert (<= 0 bn))
(assert (<= 0 cn))
(assert (<= 0 n_4487))
(assert (<= 0 an))
(assert (= n_4487 an))
(assert (or (and (= tmp2_4425 an) (>= an resrn_4426)) (and (= tmp2_4425 resrn_4426) (< an resrn_4426))))
(assert (or (and (= tmp1_4423 cn) (>= cn bn)) (and (= tmp1_4423 bn) (< cn bn))))
(assert (= resrn_4426 (+ 1 tmp1_4423)))
(assert (<= 0 n_3834))
(assert (<= 0 n_3945))
(assert (= bn n_3945))
(assert (= cn n_3834))
(assert (= n1_4605 bn))
(assert (= n2_4609 cn))
(assert (<= n1_4605 (+ 1 n2_4609)))
(assert (<= (+ 0 n2_4609) (+ n1_4605 1)))
(assert (or (and (= resrn_4426 (+ n1_4605 1)) (<= n2_4609 n1_4605)) (and (= resrn_4426 (+ n2_4609 1)) (< n1_4605 n2_4609))))
(assert (= resrn_4426 n_4598))
(assert (= (+ b_4599 n2_4609) (+ 1 n1_4605)))
(assert (exists ((max_79 Int)) (and (= n_4598 (+ max_79 1)) (or (and (= max_79 n1_4605) (>= n1_4605 n2_4609)) (and (= max_79 n2_4609) (< n1_4605 n2_4609))))))
(assert (= v_int_118_4945 (+ 1 n_4487)))
(assert (= n1_4952 n_4487))
(assert (= n2_4956 n_4598))
(assert (exists ((max_79 Int)) (and (= v_int_118_4945 (+ max_79 1)) (or (and (= max_79 n1_4952) (>= n1_4952 n2_4956)) (and (= max_79 n2_4956) (< n1_4952 n2_4956))))))
(assert (exists ((flted_76_4946 Int)) (= (+ flted_76_4946 n2_4956) (+ 1 n1_4952))))
(assert (= v_int_118_4945 1))
;Negation of Consequence
(assert (not false))
(check-sat)