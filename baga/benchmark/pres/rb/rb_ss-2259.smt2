(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_14722 () Int)
(declare-fun l_14719 () Int)
(declare-fun v_14718 () Int)
(declare-fun v_14038 () Int)
(declare-fun flted_12_14036 () Int)
(declare-fun flted_12_14035 () Int)
(declare-fun bhr_14044 () Int)
(declare-fun v_bool_314_3280_primed () Int)
(declare-fun bh_13923 () Int)
(declare-fun cl_13922 () Int)
(declare-fun Anon_13898 () Int)
(declare-fun n_13921 () Int)
(declare-fun flted_13_13890 () Int)
(declare-fun n () Int)
(declare-fun nr_13897 () Int)
(declare-fun bhr_13899 () Int)
(declare-fun bh () Int)
(declare-fun x () Int)
(declare-fun cl () Int)
(declare-fun v_bool_310_3540_primed () Int)
(declare-fun v_int_315_14049 () Int)
(declare-fun color_315_14045 () Int)
(declare-fun flted_12_14037 () Int)
(declare-fun x_primed () Int)
(declare-fun r_13896 () Int)
(declare-fun res () Int)
(declare-fun v_13891 () Int)
(declare-fun bhl_14041 () Int)
(declare-fun nl_14040 () Int)
(declare-fun l_14039 () Int)
(declare-fun nr_14043 () Int)
(declare-fun r_14042 () Int)
(declare-fun bhl_14721 () Int)
(declare-fun nl_14720 () Int)
(declare-fun bhr_14724 () Int)
(declare-fun nr_14723 () Int)
(declare-fun Anon_13894 () Int)
(declare-fun bhl_13895 () Int)
(declare-fun nl_13893 () Int)
(declare-fun l_13892 () Int)
(declare-fun x_14361 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< r_14042 1))
(assert (= nr_14043 0))
(assert (= bhr_14044 1))
(assert (or (= nl_14040 0) (< l_14039 1)))
(assert (= r_14722 r_14042))
(assert (= l_14719 l_14039))
(assert (= v_14718 v_14038))
(assert (= flted_12_14037 1))
(assert (= flted_12_14036 0))
(assert (= flted_12_14035 0))
(assert (= n_13921 (+ (+ nr_14043 1) nl_14040)))
(assert (= bhl_14041 bh_13923))
(assert (= bhr_14044 bh_13923))
(assert (> v_bool_314_3280_primed 0))
(assert (<= cl_13922 1))
(assert (<= 0 cl_13922))
(assert (<= 1 bh_13923))
(assert (<= 0 n_13921))
(assert (= cl_13922 1))
(assert (<= Anon_13898 1))
(assert (<= 0 Anon_13898))
(assert (<= 1 bhr_13899))
(assert (<= 0 nr_13897))
(assert (= bh_13923 bhr_13899))
(assert (= cl_13922 Anon_13898))
(assert (= n_13921 nr_13897))
(assert (= flted_13_13890 0))
(assert (= cl 0))
(assert (= n (+ (+ nr_13897 1) nl_13893)))
(assert (= bhl_13895 bhr_13899))
(assert (= bh (+ bhl_13895 1)))
(assert (= x_14361 x))
(assert (> x 0))
(assert (<= 0 cl))
(assert (<= cl 1))
(assert (< l_13892 1))
(assert (> v_bool_310_3540_primed 0))
(assert (= v_int_315_14049 0))
(assert (= color_315_14045 flted_12_14037))
(assert (= x_primed r_13896))
(assert (= res v_13891))
(assert (= bhl_14041 1))
(assert (= nl_14040 0))
(assert (< l_14039 1))
(assert (or (= nr_14043 0) (< r_14042 1)))
(assert (= bhl_14721 1))
(assert (= nl_14720 0))
(assert (= bhr_14724 1))
(assert (= nr_14723 0))
(assert (or (and (and (and (= Anon_13894 0) (<= 2 bhl_13895)) (<= 1 nl_13893)) (> l_13892 0)) (or (and (and (and (< l_13892 1) (= nl_13893 0)) (= bhl_13895 1)) (= Anon_13894 0)) (and (and (and (= Anon_13894 1) (<= 1 bhl_13895)) (<= 1 nl_13893)) (> l_13892 0)))))
(assert (= x_14361 1))
;Negation of Consequence
(assert (not false))
(check-sat)