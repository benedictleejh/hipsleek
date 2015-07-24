(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun b_2998 () Int)
(declare-fun ba3 () Int)
(declare-fun n_2997 () Int)
(declare-fun cn () Int)
(declare-fun m_2996 () Int)
(declare-fun cm () Int)
(declare-fun v_node_162_1527_primed () Int)
(declare-fun rr () Int)
(declare-fun height_161_2985 () Int)
(declare-fun Anon_47 () Int)
(declare-fun v_int_161_2990 () Int)
(declare-fun ba2 () Int)
(declare-fun bn () Int)
(declare-fun bm () Int)
(declare-fun ba1 () Int)
(declare-fun an () Int)
(declare-fun am () Int)
(declare-fun left_160_2944 () Int)
(declare-fun right_159_2941 () Int)
(declare-fun r () Int)
(declare-fun k1 () Int)
(declare-fun n () Int)
(declare-fun b () Int)
(declare-fun m () Int)
(declare-fun l () Int)
(declare-fun n_2960 () Int)
(declare-fun b_2961 () Int)
(declare-fun m_2959 () Int)
(declare-fun rl () Int)
(declare-fun k2_primed () Int)
(declare-fun k1_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= b_2998 ba3))
(assert (= n_2997 cn))
(assert (= m_2996 cm))
(assert (= v_node_162_1527_primed rr))
(assert (= height_161_2985 Anon_47))
(assert (= v_int_161_2990 (+ 1 n)))
(assert (<= n_2960 n))
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
(assert (= k2_primed r))
(assert (= k1_primed k1))
(assert (= k2_primed 1))
(assert (or (and (and (and (< l 1) (= m 0)) (= n 0)) (= b 1)) (and (and (and (and (and (<= 0 b) (<= (+ (- 0 n) 2) b)) (<= b n)) (<= b 2)) (<= 1 m)) (> l 0))))
(assert (or (and (and (and (< rl 1) (= m_2959 0)) (= n_2960 0)) (= b_2961 1)) (and (and (and (and (and (<= 0 b_2961) (<= (+ (- 0 n_2960) 2) b_2961)) (<= b_2961 n_2960)) (<= b_2961 2)) (<= 1 m_2959)) (> rl 0))))
(assert (= k1_primed 2))
(assert (not (= k2_primed k1_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)