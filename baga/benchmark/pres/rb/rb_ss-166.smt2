(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhl_5948 () Int)
(declare-fun Anon_5947 () Int)
(declare-fun nl_5946 () Int)
(declare-fun na () Int)
(declare-fun r_5949 () Int)
(declare-fun tmp1_5930 () Int)
(declare-fun l_5945 () Int)
(declare-fun v_5944 () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun b () Int)
(declare-fun c () Int)
(declare-fun flted_182_5925 () Int)
(declare-fun flted_182_5924 () Int)
(declare-fun flted_182_5923 () Int)
(declare-fun v_int_187_5927 () Int)
(declare-fun v_int_188_5928 () Int)
(declare-fun v_int_188_5929 () Int)
(declare-fun v_6030 () Int)
(declare-fun v_int_187_5926 () Int)
(declare-fun l_6031 () Int)
(declare-fun b_primed () Int)
(declare-fun r_6034 () Int)
(declare-fun c_primed () Int)
(declare-fun nb () Int)
(declare-fun nc () Int)
(declare-fun ha () Int)
(declare-fun bhr_6036 () Int)
(declare-fun bhl_6033 () Int)
(declare-fun bhr_5952 () Int)
(declare-fun nr_5950 () Int)
(declare-fun nr_6035 () Int)
(declare-fun nl_6032 () Int)
(declare-fun Anon_5951 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhl_5948 ha))
(assert (= Anon_5947 flted_182_5925))
(assert (= nl_5946 na))
(assert (= r_5949 tmp1_5930))
(assert (= l_5945 a_primed))
(assert (= v_5944 v_int_188_5928))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= flted_182_5925 0))
(assert (= flted_182_5924 0))
(assert (= flted_182_5923 0))
(assert (= v_int_187_5926 0))
(assert (= v_int_187_5927 1))
(assert (= v_int_188_5928 0))
(assert (= v_int_188_5929 0))
(assert (= v_6030 v_int_187_5926))
(assert (= l_6031 b_primed))
(assert (= r_6034 c_primed))
(assert (= nl_6032 nb))
(assert (= bhl_6033 ha))
(assert (= nr_6035 nc))
(assert (= bhr_6036 ha))
(assert (= bhr_6036 bhl_6033))
(assert (= bhr_6036 bhr_5952))
(assert (= bhl_6033 bhr_5952))
(assert (= nr_5950 (+ (+ nr_6035 1) nl_6032)))
(assert (= Anon_5951 1))
;Negation of Consequence
(assert (not false))
(check-sat)