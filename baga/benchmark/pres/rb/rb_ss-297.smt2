(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun v_node_130_4726_primed () Int)
(declare-fun v_int_128_6500 () Int)
(declare-fun v_int_128_6499 () Int)
(declare-fun color_127_6237 () Int)
(declare-fun flted_12_6210 () Int)
(declare-fun flted_119_6220 () Int)
(declare-fun nc () Int)
(declare-fun a_primed () Int)
(declare-fun b_primed () Int)
(declare-fun c () Int)
(declare-fun color_primed () Int)
(declare-fun color () Int)
(declare-fun h_6219 () Int)
(declare-fun v_int_127_6498 () Int)
(declare-fun v_6516 () Int)
(declare-fun v_int_130_6501 () Int)
(declare-fun l_6517 () Int)
(declare-fun r_6521 () Int)
(declare-fun flted_119_6221 () Int)
(declare-fun h () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun Anon_17 () Int)
(declare-fun h_6218 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_12_6209 () Int)
(declare-fun bhl_6214 () Int)
(declare-fun nl_6213 () Int)
(declare-fun l_6212 () Int)
(declare-fun flted_12_6208 () Int)
(declare-fun bhr_6217 () Int)
(declare-fun nr_6216 () Int)
(declare-fun r_6215 () Int)
(declare-fun c_primed () Int)
(declare-fun tmp_6502 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= res v_node_130_4726_primed))
(assert (= v_int_130_6501 0))
(assert (= v_int_128_6500 0))
(assert (= v_int_128_6499 0))
(assert (= color_127_6237 flted_12_6210))
(assert (= flted_12_6210 1))
(assert (= flted_12_6209 0))
(assert (= flted_12_6208 0))
(assert (= flted_119_6220 1))
(assert (= nc (+ (+ nr_6216 1) nl_6213)))
(assert (= bhl_6214 h_6219))
(assert (= bhr_6217 h_6219))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= color_primed color))
(assert (= flted_119_6221 0))
(assert (= color 0))
(assert (= h_6218 h))
(assert (= h_6219 h))
(assert (= v_int_127_6498 0))
(assert (= v_6516 v_int_130_6501))
(assert (= l_6517 tmp_6502))
(assert (= r_6521 c_primed))
(assert (or (and (and (and (= flted_119_6221 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_119_6221 0)) (and (and (and (= flted_119_6221 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (or (and (and (and (= Anon_17 0) (<= 2 h_6218)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h_6218 1)) (= Anon_17 0)) (and (and (and (= Anon_17 1) (<= 1 h_6218)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_12_6209 0) (<= 2 bhl_6214)) (<= 1 nl_6213)) (> l_6212 0)) (or (and (and (and (< l_6212 1) (= nl_6213 0)) (= bhl_6214 1)) (= flted_12_6209 0)) (and (and (and (= flted_12_6209 1) (<= 1 bhl_6214)) (<= 1 nl_6213)) (> l_6212 0)))))
(assert (or (and (and (and (= flted_12_6208 0) (<= 2 bhr_6217)) (<= 1 nr_6216)) (> r_6215 0)) (or (and (and (and (< r_6215 1) (= nr_6216 0)) (= bhr_6217 1)) (= flted_12_6208 0)) (and (and (and (= flted_12_6208 1) (<= 1 bhr_6217)) (<= 1 nr_6216)) (> r_6215 0)))))
(assert (= c_primed 1))
(assert (= tmp_6502 2))
(assert (not (= c_primed tmp_6502)))
;Negation of Consequence
(assert (not false))
(check-sat)