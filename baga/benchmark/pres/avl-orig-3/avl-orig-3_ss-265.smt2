(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun b_3799 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun tn_3798 () Int)
(declare-fun tm_3797 () Int)
(declare-fun v_node_52_2099_primed () Int)
(declare-fun p_3777 () Int)
(declare-fun t () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun v_bool_48_2249_primed () Int)
(declare-fun n_3775 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n1_3779 () Int)
(declare-fun tm () Int)
(declare-fun m1_3778 () Int)
(declare-fun x_primed () Int)
(declare-fun Anon_3776 () Int)
(declare-fun v_bool_50_2248_primed () Int)
(declare-fun t_primed () Int)
(declare-fun n2_3783 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun m2_3782 () Int)
(declare-fun q_3781 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= b_3799 Anon_3780))
(assert (= tn_3798 n1_3779))
(assert (= tm_3797 m1_3778))
(assert (= v_node_52_2099_primed p_3777))
(assert (= t_primed t))
(assert (= x_primed x))
(assert (< tmp_primed 1))
(assert (> t_primed 0))
(assert (not (> v_bool_48_2249_primed 0)))
(assert (= n_3775 tn))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (exists ((max_63 Int)) (and (= tn (+ 1 max_63)) (or (and (= max_63 n1_3779) (>= n1_3779 n2_3783)) (and (= max_63 n2_3783) (< n1_3779 n2_3783))))))
(assert (= tm (+ (+ m2_3782 1) m1_3778)))
(assert (< x_primed Anon_3776))
(assert (> v_bool_50_2248_primed 0))
(assert (= t_primed 1))
(assert (or (and (and (and (< q_3781 1) (= m2_3782 0)) (= n2_3783 0)) (= Anon_3784 1)) (and (and (and (and (and (<= 0 Anon_3784) (<= (+ (- 0 n2_3783) 2) Anon_3784)) (<= Anon_3784 n2_3783)) (<= Anon_3784 2)) (<= 1 m2_3782)) (> q_3781 0))))
;Negation of Consequence
(assert (not false))
(check-sat)