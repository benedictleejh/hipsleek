(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v () Int)
(declare-fun mx1_2891 () Int)
(declare-fun mx2_2852 () Int)
(declare-fun mx1_2849 () Int)
(declare-fun d_2846 () Int)
(declare-fun v_int_161_2839 () Int)
(declare-fun max2_2836 () Int)
(declare-fun max1_2835 () Int)
(declare-fun v_primed () Int)
(declare-fun mx4_2838 () Int)
(declare-fun mx3_2837 () Int)
(declare-fun mx2_2579 () Int)
(declare-fun mx1_2578 () Int)
(declare-fun d_primed () Int)
(declare-fun d_2557 () Int)
(declare-fun d () Int)
(declare-fun mx1 () Int)
(declare-fun mx2_2487 () Int)
(declare-fun mx1_2484 () Int)
(declare-fun mx2 () Int)
(declare-fun mx1_2531 () Int)
(declare-fun d_2481 () Int)
(declare-fun d_2528 () Int)
(declare-fun mx2_2534 () Int)
(declare-fun mx2_2894 () Int)
(declare-fun d_2888 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< v_primed d_2481))
(assert (<= v d))
(assert (<= 0 v))
(assert (= v_primed v))
(assert (<= 0 mx3_2837))
(assert (<= 0 mx4_2838))
(assert (<= 0 mx1_2531))
(assert (<= 0 mx2_2534))
(assert (= mx1_2891 mx1_2531))
(assert (exists ((mx3_2927 Int)) (<= d_2846 mx3_2927)))
(assert (= mx2_2852 mx4_2838))
(assert (= mx1_2849 mx3_2837))
(assert (= d_2846 d_2481))
(assert (<= 0 mx2_2579))
(assert (<= 0 mx1_2578))
(assert (<= 0 v_int_161_2839))
(assert (<= mx4_2838 v_int_161_2839))
(assert (<= mx3_2837 v_int_161_2839))
(assert (<= v_int_161_2839 max2_2836))
(assert (or (and (= max2_2836 mx2_2579) (>= mx2_2579 max1_2835)) (and (= max2_2836 max1_2835) (< mx2_2579 max1_2835))))
(assert (or (and (= max1_2835 mx1_2578) (>= mx1_2578 v_primed)) (and (= max1_2835 v_primed) (< mx1_2578 v_primed))))
(assert (<= mx4_2838 mx2_2579))
(assert (<= mx3_2837 mx1_2578))
(assert (<= 0 mx1_2484))
(assert (<= 0 mx2_2487))
(assert (= mx2_2579 mx2_2487))
(assert (= mx1_2578 mx1_2484))
(assert (= d_primed d_2481))
(assert (= d_2557 d))
(assert (<= mx1 d))
(assert (<= mx2 d))
(assert (<= d_2481 mx1))
(assert (<= mx2_2487 d_2481))
(assert (<= mx1_2484 d_2481))
(assert (<= 0 d_2481))
(assert (<= d_2528 mx2))
(assert (<= mx2_2534 d_2528))
(assert (<= mx1_2531 d_2528))
(assert (<= 0 d_2528))
(assert (<= d_2528 d_2481))
(assert (= d_2888 d_2528))
(assert (= mx2_2894 mx2_2534))
;Negation of Consequence
(assert (not (<= mx2_2894 d_2888)))
(check-sat)