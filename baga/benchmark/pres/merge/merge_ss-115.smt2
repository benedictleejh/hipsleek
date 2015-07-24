(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun d_2317 () Int)
(declare-fun bg_2302 () Int)
(declare-fun bg () Int)
(declare-fun sm_2313 () Int)
(declare-fun bg_2314 () Int)
(declare-fun sm_2355 () Int)
(declare-fun bg_2356 () Int)
(declare-fun sm_2340 () Int)
(declare-fun bg_2341 () Int)
(declare-fun sm_2365 () Int)
(declare-fun bg_2366 () Int)
(declare-fun smres_2369 () Int)
(declare-fun bgres_2370 () Int)
(declare-fun bgres_2380 () Int)
(declare-fun b1 () Int)
(declare-fun b2 () Int)
(declare-fun s1 () Int)
(declare-fun smres_2379 () Int)
(declare-fun d_2304 () Int)
(declare-fun sm_2301 () Int)
(declare-fun b3_2387 () Int)
(declare-fun sm () Int)
(declare-fun s3_2386 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= smres_2369 bgres_2370))
(assert (<= sm_2313 d_2317))
(assert (<= d_2317 bg_2314))
(assert (= sm_2301 sm_2313))
(assert (= bg_2302 bg_2314))
(assert (<= sm_2301 d_2317))
(assert (<= d_2317 bg_2302))
(assert (= d_2317 d_2304))
(assert (= bg_2302 bg))
(assert (<= d_2304 bg))
(assert (= sm_2340 sm_2313))
(assert (= bg_2341 bg_2314))
(assert (= sm_2355 sm_2340))
(assert (= bg_2356 bg_2341))
(assert (<= sm_2355 smres_2369))
(assert (<= bgres_2370 bg_2356))
(assert (= sm_2365 sm_2340))
(assert (= bg_2366 bg_2341))
(assert (<= sm_2365 smres_2379))
(assert (<= bgres_2380 bg_2366))
(assert (= s1 smres_2369))
(assert (= b1 bgres_2370))
(assert (= b2 bgres_2380))
(assert (<= smres_2379 bgres_2380))
(assert (or (and (= b3_2387 b1) (>= b1 b2)) (and (= b3_2387 b2) (< b1 b2))))
(assert (<= s1 b1))
(assert (> smres_2379 0))
(assert (<= smres_2379 b2))
(assert (or (and (= s3_2386 s1) (< s1 smres_2379)) (and (= s3_2386 smres_2379) (>= s1 smres_2379))))
(assert (<= sm d_2304))
(assert (= sm_2301 sm))
(assert (<= s3_2386 b3_2387))
;Negation of Consequence
(assert (not (<= sm s3_2386)))
(check-sat)