(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nr_6769 () Int)
(declare-fun bhr_6844 () Int)
(declare-fun Anon_6843 () Int)
(declare-fun nr_6842 () Int)
(declare-fun bhl_6840 () Int)
(declare-fun Anon_6839 () Int)
(declare-fun nl_6838 () Int)
(declare-fun r_6841 () Int)
(declare-fun r_6229 () Int)
(declare-fun l_6837 () Int)
(declare-fun l_6226 () Int)
(declare-fun v_6836 () Int)
(declare-fun v_6225 () Int)
(declare-fun nl_6766 () Int)
(declare-fun bhr_6810 () Int)
(declare-fun Anon_6809 () Int)
(declare-fun Anon_18 () Int)
(declare-fun nr_6808 () Int)
(declare-fun nb () Int)
(declare-fun bhl_6806 () Int)
(declare-fun Anon_6805 () Int)
(declare-fun nl_6804 () Int)
(declare-fun na () Int)
(declare-fun r_6807 () Int)
(declare-fun l_6803 () Int)
(declare-fun v_6802 () Int)
(declare-fun res () Int)
(declare-fun v_node_130_4726_primed () Int)
(declare-fun v_int_128_6758 () Int)
(declare-fun v_int_128_6757 () Int)
(declare-fun color_127_6236 () Int)
(declare-fun flted_12_6224 () Int)
(declare-fun flted_12_6223 () Int)
(declare-fun flted_12_6222 () Int)
(declare-fun flted_120_6234 () Int)
(declare-fun nc () Int)
(declare-fun nr_6230 () Int)
(declare-fun nl_6227 () Int)
(declare-fun bhl_6228 () Int)
(declare-fun bhr_6231 () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun c () Int)
(declare-fun color_primed () Int)
(declare-fun flted_120_6235 () Int)
(declare-fun color () Int)
(declare-fun h_6232 () Int)
(declare-fun h_6233 () Int)
(declare-fun h () Int)
(declare-fun v_int_127_6756 () Int)
(declare-fun v_6764 () Int)
(declare-fun v_int_130_6759 () Int)
(declare-fun l_6765 () Int)
(declare-fun tmp_6760 () Int)
(declare-fun r_6768 () Int)
(declare-fun c_primed () Int)
(declare-fun bhr_6770 () Int)
(declare-fun bhl_6767 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nr_6769 (+ (+ nr_6842 1) nl_6838)))
(assert (= bhr_6770 (+ bhl_6840 1)))
(assert (= bhl_6840 bhr_6844))
(assert (= bhr_6844 bhr_6231))
(assert (= Anon_6843 flted_12_6222))
(assert (= nr_6842 nr_6230))
(assert (= bhl_6840 bhl_6228))
(assert (= Anon_6839 flted_12_6223))
(assert (= nl_6838 nl_6227))
(assert (= r_6841 r_6229))
(assert (= l_6837 l_6226))
(assert (= v_6836 v_6225))
(assert (= nl_6766 (+ (+ nr_6808 1) nl_6804)))
(assert (= bhl_6767 (+ bhl_6806 1)))
(assert (= bhl_6806 bhr_6810))
(assert (= bhr_6810 h_6232))
(assert (= Anon_6809 Anon_18))
(assert (= nr_6808 nb))
(assert (= bhl_6806 h))
(assert (= Anon_6805 flted_120_6235))
(assert (= nl_6804 na))
(assert (= r_6807 b_primed))
(assert (= l_6803 a_primed))
(assert (= v_6802 v_int_128_6757))
(assert (= res v_node_130_4726_primed))
(assert (= v_int_130_6759 0))
(assert (= v_int_128_6758 0))
(assert (= v_int_128_6757 0))
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
(assert (= v_int_127_6756 0))
(assert (= v_6764 v_int_130_6759))
(assert (= l_6765 tmp_6760))
(assert (= r_6768 c_primed))
(assert (= bhr_6770 bhl_6767))
;Negation of Consequence
(assert (not false))
(check-sat)