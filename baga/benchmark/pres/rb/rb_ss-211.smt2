(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_6260 () Int)
(declare-fun l_6257 () Int)
(declare-fun v_6256 () Int)
(declare-fun v_int_127_6248 () Int)
(declare-fun color_primed () Int)
(declare-fun color () Int)
(declare-fun c_primed () Int)
(declare-fun c () Int)
(declare-fun b_primed () Int)
(declare-fun a_primed () Int)
(declare-fun h_6219 () Int)
(declare-fun nc () Int)
(declare-fun flted_119_6220 () Int)
(declare-fun color_127_6237 () Int)
(declare-fun flted_12_6210 () Int)
(declare-fun v_int_128_6249 () Int)
(declare-fun v_int_128_6250 () Int)
(declare-fun v_int_130_6251 () Int)
(declare-fun res () Int)
(declare-fun v_node_130_4726_primed () Int)
(declare-fun v_6362 () Int)
(declare-fun v_6211 () Int)
(declare-fun l_6363 () Int)
(declare-fun l_6212 () Int)
(declare-fun r_6367 () Int)
(declare-fun r_6215 () Int)
(declare-fun nl_6213 () Int)
(declare-fun Anon_6365 () Int)
(declare-fun flted_12_6209 () Int)
(declare-fun bhl_6214 () Int)
(declare-fun nr_6216 () Int)
(declare-fun Anon_6369 () Int)
(declare-fun flted_12_6208 () Int)
(declare-fun bhr_6217 () Int)
(declare-fun bhr_6370 () Int)
(declare-fun bhr_6262 () Int)
(declare-fun bhl_6366 () Int)
(declare-fun nr_6261 () Int)
(declare-fun nr_6368 () Int)
(declare-fun nl_6364 () Int)
(declare-fun flted_119_6221 () Int)
(declare-fun h () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun Anon_17 () Int)
(declare-fun h_6218 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun tmp_6252 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= r_6260 c_primed))
(assert (= l_6257 tmp_6252))
(assert (= v_6256 v_int_130_6251))
(assert (= v_int_127_6248 0))
(assert (= h_6219 h))
(assert (= h_6218 h))
(assert (= color 0))
(assert (= flted_119_6221 0))
(assert (= color_primed color))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= bhr_6217 h_6219))
(assert (= bhl_6214 h_6219))
(assert (= nc (+ (+ nr_6216 1) nl_6213)))
(assert (= flted_119_6220 1))
(assert (= flted_12_6208 0))
(assert (= flted_12_6209 0))
(assert (= flted_12_6210 1))
(assert (= color_127_6237 flted_12_6210))
(assert (= v_int_128_6249 0))
(assert (= v_int_128_6250 0))
(assert (= v_int_130_6251 0))
(assert (= res v_node_130_4726_primed))
(assert (= v_6362 v_6211))
(assert (= l_6363 l_6212))
(assert (= r_6367 r_6215))
(assert (= nl_6364 nl_6213))
(assert (= Anon_6365 flted_12_6209))
(assert (= bhl_6366 bhl_6214))
(assert (= nr_6368 nr_6216))
(assert (= Anon_6369 flted_12_6208))
(assert (= bhr_6370 bhr_6217))
(assert (= bhl_6366 bhr_6370))
(assert (= bhr_6262 (+ bhl_6366 1)))
(assert (= nr_6261 (+ (+ nr_6368 1) nl_6364)))
(assert (or (and (and (and (= flted_119_6221 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_119_6221 0)) (and (and (and (= flted_119_6221 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= Anon_17 0) (<= 2 h_6218)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h_6218 1)) (= Anon_17 0)) (and (and (and (= Anon_17 1) (<= 1 h_6218)) (<= 1 nb)) (> b 0)))))
(assert (= tmp_6252 1))
;Negation of Consequence
(assert (not false))
(check-sat)