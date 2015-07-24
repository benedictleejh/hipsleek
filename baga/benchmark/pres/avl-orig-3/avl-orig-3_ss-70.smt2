(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun cm () Int)
(declare-fun ba3 () Int)
(declare-fun b_2665 () Int)
(declare-fun m_2663 () Int)
(declare-fun r () Int)
(declare-fun right_134_2648 () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun ba2 () Int)
(declare-fun cn () Int)
(declare-fun n_2664 () Int)
(declare-fun b () Int)
(declare-fun m () Int)
(declare-fun lr () Int)
(declare-fun ba1 () Int)
(declare-fun n () Int)
(declare-fun am () Int)
(declare-fun an () Int)
(declare-fun v_int_135_2694 () Int)
(declare-fun v_int_136_2745 () Int)
(declare-fun b_2702 () Int)
(declare-fun m_2700 () Int)
(declare-fun n_2701 () Int)
(declare-fun ll () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= ba3 2))
(assert (<= 0 ba3))
(assert (<= 0 cm))
(assert (= m_2663 cm))
(assert (= b_2665 ba3))
(assert (<= 0 m_2663))
(assert (<= 0 b_2665))
(assert (<= b_2665 2))
(assert (or (and (and (and (< r 1) (= m_2663 0)) (= n_2664 0)) (= b_2665 1)) (and (and (and (and (and (<= 0 b_2665) (<= (+ (- 0 n_2664) 2) b_2665)) (<= b_2665 n_2664)) (<= b_2665 2)) (<= 1 m_2663)) (> r 0))))
(assert (<= 0 cn))
(assert (<= ba2 2))
(assert (<= 0 ba2))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (= right_134_2648 lr))
(assert (= m bm))
(assert (= n bn))
(assert (= b ba2))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (<= 0 b))
(assert (<= b 2))
(assert (= n_2664 cn))
(assert (<= 0 n_2664))
(assert (<= n_2664 n))
(assert (or (and (and (and (< lr 1) (= m 0)) (= n 0)) (= b 1)) (and (and (and (and (and (<= 0 b) (<= (+ (- 0 n) 2) b)) (<= b n)) (<= b 2)) (<= 1 m)) (> lr 0))))
(assert (<= b_2702 2))
(assert (<= 0 b_2702))
(assert (<= ba1 2))
(assert (<= 0 ba1))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (= b_2702 ba1))
(assert (= v_int_135_2694 (+ 1 n)))
(assert (= m_2700 am))
(assert (= n_2701 an))
(assert (<= 0 m_2700))
(assert (<= 0 n_2701))
(assert (<= v_int_135_2694 n_2701))
(assert (= v_int_136_2745 (+ 1 n_2701)))
(assert (or (and (and (and (< ll 1) (= m_2700 0)) (= n_2701 0)) (= b_2702 1)) (and (and (and (and (and (<= 0 b_2702) (<= (+ (- 0 n_2701) 2) b_2702)) (<= b_2702 n_2701)) (<= b_2702 2)) (<= 1 m_2700)) (> ll 0))))
;Negation of Consequence
(assert (not (or (= m_2700 0) (or (= n_2701 0) (< ll 1)))))
(check-sat)