(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n_2790 () Int)
(declare-fun next_380_2787 () Int)
(declare-fun n () Int)
(declare-fun flted_14_2780 () Int)
(declare-fun q_2782 () Int)
(declare-fun xs_primed () Int)
(declare-fun tmp_primed () Int)
(declare-fun q_2797 () Int)
(declare-fun xs () Int)
(declare-fun ys_primed () Int)
(declare-fun xs_2789 () Int)
(declare-fun ys_2788 () Int)
(declare-fun m () Int)
(declare-fun ys () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= n_2790 flted_14_2780))
(assert (= next_380_2787 q_2782))
(assert (= (+ flted_14_2780 1) n))
(assert (or (and (< q_2782 1) (= flted_14_2780 0)) (and (<= 1 flted_14_2780) (> q_2782 0))))
(assert (= tmp_primed q_2782))
(assert (= xs_primed tmp_primed))
(assert (= xs_2789 1))
(assert (= q_2797 ys_2788))
(assert (> xs_2789 0))
(assert (= xs_2789 xs))
(assert (= ys_primed xs_2789))
(assert (= ys_2788 ys))
(assert (or (and (< ys 1) (= m 0)) (and (<= 1 m) (> ys 0))))
;Negation of Consequence
(assert (not (or (= m 0) (< ys 1))))
(check-sat)