(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height_307_6170 () Int)
(declare-fun h_6167 () Int)
(declare-fun n_6104 () Int)
(declare-fun h_6771 () Int)
(declare-fun height2_6780 () Int)
(declare-fun height1_6777 () Int)
(declare-fun n_6113 () Int)
(declare-fun height2_6122 () Int)
(declare-fun height1_6119 () Int)
(declare-fun n_6022 () Int)
(declare-fun height2_6018 () Int)
(declare-fun height_6011 () Int)
(declare-fun height1_6015 () Int)
(declare-fun n_6035 () Int)
(declare-fun n_6061 () Int)
(declare-fun height_302_6098 () Int)
(declare-fun h_6161 () Int)
(declare-fun h_6095 () Int)
(declare-fun hr_6111 () Int)
(declare-fun n_6077 () Int)
(declare-fun n_5951 () Int)
(declare-fun n_5939 () Int)
(declare-fun n1_5930 () Int)
(declare-fun n_5916 () Int)
(declare-fun height1_5425 () Int)
(declare-fun height2_5428 () Int)
(declare-fun height_5421 () Int)
(declare-fun n () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n_6113))
(assert (<= 0 n_6104))
(assert (= height_307_6170 height_6011))
(assert (= h_6771 (+ 1 h_6167)))
(assert (or (and (= h_6167 n_6113) (>= n_6113 n_6104)) (and (= h_6167 n_6104) (< n_6113 n_6104))))
(assert (<= 0 n_6061))
(assert (<= 0 n_6022))
(assert (= n_6104 n_6022))
(assert (<= 0 n_6035))
(assert (<= 0 height1_6015))
(assert (<= 0 height2_6018))
(assert (= n_6022 height2_6018))
(assert (= height2_6780 n_6104))
(assert (exists ((max_6818 Int)) (and (= h_6771 (+ 1 max_6818)) (or (and (= max_6818 height1_6777) (>= height1_6777 height2_6780)) (and (= max_6818 height2_6780) (< height1_6777 height2_6780))))))
(assert (= height1_6777 n_6113))
(assert (exists ((max_6817 Int)) (and (= n_6113 (+ 1 max_6817)) (or (and (= max_6817 height1_6119) (>= height1_6119 height2_6122)) (and (= max_6817 height2_6122) (< height1_6119 height2_6122))))))
(assert (= h_6161 n_6113))
(assert (or (and (= h_6161 (+ height1_6119 1)) (<= height2_6122 height1_6119)) (and (= h_6161 (+ height2_6122 1)) (< height1_6119 height2_6122))))
(assert (<= height2_6122 (+ 1 height1_6119)))
(assert (<= height1_6119 (+ 1 height2_6122)))
(assert (= height2_6122 n_6061))
(assert (= height1_6119 n_6077))
(assert (< n_6035 n_6022))
(assert (<= height2_6018 (+ 1 height1_6015)))
(assert (<= height1_6015 (+ 1 height2_6018)))
(assert (exists ((max_6816 Int)) (and (= n_5939 (+ 1 max_6816)) (or (and (= max_6816 height1_6015) (>= height1_6015 height2_6018)) (and (= max_6816 height2_6018) (< height1_6015 height2_6018))))))
(assert (= height_6011 n_5939))
(assert (= n_6035 height1_6015))
(assert (= n_6061 n_6035))
(assert (= hr_6111 n_6061))
(assert (<= 0 n_6077))
(assert (= height_302_6098 height_5421))
(assert (= h_6161 (+ 1 h_6095)))
(assert (or (and (= h_6095 hr_6111) (>= hr_6111 n_6077)) (and (= h_6095 n_6077) (< hr_6111 n_6077))))
(assert (<= 0 n_5951))
(assert (= n_6077 n_5951))
(assert (= (+ 2 n_5951) n_5939))
(assert (<= 0 height1_5425))
(assert (= n_5951 height1_5425))
(assert (<= 0 n_5939))
(assert (<= 0 n1_5930))
(assert (= n_5939 n1_5930))
(assert (<= 0 n_5916))
(assert (<= n1_5930 (+ 1 n_5916)))
(assert (<= n_5916 n1_5930))
(assert (<= 0 height2_5428))
(assert (= n_5916 height2_5428))
(assert (<= height1_5425 (+ 1 height2_5428)))
(assert (<= height2_5428 (+ 1 height1_5425)))
(assert (exists ((max_6815 Int)) (and (= n (+ 1 max_6815)) (or (and (= max_6815 height1_5425) (>= height1_5425 height2_5428)) (and (= max_6815 height2_5428) (< height1_5425 height2_5428))))))
(assert (= height_5421 n))
;Negation of Consequence
(assert (not (<= 0 n)))
(check-sat)