(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhr_11264 () Int)
(declare-fun nr_11263 () Int)
(declare-fun nb () Int)
(declare-fun bhl_11261 () Int)
(declare-fun h () Int)
(declare-fun nl_11260 () Int)
(declare-fun na () Int)
(declare-fun r_11262 () Int)
(declare-fun l_11259 () Int)
(declare-fun v_11258 () Int)
(declare-fun v_int_175_11178 () Int)
(declare-fun v_int_175_11177 () Int)
(declare-fun flted_169_11173 () Int)
(declare-fun flted_169_11175 () Int)
(declare-fun flted_169_11176 () Int)
(declare-fun color_primed () Int)
(declare-fun color () Int)
(declare-fun d_primed () Int)
(declare-fun d () Int)
(declare-fun c_primed () Int)
(declare-fun c () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun nb_10927 () Int)
(declare-fun nc () Int)
(declare-fun Anon_19 () Int)
(declare-fun flted_169_11174 () Int)
(declare-fun nc_10928 () Int)
(declare-fun nd () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhr_11264 h))
(assert (= nr_11263 nb))
(assert (= bhl_11261 h))
(assert (= nl_11260 na))
(assert (= r_11262 b_primed))
(assert (= l_11259 a_primed))
(assert (= v_11258 v_int_175_11177))
(assert (= v_int_175_11178 1))
(assert (= v_int_175_11177 0))
(assert (= color 1))
(assert (= flted_169_11173 0))
(assert (= flted_169_11174 0))
(assert (= flted_169_11175 0))
(assert (= flted_169_11176 0))
(assert (= color_primed color))
(assert (= d_primed d))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= nb_10927 nc))
(assert (= Anon_19 flted_169_11174))
(assert (= nc_10928 nd))
;Negation of Consequence
(assert (not false))
(check-sat)