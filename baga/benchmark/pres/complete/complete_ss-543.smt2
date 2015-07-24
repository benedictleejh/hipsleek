(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n () Int)
(declare-fun nmin () Int)
(declare-fun flted_26_2684 () Int)
(declare-fun nmin2_2690 () Int)
(declare-fun n_2732 () Int)
(declare-fun nmin_2733 () Int)
(declare-fun tmp_primed () Int)
(declare-fun r_2689 () Int)
(declare-fun nmin_2788 () Int)
(declare-fun nmin_2745 () Int)
(declare-fun n_2744 () Int)
(declare-fun n_2693 () Int)
(declare-fun flted_26_2685 () Int)
(declare-fun nmin1_2688 () Int)
(declare-fun nmin_2694 () Int)
(declare-fun n_2705 () Int)
(declare-fun nmin_2706 () Int)
(declare-fun n_2787 () Int)
(declare-fun aux_primed () Int)
(declare-fun n_2775 () Int)
(declare-fun nmin_2776 () Int)
(declare-fun l_2687 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= nmin_2733 n_2732))
(assert (<= 0 nmin_2733))
(assert (<= nmin2_2690 flted_26_2684))
(assert (<= 0 nmin2_2690))
(assert (= nmin n))
(assert (<= n_2744 nmin_2733))
(assert (= (+ flted_26_2685 1) n))
(assert (= (+ flted_26_2684 1) n))
(assert (exists ((min_2812 Int)) (and (= nmin (+ 1 min_2812)) (or (and (= min_2812 nmin1_2688) (< nmin1_2688 nmin2_2690)) (and (= min_2812 nmin2_2690) (>= nmin1_2688 nmin2_2690))))))
(assert (= n_2693 flted_26_2685))
(assert (= n_2732 flted_26_2684))
(assert (= nmin_2733 nmin2_2690))
(assert (= n_2744 n_2732))
(assert (= nmin_2745 nmin_2733))
(assert (= tmp_primed r_2689))
(assert (= nmin_2788 nmin_2745))
(assert (<= 0 nmin_2745))
(assert (<= 0 nmin_2788))
(assert (or (and (and (<= 1 nmin_2788) (<= nmin_2788 n_2787)) (> r_2689 0)) (or (and (and (< r_2689 1) (= n_2787 0)) (= nmin_2788 0)) (and (and (<= 1 nmin_2788) (< nmin_2788 n_2787)) (> r_2689 0)))))
(assert (<= nmin_2788 n_2787))
(assert (<= nmin_2745 n_2744))
(assert (= n_2787 n_2744))
(assert (<= nmin_2706 n_2705))
(assert (<= 0 nmin_2706))
(assert (<= nmin_2694 n_2693))
(assert (<= 0 nmin_2694))
(assert (= nmin_2706 nmin_2694))
(assert (= n_2705 n_2693))
(assert (<= nmin1_2688 flted_26_2685))
(assert (<= 0 nmin1_2688))
(assert (= nmin_2694 nmin1_2688))
(assert (<= n_2705 nmin_2694))
(assert (= n_2775 n_2705))
(assert (= nmin_2776 nmin_2706))
(assert (= n_2787 n_2775))
(assert (<= 0 nmin_2776))
(assert (<= nmin_2776 n_2775))
(assert (= aux_primed l_2687))
(assert (or (and (and (<= 1 nmin_2776) (<= nmin_2776 n_2775)) (> l_2687 0)) (or (and (and (< l_2687 1) (= n_2775 0)) (= nmin_2776 0)) (and (and (<= 1 nmin_2776) (< nmin_2776 n_2775)) (> l_2687 0)))))
;Negation of Consequence
(assert (not (or (= n_2775 0) (or (= nmin_2776 0) (< l_2687 1)))))
(check-sat)