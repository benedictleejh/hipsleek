(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun d_2208 () Int)
(declare-fun d_2151 () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun bg () Int)
(declare-fun sm () Int)
(declare-fun n () Int)
(declare-fun next_49_2158 () Int)
(declare-fun res () Int)
(declare-fun sm_2148 () Int)
(declare-fun bg_2149 () Int)
(declare-fun flted_9_2150 () Int)
(declare-fun p_2152 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (exists ((sm_2225 Int)) (<= sm_2225 d_2208)))
(assert (exists ((bg_2224 Int)) (<= d_2208 bg_2224)))
(assert (= d_2208 d_2151))
(assert (<= sm d_2151))
(assert (<= d_2151 bg))
(assert (= a_primed 1))
(assert (= a_primed a))
(assert (< 0 a))
(assert (< a n))
(assert (= bg_2149 bg))
(assert (= sm_2148 sm))
(assert (= (+ flted_9_2150 1) n))
(assert (= next_49_2158 p_2152))
(assert (= res p_2152))
(assert (or (and (< p_2152 1) (= flted_9_2150 0)) (and (and (<= sm_2148 bg_2149) (<= 1 flted_9_2150)) (> p_2152 0))))
;Negation of Consequence
(assert (not (or (= flted_9_2150 0) (< p_2152 1))))
(check-sat)