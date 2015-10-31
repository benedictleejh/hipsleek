(set-logic QF_S)
(set-info :source |  Sleek solver
  http://loris-7.ddns.comp.nus.edu.sg/~project/hip/
|)

(set-info :smt-lib-version 2.0)
(set-info :category "crafted")
(set-info :status unsat)


(declare-sort node2 0)
(declare-fun val () (Field node2 Int))
(declare-fun prev () (Field node2 node2))
(declare-fun next () (Field node2 node2))

(define-fun dll ((?in node2) (?p node2) (?n Int))
Space (tospace
(or
(and 
(= ?in nil)
(= ?n 0)

)(exists ((?p_41 node2)(?self_42 node2)(?flted_12_40 Int))(and 
(= (+ ?flted_12_40 1) ?n)
(= ?p_41 ?p)
(= ?self_42 ?in)
(tobool (ssep 
(pto ?in (sref (ref val ?Anon_14) (ref prev ?p_41) (ref next ?q) ))
(dll ?q ?self_42 ?flted_12_40)
) )
)))))








































































































































(declare-fun Anon1 () Int)
(declare-fun p () node2)
(declare-fun n () Int)
(declare-fun tmpprm () node2)
(declare-fun q2 () node2)
(declare-fun x () node2)
(declare-fun yprm () node2)
(declare-fun y () node2)
(declare-fun self2 () node2)
(declare-fun xprm () node2)
(declare-fun p2 () node2)
(declare-fun q () node2)
(declare-fun flted1 () Int)
(declare-fun m () Int)


(assert 
(and 
;lexvar(= tmpprm q2)
(= xprm x)
(= yprm y)
(distinct xprm nil)
(not )(= self2 xprm)
(= p2 q)
(= (+ flted1 1) m)
(tobool (ssep 
(pto xprm (sref (ref val Anon1) (ref prev p2) (ref next q2) ))
(dll q2 self2 flted1)
(dll y p n)
) )
)
)

(assert (not 
(and 
(tobool (ssep 
(dll tmpprm q3 m1)
(dll yprm p3 n1)
) )
)
))

(check-sat)