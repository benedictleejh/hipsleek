(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun na_10926 () Int)
(declare-fun ha () Int)
(declare-fun nr_10952 () Int)
(declare-fun nl_10949 () Int)
(declare-fun r_10951 () Int)
(declare-fun l_10948 () Int)
(declare-fun c_primed () Int)
(declare-fun b_primed () Int)
(declare-fun a_primed () Int)
(declare-fun nb_10927 () Int)
(declare-fun Anon_19 () Int)
(declare-fun flted_168_10940 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun flted_168_10939 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_168_10938 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun bhl_10950 () Int)
(declare-fun bhr_10953 () Int)
(declare-fun d_primed () Int)
(declare-fun flted_168_10937 () Int)
(declare-fun h () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= na_10926 (+ (+ nr_10952 1) nl_10949)))
(assert (= bhl_10950 ha))
(assert (= bhr_10953 ha))
(assert (= bhr_10953 bhl_10950))
(assert (= nr_10952 nb))
(assert (= nl_10949 na))
(assert (= r_10951 b_primed))
(assert (= l_10948 a_primed))
(assert (= flted_168_10938 0))
(assert (= flted_168_10939 0))
(assert (= flted_168_10940 0))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= nb_10927 nc))
(assert (= Anon_19 flted_168_10938))
(assert (or (and (and (and (= flted_168_10940 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_168_10940 0)) (and (and (and (= flted_168_10940 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= flted_168_10939 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_168_10939 0)) (and (and (and (= flted_168_10939 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_168_10938 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_168_10938 0)) (and (and (and (= flted_168_10938 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (= flted_168_10937 0))
(assert (= bhl_10950 h))
(assert (= bhr_10953 h))
(assert (= d_primed d))
(assert (or (and (and (and (= flted_168_10937 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_168_10937 0)) (and (and (and (= flted_168_10937 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
;Negation of Consequence
(assert (not (or (= nd 0) (< d 1))))
(check-sat)