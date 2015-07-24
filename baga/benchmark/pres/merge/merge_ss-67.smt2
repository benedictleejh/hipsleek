(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun x2 () Int)
(declare-fun x2_primed () Int)
(declare-fun n2 () Int)
(declare-fun s2 () Int)
(declare-fun b2 () Int)
(declare-fun n1 () Int)
(declare-fun s1 () Int)
(declare-fun b1 () Int)
(declare-fun n () Int)
(declare-fun xs () Int)
(declare-fun sm_2037 () Int)
(declare-fun xl () Int)
(declare-fun flted_117_2069 () Int)
(declare-fun sres_2070 () Int)
(declare-fun lres_2071 () Int)
(declare-fun flted_22_2039 () Int)
(declare-fun qs_2041 () Int)
(declare-fun lg_2038 () Int)
(declare-fun s1_2084 () Int)
(declare-fun s2_2087 () Int)
(declare-fun b1_2085 () Int)
(declare-fun b2_2088 () Int)
(declare-fun n2_2086 () Int)
(declare-fun n1_2083 () Int)
(declare-fun s3_2105 () Int)
(declare-fun b3_2106 () Int)
(declare-fun res () Int)
(declare-fun flted_90_2104 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= s2_2087 b2_2088))
(assert (<= s1_2084 b1_2085))
(assert (<= sres_2070 lres_2071))
(assert (<= 1 flted_117_2069))
(assert (<= qs_2041 lg_2038))
(assert (<= 1 flted_22_2039))
(assert (<= xs xl))
(assert (<= 1 n))
(assert (<= s1 b1))
(assert (<= 1 n1))
(assert (= x2_primed x2))
(assert (> x2_primed 0))
(assert (= x2_primed 1))
(assert (not (= x2_primed res)))
(assert (= (+ flted_22_2039 1) n2))
(assert (<= s2 qs_2041))
(assert (= sm_2037 s2))
(assert (= lg_2038 b2))
(assert (= n n1))
(assert (= xs s1))
(assert (= xl b1))
(assert (= flted_117_2069 (+ 1 n)))
(assert (or (and (= sres_2070 sm_2037) (< sm_2037 xs)) (and (= sres_2070 xs) (>= sm_2037 xs))))
(assert (or (and (= lres_2071 sm_2037) (>= sm_2037 xl)) (and (= lres_2071 xl) (< sm_2037 xl))))
(assert (= n1_2083 flted_117_2069))
(assert (= s1_2084 sres_2070))
(assert (= b1_2085 lres_2071))
(assert (= n2_2086 flted_22_2039))
(assert (= s2_2087 qs_2041))
(assert (= b2_2088 lg_2038))
(assert (or (and (= s3_2105 s1_2084) (< s1_2084 s2_2087)) (and (= s3_2105 s2_2087) (>= s1_2084 s2_2087))))
(assert (or (and (= b3_2106 b1_2085) (>= b1_2085 b2_2088)) (and (= b3_2106 b2_2088) (< b1_2085 b2_2088))))
(assert (<= 1 n1_2083))
(assert (<= 1 n2_2086))
(assert (= flted_90_2104 (+ n2_2086 n1_2083)))
(assert (or (and (and (= b3_2106 s3_2105) (= flted_90_2104 1)) (> res 0)) (and (and (<= s3_2105 b3_2106) (<= 2 flted_90_2104)) (> res 0))))
;Negation of Consequence
(assert (not (= flted_90_2104 1)))
(check-sat)