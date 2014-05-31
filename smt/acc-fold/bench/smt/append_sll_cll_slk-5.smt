(set-logic QF_S)

(declare-sort node 0)
(declare-fun val () (Field node int))
(declare-fun next () (Field node node))

(define-fun lseg ((?in node) (?p node))
Space (tospace
(or
(= ?in ?p)
(exists ((?p_23 node)) (tobool (ssep (pto ?in (sref (ref val ?Anon_13) (ref next ?q) )) (lseg ?q ?p_23))))
)))

(define-fun ll ((?in node))
Space (tospace
(or
(= ?in nil)
(and 
(tobool (ssep 
(pto ?in (sref (ref val ?Anon_12) (ref next ?q) ))
(ll ?q)
) )
))))

(define-fun clist ((?in node))
Space (tospace
(exists ((?self_22 node)) (tobool (ssep (pto ?in (sref (ref val ?Anon_14) (ref next ?p) )) (lseg ?p ?self_22))))
))



















(declare-fun Anon_1029 () int)
(declare-fun y () node)
(declare-fun xprm () node)
(declare-fun x () node)
(declare-fun v_bool_20_1003prm () boolean)
(declare-fun v_node_21_1000prm () node)
(declare-fun q_1030 () node)
(declare-fun yprm () node)


(assert 
(and 
(distinct x nil)
(= yprm y)
(= xprm x)
(distinct q_1030 nil)
bvar(distinct q_1030 nil)
bvar(= v_node_21_1000prm q_1030)
(tobool (ssep 
(pto xprm (sref (ref val Anon_1029) (ref next q_1030) ))
(ll q_1030)
emp
) )
)
)

(assert (not 
(and 
(= yprm v_node_21_1000prm)
(distinct v_node_21_1000prm nil)
(tobool (ssep 
(ll v_node_21_1000prm)
emp
) )
)
))

(check-sat)
