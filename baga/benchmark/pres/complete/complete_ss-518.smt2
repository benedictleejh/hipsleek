(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_88_1429_primed () Int)
(declare-fun v_bool_83_1430_primed () Int)
(declare-fun nmin () Int)
(declare-fun n () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun t () Int)
(declare-fun nmin1_2688 () Int)
(declare-fun flted_26_2685 () Int)
(declare-fun nmin_2694 () Int)
(declare-fun n_2693 () Int)
(declare-fun nmin2_2690 () Int)
(declare-fun flted_26_2684 () Int)
(declare-fun v_int_95_1372_primed () Int)
(declare-fun r_2689 () Int)
(declare-fun nmin_2733 () Int)
(declare-fun n_2732 () Int)
(declare-fun res () Int)
(declare-fun nmin_2745 () Int)
(declare-fun n_2744 () Int)
(declare-fun t_primed () Int)
(declare-fun nmin_2706 () Int)
(declare-fun n_2705 () Int)
(declare-fun l_2687 () Int)
(declare-fun nmin_2750 () Int)
(declare-fun n_2749 () Int)
(declare-fun v_node2_95_1367_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (not (> v_bool_88_1429_primed 0)))
(assert (<= n_2705 nmin_2694))
(assert (= (+ flted_26_2685 1) n))
(assert (= (+ flted_26_2684 1) n))
(assert (exists ((min_32 Int)) (and (= nmin (+ 1 min_32)) (or (and (= min_32 nmin1_2688) (< nmin1_2688 nmin2_2690)) (and (= min_32 nmin2_2690) (>= nmin1_2688 nmin2_2690))))))
(assert (not (> v_bool_83_1430_primed 0)))
(assert (> t_primed 0))
(assert (= nmin n))
(assert (= v_primed v))
(assert (= t_primed t))
(assert (= n_2693 flted_26_2685))
(assert (= nmin_2694 nmin1_2688))
(assert (<= 0 nmin1_2688))
(assert (<= nmin1_2688 flted_26_2685))
(assert (= n_2705 n_2693))
(assert (= nmin_2706 nmin_2694))
(assert (<= 0 nmin_2694))
(assert (<= nmin_2694 n_2693))
(assert (<= 0 nmin_2706))
(assert (<= nmin_2706 n_2705))
(assert (= n_2732 flted_26_2684))
(assert (= nmin_2733 nmin2_2690))
(assert (<= 0 nmin2_2690))
(assert (<= nmin2_2690 flted_26_2684))
(assert (= v_int_95_1372_primed nmin_2733))
(assert (= v_node2_95_1367_primed r_2689))
(assert (= n_2744 n_2732))
(assert (= nmin_2745 nmin_2733))
(assert (<= 0 nmin_2733))
(assert (<= nmin_2733 n_2732))
(assert (= res n_2744))
(assert (= n_2749 n_2744))
(assert (= nmin_2750 nmin_2745))
(assert (<= 0 nmin_2745))
(assert (<= nmin_2745 n_2744))
(assert (= t_primed 1))
(assert (or (and (and (<= 1 nmin_2706) (<= nmin_2706 n_2705)) (> l_2687 0)) (or (and (and (< l_2687 1) (= n_2705 0)) (= nmin_2706 0)) (and (and (<= 1 nmin_2706) (< nmin_2706 n_2705)) (> l_2687 0)))))
(assert (or (and (and (<= 1 nmin_2750) (<= nmin_2750 n_2749)) (> v_node2_95_1367_primed 0)) (or (and (and (< v_node2_95_1367_primed 1) (= n_2749 0)) (= nmin_2750 0)) (and (and (<= 1 nmin_2750) (< nmin_2750 n_2749)) (> v_node2_95_1367_primed 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)