(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun right_50_2087_primed () Int)
(declare-fun left_50_2086_primed () Int)
(declare-fun height_50_2085_primed () Int)
(declare-fun ele_50_2084_primed () Int)
(declare-fun Anon_3776 () Int)
(declare-fun t () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun t_primed () Int)
(declare-fun v_bool_48_2249_primed () Int)
(declare-fun n_3775 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun tm () Int)
(declare-fun n1_3779 () Int)
(declare-fun Anon_3780 () Int)
(declare-fun m1_3778 () Int)
(declare-fun p_3777 () Int)
(declare-fun n2_3783 () Int)
(declare-fun Anon_3784 () Int)
(declare-fun m2_3782 () Int)
(declare-fun q_3781 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_50_2087_primed q_3781))
(assert (= left_50_2086_primed p_3777))
(assert (= height_50_2085_primed n_3775))
(assert (= ele_50_2084_primed Anon_3776))
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
(assert (or (and (and (and (< p_3777 1) (= m1_3778 0)) (= n1_3779 0)) (= Anon_3780 1)) (and (and (and (and (and (<= 0 Anon_3780) (<= (+ (- 0 n1_3779) 2) Anon_3780)) (<= Anon_3780 n1_3779)) (<= Anon_3780 2)) (<= 1 m1_3778)) (> p_3777 0))))
(assert (or (and (and (and (< q_3781 1) (= m2_3782 0)) (= n2_3783 0)) (= Anon_3784 1)) (and (and (and (and (and (<= 0 Anon_3784) (<= (+ (- 0 n2_3783) 2) Anon_3784)) (<= Anon_3784 n2_3783)) (<= Anon_3784 2)) (<= 1 m2_3782)) (> q_3781 0))))
;Negation of Consequence
(assert (not false))
(check-sat)