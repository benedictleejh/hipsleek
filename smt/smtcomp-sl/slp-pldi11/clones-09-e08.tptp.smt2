(set-logic QF_S)
(set-info :source |
A. Rybalchenko and J. A. Navarro Pérez.
[Separation Logic + Superposition Calculus = Heap Theorem Prover]
[PLDI 2011]
http://navarroj.com/research/papers.html#pldi11
|)
(set-info :smt-lib-version 2.0)
(set-info :category "random") 
(set-info :status sat)


(declare-sort Sll_t 0)

(declare-fun f () (Field Sll_t Sll_t))

(define-fun ls ((?in Sll_t) (?out Sll_t)) Space
(tospace (or (= ?in ?out)
(exists ((?u Sll_t))
(tobool
(ssep (pto ?in (ref f ?u)) (ls ?u ?out)
))))))

(declare-fun nil () Sll_t)

(declare-fun x_emp () Sll_t)
(declare-fun y_emp () Sll_t)
(declare-fun z_emp () Sll_t)
(declare-fun t_emp () Sll_t)
(declare-fun x0 () Sll_t)
(declare-fun x1 () Sll_t)
(declare-fun x2 () Sll_t)
(declare-fun x3 () Sll_t)
(declare-fun x4 () Sll_t)
(declare-fun x5 () Sll_t)
(declare-fun x6 () Sll_t)
(declare-fun x7 () Sll_t)
(declare-fun x8 () Sll_t)
(declare-fun x9 () Sll_t)
(declare-fun x10 () Sll_t)
(declare-fun x11 () Sll_t)
(declare-fun x12 () Sll_t)
(declare-fun x13 () Sll_t)
(declare-fun x14 () Sll_t)
(declare-fun x15 () Sll_t)
(declare-fun x16 () Sll_t)
(declare-fun x17 () Sll_t)
(declare-fun x18 () Sll_t)
(declare-fun x19 () Sll_t)
(declare-fun x20 () Sll_t)
(declare-fun x21 () Sll_t)
(declare-fun x22 () Sll_t)
(declare-fun x23 () Sll_t)
(declare-fun x24 () Sll_t)
(declare-fun x25 () Sll_t)
(declare-fun x26 () Sll_t)
(declare-fun x27 () Sll_t)
(declare-fun x28 () Sll_t)
(declare-fun x29 () Sll_t)
(declare-fun x30 () Sll_t)
(declare-fun x31 () Sll_t)
(declare-fun x32 () Sll_t)
(declare-fun x33 () Sll_t)
(declare-fun x34 () Sll_t)
(declare-fun x35 () Sll_t)
(declare-fun x36 () Sll_t)
(declare-fun x37 () Sll_t)
(declare-fun x38 () Sll_t)
(declare-fun x39 () Sll_t)
(declare-fun x40 () Sll_t)
(declare-fun alpha0 () SetLoc)
(declare-fun alpha1 () SetLoc)
(declare-fun alpha2 () SetLoc)
(declare-fun alpha3 () SetLoc)
(declare-fun alpha4 () SetLoc)
(declare-fun alpha5 () SetLoc)
(declare-fun alpha6 () SetLoc)
(declare-fun alpha7 () SetLoc)
(declare-fun alpha8 () SetLoc)
(declare-fun alpha9 () SetLoc)
(declare-fun alpha10 () SetLoc)
(declare-fun alpha11 () SetLoc)
(declare-fun alpha12 () SetLoc)
(declare-fun alpha13 () SetLoc)
(declare-fun alpha14 () SetLoc)
(declare-fun alpha15 () SetLoc)
(declare-fun alpha16 () SetLoc)
(declare-fun alpha17 () SetLoc)
(declare-fun alpha18 () SetLoc)
(declare-fun alpha19 () SetLoc)
(declare-fun alpha20 () SetLoc)
(declare-fun alpha21 () SetLoc)
(declare-fun alpha22 () SetLoc)
(assert
  (and 
    (= nil nil)
(distinct nil x1 )
(distinct nil x2 )
(distinct nil x3 )
(distinct x1 x3 )
(distinct x2 x3 )
(distinct nil x5 )
(distinct nil x6 )
(distinct nil x7 )
(distinct x5 x7 )
(distinct x6 x7 )
(distinct nil x9 )
(distinct nil x10 )
(distinct nil x11 )
(distinct x9 x11 )
(distinct x10 x11 )
(distinct nil x13 )
(distinct nil x14 )
(distinct nil x15 )
(distinct x13 x15 )
(distinct x14 x15 )
(distinct nil x17 )
(distinct nil x18 )
(distinct nil x19 )
(distinct x17 x19 )
(distinct x18 x19 )
(distinct nil x21 )
(distinct nil x22 )
(distinct nil x23 )
(distinct x21 x23 )
(distinct x22 x23 )
(distinct nil x25 )
(distinct nil x26 )
(distinct nil x27 )
(distinct x25 x27 )
(distinct x26 x27 )
(distinct nil x29 )
(distinct nil x30 )
(distinct nil x31 )
(distinct x29 x31 )
(distinct x30 x31 )
(distinct nil x33 )
(distinct nil x34 )
(distinct nil x35 )
(distinct x33 x35 )
(distinct x34 x35 )
    (tobool  (ssep  (index alpha0 (ls x34 x33 )) (ssep  (pto x35  (ref f x34 ) ) (ssep  (pto x33  (ref f x35 ) ) (ssep  (index alpha1 (ls x30 x29 )) (ssep  (pto x31  (ref f x30 ) ) (ssep  (pto x29  (ref f x31 ) ) (ssep  (index alpha2 (ls x26 x25 )) (ssep  (pto x27  (ref f x26 ) ) (ssep  (pto x25  (ref f x27 ) ) (ssep  (index alpha3 (ls x22 x21 )) (ssep  (pto x23  (ref f x22 ) ) (ssep  (pto x21  (ref f x23 ) ) (ssep  (index alpha4 (ls x18 x17 )) (ssep  (pto x19  (ref f x18 ) ) (ssep  (pto x17  (ref f x19 ) ) (ssep  (index alpha5 (ls x14 x13 )) (ssep  (pto x15  (ref f x14 ) ) (ssep  (pto x13  (ref f x15 ) ) (ssep  (index alpha6 (ls x10 x9 )) (ssep  (pto x11  (ref f x10 ) ) (ssep  (pto x9  (ref f x11 ) ) (ssep  (index alpha7 (ls x6 x5 )) (ssep  (pto x7  (ref f x6 ) ) (ssep  (pto x5  (ref f x7 ) ) (ssep  (index alpha8 (ls x2 x1 )) (ssep  (pto x3  (ref f x2 ) ) (ssep  (pto x1  (ref f x3 ) )(ssep (pto x_emp (ref f y_emp)) (pto z_emp (ref f t_emp)))))))))))))))))))))))))))))))
  )
)
(assert
  (not
        (tobool  (ssep  (pto x36  (ref f x35 ) ) (ssep  (index alpha9 (ls x34 x36 )) (ssep  (pto x35  (ref f x34 ) ) (ssep  (pto x32  (ref f x31 ) ) (ssep  (index alpha10 (ls x30 x32 )) (ssep  (pto x31  (ref f x30 ) ) (ssep  (pto x28  (ref f x27 ) ) (ssep  (index alpha11 (ls x26 x28 )) (ssep  (pto x27  (ref f x26 ) ) (ssep  (pto x24  (ref f x23 ) ) (ssep  (index alpha12 (ls x22 x24 )) (ssep  (pto x23  (ref f x22 ) ) (ssep  (pto x20  (ref f x19 ) ) (ssep  (index alpha13 (ls x18 x20 )) (ssep  (pto x19  (ref f x18 ) ) (ssep  (pto x16  (ref f x15 ) ) (ssep  (index alpha14 (ls x14 x16 )) (ssep  (pto x15  (ref f x14 ) ) (ssep  (pto x12  (ref f x11 ) ) (ssep  (index alpha15 (ls x10 x12 )) (ssep  (pto x11  (ref f x10 ) ) (ssep  (pto x8  (ref f x7 ) ) (ssep  (index alpha16 (ls x6 x8 )) (ssep  (pto x7  (ref f x6 ) ) (ssep  (pto x4  (ref f x3 ) ) (ssep  (index alpha17 (ls x2 x4 )) (ssep  (pto x3  (ref f x2 ) )(ssep (pto x_emp (ref f y_emp)) (pto z_emp (ref f t_emp)))))))))))))))))))))))))))))))
  ))

(check-sat)
