(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_50_2248_primed () Int)
(declare-fun Anon_3776 () Int)
(declare-fun tm () Int)
(declare-fun b () Int)
(declare-fun n_3775 () Int)
(declare-fun tn () Int)
(declare-fun v_bool_48_2249_primed () Int)
(declare-fun tmp_primed () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun t () Int)
(declare-fun p_3777 () Int)
(declare-fun m1_3778 () Int)
(declare-fun n1_3779 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun v_node_52_2099_primed () Int)
(declare-fun tm_3797 () Int)
(declare-fun tn_3798 () Int)
(declare-fun b_3799 () Int)
(declare-fun t_primed () Int)
(declare-fun n2_3783 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun m2_3782 () Int)
(declare-fun q_3781 () Int)
(declare-fun flted_44_3809 () Int)
(declare-fun flted_44_3808 () Int)
(declare-fun flted_44_3810 () Int)
(declare-fun res () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_50_2248_primed 0))
(assert (< x_primed Anon_3776))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (exists ((max_63 Int)) (and (= tn (+ 1 max_63)) (or (and (= max_63 n1_3779) (>= n1_3779 n2_3783)) (and (= max_63 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= n_3775 tn))
(assert (not (> v_bool_48_2249_primed 0)))
(assert (> t_primed 0))
(assert (< tmp_primed 1))
(assert (= x_primed x))
(assert (= t_primed t))
(assert (= v_node_52_2099_primed p_3777))
(assert (= tm_3797 m1_3778))
(assert (= tn_3798 n1_3779))
(assert (= b_3799 Anon_3780))
(assert (<= 0 m1_3778))
(assert (<= 0 n1_3779))
(assert (<= 0 Anon_3780))
(assert (<= Anon_3780 2))
(assert (= flted_44_3810 1))
(assert (= flted_44_3809 1))
(assert (= flted_44_3808 1))
(assert (= tn_3798 0))
(assert (= tm_3797 0))
(assert (< v_node_52_2099_primed 1))
(assert (<= 0 tm_3797))
(assert (<= 0 tn_3798))
(assert (<= 0 b_3799))
(assert (<= b_3799 2))
(assert (= t_primed 1))
(assert (or (and (and (and (< q_3781 1) (= m2_3782 0)) (= n2_3783 0)) (= Anon_3784 1)) (and (and (and (and (and (<= 0 Anon_3784) (<= (+ (- 0 n2_3783) 2) Anon_3784)) (<= Anon_3784 n2_3783)) (<= Anon_3784 2)) (<= 1 m2_3782)) (> q_3781 0))))
(assert (or (and (and (and (< res 1) (= flted_44_3810 0)) (= flted_44_3809 0)) (= flted_44_3808 1)) (and (and (and (and (and (<= 0 flted_44_3808) (<= (+ (- 0 flted_44_3809) 2) flted_44_3808)) (<= flted_44_3808 flted_44_3809)) (<= flted_44_3808 2)) (<= 1 flted_44_3810)) (> res 0))))
;Negation of Consequence
(assert (not false))
(check-sat)