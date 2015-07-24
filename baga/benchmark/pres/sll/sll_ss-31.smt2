(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun sm () Int)
(declare-fun qmin_1892 () Int)
(declare-fun n () Int)
(declare-fun qmin_1769 () Int)
(declare-fun lg () Int)
(declare-fun v () Int)
(declare-fun flted_16_1766 () Int)
(declare-fun qs_1767 () Int)
(declare-fun ql_1768 () Int)
(declare-fun sm_1785 () Int)
(declare-fun v_primed () Int)
(declare-fun lg_1786 () Int)
(declare-fun n_1784 () Int)
(declare-fun q_1893 () Int)
(declare-fun mi_1801 () Int)
(declare-fun ma_1802 () Int)
(declare-fun flted_23_1800 () Int)
(declare-fun v_node_37_1888 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= sm_1785 lg_1786))
(assert (<= qs_1767 ql_1768))
(assert (<= 0 flted_16_1766))
(assert (<= sm qmin_1769))
(assert (= qmin_1892 qmin_1769))
(assert (< qmin_1769 v_primed))
(assert (= (+ flted_16_1766 1) n))
(assert (<= qmin_1769 qs_1767))
(assert (<= ql_1768 lg))
(assert (= v_primed v))
(assert (= n_1784 flted_16_1766))
(assert (= sm_1785 qs_1767))
(assert (= lg_1786 ql_1768))
(assert (or (and (= mi_1801 v_primed) (< v_primed sm_1785)) (and (= mi_1801 sm_1785) (>= v_primed sm_1785))))
(assert (or (and (= ma_1802 v_primed) (>= v_primed lg_1786)) (and (= ma_1802 lg_1786) (< v_primed lg_1786))))
(assert (<= 0 n_1784))
(assert (= flted_23_1800 (+ 1 n_1784)))
(assert (= q_1893 v_node_37_1888))
(assert (or (and (and (< v_node_37_1888 1) (= flted_23_1800 0)) (<= mi_1801 ma_1802)) (and (and (<= mi_1801 ma_1802) (<= 1 flted_23_1800)) (> v_node_37_1888 0))))
;Negation of Consequence
(assert (not (or (= flted_23_1800 0) (< v_node_37_1888 1))))
(check-sat)