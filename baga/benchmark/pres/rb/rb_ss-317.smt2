(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhr_6724 () Int)
(declare-fun Anon_6723 () Int)
(declare-fun nr_6722 () Int)
(declare-fun bhl_6720 () Int)
(declare-fun Anon_6719 () Int)
(declare-fun nl_6718 () Int)
(declare-fun r_6721 () Int)
(declare-fun r_6215 () Int)
(declare-fun l_6717 () Int)
(declare-fun l_6212 () Int)
(declare-fun v_6716 () Int)
(declare-fun v_6211 () Int)
(declare-fun Anon_6519 () Int)
(declare-fun nl_6518 () Int)
(declare-fun bhl_6520 () Int)
(declare-fun bhr_6690 () Int)
(declare-fun Anon_6689 () Int)
(declare-fun Anon_17 () Int)
(declare-fun nr_6688 () Int)
(declare-fun nb () Int)
(declare-fun bhl_6686 () Int)
(declare-fun Anon_6685 () Int)
(declare-fun nl_6684 () Int)
(declare-fun na () Int)
(declare-fun r_6687 () Int)
(declare-fun l_6683 () Int)
(declare-fun v_6682 () Int)
(declare-fun res () Int)
(declare-fun v_node_130_4726_primed () Int)
(declare-fun v_int_128_6500 () Int)
(declare-fun v_int_128_6499 () Int)
(declare-fun color_127_6237 () Int)
(declare-fun flted_12_6210 () Int)
(declare-fun flted_12_6209 () Int)
(declare-fun flted_12_6208 () Int)
(declare-fun flted_119_6220 () Int)
(declare-fun nc () Int)
(declare-fun nr_6216 () Int)
(declare-fun nl_6213 () Int)
(declare-fun bhl_6214 () Int)
(declare-fun bhr_6217 () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun c () Int)
(declare-fun color_primed () Int)
(declare-fun flted_119_6221 () Int)
(declare-fun color () Int)
(declare-fun h_6218 () Int)
(declare-fun h_6219 () Int)
(declare-fun h () Int)
(declare-fun v_int_127_6498 () Int)
(declare-fun v_6516 () Int)
(declare-fun v_int_130_6501 () Int)
(declare-fun l_6517 () Int)
(declare-fun tmp_6502 () Int)
(declare-fun r_6521 () Int)
(declare-fun c_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhr_6724 bhr_6217))
(assert (= Anon_6723 flted_12_6208))
(assert (= nr_6722 nr_6216))
(assert (= bhl_6720 bhl_6214))
(assert (= Anon_6719 flted_12_6209))
(assert (= nl_6718 nl_6213))
(assert (= r_6721 r_6215))
(assert (= l_6717 l_6212))
(assert (= v_6716 v_6211))
(assert (= Anon_6519 0))
(assert (= nl_6518 (+ (+ nr_6688 1) nl_6684)))
(assert (= bhl_6520 (+ bhl_6686 1)))
(assert (= bhl_6686 bhr_6690))
(assert (= bhr_6690 h_6218))
(assert (= Anon_6689 Anon_17))
(assert (= nr_6688 nb))
(assert (= bhl_6686 h))
(assert (= Anon_6685 flted_119_6221))
(assert (= nl_6684 na))
(assert (= r_6687 b_primed))
(assert (= l_6683 a_primed))
(assert (= v_6682 v_int_128_6499))
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
;Negation of Consequence
(assert (not false))
(check-sat)