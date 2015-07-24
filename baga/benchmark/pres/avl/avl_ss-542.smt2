(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_5041 () Int)
(declare-fun n_5024 () Int)
(declare-fun height1_5017 () Int)
(declare-fun height2_5020 () Int)
(declare-fun height_5013 () Int)
(declare-fun Anon_4932 () Int)
(declare-fun flted_34_5346 () Int)
(declare-fun ln () Int)
(declare-fun n_4941 () Int)
(declare-fun n_4918 () Int)
(declare-fun n_4953 () Int)
(declare-fun height_4545 () Int)
(declare-fun height1_4549 () Int)
(declare-fun height2_4552 () Int)
(declare-fun n () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< n_5041 n_5024))
(assert (<= 0 n_5041))
(assert (<= 0 n_5024))
(assert (<= 0 height1_5017))
(assert (= n_5041 height1_5017))
(assert (<= 0 height2_5020))
(assert (= n_5024 height2_5020))
(assert (<= 0 Anon_4932))
(assert (<= 0 flted_34_5346))
(assert (<= height2_5020 (+ 1 height1_5017)))
(assert (<= height1_5017 (+ 1 height2_5020)))
(assert (exists ((max_5359 Int)) (and (= n_4941 (+ 1 max_5359)) (or (and (= max_5359 height1_5017) (>= height1_5017 height2_5020)) (and (= max_5359 height2_5020) (< height1_5017 height2_5020))))))
(assert (= height_5013 n_4941))
(assert (= n_4941 Anon_4932))
(assert (<= 0 n_4941))
(assert (<= 0 ln))
(assert (= flted_34_5346 (+ ln 2)))
(assert (<= 0 n_4953))
(assert (= ln n_4953))
(assert (= (+ 2 n_4953) n_4941))
(assert (<= 0 n_4918))
(assert (<= height2_4552 (+ 1 height1_4549)))
(assert (<= height1_4549 (+ 1 height2_4552)))
(assert (= n_4918 height2_4552))
(assert (<= 0 height2_4552))
(assert (= n_4953 height1_4549))
(assert (<= 0 height1_4549))
(assert (= height_4545 n))
(assert (exists ((max_5360 Int)) (and (= n (+ 1 max_5360)) (or (and (= max_5360 height1_4549) (>= height1_4549 height2_4552)) (and (= max_5360 height2_4552) (< height1_4549 height2_4552))))))
;Negation of Consequence
(assert (not (<= 0 n)))
(check-sat)