(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun mx1_4056 () Int)
(declare-fun res () Int)
(declare-fun v_node_28_1766_primed () Int)
(declare-fun v () Int)
(declare-fun t_primed () Int)
(declare-fun v_bool_27_1962_primed () Int)
(declare-fun d_4053 () Int)
(declare-fun v_primed () Int)
(declare-fun m1_4055 () Int)
(declare-fun v_int_28_4048 () Int)
(declare-fun m2_4058 () Int)
(declare-fun v_int_28_4049 () Int)
(declare-fun l_4054 () Int)
(declare-fun r_4057 () Int)
(declare-fun tmp_4050 () Int)
(declare-fun mx () Int)
(declare-fun n () Int)
(declare-fun t () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= mx1_4056 0))
(assert (= res v_node_28_1766_primed))
(assert (= v_int_28_4049 0))
(assert (= v_int_28_4048 0))
(assert (= t_primed t))
(assert (= v_primed v))
(assert (<= 0 v))
(assert (< tmp_4050 1))
(assert (< t_primed 1))
(assert (> v_bool_27_1962_primed 0))
(assert (= d_4053 v_primed))
(assert (= m1_4055 v_int_28_4048))
(assert (= m2_4058 v_int_28_4049))
(assert (= l_4054 tmp_4050))
(assert (= r_4057 tmp_4050))
(assert (or (and (and (< t 1) (= n 0)) (= mx 0)) (and (and (<= 0 mx) (<= 1 n)) (> t 0))))
;Negation of Consequence
(assert (not false))
(check-sat)