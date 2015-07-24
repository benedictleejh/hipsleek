(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun b_2961 () Int)
(declare-fun ba2 () Int)
(declare-fun n_2960 () Int)
(declare-fun bn () Int)
(declare-fun m_2959 () Int)
(declare-fun bm () Int)
(declare-fun v_node_161_1507_primed () Int)
(declare-fun v_int_161_1511_primed () Int)
(declare-fun ba1 () Int)
(declare-fun an () Int)
(declare-fun am () Int)
(declare-fun left_160_2944 () Int)
(declare-fun rl () Int)
(declare-fun right_159_2941 () Int)
(declare-fun r () Int)
(declare-fun k1 () Int)
(declare-fun cn () Int)
(declare-fun ba3 () Int)
(declare-fun cm () Int)
(declare-fun rr () Int)
(declare-fun n () Int)
(declare-fun b () Int)
(declare-fun m () Int)
(declare-fun l () Int)
(declare-fun k1_primed () Int)
(declare-fun k2_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= b_2961 ba2))
(assert (= n_2960 bn))
(assert (= m_2959 bm))
(assert (= v_node_161_1507_primed rl))
(assert (<= b 2))
(assert (<= 0 b))
(assert (<= 0 n))
(assert (<= 0 m))
(assert (= v_int_161_1511_primed n))
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
(assert (or (and (and (and (< rr 1) (= cm 0)) (= cn 0)) (= ba3 1)) (and (and (and (and (and (<= 0 ba3) (<= (+ (- 0 cn) 2) ba3)) (<= ba3 cn)) (<= ba3 2)) (<= 1 cm)) (> rr 0))))
(assert (= k1_primed 1))
(assert (= k2_primed 2))
(assert (or (and (and (and (< l 1) (= m 0)) (= n 0)) (= b 1)) (and (and (and (and (and (<= 0 b) (<= (+ (- 0 n) 2) b)) (<= b n)) (<= b 2)) (<= 1 m)) (> l 0))))
(assert (not (= k1_primed k2_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)