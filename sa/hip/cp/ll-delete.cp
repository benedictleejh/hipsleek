HeapPred HP_2(node a, node b).
HeapPred HP_1(node a).
HeapPred HP_621(node a).
HeapPred HP_606(node a).

delete_list:SUCCESS[
ass [D,E][]:{

  D(x)&x=null & x'=null --> E(x,x');
  x::node<_,v_node_32_619> * E(v_node_32_619,v_node_32_620)&x'=null --> E(x,x') * HP_621(v_node_32_620);
  HP_606(v_node_32_561')&true --> D(v_node_32_561');
  D(x)&x!=null --> x::node<_,next_32_560'> * HP_606(next_32_560')

 }

hpdefs [D,E][]:{
  E(x,v) -->
     x=null & x=v
   or x::node<_,p> * E(p,_)& v=null;
  D(x) --> x=null or x::node<_,p>*D(p)

 }
]

/*
 D(x)&x=null --> E(x,v_594)&x=v_594;
  x::node<val_32_585,v_node_32_592> * E(v_node_32_592,v_node_32_593)&true --> E(x,x')* HP_1(v_node_32_593);
  HP_2(v_node_32_557',x)&x!=null --> D(v_node_32_557');
  D(x)&x!=null --> x::node<val_32_555',next_32_556'> * HP_2(next_32_556',x)

*/
