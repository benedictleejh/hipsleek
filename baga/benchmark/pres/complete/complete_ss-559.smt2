(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_2852 () Int)
(declare-fun l_2850 () Int)
(declare-fun Anon_2849 () Int)
(declare-fun v_bool_83_1430_primed () Int)
(declare-fun v_primed () Int)
(declare-fun v () Int)
(declare-fun t_2650 () Int)
(declare-fun v_null_type_84_2838 () Int)
(declare-fun v_null_type_84_2839 () Int)
(declare-fun nmin1_2851 () Int)
(declare-fun nmin2_2853 () Int)
(declare-fun nmin () Int)
(declare-fun n () Int)
(declare-fun t () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= r_2852 v_null_type_84_2839))
(assert (= l_2850 v_null_type_84_2838))
(assert (= Anon_2849 v_primed))
(assert (> v_bool_83_1430_primed 0))
(assert (< t_2650 1))
(assert (= nmin n))
(assert (= v_primed v))
(assert (= t_2650 t))
(assert (< v_null_type_84_2838 1))
(assert (< v_null_type_84_2839 1))
(assert (= nmin1_2851 0))
(assert (= nmin2_2853 0))
(assert (or (and (and (<= 1 nmin) (<= nmin n)) (> t 0)) (or (and (and (< t 1) (= n 0)) (= nmin 0)) (and (and (<= 1 nmin) (< nmin n)) (> t 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)