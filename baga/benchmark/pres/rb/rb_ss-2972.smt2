(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_bool_539_2199_primed () Int)
(declare-fun v_16660 () Int)
(declare-fun Anon_22 () Int)
(declare-fun n () Int)
(declare-fun bh () Int)
(declare-fun v_bool_534_2200_primed () Int)
(declare-fun tmp_null_primed () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun x () Int)
(declare-fun tmp_primed () Int)
(declare-fun nl_16662 () Int)
(declare-fun bhl_16663 () Int)
(declare-fun flted_12_16658 () Int)
(declare-fun n_16695 () Int)
(declare-fun bh_16697 () Int)
(declare-fun Anon_16696 () Int)
(declare-fun left_542_16725 () Int)
(declare-fun l_16661 () Int)
(declare-fun flted_12_16659 () Int)
(declare-fun v_int_545_1787_primed () Int)
(declare-fun v_int_545_1786_primed () Int)
(declare-fun flted_12_16657 () Int)
(declare-fun bhr_16666 () Int)
(declare-fun nr_16665 () Int)
(declare-fun r_16664 () Int)
(declare-fun Anon_16719 () Int)
(declare-fun bh1_16720 () Int)
(declare-fun flted_529_16718 () Int)
(declare-fun v_node_542_16730 () Int)
(declare-fun x_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_bool_539_2199_primed 0))
(assert (<= v_primed v_16660))
(assert (= flted_12_16659 1))
(assert (= flted_12_16658 0))
(assert (= flted_12_16657 0))
(assert (= Anon_22 1))
(assert (= n (+ (+ nr_16665 1) nl_16662)))
(assert (= bhl_16663 bh))
(assert (= bhr_16666 bh))
(assert (not (> v_bool_534_2200_primed 0)))
(assert (> x_primed 0))
(assert (< tmp_null_primed 1))
(assert (= v_primed v))
(assert (= x_primed x))
(assert (= tmp_primed l_16661))
(assert (= n_16695 nl_16662))
(assert (= Anon_16696 flted_12_16658))
(assert (= bh_16697 bhl_16663))
(assert (<= 0 nl_16662))
(assert (<= 1 bhl_16663))
(assert (<= 0 flted_12_16658))
(assert (<= flted_12_16658 1))
(assert (= flted_529_16718 (+ 1 n_16695)))
(assert (> v_node_542_16730 0))
(assert (<= bh_16697 bh1_16720))
(assert (<= bh1_16720 bh_16697))
(assert (<= 0 n_16695))
(assert (<= 1 bh_16697))
(assert (<= 0 Anon_16696))
(assert (<= Anon_16696 1))
(assert (= left_542_16725 l_16661))
(assert (= v_int_545_1787_primed flted_12_16659))
(assert (= v_int_545_1786_primed 0))
(assert (not (= v_int_545_1787_primed v_int_545_1786_primed)))
(assert (or (and (and (and (= flted_12_16657 0) (<= 2 bhr_16666)) (<= 1 nr_16665)) (> r_16664 0)) (or (and (and (and (< r_16664 1) (= nr_16665 0)) (= bhr_16666 1)) (= flted_12_16657 0)) (and (and (and (= flted_12_16657 1) (<= 1 bhr_16666)) (<= 1 nr_16665)) (> r_16664 0)))))
(assert (or (and (and (and (= Anon_16719 0) (<= 2 bh1_16720)) (<= 1 flted_529_16718)) (> v_node_542_16730 0)) (or (and (and (and (< v_node_542_16730 1) (= flted_529_16718 0)) (= bh1_16720 1)) (= Anon_16719 0)) (and (and (and (= Anon_16719 1) (<= 1 bh1_16720)) (<= 1 flted_529_16718)) (> v_node_542_16730 0)))))
(assert (= x_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)