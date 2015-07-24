(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun sm2 () Int)
(declare-fun bg2 () Int)
(declare-fun bg_1749 () Int)
(declare-fun sm_1748 () Int)
(declare-fun bg2_1735 () Int)
(declare-fun sm2_1734 () Int)
(declare-fun bg1_1732 () Int)
(declare-fun lres_1727 () Int)
(declare-fun xl () Int)
(declare-fun sres_1726 () Int)
(declare-fun xs () Int)
(declare-fun bg_1706 () Int)
(declare-fun bg1 () Int)
(declare-fun sm1 () Int)
(declare-fun sm_1705 () Int)
(declare-fun d_1708 () Int)
(declare-fun sm1_1731 () Int)
(declare-fun d_1759 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= sm2 bg2))
(assert (= xs sm2))
(assert (= xl bg2))
(assert (<= sm_1748 bg_1749))
(assert (<= sm2_1734 bg2_1735))
(assert (<= bg2_1735 bg_1749))
(assert (<= sm_1748 sm2_1734))
(assert (<= sres_1726 lres_1727))
(assert (= bg2_1735 lres_1727))
(assert (= sm2_1734 sres_1726))
(assert (= bg1_1732 bg_1706))
(assert (<= xs xl))
(assert (or (and (= lres_1727 d_1708) (>= d_1708 xl)) (and (= lres_1727 xl) (< d_1708 xl))))
(assert (or (and (= sres_1726 d_1708) (< d_1708 xs)) (and (= sres_1726 xs) (>= d_1708 xs))))
(assert (= bg_1706 bg1))
(assert (= sm_1705 sm1))
(assert (< d_1708 bg1))
(assert (<= sm1 d_1708))
(assert (= sm1_1731 sm_1705))
(assert (= d_1759 d_1708))
;Negation of Consequence
(assert (not (<= sm1_1731 d_1759)))
(check-sat)