(set-logic QF_S)

(declare-sort node 0)
(declare-fun val () (Field node Int))
(declare-fun next () (Field node node))

(define-fun ll ((?in node))
Space (tospace
(or
(and 
(= ?in nil)

)(exists ((?v_19 Int)(?q_20 node))(and 
(tobool (ssep 
(pto ?in (sref (ref val ?v_19) (ref next ?q_20) ))
(ll ?q_20)
) )
)))))










(declare-fun yprm () node)
(declare-fun xprm () node)
(declare-fun v_node_15_964prm () node)
(declare-fun y () node)
(declare-fun x () node)
(declare-fun v_bool_14_967prm () boolean)
(declare-fun v_993 () Int)
(declare-fun q_994 () node)


(assert 
(and 
(distinct x nil)
(= yprm y)
(= xprm x)
(distinct q_994 nil)
bvar(distinct q_994 nil)
bvar(= v_node_15_964prm q_994)
(tobool (ssep 
(ll q_994)
(ll y)
(pto xprm (sref (ref val v_993) (ref next q_994) ))
emp
) )
)
)

(assert (not 
(and 
(distinct v_node_15_964prm nil)
(distinct v_node_15_964prm nil)
(distinct x nil)
(= yprm y)
(= xprm x)
(distinct q_994 nil)
bvar(distinct q_994 nil)
bvar(= v_node_15_964prm q_994)
(tobool (ssep 
(ll v_node_15_964prm)
(ll yprm)
(pto xprm (sref (ref val v_993) (ref next q_994) ))
emp
) )
)
))

(check-sat)