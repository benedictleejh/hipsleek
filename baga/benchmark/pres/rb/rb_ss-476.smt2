(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_7037 () Int)
(declare-fun l_7033 () Int)
(declare-fun tmp_7018 () Int)
(declare-fun v_7032 () Int)
(declare-fun v_int_127_7014 () Int)
(declare-fun color_primed () Int)
(declare-fun color () Int)
(declare-fun c_primed () Int)
(declare-fun c () Int)
(declare-fun b () Int)
(declare-fun a () Int)
(declare-fun h_6233 () Int)
(declare-fun nc () Int)
(declare-fun flted_120_6234 () Int)
(declare-fun color_127_6236 () Int)
(declare-fun flted_12_6224 () Int)
(declare-fun v_int_128_7016 () Int)
(declare-fun v_int_130_7017 () Int)
(declare-fun res () Int)
(declare-fun v_node_130_4726_primed () Int)
(declare-fun v_7198 () Int)
(declare-fun v_6225 () Int)
(declare-fun l_7199 () Int)
(declare-fun l_6226 () Int)
(declare-fun r_7203 () Int)
(declare-fun r_6229 () Int)
(declare-fun nl_6227 () Int)
(declare-fun Anon_7201 () Int)
(declare-fun flted_12_6223 () Int)
(declare-fun bhl_6228 () Int)
(declare-fun nr_6230 () Int)
(declare-fun Anon_7205 () Int)
(declare-fun flted_12_6222 () Int)
(declare-fun bhr_6231 () Int)
(declare-fun bhr_7206 () Int)
(declare-fun bhr_7040 () Int)
(declare-fun bhl_7202 () Int)
(declare-fun nr_7038 () Int)
(declare-fun nr_7204 () Int)
(declare-fun nl_7200 () Int)
(declare-fun Anon_7039 () Int)
(declare-fun v_7232 () Int)
(declare-fun v_int_128_7015 () Int)
(declare-fun l_7233 () Int)
(declare-fun a_primed () Int)
(declare-fun r_7237 () Int)
(declare-fun b_primed () Int)
(declare-fun na () Int)
(declare-fun Anon_7235 () Int)
(declare-fun flted_120_6235 () Int)
(declare-fun h () Int)
(declare-fun nb () Int)
(declare-fun Anon_7239 () Int)
(declare-fun Anon_18 () Int)
(declare-fun h_6232 () Int)
(declare-fun bhr_7240 () Int)
(declare-fun bhl_7036 () Int)
(declare-fun bhl_7236 () Int)
(declare-fun nl_7034 () Int)
(declare-fun nr_7238 () Int)
(declare-fun nl_7234 () Int)
(declare-fun Anon_7035 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= r_7037 c_primed))
(assert (= l_7033 tmp_7018))
(assert (= v_7032 v_int_130_7017))
(assert (= v_int_127_7014 0))
(assert (= h_6233 h))
(assert (= h_6232 h))
(assert (= color 1))
(assert (= flted_120_6235 0))
(assert (= color_primed color))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= bhr_6231 h_6233))
(assert (= bhl_6228 h_6233))
(assert (= nc (+ (+ nr_6230 1) nl_6227)))
(assert (= flted_120_6234 1))
(assert (= flted_12_6222 0))
(assert (= flted_12_6223 0))
(assert (= flted_12_6224 1))
(assert (= color_127_6236 flted_12_6224))
(assert (= v_int_128_7015 0))
(assert (= v_int_128_7016 0))
(assert (= v_int_130_7017 0))
(assert (= res v_node_130_4726_primed))
(assert (= v_7198 v_6225))
(assert (= l_7199 l_6226))
(assert (= r_7203 r_6229))
(assert (= nl_7200 nl_6227))
(assert (= Anon_7201 flted_12_6223))
(assert (= bhl_7202 bhl_6228))
(assert (= nr_7204 nr_6230))
(assert (= Anon_7205 flted_12_6222))
(assert (= bhr_7206 bhr_6231))
(assert (= bhl_7202 bhr_7206))
(assert (= bhr_7040 (+ bhl_7202 1)))
(assert (= nr_7038 (+ (+ nr_7204 1) nl_7200)))
(assert (= Anon_7039 0))
(assert (= v_7232 v_int_128_7015))
(assert (= l_7233 a_primed))
(assert (= r_7237 b_primed))
(assert (= nl_7234 na))
(assert (= Anon_7235 flted_120_6235))
(assert (= bhl_7236 h))
(assert (= nr_7238 nb))
(assert (= Anon_7239 Anon_18))
(assert (= bhr_7240 h_6232))
(assert (= bhl_7236 bhr_7240))
(assert (= bhl_7036 (+ bhl_7236 1)))
(assert (= nl_7034 (+ (+ nr_7238 1) nl_7234)))
(assert (= Anon_7035 0))
;Negation of Consequence
(assert (not false))
(check-sat)