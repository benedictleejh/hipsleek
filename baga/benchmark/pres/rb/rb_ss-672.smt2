(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun flted_154_7706 () Int)
(declare-fun Anon_17 () Int)
(declare-fun Anon_18 () Int)
(declare-fun bhr_7722 () Int)
(declare-fun nr_7721 () Int)
(declare-fun bhl_7719 () Int)
(declare-fun nl_7718 () Int)
(declare-fun flted_122_7872 () Int)
(declare-fun nb_7283 () Int)
(declare-fun na_7282 () Int)
(declare-fun nc_7284 () Int)
(declare-fun flted_122_7870 () Int)
(declare-fun h_7285 () Int)
(declare-fun na () Int)
(declare-fun h () Int)
(declare-fun nb () Int)
(declare-fun nc () Int)
(declare-fun nd () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= flted_154_7706 1))
(assert (<= 0 flted_154_7706))
(assert (= nc_7284 (+ (+ nr_7721 1) nl_7718)))
(assert (= bhl_7719 bhr_7722))
(assert (= flted_154_7706 0))
(assert (= Anon_18 flted_154_7706))
(assert (or (and (and (and (and (and (and (and (and (and (exists ((flted_119_400 Int)) (and (<= 0 flted_119_400) (<= flted_119_400 1))) (exists ((flted_119_399 Int)) (and (<= 0 flted_119_399) (<= flted_119_399 1)))) (exists ((h_402 Int)) (<= 1 h_402))) (exists ((h_401 Int)) (<= 1 h_401))) (<= 0 na_7282)) (<= 1 h_7285)) (<= 0 nb_7283)) (<= 0 Anon_17)) (<= Anon_17 1)) (<= 0 nc_7284)) (and (and (and (and (and (and (and (and (and (exists ((flted_120_398 Int)) (and (<= 0 flted_120_398) (<= flted_120_398 1))) (exists ((flted_120_397 Int)) (and (<= 0 flted_120_397) (<= flted_120_397 1)))) (exists ((h_404 Int)) (<= 1 h_404))) (exists ((h_403 Int)) (<= 1 h_403))) (<= 0 na_7282)) (<= 1 h_7285)) (<= 0 nb_7283)) (<= 0 Anon_18)) (<= Anon_18 1)) (<= 0 nc_7284))))
(assert (<= 1 flted_122_7870))
(assert (<= 0 flted_122_7872))
(assert (= bhr_7722 h))
(assert (= nr_7721 nd))
(assert (= bhl_7719 h))
(assert (= nl_7718 nc))
(assert (= na_7282 na))
(assert (= h_7285 h))
(assert (= nb_7283 nb))
(assert (<= 0 nd))
(assert (<= 0 nc))
(assert (<= 0 nb))
(assert (<= 0 na))
(assert (<= 1 h))
(assert (= flted_122_7872 (+ (+ (+ 2 nb_7283) na_7282) nc_7284)))
(assert (= flted_122_7870 (+ 1 h_7285)))
(assert (or (and (and (and (and (and (and (and (and (and (and (and (exists ((flted_153_326 Int)) (and (<= 0 flted_153_326) (<= flted_153_326 1))) (exists ((flted_153_325 Int)) (and (<= 0 flted_153_325) (<= flted_153_325 1)))) (exists ((flted_153_324 Int)) (and (<= 0 flted_153_324) (<= flted_153_324 1)))) (exists ((flted_153_323 Int)) (and (<= 0 flted_153_323) (<= flted_153_323 1)))) (exists ((h_329 Int)) (<= 1 h_329))) (exists ((h_328 Int)) (<= 1 h_328))) (exists ((h_327 Int)) (<= 1 h_327))) (<= 0 na)) (<= 1 h)) (<= 0 nb)) (<= 0 nc)) (<= 0 nd)) (and (and (and (and (and (and (and (and (and (and (and (exists ((flted_154_322 Int)) (and (<= 0 flted_154_322) (<= flted_154_322 1))) (exists ((flted_154_321 Int)) (and (<= 0 flted_154_321) (<= flted_154_321 1)))) (exists ((flted_154_320 Int)) (and (<= 0 flted_154_320) (<= flted_154_320 1)))) (exists ((flted_154_319 Int)) (and (<= 0 flted_154_319) (<= flted_154_319 1)))) (exists ((h_332 Int)) (<= 1 h_332))) (exists ((h_331 Int)) (<= 1 h_331))) (exists ((h_330 Int)) (<= 1 h_330))) (<= 0 na)) (<= 1 h)) (<= 0 nb)) (<= 0 nc)) (<= 0 nd))))
;Negation of Consequence
(assert (not false))
(check-sat)