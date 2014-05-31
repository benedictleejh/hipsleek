(set-logic QF_S)

(declare-sort node 0)
(declare-fun val () (Field node int))
(declare-fun next () (Field node node))

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

(define-fun lseg ((?in node) (?p node))
Space (tospace
(or
(= ?in ?p)
(exists ((?p_21 node)) (tobool (ssep (pto ?in (sref (ref val ?Anon_13) (ref next ?q) )) (lseg ?q ?p_21))))
)))









(declare-fun xprm () node)
(declare-fun yprm () node)
(declare-fun y () node)
(declare-fun x () node)


(assert 
(exists ((Anon_1010 int)(q_1011 node)) (tobool (ssep (pto xprm (sref (ref val Anon_1010) (ref next q_1011) )) (ll q_1011))))

)

(assert (not 
(exists ((Anon_1013 int)(q_1014 node)) (tobool (ssep (pto xprm (sref (ref val val_15_979prm) (ref next next_15_980prm) )) (ll q_1014))))

))

(check-sat)
