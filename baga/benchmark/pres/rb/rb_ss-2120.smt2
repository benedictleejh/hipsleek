(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_13_14249 () Int)
(declare-fun v_bool_314_3280_primed () Int)
(declare-fun cl_13922 () Int)
(declare-fun v_bool_310_3540_primed () Int)
(declare-fun x () Int)
(declare-fun bhr_13888 () Int)
(declare-fun bhl_13885 () Int)
(declare-fun bh () Int)
(declare-fun n () Int)
(declare-fun nl_13884 () Int)
(declare-fun cl () Int)
(declare-fun flted_12_13879 () Int)
(declare-fun flted_12_13880 () Int)
(declare-fun flted_12_13881 () Int)
(declare-fun tmp_primed () Int)
(declare-fun v_13882 () Int)
(declare-fun nr_13887 () Int)
(declare-fun r_13886 () Int)
(declare-fun bh_13923 () Int)
(declare-fun n_13921 () Int)
(declare-fun Anon_14253 () Int)
(declare-fun bhl_14254 () Int)
(declare-fun nl_14252 () Int)
(declare-fun l_14251 () Int)
(declare-fun Anon_14257 () Int)
(declare-fun bhr_14258 () Int)
(declare-fun nr_14256 () Int)
(declare-fun r_14255 () Int)
(declare-fun x_primed () Int)
(declare-fun l_13883 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nl_13884 0))
(assert (= bhl_13885 1))
(assert (= flted_13_14249 0))
(assert (= n_13921 (+ (+ nr_14256 1) nl_14252)))
(assert (= bhl_14254 bhr_14258))
(assert (= bh_13923 (+ bhl_14254 1)))
(assert (not (> v_bool_314_3280_primed 0)))
(assert (<= cl_13922 1))
(assert (<= 0 cl_13922))
(assert (<= 1 bh_13923))
(assert (<= 0 n_13921))
(assert (= cl_13922 0))
(assert (< r_13886 1))
(assert (= nr_13887 0))
(assert (= bhr_13888 1))
(assert (> v_bool_310_3540_primed 0))
(assert (< l_13883 1))
(assert (<= cl 1))
(assert (<= 0 cl))
(assert (> x 0))
(assert (= x_primed x))
(assert (= bhr_13888 bh))
(assert (= bhl_13885 bh))
(assert (= n (+ (+ nr_13887 1) nl_13884)))
(assert (= cl 1))
(assert (= flted_12_13879 0))
(assert (= flted_12_13880 0))
(assert (= flted_12_13881 1))
(assert (= tmp_primed v_13882))
(assert (or (= nr_13887 0) (< r_13886 1)))
(assert (= bh_13923 1))
(assert (= n_13921 0))
(assert (= x_primed 1))
(assert (= l_13883 2))
(assert (or (and (and (and (= Anon_14253 0) (<= 2 bhl_14254)) (<= 1 nl_14252)) (> l_14251 0)) (or (and (and (and (< l_14251 1) (= nl_14252 0)) (= bhl_14254 1)) (= Anon_14253 0)) (and (and (and (= Anon_14253 1) (<= 1 bhl_14254)) (<= 1 nl_14252)) (> l_14251 0)))))
(assert (or (and (and (and (= Anon_14257 0) (<= 2 bhr_14258)) (<= 1 nr_14256)) (> r_14255 0)) (or (and (and (and (< r_14255 1) (= nr_14256 0)) (= bhr_14258 1)) (= Anon_14257 0)) (and (and (and (= Anon_14257 1) (<= 1 bhr_14258)) (<= 1 nr_14256)) (> r_14255 0)))))
(assert (not (= x_primed l_13883)))
;Negation of Consequence
(assert (not false))
(check-sat)