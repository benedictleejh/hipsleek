(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun height_136_2744 () Int)
(declare-fun Anon_43 () Int)
(declare-fun v_int_136_2745 () Int)
(declare-fun b_2702 () Int)
(declare-fun ba1 () Int)
(declare-fun n_2701 () Int)
(declare-fun an () Int)
(declare-fun m_2700 () Int)
(declare-fun am () Int)
(declare-fun height_135_2689 () Int)
(declare-fun Anon_41 () Int)
(declare-fun v_int_135_2694 () Int)
(declare-fun b_2665 () Int)
(declare-fun ba3 () Int)
(declare-fun n_2664 () Int)
(declare-fun cn () Int)
(declare-fun m_2663 () Int)
(declare-fun cm () Int)
(declare-fun b () Int)
(declare-fun ba2 () Int)
(declare-fun n () Int)
(declare-fun bn () Int)
(declare-fun m () Int)
(declare-fun bm () Int)
(declare-fun right_134_2648 () Int)
(declare-fun lr () Int)
(declare-fun left_133_2645 () Int)
(declare-fun l () Int)
(declare-fun k2_primed () Int)
(declare-fun k2 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res l))
(assert (= height_136_2744 Anon_43))
(assert (= v_int_136_2745 (+ 1 n_2701)))
(assert (<= v_int_135_2694 n_2701))
(assert (<= b_2702 2))
(assert (<= 0 b_2702))
(assert (<= 0 n_2701))
(assert (<= 0 m_2700))
(assert (<= ba1 2))
(assert (<= 0 ba1))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (= b_2702 ba1))
(assert (= n_2701 an))
(assert (= m_2700 am))
(assert (= height_135_2689 Anon_41))
(assert (= v_int_135_2694 (+ 1 n)))
(assert (<= n_2664 n))
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
(assert (= k2_primed k2))
;Negation of Consequence
(assert (not false))
(check-sat)