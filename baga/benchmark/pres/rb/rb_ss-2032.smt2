(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun bhr_13735 () Int)
(declare-fun Anon_13734 () Int)
(declare-fun Anon_13645 () Int)
(declare-fun nr_13733 () Int)
(declare-fun bhl_13731 () Int)
(declare-fun Anon_13730 () Int)
(declare-fun Anon_13641 () Int)
(declare-fun nl_13729 () Int)
(declare-fun r_13732 () Int)
(declare-fun r_13643 () Int)
(declare-fun l_13728 () Int)
(declare-fun l_13639 () Int)
(declare-fun v_13727 () Int)
(declare-fun v_13638 () Int)
(declare-fun v_bool_90_4883_primed () Int)
(declare-fun flted_13_13637 () Int)
(declare-fun cl () Int)
(declare-fun n () Int)
(declare-fun nr_13644 () Int)
(declare-fun nl_13640 () Int)
(declare-fun bhr_13646 () Int)
(declare-fun bh () Int)
(declare-fun bhl_13642 () Int)
(declare-fun v_bool_87_4884_primed () Int)
(declare-fun x_primed () Int)
(declare-fun x () Int)
(declare-fun res () Int)
(declare-fun v_boolean_91_4881_primed () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= bhr_13735 bhr_13646))
(assert (= Anon_13734 Anon_13645))
(assert (= nr_13733 nr_13644))
(assert (= bhl_13731 bhl_13642))
(assert (= Anon_13730 Anon_13641))
(assert (= nl_13729 nl_13640))
(assert (= r_13732 r_13643))
(assert (= l_13728 l_13639))
(assert (= v_13727 v_13638))
(assert (> v_bool_90_4883_primed 0))
(assert (= flted_13_13637 0))
(assert (= cl 0))
(assert (= n (+ (+ nr_13644 1) nl_13640)))
(assert (= bhl_13642 bhr_13646))
(assert (= bh (+ bhl_13642 1)))
(assert (not (> v_bool_87_4884_primed 0)))
(assert (> x_primed 0))
(assert (= x_primed x))
(assert (not (> v_boolean_91_4881_primed 0)))
(assert (= res v_boolean_91_4881_primed))
;Negation of Consequence
(assert (not false))
(check-sat)