(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun height_162_3038 () Int)
(declare-fun Anon_49 () Int)
(declare-fun v_int_162_3115 () Int)
(declare-fun b_2998 () Int)
(declare-fun ba3 () Int)
(declare-fun n_2997 () Int)
(declare-fun cn () Int)
(declare-fun m_2996 () Int)
(declare-fun cm () Int)
(declare-fun height_161_2984 () Int)
(declare-fun Anon_47 () Int)
(declare-fun v_int_161_2992 () Int)
(declare-fun b_2961 () Int)
(declare-fun ba2 () Int)
(declare-fun n_2960 () Int)
(declare-fun bn () Int)
(declare-fun m_2959 () Int)
(declare-fun bm () Int)
(declare-fun b () Int)
(declare-fun ba1 () Int)
(declare-fun n () Int)
(declare-fun an () Int)
(declare-fun m () Int)
(declare-fun am () Int)
(declare-fun left_160_2944 () Int)
(declare-fun rl () Int)
(declare-fun right_159_2941 () Int)
(declare-fun r () Int)
(declare-fun k1_primed () Int)
(declare-fun k1 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res r))
(assert (= height_162_3038 Anon_49))
(assert (= v_int_162_3115 (+ 1 n_2997)))
(assert (<= v_int_161_2992 n_2997))
(assert (<= b_2998 2))
(assert (<= 0 b_2998))
(assert (<= 0 n_2997))
(assert (<= 0 m_2996))
(assert (<= ba3 2))
(assert (<= 0 ba3))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (= b_2998 ba3))
(assert (= n_2997 cn))
(assert (= m_2996 cm))
(assert (= height_161_2984 Anon_47))
(assert (= v_int_161_2992 (+ 1 n_2960)))
(assert (< n n_2960))
(assert (<= b_2961 2))
(assert (<= 0 b_2961))
(assert (<= 0 n_2960))
(assert (<= 0 m_2959))
(assert (<= ba2 2))
(assert (<= 0 ba2))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (= b_2961 ba2))
(assert (= n_2960 bn))
(assert (= m_2959 bm))
(assert (<= b 2))
(assert (<= 0 b))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (<= ba1 2))
(assert (<= 0 ba1))
(assert (<= 0 an))
(assert (<= 0 am))
(assert (= b ba1))
(assert (= n an))
(assert (= m am))
(assert (= left_160_2944 rl))
(assert (= right_159_2941 r))
(assert (= k1_primed k1))
;Negation of Consequence
(assert (not false))
(check-sat)