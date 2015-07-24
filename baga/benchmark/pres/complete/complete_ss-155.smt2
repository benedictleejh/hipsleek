(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nmin2_1957 () Int)
(declare-fun nmin1_1955 () Int)
(declare-fun res () Int)
(declare-fun v_int_71_1475_primed () Int)
(declare-fun v_int_71_1950 () Int)
(declare-fun n_1905 () Int)
(declare-fun nmin_1906 () Int)
(declare-fun n_1923 () Int)
(declare-fun nmin_1924 () Int)
(declare-fun nmin1_1891 () Int)
(declare-fun nmin2_1893 () Int)
(declare-fun flted_25_1887 () Int)
(declare-fun flted_25_1888 () Int)
(declare-fun nmin () Int)
(declare-fun n () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((min_1999 Int)) (or (and (= min_1999 nmin1_1955) (< nmin1_1955 nmin2_1957)) (and (= min_1999 nmin2_1957) (>= nmin1_1955 nmin2_1957)))))
(assert (= (+ n_1905 1) (+ n_1923 2)))
(assert (= nmin2_1957 nmin_1924))
(assert (= nmin1_1955 nmin_1906))
(assert (= res v_int_71_1475_primed))
(assert (= v_int_71_1475_primed (+ 1 v_int_71_1950)))
(assert (or (<= nmin_1924 nmin_1906) (= v_int_71_1950 nmin_1906)))
(assert (or (< nmin_1906 nmin_1924) (= v_int_71_1950 nmin_1924)))
(assert (<= nmin_1906 n_1905))
(assert (<= 0 nmin_1906))
(assert (<= nmin_1924 n_1923))
(assert (<= 0 nmin_1924))
(assert (= n_1905 flted_25_1888))
(assert (= nmin_1906 nmin1_1891))
(assert (<= 0 nmin1_1891))
(assert (<= nmin1_1891 flted_25_1888))
(assert (= n_1923 flted_25_1887))
(assert (= nmin_1924 nmin2_1893))
(assert (<= 0 nmin2_1893))
(assert (<= nmin2_1893 flted_25_1887))
(assert (exists ((min_1998 Int)) (and (= nmin (+ 1 min_1998)) (or (and (= min_1998 nmin1_1891) (< nmin1_1891 nmin2_1893)) (and (= min_1998 nmin2_1893) (>= nmin1_1891 nmin2_1893))))))
(assert (= (+ flted_25_1887 2) n))
(assert (= (+ flted_25_1888 1) n))
;Negation of Consequence
(assert (not (<= nmin n)))
(check-sat)