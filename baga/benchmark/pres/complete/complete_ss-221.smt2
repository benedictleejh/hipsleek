(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nmin_2133 () Int)
(declare-fun n_2132 () Int)
(declare-fun t () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun v_bool_83_1430_primed () Int)
(declare-fun nmin () Int)
(declare-fun nmin1_2126 () Int)
(declare-fun flted_26_2123 () Int)
(declare-fun n () Int)
(declare-fun res () Int)
(declare-fun v_int_88_1344_primed () Int)
(declare-fun v_int_88_1343_primed () Int)
(declare-fun t_primed () Int)
(declare-fun nmin2_2128 () Int)
(declare-fun flted_26_2122 () Int)
(declare-fun r_2127 () Int)
(declare-fun nmin_2151 () Int)
(declare-fun n_2150 () Int)
(declare-fun l_2125 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= nmin_2151 n_2150))
(assert (<= 0 nmin_2151))
(assert (= v_int_88_1343_primed n_2150))
(assert (<= nmin_2133 n_2132))
(assert (<= 0 nmin_2133))
(assert (= nmin_2151 nmin_2133))
(assert (= n_2150 n_2132))
(assert (= v_int_88_1344_primed nmin_2133))
(assert (<= nmin1_2126 flted_26_2123))
(assert (<= 0 nmin1_2126))
(assert (= nmin_2133 nmin1_2126))
(assert (= n_2132 flted_26_2123))
(assert (= t_primed t))
(assert (= v_primed v))
(assert (< nmin n))
(assert (> t_primed 0))
(assert (not (> v_bool_83_1430_primed 0)))
(assert (exists ((min_32 Int)) (and (= nmin (+ 1 min_32)) (or (and (= min_32 nmin1_2126) (< nmin1_2126 nmin2_2128)) (and (= min_32 nmin2_2128) (>= nmin1_2126 nmin2_2128))))))
(assert (= (+ flted_26_2122 1) n))
(assert (= (+ flted_26_2123 1) n))
(assert (> res 0))
(assert (< v_int_88_1344_primed v_int_88_1343_primed))
(assert (= t_primed 1))
(assert (or (and (and (<= 1 nmin2_2128) (<= nmin2_2128 flted_26_2122)) (> r_2127 0)) (or (and (and (< r_2127 1) (= flted_26_2122 0)) (= nmin2_2128 0)) (and (and (<= 1 nmin2_2128) (< nmin2_2128 flted_26_2122)) (> r_2127 0)))))
(assert (or (and (and (<= 1 nmin_2151) (<= nmin_2151 n_2150)) (> l_2125 0)) (or (and (and (< l_2125 1) (= n_2150 0)) (= nmin_2151 0)) (and (and (<= 1 nmin_2151) (< nmin_2151 n_2150)) (> l_2125 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)