(set-info :source loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
(set-info :smt-lib-version 2.0) 
(set-info :status  sat) 
;Variables declarations
(declare-fun v_int_135_1706_primed () Int)
(declare-fun v_int_135_1707_primed () Int)
(declare-fun ba3 () Int)
(declare-fun cn () Int)
(declare-fun cm () Int)
(declare-fun ba2 () Int)
(declare-fun bn () Int)
(declare-fun bm () Int)
(declare-fun right_134_2648 () Int)
(declare-fun left_133_2645 () Int)
(declare-fun l () Int)
(declare-fun k2 () Int)
(declare-fun an () Int)
(declare-fun ba1 () Int)
(declare-fun am () Int)
(declare-fun ll () Int)
(declare-fun n () Int)
(declare-fun b () Int)
(declare-fun m () Int)
(declare-fun lr () Int)
(declare-fun n_2664 () Int)
(declare-fun b_2665 () Int)
(declare-fun m_2663 () Int)
(declare-fun r () Int)
(declare-fun k2_primed () Int)
(declare-fun k1_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= v_int_135_1706_primed 1))
(assert (<= n_2664 n))
(assert (= v_int_135_1707_primed n))
(assert (<= b_2665 2))
(assert (<= 0 b_2665))
(assert (<= 0 n_2664))
(assert (<= 0 m_2663))
(assert (<= ba3 2))
(assert (<= 0 ba3))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (= b_2665 ba3))
(assert (= n_2664 cn))
(assert (= m_2663 cm))
(assert (<= b 2))
(assert (<= 0 b))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (<= ba2 2))
(assert (<= 0 ba2))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (= b ba2))
(assert (= n bn))
(assert (= m bm))
(assert (= right_134_2648 lr))
(assert (= left_133_2645 l))
(assert (= k1_primed l))
(assert (= k2_primed k2))
(assert (or (and (and (and (< ll 1) (= am 0)) (= an 0)) (= ba1 1)) (and (and (and (and (and (<= 0 ba1) (<= (+ (- 0 an) 2) ba1)) (<= ba1 an)) (<= ba1 2)) (<= 1 am)) (> ll 0))))
(assert (= k2_primed 1))
(assert (= k1_primed 2))
(assert (or (and (and (and (< lr 1) (= m 0)) (= n 0)) (= b 1)) (and (and (and (and (and (<= 0 b) (<= (+ (- 0 n) 2) b)) (<= b n)) (<= b 2)) (<= 1 m)) (> lr 0))))
(assert (or (and (and (and (< r 1) (= m_2663 0)) (= n_2664 0)) (= b_2665 1)) (and (and (and (and (and (<= 0 b_2665) (<= (+ (- 0 n_2664) 2) b_2665)) (<= b_2665 n_2664)) (<= b_2665 2)) (<= 1 m_2663)) (> r 0))))
(assert (not (= k2_primed k1_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)