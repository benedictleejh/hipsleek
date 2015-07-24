(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun nr_10424 () Int)
(declare-fun l_10585 () Int)
(declare-fun b_primed () Int)
(declare-fun r_10589 () Int)
(declare-fun c_primed () Int)
(declare-fun nl_10586 () Int)
(declare-fun Anon_10587 () Int)
(declare-fun nr_10590 () Int)
(declare-fun Anon_10591 () Int)
(declare-fun Anon_20 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_137_9878 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun bhr_10426 () Int)
(declare-fun bhr_10592 () Int)
(declare-fun bhl_10588 () Int)
(declare-fun ha_9877 () Int)
(declare-fun ha_9876 () Int)
(declare-fun r_10612 () Int)
(declare-fun bhr_10614 () Int)
(declare-fun flted_12_9866 () Int)
(declare-fun bhr_9875 () Int)
(declare-fun r_9873 () Int)
(declare-fun nr_10613 () Int)
(declare-fun ha () Int)
(declare-fun na () Int)
(declare-fun nr_9874 () Int)
(declare-fun l_10609 () Int)
(declare-fun flted_12_9867 () Int)
(declare-fun bhl_9872 () Int)
(declare-fun nl_9871 () Int)
(declare-fun l_9870 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= nr_10424 (+ (+ nr_10590 1) nl_10586)))
(assert (= flted_137_9878 0))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= l_10585 b_primed))
(assert (= r_10589 c_primed))
(assert (= nl_10586 nb))
(assert (= Anon_10587 Anon_20))
(assert (= nr_10590 nc))
(assert (= Anon_10591 flted_137_9878))
(assert (or (and (and (and (= Anon_20 0) (<= 2 ha_9876)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha_9876 1)) (= Anon_20 0)) (and (and (and (= Anon_20 1) (<= 1 ha_9876)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_137_9878 0) (<= 2 ha_9877)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha_9877 1)) (= flted_137_9878 0)) (and (and (and (= flted_137_9878 1) (<= 1 ha_9877)) (<= 1 nc)) (> c 0)))))
(assert (= bhr_10426 (+ bhl_10588 1)))
(assert (= bhl_10588 bhr_10592))
(assert (= bhr_10592 ha_9877))
(assert (= bhl_10588 ha_9876))
(assert (= ha_9877 ha))
(assert (= ha_9876 ha))
(assert (= bhr_9875 ha))
(assert (= flted_12_9866 0))
(assert (= r_10612 r_9873))
(assert (= bhr_10614 bhr_9875))
(assert (or (and (and (and (= flted_12_9866 0) (<= 2 bhr_9875)) (<= 1 nr_9874)) (> r_9873 0)) (or (and (and (and (< r_9873 1) (= nr_9874 0)) (= bhr_9875 1)) (= flted_12_9866 0)) (and (and (and (= flted_12_9866 1) (<= 1 bhr_9875)) (<= 1 nr_9874)) (> r_9873 0)))))
(assert (= nr_10613 nr_9874))
(assert (= flted_12_9867 0))
(assert (= bhl_9872 ha))
(assert (= na (+ (+ nr_9874 1) nl_9871)))
(assert (= l_10609 l_9870))
(assert (or (and (and (and (= flted_12_9867 0) (<= 2 bhl_9872)) (<= 1 nl_9871)) (> l_9870 0)) (or (and (and (and (< l_9870 1) (= nl_9871 0)) (= bhl_9872 1)) (= flted_12_9867 0)) (and (and (and (= flted_12_9867 1) (<= 1 bhl_9872)) (<= 1 nl_9871)) (> l_9870 0)))))
;Negation of Consequence
(assert (not (or (= nl_9871 0) (< l_9870 1))))
(check-sat)