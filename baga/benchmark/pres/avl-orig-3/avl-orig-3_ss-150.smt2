(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun am () Int)
(declare-fun ba1 () Int)
(declare-fun cm () Int)
(declare-fun cn () Int)
(declare-fun ba3 () Int)
(declare-fun b_2998 () Int)
(declare-fun m_2996 () Int)
(declare-fun rr () Int)
(declare-fun b () Int)
(declare-fun m () Int)
(declare-fun l () Int)
(declare-fun v_int_162_3078 () Int)
(declare-fun n_2997 () Int)
(declare-fun v_int_161_2990 () Int)
(declare-fun ba2 () Int)
(declare-fun an () Int)
(declare-fun left_160_2944 () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun n () Int)
(declare-fun b_2961 () Int)
(declare-fun m_2959 () Int)
(declare-fun n_2960 () Int)
(declare-fun rl () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= ba3 2))
(assert (<= 0 ba3))
(assert (<= 0 cn))
(assert (<= 0 cm))
(assert (<= ba1 2))
(assert (<= 0 ba1))
(assert (<= 0 am))
(assert (= m am))
(assert (= b ba1))
(assert (<= 0 m))
(assert (<= 0 b))
(assert (<= b 2))
(assert (= m_2996 cm))
(assert (= n_2997 cn))
(assert (= b_2998 ba3))
(assert (<= 0 m_2996))
(assert (<= 0 n_2997))
(assert (<= 0 b_2998))
(assert (<= b_2998 2))
(assert (or (and (and (and (< rr 1) (= m_2996 0)) (= n_2997 0)) (= b_2998 1)) (and (and (and (and (and (<= 0 b_2998) (<= (+ (- 0 n_2997) 2) b_2998)) (<= b_2998 n_2997)) (<= b_2998 2)) (<= 1 m_2996)) (> rr 0))))
(assert (or (and (and (and (< l 1) (= m 0)) (= n 0)) (= b 1)) (and (and (and (and (and (<= 0 b) (<= (+ (- 0 n) 2) b)) (<= b n)) (<= b 2)) (<= 1 m)) (> l 0))))
(assert (= v_int_162_3078 (+ 1 v_int_161_2990)))
(assert (< n_2997 v_int_161_2990))
(assert (= v_int_161_2990 (+ 1 n)))
(assert (<= b_2961 2))
(assert (<= 0 b_2961))
(assert (<= ba2 2))
(assert (<= 0 ba2))
(assert (<= 0 bn))
(assert (<= 0 bm))
(assert (= b_2961 ba2))
(assert (<= 0 n))
(assert (<= 0 an))
(assert (= n an))
(assert (= left_160_2944 rl))
(assert (= m_2959 bm))
(assert (= n_2960 bn))
(assert (<= 0 m_2959))
(assert (<= 0 n_2960))
(assert (<= n_2960 n))
(assert (or (and (and (and (< rl 1) (= m_2959 0)) (= n_2960 0)) (= b_2961 1)) (and (and (and (and (and (<= 0 b_2961) (<= (+ (- 0 n_2960) 2) b_2961)) (<= b_2961 n_2960)) (<= b_2961 2)) (<= 1 m_2959)) (> rl 0))))
;Negation of Consequence
(assert (not (or (= m_2959 0) (or (= n_2960 0) (< rl 1)))))
(check-sat)