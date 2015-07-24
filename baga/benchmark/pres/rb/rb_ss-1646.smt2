(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun c_primed () Int)
(declare-fun a_primed () Int)
(declare-fun nd () Int)
(declare-fun flted_262_11752 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_262_11756 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_262_11755 () Int)
(declare-fun h () Int)
(declare-fun flted_262_11753 () Int)
(declare-fun Anon_11746 () Int)
(declare-fun v_node_273_3674_primed () Int)
(declare-fun v_node_273_3672_primed () Int)
(declare-fun cl () Int)
(declare-fun l_11744 () Int)
(declare-fun flted_12_11891 () Int)
(declare-fun r_11898 () Int)
(declare-fun nc_11914 () Int)
(declare-fun nb_11913 () Int)
(declare-fun na_11912 () Int)
(declare-fun v_node_273_3673_primed () Int)
(declare-fun n () Int)
(declare-fun nb () Int)
(declare-fun nl_11745 () Int)
(declare-fun bhl_11747 () Int)
(declare-fun nr_11749 () Int)
(declare-fun bhr_11751 () Int)
(declare-fun bhr_11900 () Int)
(declare-fun n_11773 () Int)
(declare-fun nr_11899 () Int)
(declare-fun bh_11775 () Int)
(declare-fun bh () Int)
(declare-fun flted_12_11892 () Int)
(declare-fun nl_11896 () Int)
(declare-fun l_11895 () Int)
(declare-fun bhl_11897 () Int)
(declare-fun h_11915 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_262_11752 0))
(assert (= flted_262_11756 0))
(assert (= c_primed c))
(assert (= a_primed a))
(assert (= nd nc))
(assert (or (and (and (and (= flted_262_11752 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_262_11752 0)) (and (and (and (= flted_262_11752 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_262_11756 0) (<= 2 flted_262_11755)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= flted_262_11755 1)) (= flted_262_11756 0)) (and (and (and (= flted_262_11756 1) (<= 1 flted_262_11755)) (<= 1 na)) (> a 0)))))
(assert (<= Anon_11746 1))
(assert (<= 0 Anon_11746))
(assert (= flted_262_11755 (+ 1 h)))
(assert (= flted_12_11891 0))
(assert (<= 1 bhr_11751))
(assert (<= 0 nr_11749))
(assert (= flted_262_11753 (+ 1 h)))
(assert (= flted_262_11753 (+ bhl_11747 1)))
(assert (= cl Anon_11746))
(assert (= cl 0))
(assert (<= 0 cl))
(assert (<= cl 1))
(assert (= v_node_273_3674_primed l_11744))
(assert (= v_node_273_3672_primed r_11898))
(assert (or (and (and (and (= cl 0) (<= 2 bh)) (<= 1 n)) (> l_11744 0)) (or (and (and (and (< l_11744 1) (= n 0)) (= bh 1)) (= cl 0)) (and (and (and (= cl 1) (<= 1 bh)) (<= 1 n)) (> l_11744 0)))))
(assert (or (and (and (and (= flted_12_11891 0) (<= 2 bhr_11900)) (<= 1 nr_11899)) (> r_11898 0)) (or (and (and (and (< r_11898 1) (= nr_11899 0)) (= bhr_11900 1)) (= flted_12_11891 0)) (and (and (and (= flted_12_11891 1) (<= 1 bhr_11900)) (<= 1 nr_11899)) (> r_11898 0)))))
(assert (= nc_11914 nr_11899))
(assert (= nb_11913 nl_11896))
(assert (= na_11912 n))
(assert (= v_node_273_3673_primed l_11895))
(assert (<= 1 bh))
(assert (<= 0 n))
(assert (<= 1 bhl_11747))
(assert (<= 0 nl_11745))
(assert (= bh bhl_11747))
(assert (= n nl_11745))
(assert (= nb (+ (+ nr_11749 1) nl_11745)))
(assert (= bhl_11747 bhr_11751))
(assert (= n_11773 nr_11749))
(assert (= bh_11775 bhr_11751))
(assert (<= 0 n_11773))
(assert (<= 1 bh_11775))
(assert (= bhr_11900 bh_11775))
(assert (= n_11773 (+ (+ nr_11899 1) nl_11896)))
(assert (= flted_12_11892 0))
(assert (= bhl_11897 bh_11775))
(assert (= h_11915 bh))
(assert (or (and (and (and (= flted_12_11892 0) (<= 2 bhl_11897)) (<= 1 nl_11896)) (> l_11895 0)) (or (and (and (and (< l_11895 1) (= nl_11896 0)) (= bhl_11897 1)) (= flted_12_11892 0)) (and (and (and (= flted_12_11892 1) (<= 1 bhl_11897)) (<= 1 nl_11896)) (> l_11895 0)))))
;Negation of Consequence
(assert (not (= bhl_11897 h_11915)))
(check-sat)