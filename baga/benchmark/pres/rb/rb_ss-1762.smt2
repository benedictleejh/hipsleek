(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun right_276_3679_primed () Int)
(declare-fun left_276_3678_primed () Int)
(declare-fun color_276_3677_primed () Int)
(declare-fun val_276_3676_primed () Int)
(declare-fun v_11743 () Int)
(declare-fun c_primed () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun a_primed () Int)
(declare-fun flted_262_11753 () Int)
(declare-fun nb () Int)
(declare-fun flted_262_11754 () Int)
(declare-fun flted_13_11742 () Int)
(declare-fun nl_11745 () Int)
(declare-fun bhl_11747 () Int)
(declare-fun Anon_11746 () Int)
(declare-fun v_bool_268_3692_primed () Int)
(declare-fun flted_262_11756 () Int)
(declare-fun flted_262_11755 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun Anon_11750 () Int)
(declare-fun bhr_11751 () Int)
(declare-fun nr_11749 () Int)
(declare-fun r_11748 () Int)
(declare-fun flted_262_11752 () Int)
(declare-fun h () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun cl () Int)
(declare-fun bh () Int)
(declare-fun n () Int)
(declare-fun l_11744 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= right_276_3679_primed r_11748))
(assert (= left_276_3678_primed l_11744))
(assert (= color_276_3677_primed flted_13_11742))
(assert (= val_276_3676_primed v_11743))
(assert (> b 0))
(assert (= flted_262_11752 0))
(assert (= flted_262_11753 (+ 1 h)))
(assert (= flted_262_11755 (+ 1 h)))
(assert (= flted_262_11756 0))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= flted_262_11753 (+ bhl_11747 1)))
(assert (= bhl_11747 bhr_11751))
(assert (= nb (+ (+ nr_11749 1) nl_11745)))
(assert (= flted_262_11754 0))
(assert (= flted_13_11742 0))
(assert (= n nl_11745))
(assert (= cl Anon_11746))
(assert (= bh bhl_11747))
(assert (<= 0 nl_11745))
(assert (<= 1 bhl_11747))
(assert (<= 0 Anon_11746))
(assert (<= Anon_11746 1))
(assert (= cl 1))
(assert (<= 0 n))
(assert (<= 1 bh))
(assert (<= 0 cl))
(assert (<= cl 1))
(assert (not (> v_bool_268_3692_primed 0)))
(assert (or (and (and (and (= flted_262_11756 0) (<= 2 flted_262_11755)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= flted_262_11755 1)) (= flted_262_11756 0)) (and (and (and (= flted_262_11756 1) (<= 1 flted_262_11755)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= Anon_11750 0) (<= 2 bhr_11751)) (<= 1 nr_11749)) (> r_11748 0)) (or (and (and (and (< r_11748 1) (= nr_11749 0)) (= bhr_11751 1)) (= Anon_11750 0)) (and (and (and (= Anon_11750 1) (<= 1 bhr_11751)) (<= 1 nr_11749)) (> r_11748 0)))))
(assert (or (and (and (and (= flted_262_11752 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_262_11752 0)) (and (and (and (= flted_262_11752 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= cl 0) (<= 2 bh)) (<= 1 n)) (> l_11744 0)) (or (and (and (and (< l_11744 1) (= n 0)) (= bh 1)) (= cl 0)) (and (and (and (= cl 1) (<= 1 bh)) (<= 1 n)) (> l_11744 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)