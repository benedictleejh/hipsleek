(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun l_12673 () Int)
(declare-fun a_primed () Int)
(declare-fun nl_12674 () Int)
(declare-fun Anon_12675 () Int)
(declare-fun flted_262_11756 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun bhl_12676 () Int)
(declare-fun flted_262_11755 () Int)
(declare-fun bhl_11897 () Int)
(declare-fun bhr_11900 () Int)
(declare-fun bh_11775 () Int)
(declare-fun n_11773 () Int)
(declare-fun h () Int)
(declare-fun flted_262_11753 () Int)
(declare-fun bhr_11751 () Int)
(declare-fun nb () Int)
(declare-fun nr_11749 () Int)
(declare-fun nl_11745 () Int)
(declare-fun bhl_11747 () Int)
(declare-fun bh () Int)
(declare-fun h_11915 () Int)
(declare-fun nc () Int)
(declare-fun nr_11899 () Int)
(declare-fun nl_11896 () Int)
(declare-fun n () Int)
(declare-fun nc_11914 () Int)
(declare-fun na_11912 () Int)
(declare-fun nb_11913 () Int)
(declare-fun nd () Int)
(declare-fun r_12677 () Int)
(declare-fun flted_171_12654 () Int)
(declare-fun flted_171_12655 () Int)
(declare-fun flted_171_12653 () Int)
(declare-fun tmp_12658 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_262_11756 0))
(assert (= a_primed a))
(assert (= l_12673 a_primed))
(assert (= nl_12674 na))
(assert (= Anon_12675 flted_262_11756))
(assert (or (and (and (and (= flted_262_11756 0) (<= 2 flted_262_11755)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= flted_262_11755 1)) (= flted_262_11756 0)) (and (and (and (= flted_262_11756 1) (<= 1 flted_262_11755)) (<= 1 na)) (> a 0)))))
(assert (= bhl_12676 flted_262_11755))
(assert (<= 1 bh))
(assert (<= 1 bhl_11897))
(assert (<= 1 bhr_11900))
(assert (<= 1 h))
(assert (<= 1 bhl_11747))
(assert (<= 0 nl_11745))
(assert (= flted_262_11755 (+ 1 h)))
(assert (= n_11773 (+ (+ nr_11899 1) nl_11896)))
(assert (= bhl_11897 bh_11775))
(assert (= bhr_11900 bh_11775))
(assert (<= 1 bh_11775))
(assert (<= 0 n_11773))
(assert (<= 1 bhr_11751))
(assert (<= 0 nr_11749))
(assert (= bh_11775 bhr_11751))
(assert (= n_11773 nr_11749))
(assert (= flted_262_11753 (+ 1 h)))
(assert (= flted_262_11753 (+ bhl_11747 1)))
(assert (= bhl_11747 bhr_11751))
(assert (= nb (+ (+ nr_11749 1) nl_11745)))
(assert (= n nl_11745))
(assert (= bh bhl_11747))
(assert (= h_11915 bh))
(assert (or (and (and (and (and (and (and (and (and (and (and (and (exists ((flted_168_12905 Int)) (and (<= 0 flted_168_12905) (<= flted_168_12905 1))) (exists ((flted_168_12904 Int)) (and (<= 0 flted_168_12904) (<= flted_168_12904 1)))) (exists ((flted_168_12903 Int)) (and (<= 0 flted_168_12903) (<= flted_168_12903 1)))) (exists ((flted_168_12902 Int)) (and (<= 0 flted_168_12902) (<= flted_168_12902 1)))) (exists ((h_12901 Int)) (<= 1 h_12901))) (exists ((h_12900 Int)) (<= 1 h_12900))) (exists ((h_12899 Int)) (<= 1 h_12899))) (<= 0 na_11912)) (<= 1 h_11915)) (<= 0 nb_11913)) (<= 0 nc_11914)) (<= 0 nd)) (and (and (and (and (and (and (and (and (and (and (and (exists ((flted_169_12898 Int)) (and (<= 0 flted_169_12898) (<= flted_169_12898 1))) (exists ((flted_169_12897 Int)) (and (<= 0 flted_169_12897) (<= flted_169_12897 1)))) (exists ((flted_169_12896 Int)) (and (<= 0 flted_169_12896) (<= flted_169_12896 1)))) (exists ((flted_169_12895 Int)) (and (<= 0 flted_169_12895) (<= flted_169_12895 1)))) (exists ((h_12894 Int)) (<= 1 h_12894))) (exists ((h_12893 Int)) (<= 1 h_12893))) (exists ((h_12892 Int)) (<= 1 h_12892))) (<= 0 na_11912)) (<= 1 h_11915)) (<= 0 nb_11913)) (<= 0 nc_11914)) (<= 0 nd))))
(assert (= flted_171_12655 (+ 1 h_11915)))
(assert (= flted_171_12654 1))
(assert (<= 0 n))
(assert (<= 0 nl_11896))
(assert (<= 0 nr_11899))
(assert (<= 0 nc))
(assert (= nd nc))
(assert (= nc_11914 nr_11899))
(assert (= nb_11913 nl_11896))
(assert (= na_11912 n))
(assert (= flted_171_12653 (+ (+ (+ (+ 3 nc_11914) na_11912) nb_11913) nd)))
(assert (= r_12677 tmp_12658))
(assert (or (and (and (and (= flted_171_12654 0) (<= 2 flted_171_12655)) (<= 1 flted_171_12653)) (> tmp_12658 0)) (or (and (and (and (< tmp_12658 1) (= flted_171_12653 0)) (= flted_171_12655 1)) (= flted_171_12654 0)) (and (and (and (= flted_171_12654 1) (<= 1 flted_171_12655)) (<= 1 flted_171_12653)) (> tmp_12658 0)))))
;Negation of Consequence
(assert (not (or (= flted_171_12653 0) (< tmp_12658 1))))
(check-sat)