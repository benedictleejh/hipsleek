(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhr_12517 () Int)
(declare-fun Anon_12516 () Int)
(declare-fun nr_12515 () Int)
(declare-fun bhl_12513 () Int)
(declare-fun Anon_12512 () Int)
(declare-fun nl_12511 () Int)
(declare-fun na () Int)
(declare-fun r_12514 () Int)
(declare-fun tmp_12495 () Int)
(declare-fun l_12510 () Int)
(declare-fun v_12509 () Int)
(declare-fun v_int_280_12494 () Int)
(declare-fun v_int_280_12493 () Int)
(declare-fun flted_196_12490 () Int)
(declare-fun flted_196_12491 () Int)
(declare-fun flted_196_12492 () Int)
(declare-fun nc_11796 () Int)
(declare-fun nc () Int)
(declare-fun nb_11795 () Int)
(declare-fun ha () Int)
(declare-fun na_11794 () Int)
(declare-fun v_bool_268_3692_primed () Int)
(declare-fun bh () Int)
(declare-fun cl () Int)
(declare-fun Anon_11746 () Int)
(declare-fun n () Int)
(declare-fun flted_13_11742 () Int)
(declare-fun flted_262_11754 () Int)
(declare-fun nb () Int)
(declare-fun nl_11745 () Int)
(declare-fun bhl_11747 () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun c_primed () Int)
(declare-fun c () Int)
(declare-fun flted_262_11756 () Int)
(declare-fun flted_262_11755 () Int)
(declare-fun flted_262_11753 () Int)
(declare-fun h () Int)
(declare-fun flted_262_11752 () Int)
(declare-fun b () Int)
(declare-fun n_11773 () Int)
(declare-fun bh_11775 () Int)
(declare-fun nr_11749 () Int)
(declare-fun bhr_11751 () Int)
(declare-fun Anon_11750 () Int)
(declare-fun cl_11774 () Int)
(declare-fun v_bool_270_3675_primed () Int)
(declare-fun b_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhr_12517 flted_196_12490))
(assert (= Anon_12516 flted_196_12491))
(assert (= nr_12515 flted_196_12492))
(assert (= bhl_12513 flted_262_11755))
(assert (= Anon_12512 flted_262_11756))
(assert (= nl_12511 na))
(assert (= r_12514 tmp_12495))
(assert (= l_12510 a_primed))
(assert (= v_12509 v_int_280_12493))
(assert (= v_int_280_12494 0))
(assert (= v_int_280_12493 0))
(assert (<= 0 nc_11796))
(assert (<= 0 nb_11795))
(assert (<= 1 ha))
(assert (<= 0 na_11794))
(assert (exists ((ha_219 Int)) (<= 1 ha_219)))
(assert (exists ((ha_220 Int)) (<= 1 ha_220)))
(assert (exists ((flted_195_216 Int)) (and (<= 0 flted_195_216) (<= flted_195_216 1))))
(assert (exists ((flted_195_217 Int)) (and (<= 0 flted_195_217) (<= flted_195_217 1))))
(assert (exists ((flted_195_218 Int)) (and (<= 0 flted_195_218) (<= flted_195_218 1))))
(assert (= flted_196_12490 (+ 1 ha)))
(assert (= flted_196_12491 0))
(assert (= flted_196_12492 (+ (+ (+ 2 nb_11795) na_11794) nc_11796)))
(assert (<= cl 1))
(assert (<= 0 cl))
(assert (<= 1 bh))
(assert (<= 0 n))
(assert (<= cl_11774 1))
(assert (<= 0 cl_11774))
(assert (<= 1 bh_11775))
(assert (<= 0 n_11773))
(assert (<= flted_262_11752 1))
(assert (<= 0 flted_262_11752))
(assert (<= 1 h))
(assert (<= 0 nc))
(assert (= nc_11796 nc))
(assert (= nb_11795 n_11773))
(assert (= ha bh))
(assert (= na_11794 n))
(assert (> v_bool_268_3692_primed 0))
(assert (= cl 0))
(assert (<= Anon_11746 1))
(assert (<= 0 Anon_11746))
(assert (<= 1 bhl_11747))
(assert (<= 0 nl_11745))
(assert (= bh bhl_11747))
(assert (= cl Anon_11746))
(assert (= n nl_11745))
(assert (= flted_13_11742 0))
(assert (= flted_262_11754 0))
(assert (= nb (+ (+ nr_11749 1) nl_11745)))
(assert (= bhl_11747 bhr_11751))
(assert (= flted_262_11753 (+ bhl_11747 1)))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= flted_262_11756 0))
(assert (= flted_262_11755 (+ 1 h)))
(assert (= flted_262_11753 (+ 1 h)))
(assert (= flted_262_11752 0))
(assert (> b 0))
(assert (= n_11773 nr_11749))
(assert (= cl_11774 Anon_11750))
(assert (= bh_11775 bhr_11751))
(assert (<= 0 nr_11749))
(assert (<= 1 bhr_11751))
(assert (<= 0 Anon_11750))
(assert (<= Anon_11750 1))
(assert (= cl_11774 0))
(assert (> v_bool_270_3675_primed 0))
(assert (= b_primed 1))
;Negation of Consequence
(assert (not false))
(check-sat)