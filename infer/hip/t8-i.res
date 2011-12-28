
Processing file "t8-i.ss"
Parsing t8-i.ss ...
Parsing ../../prelude.ss ...
Starting Reduce... 
Starting Omega...oc
Translating global variables to procedure parameters...
Checking procedure foo1$int... 
Inferred Heap:[]
Inferred Pure:[ 1<=i]
OLD SPECS:  EInfer [i]
   EBase true & true & {FLOW,(20,21)=__norm}
           EAssume 1::ref [i]
             true & true & {FLOW,(20,21)=__norm}
NEW SPECS:  EBase true & 1<=i & {FLOW,(20,21)=__norm}
         EAssume 1::ref [i]
           true & i=i'+1 & 0<=i' & {FLOW,(20,21)=__norm}
NEW RELS: []

Procedure foo1$int SUCCESS
Checking procedure foo1a$int... 
Inferred Heap:[]
Inferred Pure:[ 1<=i]
OLD SPECS:  EInfer [i]
   EBase true & true & {FLOW,(20,21)=__norm}
           EAssume 4::ref [i]
             true & true & {FLOW,(20,21)=__norm}
NEW SPECS:  EBase true & 1<=i & {FLOW,(20,21)=__norm}
         EAssume 4::ref [i]
           true & true & {FLOW,(20,21)=__norm}
NEW RELS: []

Procedure foo1a$int SUCCESS
Checking procedure foo1b$int... OLD SPECS:  EInfer @post []
   EBase true & 0<i & {FLOW,(20,21)=__norm}
           EAssume 7::ref [i]
             true & true & {FLOW,(20,21)=__norm}
NEW SPECS:  EBase true & 0<i & {FLOW,(20,21)=__norm}
         EAssume 7::ref [i]
           true & i=i'+1 & 0<=i' & {FLOW,(20,21)=__norm}
NEW RELS: []

Procedure foo1b$int SUCCESS
Stop Omega... 61 invocations 
0 false contexts at: ()

Total verification time: 0.18 second(s)
	Time spent in main process: 0.16 second(s)
	Time spent in child processes: 0.02 second(s)
