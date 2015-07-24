(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun n () Int)
(declare-fun q_1922 () Int)
(declare-fun flted_19_1498 () Int)
(declare-fun xs () Int)
(declare-fun l_1526 () Int)
(declare-fun n_1512 () Int)
(declare-fun q_1941 () Int)
(declare-fun r_1500 () Int)
(declare-fun xs_primed () Int)
(declare-fun lg_1579 () Int)
(declare-fun flted_10_1580 () Int)
(declare-fun q_1581 () Int)
(declare-fun s_1525 () Int)
(declare-fun val_73_1617 () Int)
(declare-fun val_72_1607 () Int)
(declare-fun sm_1578 () Int)
(declare-fun qs_1582 () Int)
(declare-fun Anon_1499 () Int)
(declare-fun qs_1942 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< 0 n))
(assert (= (+ flted_19_1498 1) n))
(assert (= q_1922 r_1500))
(assert (<= 0 n_1512))
(assert (<= 0 flted_19_1498))
(assert (= n_1512 flted_19_1498))
(assert (= xs_primed xs))
(assert (= lg_1579 l_1526))
(assert (> q_1581 0))
(assert (= (+ flted_10_1580 1) n_1512))
(assert (= q_1941 q_1581))
(assert (> r_1500 0))
(assert (> xs_primed 0))
(assert (not (= r_1500 xs_primed)))
(assert (not (= q_1581 r_1500)))
(assert (not (= q_1581 xs_primed)))
(assert (or (and (and (= lg_1579 qs_1582) (= flted_10_1580 1)) (> q_1581 0)) (and (and (<= qs_1582 lg_1579) (<= 2 flted_10_1580)) (> q_1581 0))))
(assert (<= s_1525 qs_1582))
(assert (= sm_1578 s_1525))
(assert (= val_73_1617 sm_1578))
(assert (= val_72_1607 Anon_1499))
(assert (< sm_1578 Anon_1499))
(assert (= qs_1942 qs_1582))
;Negation of Consequence
(assert (not (<= Anon_1499 qs_1942)))
(check-sat)