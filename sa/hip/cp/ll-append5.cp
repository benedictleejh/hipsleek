HeapPred HP_2(node a, node b).
HeapPred HP_2a(node a, node b).
HeapPred HP_2b(node a, node b).
HeapPred HP_3(node a, node b, node c).
HeapPred H1a(node a).

append:SUCCESS[
ass [H2,G2][]:{
        x::node<_,b> * G2(b,y)&b!=null --> G2(x,y);
        HP_2b(a,y) * x::node<_,y>&a=null --> G2(x,y);
        HP_2b(v,y)&v!=null --> H2(v,y);
        H2(x,y) --> x::node<_,b> * HP_2b(b,y)
	}

hpdefs [G2,H2][]:{
 G2(x,y) --> x::node<_,p> * HP_2(p,y) & y = H1a_y;
 H2(x,y) --> x::node<_,p>* HP_2a(p,y) & y = H1a_y;
 HP_2a(x,y) --> x=null or x::node<_,p1> * HP_2a(p1,y);
 HP_2(x,p) --> x=p or x::node<_,p1> * HP_2(p1,p)
 }
]

/*
hpdefs [G2,H2]:{
 H1a(x) --> htrue&true;
 G2(x,y) --> x::node<_,p> * HP_2(p,y) * H1a(y);
 H2(x,y) --> x::node<_,p>* HP_2a(p,y) * H1a(y);
 HP_2a(x,y) --> x=null or x::node<_,p1> * HP_2a(p1,y);
 HP_2(x,p) --> x=p or x::node<_,p1> * HP_2(p1,p)
 }
*/
