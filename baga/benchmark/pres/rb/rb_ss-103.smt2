(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_5674 () Int)
(declare-fun l_5670 () Int)
(declare-fun tmp_5655 () Int)
(declare-fun v_5669 () Int)
(declare-fun a () Int)
(declare-fun b () Int)
(declare-fun c_primed () Int)
(declare-fun flted_51_5650 () Int)
(declare-fun flted_51_5649 () Int)
(declare-fun v_int_57_5652 () Int)
(declare-fun v_int_59_5653 () Int)
(declare-fun v_int_59_5654 () Int)
(declare-fun res () Int)
(declare-fun v_node_59_5028_primed () Int)
(declare-fun v_5755 () Int)
(declare-fun v_int_57_5651 () Int)
(declare-fun l_5756 () Int)
(declare-fun a_primed () Int)
(declare-fun r_5759 () Int)
(declare-fun b_primed () Int)
(declare-fun na () Int)
(declare-fun nb () Int)
(declare-fun bhr_5761 () Int)
(declare-fun bhl_5758 () Int)
(declare-fun bhl_5673 () Int)
(declare-fun nl_5671 () Int)
(declare-fun nr_5760 () Int)
(declare-fun nl_5757 () Int)
(declare-fun Anon_5672 () Int)
(declare-fun flted_51_5648 () Int)
(declare-fun bha () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= r_5674 c_primed))
(assert (= l_5670 tmp_5655))
(assert (= v_5669 v_int_59_5653))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= flted_51_5650 0))
(assert (= flted_51_5649 0))
(assert (= flted_51_5648 1))
(assert (= v_int_57_5651 0))
(assert (= v_int_57_5652 1))
(assert (= v_int_59_5653 0))
(assert (= v_int_59_5654 0))
(assert (= res v_node_59_5028_primed))
(assert (= v_5755 v_int_57_5651))
(assert (= l_5756 a_primed))
(assert (= r_5759 b_primed))
(assert (= nl_5757 na))
(assert (= bhl_5758 bha))
(assert (= nr_5760 nb))
(assert (= bhr_5761 bha))
(assert (= bhr_5761 bhl_5758))
(assert (= bhr_5761 bhl_5673))
(assert (= bhl_5758 bhl_5673))
(assert (= nl_5671 (+ (+ nr_5760 1) nl_5757)))
(assert (= Anon_5672 1))
(assert (or (and (and (and (= flted_51_5648 0) (<= 2 bha)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= bha 1)) (= flted_51_5648 0)) (and (and (and (= flted_51_5648 1) (<= 1 bha)) (<= 1 nc)) (> c 0)))))
;Negation of Consequence
(assert (not false))
(check-sat)