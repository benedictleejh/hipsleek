(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun height_203_2707 () Int)
(declare-fun Anon_48 () Int)
(declare-fun v_int_203_2708 () Int)
(declare-fun b_2665 () Int)
(declare-fun Anon_49 () Int)
(declare-fun n_2664 () Int)
(declare-fun an () Int)
(declare-fun m_2663 () Int)
(declare-fun am () Int)
(declare-fun height_202_2652 () Int)
(declare-fun Anon_45 () Int)
(declare-fun v_int_202_2657 () Int)
(declare-fun b_2628 () Int)
(declare-fun Anon_46 () Int)
(declare-fun n_2627 () Int)
(declare-fun cn () Int)
(declare-fun m_2626 () Int)
(declare-fun cm () Int)
(declare-fun b () Int)
(declare-fun Anon_50 () Int)
(declare-fun n () Int)
(declare-fun bn () Int)
(declare-fun m () Int)
(declare-fun bm () Int)
(declare-fun right_201_2611 () Int)
(declare-fun lr () Int)
(declare-fun left_200_2608 () Int)
(declare-fun l () Int)
(declare-fun k2_primed () Int)
(declare-fun k2 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res l))
(assert (= height_203_2707 Anon_48))
(assert (= v_int_203_2708 (+ 1 n_2664)))
(assert (<= v_int_202_2657 n_2664))
(assert (<= b_2665 2))
(assert (<= 0 b_2665))
(assert (<= 0 n_2664))
(assert (<= 0 m_2663))
(assert (<= Anon_49 2))
(assert (<= 0 Anon_49))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (= b_2665 Anon_49))
(assert (= n_2664 an))
(assert (= m_2663 am))
(assert (= height_202_2652 Anon_45))
(assert (= v_int_202_2657 (+ 1 n)))
(assert (<= n_2627 n))
(assert (<= b_2628 2))
(assert (<= 0 b_2628))
(assert (<= 0 n_2627))
(assert (<= 0 m_2626))
(assert (<= Anon_46 2))
(assert (<= 0 Anon_46))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (= b_2628 Anon_46))
(assert (= n_2627 cn))
(assert (= m_2626 cm))
(assert (<= b 2))
(assert (<= 0 b))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (<= Anon_50 2))
(assert (<= 0 Anon_50))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (= b Anon_50))
(assert (= n bn))
(assert (= m bm))
(assert (= right_201_2611 lr))
(assert (= left_200_2608 l))
(assert (= k2_primed k2))
;Negation of Consequence
(assert (not false))
(check-sat)