(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun Anon_22 () Int)
(declare-fun Anon_19 () Int)
(declare-fun n_3750 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n2_3758 () Int)
(declare-fun n1_3754 () Int)
(declare-fun tn_3773 () Int)
(declare-fun resn_3797 () Int)
(declare-fun resb_3798 () Int)
(declare-fun n_3834 () Int)
(declare-fun n_3913 () Int)
(declare-fun b_3814 () Int)
(declare-fun n () Int)
(declare-fun Anon_25 () Int)
(declare-fun Anon_3922 () Int)
(declare-fun n2_3921 () Int)
(declare-fun n1_3917 () Int)
(declare-fun n_3926 () Int)
(declare-fun n_4020 () Int)
(declare-fun b_3946 () Int)
(declare-fun n_3945 () Int)
(declare-fun n1_4024 () Int)
(declare-fun n2_4028 () Int)
(declare-fun height_118_4735 () Int)
(declare-fun cn () Int)
(declare-fun dn () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun h_4435 () Int)
(declare-fun t_4436 () Int)
(declare-fun t1_4438 () Int)
(declare-fun t2_4440 () Int)
(declare-fun h2_4439 () Int)
(declare-fun h1_4437 () Int)
(declare-fun n_4487 () Int)
(declare-fun n_4598 () Int)
(declare-fun v_int_118_5138 () Int)
(declare-fun n2_5149 () Int)
(declare-fun n1_5145 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= Anon_22 n_3913))
(assert (<= resb_3798 2))
(assert (<= 0 resb_3798))
(assert (<= 0 resn_3797))
(assert (<= 0 tn_3773))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (= Anon_19 n_3750))
(assert (= n_3750 tn))
(assert (exists ((max_79 Int)) (and (= tn (+ max_79 1)) (or (and (= max_79 n1_3754) (>= n1_3754 n2_3758)) (and (= max_79 n2_3758) (< n1_3754 n2_3758))))))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (<= 0 n2_3758))
(assert (= n_3834 n2_3758))
(assert (<= 0 n1_3754))
(assert (= tn_3773 n1_3754))
(assert (<= 0 n_3834))
(assert (< 0 tn_3773))
(assert (or (= tn_3773 resn_3797) (and (= resn_3797 (+ 1 tn_3773)) (not (= resb_3798 1)))))
(assert (= n resn_3797))
(assert (= b_3814 resb_3798))
(assert (<= 0 n))
(assert (<= 0 b_3814))
(assert (<= b_3814 2))
(assert (= (+ 2 n_3834) n))
(assert (= dn n_3834))
(assert (= n_3913 n))
(assert (= (+ b_3814 n2_3921) (+ 1 n1_3917)))
(assert (<= n1_3917 (+ 1 n2_3921)))
(assert (<= (+ 0 n2_3921) (+ n1_3917 1)))
(assert (exists ((max_79 Int)) (and (= n (+ max_79 1)) (or (and (= max_79 n1_3917) (>= n1_3917 n2_3921)) (and (= max_79 n2_3921) (< n1_3917 n2_3921))))))
(assert (<= 0 n_3926))
(assert (<= 0 n1_4024))
(assert (<= 0 n2_4028))
(assert (= Anon_25 n_4020))
(assert (= an n_3926))
(assert (<= b_3946 2))
(assert (<= 0 b_3946))
(assert (<= 0 n_3945))
(assert (<= Anon_3922 2))
(assert (<= 0 Anon_3922))
(assert (<= 0 n2_3921))
(assert (= b_3946 Anon_3922))
(assert (= n_3945 n2_3921))
(assert (<= 0 n1_3917))
(assert (= n_3926 n1_3917))
(assert (<= n_3926 n_3945))
(assert (= n_4020 n_3945))
(assert (= (+ b_3946 n2_4028) (+ 1 n1_4024)))
(assert (<= n1_4024 (+ 1 n2_4028)))
(assert (<= (+ 0 n2_4028) (+ n1_4024 1)))
(assert (exists ((max_79 Int)) (and (= n_3945 (+ max_79 1)) (or (and (= max_79 n1_4024) (>= n1_4024 n2_4028)) (and (= max_79 n2_4028) (< n1_4024 n2_4028))))))
(assert (= bn n1_4024))
(assert (= cn n2_4028))
(assert (= height_118_4735 h_4435))
(assert (<= 0 cn))
(assert (<= 0 bn))
(assert (<= 0 an))
(assert (<= 0 dn))
(assert (or (and (= t2_4440 cn) (>= cn dn)) (and (= t2_4440 dn) (< cn dn))))
(assert (or (and (= t1_4438 an) (>= an bn)) (and (= t1_4438 bn) (< an bn))))
(assert (= h_4435 (+ t_4436 1)))
(assert (or (and (= t_4436 h1_4437) (>= h1_4437 h2_4439)) (and (= t_4436 h2_4439) (< h1_4437 h2_4439))))
(assert (= h1_4437 (+ t1_4438 1)))
(assert (= h2_4439 (+ t2_4440 1)))
(assert (<= n_4598 n_4487))
(assert (<= 0 n_4598))
(assert (<= 0 h2_4439))
(assert (= n_4598 h2_4439))
(assert (<= 0 n_4487))
(assert (<= 0 h1_4437))
(assert (= n_4487 h1_4437))
(assert (= v_int_118_5138 (+ 1 n_4487)))
(assert (= n1_5145 n_4487))
(assert (= n2_5149 n_4598))
(assert (exists ((max_79 Int)) (and (= v_int_118_5138 (+ max_79 1)) (or (and (= max_79 n1_5145) (>= n1_5145 n2_5149)) (and (= max_79 n2_5149) (< n1_5145 n2_5149))))))
(assert (exists ((flted_76_5139 Int)) (= (+ flted_76_5139 n2_5149) (+ 1 n1_5145))))
(assert (= (+ n2_5149 1) (+ n1_5145 1)))
;Negation of Consequence
(assert (not false))
(check-sat)