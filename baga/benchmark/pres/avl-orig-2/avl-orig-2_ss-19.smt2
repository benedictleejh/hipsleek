(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun k2 () Int)
(declare-fun left_200_2608 () Int)
(declare-fun l () Int)
(declare-fun right_201_2611 () Int)
(declare-fun lr () Int)
(declare-fun bm () Int)
(declare-fun bn () Int)
(declare-fun Anon_50 () Int)
(declare-fun res () Int)
(declare-fun m () Int)
(declare-fun n () Int)
(declare-fun b () Int)
(declare-fun cn () Int)
(declare-fun Anon_46 () Int)
(declare-fun cm () Int)
(declare-fun r () Int)
(declare-fun an () Int)
(declare-fun Anon_49 () Int)
(declare-fun am () Int)
(declare-fun ll () Int)
(declare-fun n_2619 () Int)
(declare-fun b_2620 () Int)
(declare-fun m_2618 () Int)
(declare-fun v_node_202_1655_primed () Int)
(declare-fun k2_primed () Int)
(declare-fun k1_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= k2_primed k2))
(assert (= k1_primed l))
(assert (= left_200_2608 l))
(assert (= right_201_2611 lr))
(assert (= v_node_202_1655_primed lr))
(assert (= m bm))
(assert (= n bn))
(assert (= b Anon_50))
(assert (<= 0 bm))
(assert (<= 0 bn))
(assert (<= 0 Anon_50))
(assert (<= Anon_50 2))
(assert (= res n))
(assert (= m_2618 m))
(assert (= n_2619 n))
(assert (= b_2620 b))
(assert (<= 0 m))
(assert (<= 0 n))
(assert (<= 0 b))
(assert (<= b 2))
(assert (or (and (and (and (< r 1) (= cm 0)) (= cn 0)) (= Anon_46 1)) (and (and (and (and (and (<= 0 Anon_46) (<= (+ (- 0 cn) 2) Anon_46)) (<= Anon_46 cn)) (<= Anon_46 2)) (<= 1 cm)) (> r 0))))
(assert (or (and (and (and (< ll 1) (= am 0)) (= an 0)) (= Anon_49 1)) (and (and (and (and (and (<= 0 Anon_49) (<= (+ (- 0 an) 2) Anon_49)) (<= Anon_49 an)) (<= Anon_49 2)) (<= 1 am)) (> ll 0))))
(assert (= k2_primed 1))
(assert (= k1_primed 2))
(assert (or (and (and (and (< v_node_202_1655_primed 1) (= m_2618 0)) (= n_2619 0)) (= b_2620 1)) (and (and (and (and (and (<= 0 b_2620) (<= (+ (- 0 n_2619) 2) b_2620)) (<= b_2620 n_2619)) (<= b_2620 2)) (<= 1 m_2618)) (> v_node_202_1655_primed 0))))
(assert (not (= k2_primed k1_primed)))
;Negation of Consequence
(assert (not false))
(check-sat)