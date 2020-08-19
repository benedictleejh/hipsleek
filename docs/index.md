# HIP/SLEEK

The HIP/SLEEK systems are aimed at automatic verification of functional correctness of heap manipulating programs. HIP
is a separation logic based automated verification system for a simple imperative language, able to modularly verify the
specifications of heap-manipulating programs. The specification language allows user defined inductive predicates used
to model complex data structures. Specifications can contain both heap constraints and various pure constraints like
arithmetic constraints, bag constraints. Based on given annotations for each method/loop, HIP will construct a set of
separation logic proof obligations in the form of formula implications which are sent to the SLEEK separation logic
prover. SLEEK is a fully automatic prover for separation logic with frame inferring capability.
