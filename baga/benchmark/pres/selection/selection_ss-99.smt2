(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun res () Int)
(declare-fun v_int_29_1523_primed () Int)
(declare-fun sm_1770 () Int)
(declare-fun bg_1771 () Int)
(declare-fun l_1793 () Int)
(declare-fun s_1792 () Int)
(declare-fun mi_1794 () Int)
(declare-fun l () Int)
(declare-fun s () Int)
(declare-fun d_1773 () Int)
(declare-fun tmi_1775 () Int)
(declare-fun mi () Int)
(declare-fun d_1864 () Int)
(declare-fun tmi_1866 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (< mi_1794 l_1793))
(assert (<= s_1792 mi_1794))
(assert (= res v_int_29_1523_primed))
(assert (= v_int_29_1523_primed d_1773))
(assert (< tmi_1775 bg_1771))
(assert (<= sm_1770 tmi_1775))
(assert (= mi_1794 tmi_1775))
(assert (= l_1793 bg_1771))
(assert (= s_1792 sm_1770))
(assert (<= s d_1773))
(assert (< d_1773 l))
(assert (= sm_1770 s))
(assert (= bg_1771 l))
(assert (< d_1773 mi_1794))
(assert (< d_1864 l_1793))
(assert (exists ((mi_1896 Int)) (and (and (< mi_1896 l_1793) (<= s_1792 mi_1896)) (or (and (= mi_1896 d_1864) (< d_1864 tmi_1866)) (and (= mi_1896 tmi_1866) (>= d_1864 tmi_1866))))))
(assert (<= s_1792 d_1864))
(assert (= tmi_1866 mi_1794))
(assert (= d_1864 d_1773))
(assert (< mi l))
(assert (<= s mi))
(assert (or (and (= mi d_1773) (< d_1773 tmi_1775)) (and (= mi tmi_1775) (>= d_1773 tmi_1775))))
;Negation of Consequence
(assert (not (or (and (= mi d_1864) (< d_1864 tmi_1866)) (and (= mi tmi_1866) (>= d_1864 tmi_1866)))))
(check-sat)