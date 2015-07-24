(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nmin2_2022 () Int)
(declare-fun res () Int)
(declare-fun v_int_71_1475_primed () Int)
(declare-fun nmin () Int)
(declare-fun nmin1_1899 () Int)
(declare-fun nmin2_1901 () Int)
(declare-fun nmin_1924 () Int)
(declare-fun v_int_71_2008 () Int)
(declare-fun nmin1_2020 () Int)
(declare-fun n_1923 () Int)
(declare-fun flted_26_1895 () Int)
(declare-fun flted_26_1896 () Int)
(declare-fun nmin_1906 () Int)
(declare-fun n_1905 () Int)
(declare-fun n () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((min_2065 Int)) (or (and (= min_2065 nmin1_2020) (< nmin1_2020 nmin2_2022)) (and (= min_2065 nmin2_2022) (>= nmin1_2020 nmin2_2022)))))
(assert (= nmin2_2022 nmin_1924))
(assert (= res v_int_71_1475_primed))
(assert (= v_int_71_1475_primed (+ 1 v_int_71_2008)))
(assert (<= 0 nmin_1906))
(assert (<= nmin_1924 n_1923))
(assert (<= 0 nmin_1924))
(assert (exists ((min_2064 Int)) (and (= nmin (+ 1 min_2064)) (or (and (= min_2064 nmin1_1899) (< nmin1_1899 nmin2_1901)) (and (= min_2064 nmin2_1901) (>= nmin1_1899 nmin2_1901))))))
(assert (= nmin_1906 nmin1_1899))
(assert (<= 0 nmin1_1899))
(assert (<= nmin1_1899 flted_26_1896))
(assert (= n_1923 flted_26_1895))
(assert (= nmin_1924 nmin2_1901))
(assert (<= 0 nmin2_1901))
(assert (<= nmin2_1901 flted_26_1895))
(assert (or (< nmin_1906 nmin_1924) (= v_int_71_2008 nmin_1924)))
(assert (or (<= nmin_1924 nmin_1906) (= v_int_71_2008 nmin_1906)))
(assert (= nmin1_2020 nmin_1906))
(assert (= (+ n_1905 1) (+ n_1923 1)))
(assert (= n_1905 flted_26_1896))
(assert (= (+ flted_26_1895 1) n))
(assert (= (+ flted_26_1896 1) n))
(assert (<= nmin_1906 n_1905))
;Negation of Consequence
(assert (not (= (+ 1 n_1905) n)))
(check-sat)