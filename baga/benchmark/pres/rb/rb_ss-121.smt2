(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nb_5797 () Int)
(declare-fun nb () Int)
(declare-fun bha_5799 () Int)
(declare-fun na_5796 () Int)
(declare-fun na () Int)
(declare-fun a_primed () Int)
(declare-fun a () Int)
(declare-fun b_primed () Int)
(declare-fun b () Int)
(declare-fun c () Int)
(declare-fun d () Int)
(declare-fun flted_66_5809 () Int)
(declare-fun flted_66_5808 () Int)
(declare-fun flted_66_5807 () Int)
(declare-fun flted_66_5806 () Int)
(declare-fun v_int_72_5811 () Int)
(declare-fun v_5820 () Int)
(declare-fun v_int_72_5810 () Int)
(declare-fun l_5821 () Int)
(declare-fun c_primed () Int)
(declare-fun r_5824 () Int)
(declare-fun d_primed () Int)
(declare-fun nc () Int)
(declare-fun nd () Int)
(declare-fun bha () Int)
(declare-fun bhl_5823 () Int)
(declare-fun bhr_5826 () Int)
(declare-fun nc_5798 () Int)
(declare-fun nr_5825 () Int)
(declare-fun nl_5822 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nb_5797 nb))
(assert (= bha_5799 bha))
(assert (= na_5796 na))
(assert (= a_primed a))
(assert (= b_primed b))
(assert (= c_primed c))
(assert (= d_primed d))
(assert (= flted_66_5809 0))
(assert (= flted_66_5808 0))
(assert (= flted_66_5807 0))
(assert (= flted_66_5806 0))
(assert (= v_int_72_5810 0))
(assert (= v_int_72_5811 1))
(assert (= v_5820 v_int_72_5810))
(assert (= l_5821 c_primed))
(assert (= r_5824 d_primed))
(assert (= nl_5822 nc))
(assert (= bhl_5823 bha))
(assert (= nr_5825 nd))
(assert (= bhr_5826 bha))
(assert (= bhl_5823 bhr_5826))
(assert (= nc_5798 (+ (+ nr_5825 1) nl_5822)))
;Negation of Consequence
(assert (not false))
(check-sat)