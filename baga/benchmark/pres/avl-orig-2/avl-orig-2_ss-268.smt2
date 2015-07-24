(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_87_2067_primed () Int)
(declare-fun left_87_2066_primed () Int)
(declare-fun height_87_2065_primed () Int)
(declare-fun ele_87_2064_primed () Int)
(declare-fun p_3752 () Int)
(declare-fun b_3774 () Int)
(declare-fun Anon_3755 () Int)
(declare-fun tn_3773 () Int)
(declare-fun tm_3772 () Int)
(declare-fun t () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun t_primed () Int)
(declare-fun v_bool_80_2243_primed () Int)
(declare-fun n_3750 () Int)
(declare-fun b () Int)
(declare-fun tn () Int)
(declare-fun n1_3754 () Int)
(declare-fun tm () Int)
(declare-fun m1_3753 () Int)
(declare-fun x_primed () Int)
(declare-fun Anon_3751 () Int)
(declare-fun v_bool_86_2211_primed () Int)
(declare-fun n2_3758 () Int)
(declare-fun Anon_3759 () Int)
(declare-fun m2_3757 () Int)
(declare-fun q_3756 () Int)
(declare-fun resn_3797 () Int)
(declare-fun resb_3798 () Int)
(declare-fun flted_74_3796 () Int)
(declare-fun v_node_87_2063_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_87_2067_primed q_3756))
(assert (= left_87_2066_primed p_3752))
(assert (= height_87_2065_primed n_3750))
(assert (= ele_87_2064_primed Anon_3751))
(assert (<= b_3774 2))
(assert (<= 0 b_3774))
(assert (<= 0 tn_3773))
(assert (<= 0 tm_3772))
(assert (or (= tn_3773 resn_3797) (and (= resn_3797 (+ 1 tn_3773)) (not (= resb_3798 1)))))
(assert (< 0 tn_3773))
(assert (< 0 tm_3772))
(assert (> p_3752 0))
(assert (= flted_74_3796 (+ 1 tm_3772)))
(assert (<= Anon_3755 2))
(assert (<= 0 Anon_3755))
(assert (<= 0 n1_3754))
(assert (<= 0 m1_3753))
(assert (= b_3774 Anon_3755))
(assert (= tn_3773 n1_3754))
(assert (= tm_3772 m1_3753))
(assert (= t_primed t))
(assert (= x_primed x))
(assert (< tmp_primed 1))
(assert (> t_primed 0))
(assert (not (> v_bool_80_2243_primed 0)))
(assert (= n_3750 tn))
(assert (= (+ b n2_3758) (+ 1 n1_3754)))
(assert (<= n1_3754 (+ 1 n2_3758)))
(assert (<= (+ 0 n2_3758) (+ n1_3754 1)))
(assert (exists ((max_79 Int)) (and (= tn (+ max_79 1)) (or (and (= max_79 n1_3754) (>= n1_3754 n2_3758)) (and (= max_79 n2_3758) (< n1_3754 n2_3758))))))
(assert (= tm (+ (+ m2_3757 1) m1_3753)))
(assert (< x_primed Anon_3751))
(assert (> v_bool_86_2211_primed 0))
(assert (or (and (and (and (< q_3756 1) (= m2_3757 0)) (= n2_3758 0)) (= Anon_3759 1)) (and (and (and (and (and (<= 0 Anon_3759) (<= (+ (- 0 n2_3758) 2) Anon_3759)) (<= Anon_3759 n2_3758)) (<= Anon_3759 2)) (<= 1 m2_3757)) (> q_3756 0))))
(assert (or (and (and (and (< v_node_87_2063_primed 1) (= flted_74_3796 0)) (= resn_3797 0)) (= resb_3798 1)) (and (and (and (and (and (<= 0 resb_3798) (<= (+ (- 0 resn_3797) 2) resb_3798)) (<= resb_3798 resn_3797)) (<= resb_3798 2)) (<= 1 flted_74_3796)) (> v_node_87_2063_primed 0))))
;Negation of Consequence
(assert (not false))
(check-sat)