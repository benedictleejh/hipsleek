(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nr_6769 () Int)
(declare-fun bhr_6770 () Int)
(declare-fun bhr_6844 () Int)
(declare-fun nr_6842 () Int)
(declare-fun bhl_6840 () Int)
(declare-fun nl_6838 () Int)
(declare-fun nl_6766 () Int)
(declare-fun bhl_6767 () Int)
(declare-fun bhr_6810 () Int)
(declare-fun bhl_6228 () Int)
(declare-fun bhr_6231 () Int)
(declare-fun h_6233 () Int)
(declare-fun h_6232 () Int)
(declare-fun nr_6230 () Int)
(declare-fun nl_6227 () Int)
(declare-fun nl_6804 () Int)
(declare-fun bhl_6806 () Int)
(declare-fun nr_6808 () Int)
(declare-fun Anon_6809 () Int)
(declare-fun Anon_17 () Int)
(declare-fun na () Int)
(declare-fun h () Int)
(declare-fun nb () Int)
(declare-fun Anon_18 () Int)
(declare-fun nc () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhr_6770 bhl_6767))
(assert (<= 1 h_6232))
(assert (<= 1 bhl_6228))
(assert (<= 0 nl_6227))
(assert (<= 1 bhr_6231))
(assert (<= 0 nr_6230))
(assert (= nr_6769 (+ (+ nr_6842 1) nl_6838)))
(assert (= bhr_6770 (+ bhl_6840 1)))
(assert (= bhl_6840 bhr_6844))
(assert (= bhr_6844 bhr_6231))
(assert (= nr_6842 nr_6230))
(assert (= bhl_6840 bhl_6228))
(assert (= nl_6838 nl_6227))
(assert (= nl_6766 (+ (+ nr_6808 1) nl_6804)))
(assert (= bhl_6767 (+ bhl_6806 1)))
(assert (= bhl_6806 bhr_6810))
(assert (= bhr_6810 h_6232))
(assert (= bhl_6228 h_6233))
(assert (= bhr_6231 h_6233))
(assert (= h_6233 h))
(assert (= h_6232 h))
(assert (= nc (+ (+ nr_6230 1) nl_6227)))
(assert (= nl_6804 na))
(assert (= bhl_6806 h))
(assert (= nr_6808 nb))
(assert (= Anon_6809 Anon_18))
(assert (<= 0 nb))
(assert (<= 0 Anon_18))
(assert (<= Anon_18 1))
(assert (<= 0 na))
(assert (<= 1 h))
;Negation of Consequence
(assert (not (or (and (and (and (and (and (and (and (and (and (exists ((flted_119_7005 Int)) (and (<= 0 flted_119_7005) (<= flted_119_7005 1))) (exists ((flted_119_7004 Int)) (and (<= 0 flted_119_7004) (<= flted_119_7004 1)))) (exists ((h_7003 Int)) (<= 1 h_7003))) (exists ((h_7002 Int)) (<= 1 h_7002))) (<= 0 na)) (<= 1 h)) (<= 0 nb)) (<= 0 Anon_17)) (<= Anon_17 1)) (<= 0 nc)) (and (and (and (and (and (and (and (and (and (exists ((flted_120_7001 Int)) (and (<= 0 flted_120_7001) (<= flted_120_7001 1))) (exists ((flted_120_7000 Int)) (and (<= 0 flted_120_7000) (<= flted_120_7000 1)))) (exists ((h_6999 Int)) (<= 1 h_6999))) (exists ((h_6998 Int)) (<= 1 h_6998))) (<= 0 na)) (<= 1 h)) (<= 0 nb)) (<= 0 Anon_18)) (<= Anon_18 1)) (<= 0 nc)))))
(check-sat)