(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun v_boolean_106_4794_primed () Int)
(declare-fun x_primed () Int)
(declare-fun res () Int)
(declare-fun n () Int)
(declare-fun cl () Int)
(declare-fun bh () Int)
(declare-fun cl_8082 () Int)
(declare-fun bh_8083 () Int)
(declare-fun n_8081 () Int)
(declare-fun x () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (> v_boolean_106_4794_primed 0))
(assert (or (= n 0) (< x 1)))
(assert (= res v_boolean_106_4794_primed))
(assert (= x_primed x))
(assert (< x_primed 1))
(assert (= cl 0))
(assert (= bh 1))
(assert (= n 0))
(assert (< x 1))
(assert (= cl 1))
(assert (not (> res 0)))
(assert (= n_8081 n))
(assert (= cl_8082 cl))
(assert (= bh_8083 bh))
(assert (or (and (and (and (= cl_8082 0) (<= 2 bh_8083)) (<= 1 n_8081)) (> x 0)) (or (and (and (and (< x 1) (= n_8081 0)) (= bh_8083 1)) (= cl_8082 0)) (and (and (and (= cl_8082 1) (<= 1 bh_8083)) (<= 1 n_8081)) (> x 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)