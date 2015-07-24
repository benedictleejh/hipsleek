(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun v_node_130_4726_primed () Int)
(declare-fun v_int_128_7016 () Int)
(declare-fun v_int_128_7015 () Int)
(declare-fun color_127_6236 () Int)
(declare-fun flted_12_6224 () Int)
(declare-fun flted_120_6234 () Int)
(declare-fun nc () Int)
(declare-fun a_primed () Int)
(declare-fun b_primed () Int)
(declare-fun c () Int)
(declare-fun color_primed () Int)
(declare-fun color () Int)
(declare-fun h_6233 () Int)
(declare-fun v_int_127_7014 () Int)
(declare-fun v_7032 () Int)
(declare-fun v_int_130_7017 () Int)
(declare-fun l_7033 () Int)
(declare-fun r_7037 () Int)
(declare-fun flted_120_6235 () Int)
(declare-fun h () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun Anon_18 () Int)
(declare-fun h_6232 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_12_6223 () Int)
(declare-fun bhl_6228 () Int)
(declare-fun nl_6227 () Int)
(declare-fun l_6226 () Int)
(declare-fun flted_12_6222 () Int)
(declare-fun bhr_6231 () Int)
(declare-fun nr_6230 () Int)
(declare-fun r_6229 () Int)
(declare-fun c_primed () Int)
(declare-fun tmp_7018 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res v_node_130_4726_primed))
(assert (= v_int_130_7017 0))
(assert (= v_int_128_7016 0))
(assert (= v_int_128_7015 0))
(assert (= color_127_6236 flted_12_6224))
(assert (= flted_12_6224 1))
(assert (= flted_12_6223 0))
(assert (= flted_12_6222 0))
(assert (= flted_120_6234 1))
(assert (= nc (+ (+ nr_6230 1) nl_6227)))
(assert (= bhl_6228 h_6233))
(assert (= bhr_6231 h_6233))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= color_primed color))
(assert (= flted_120_6235 0))
(assert (= color 1))
(assert (= h_6232 h))
(assert (= h_6233 h))
(assert (= v_int_127_7014 0))
(assert (= v_7032 v_int_130_7017))
(assert (= l_7033 tmp_7018))
(assert (= r_7037 c_primed))
(assert (or (and (and (and (= flted_120_6235 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_120_6235 0)) (and (and (and (= flted_120_6235 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= Anon_18 0) (<= 2 h_6232)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h_6232 1)) (= Anon_18 0)) (and (and (and (= Anon_18 1) (<= 1 h_6232)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_12_6223 0) (<= 2 bhl_6228)) (<= 1 nl_6227)) (> l_6226 0)) (or (and (and (and (< l_6226 1) (= nl_6227 0)) (= bhl_6228 1)) (= flted_12_6223 0)) (and (and (and (= flted_12_6223 1) (<= 1 bhl_6228)) (<= 1 nl_6227)) (> l_6226 0)))))
(assert (or (and (and (and (= flted_12_6222 0) (<= 2 bhr_6231)) (<= 1 nr_6230)) (> r_6229 0)) (or (and (and (and (< r_6229 1) (= nr_6230 0)) (= bhr_6231 1)) (= flted_12_6222 0)) (and (and (and (= flted_12_6222 1) (<= 1 bhr_6231)) (<= 1 nr_6230)) (> r_6229 0)))))
(assert (= c_primed 1))
(assert (= tmp_7018 2))
(assert (not (= c_primed tmp_7018)))
;Negation of Consequence
(assert (not false))
(check-sat)