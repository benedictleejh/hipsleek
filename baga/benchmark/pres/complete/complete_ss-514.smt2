(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_95_1363_primed () Int)
(declare-fun left_95_1362_primed () Int)
(declare-fun val_95_1361_primed () Int)
(declare-fun Anon_2686 () Int)
(declare-fun v_int_95_1372_primed () Int)
(declare-fun n_2693 () Int)
(declare-fun t () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun t_primed () Int)
(declare-fun v_bool_83_1430_primed () Int)
(declare-fun nmin () Int)
(declare-fun nmin1_2688 () Int)
(declare-fun nmin2_2690 () Int)
(declare-fun flted_26_2684 () Int)
(declare-fun flted_26_2685 () Int)
(declare-fun n () Int)
(declare-fun nmin_2694 () Int)
(declare-fun v_bool_88_1429_primed () Int)
(declare-fun nmin_2706 () Int)
(declare-fun n_2705 () Int)
(declare-fun l_2687 () Int)
(declare-fun nmin_2733 () Int)
(declare-fun n_2732 () Int)
(declare-fun r_2689 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_95_1363_primed r_2689))
(assert (= left_95_1362_primed l_2687))
(assert (= val_95_1361_primed Anon_2686))
(assert (<= nmin_2733 n_2732))
(assert (<= 0 nmin_2733))
(assert (= v_int_95_1372_primed nmin_2733))
(assert (<= nmin2_2690 flted_26_2684))
(assert (<= 0 nmin2_2690))
(assert (= nmin_2733 nmin2_2690))
(assert (= n_2732 flted_26_2684))
(assert (<= nmin_2706 n_2705))
(assert (<= 0 nmin_2706))
(assert (<= nmin_2694 n_2693))
(assert (<= 0 nmin_2694))
(assert (= nmin_2706 nmin_2694))
(assert (= n_2705 n_2693))
(assert (<= nmin1_2688 flted_26_2685))
(assert (<= 0 nmin1_2688))
(assert (= nmin_2694 nmin1_2688))
(assert (= n_2693 flted_26_2685))
(assert (= t_primed t))
(assert (= v_primed v))
(assert (= nmin n))
(assert (> t_primed 0))
(assert (not (> v_bool_83_1430_primed 0)))
(assert (exists ((min_32 Int)) (and (= nmin (+ 1 min_32)) (or (and (= min_32 nmin1_2688) (< nmin1_2688 nmin2_2690)) (and (= min_32 nmin2_2690) (>= nmin1_2688 nmin2_2690))))))
(assert (= (+ flted_26_2684 1) n))
(assert (= (+ flted_26_2685 1) n))
(assert (<= n_2705 nmin_2694))
(assert (not (> v_bool_88_1429_primed 0)))
(assert (or (and (and (<= 1 nmin_2706) (<= nmin_2706 n_2705)) (> l_2687 0)) (or (and (and (< l_2687 1) (= n_2705 0)) (= nmin_2706 0)) (and (and (<= 1 nmin_2706) (< nmin_2706 n_2705)) (> l_2687 0)))))
(assert (or (and (and (<= 1 nmin_2733) (<= nmin_2733 n_2732)) (> r_2689 0)) (or (and (and (< r_2689 1) (= n_2732 0)) (= nmin_2733 0)) (and (and (<= 1 nmin_2733) (< nmin_2733 n_2732)) (> r_2689 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)