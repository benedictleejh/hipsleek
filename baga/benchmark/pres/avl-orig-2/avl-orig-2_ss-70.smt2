(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun cm () Int)
(declare-fun Anon_46 () Int)
(declare-fun b_2628 () Int)
(declare-fun m_2626 () Int)
(declare-fun r () Int)
(declare-fun right_201_2611 () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun Anon_50 () Int)
(declare-fun cn () Int)
(declare-fun n_2627 () Int)
(declare-fun b () Int)
(declare-fun m () Int)
(declare-fun lr () Int)
(declare-fun Anon_49 () Int)
(declare-fun n () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun v_int_202_2657 () Int)
(declare-fun v_int_203_2708 () Int)
(declare-fun b_2665 () Int)
(declare-fun m_2663 () Int)
(declare-fun n_2664 () Int)
(declare-fun ll () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= Anon_46 2))
(assert (<= 0 Anon_46))
(assert (<= 0 cm))
(assert (= m_2626 cm))
(assert (= b_2628 Anon_46))
(assert (<= 0 m_2626))
(assert (<= 0 b_2628))
(assert (<= b_2628 2))
(assert (or (and (and (and (< r 1) (= m_2626 0)) (= n_2627 0)) (= b_2628 1)) (and (and (and (and (and (<= 0 b_2628) (<= (+ (- 0 n_2627) 2) b_2628)) (<= b_2628 n_2627)) (<= b_2628 2)) (<= 1 m_2626)) (> r 0))))
(assert (<= 0 cn))
(assert (<= Anon_50 2))
(assert (<= 0 Anon_50))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (= right_201_2611 lr))
(assert (= m bm))
(assert (= n bn))
(assert (= b Anon_50))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (<= 0 b))
(assert (<= b 2))
(assert (= n_2627 cn))
(assert (<= 0 n_2627))
(assert (<= n_2627 n))
(assert (or (and (and (and (< lr 1) (= m 0)) (= n 0)) (= b 1)) (and (and (and (and (and (<= 0 b) (<= (+ (- 0 n) 2) b)) (<= b n)) (<= b 2)) (<= 1 m)) (> lr 0))))
(assert (<= b_2665 2))
(assert (<= 0 b_2665))
(assert (<= Anon_49 2))
(assert (<= 0 Anon_49))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (= b_2665 Anon_49))
(assert (= v_int_202_2657 (+ 1 n)))
(assert (= m_2663 am))
(assert (= n_2664 an))
(assert (<= 0 m_2663))
(assert (<= 0 n_2664))
(assert (<= v_int_202_2657 n_2664))
(assert (= v_int_203_2708 (+ 1 n_2664)))
(assert (or (and (and (and (< ll 1) (= m_2663 0)) (= n_2664 0)) (= b_2665 1)) (and (and (and (and (and (<= 0 b_2665) (<= (+ (- 0 n_2664) 2) b_2665)) (<= b_2665 n_2664)) (<= b_2665 2)) (<= 1 m_2663)) (> ll 0))))
;Negation of Consequence
(assert (not (or (= m_2663 0) (or (= n_2664 0) (< ll 1)))))
(check-sat)