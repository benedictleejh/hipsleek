(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun r_10802 () Int)
(declare-fun c_primed () Int)
(declare-fun flted_137_9878 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun nl_10678 () Int)
(declare-fun ha_9877 () Int)
(declare-fun na () Int)
(declare-fun l_10775 () Int)
(declare-fun r_10779 () Int)
(declare-fun nl_10776 () Int)
(declare-fun Anon_10777 () Int)
(declare-fun nr_10780 () Int)
(declare-fun Anon_10781 () Int)
(declare-fun flted_12_9867 () Int)
(declare-fun nl_9871 () Int)
(declare-fun l_9870 () Int)
(declare-fun flted_12_9866 () Int)
(declare-fun nr_9874 () Int)
(declare-fun r_9873 () Int)
(declare-fun bhl_10680 () Int)
(declare-fun bhr_10782 () Int)
(declare-fun bhl_10778 () Int)
(declare-fun bhl_9872 () Int)
(declare-fun bhr_9875 () Int)
(declare-fun ha () Int)
(declare-fun l_10799 () Int)
(declare-fun b_primed () Int)
(declare-fun Anon_20 () Int)
(declare-fun ha_9876 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_137_9878 0))
(assert (= c_primed c))
(assert (= r_10802 c_primed))
(assert (or (and (and (and (= flted_137_9878 0) (<= 2 ha_9877)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= ha_9877 1)) (= flted_137_9878 0)) (and (and (and (= flted_137_9878 1) (<= 1 ha_9877)) (<= 1 nc)) (> c 0)))))
(assert (= nl_10678 (+ (+ nr_10780 1) nl_10776)))
(assert (= ha_9877 ha))
(assert (= na (+ (+ nr_9874 1) nl_9871)))
(assert (= flted_12_9866 0))
(assert (= flted_12_9867 0))
(assert (= l_10775 l_9870))
(assert (= r_10779 r_9873))
(assert (= nl_10776 nl_9871))
(assert (= Anon_10777 flted_12_9867))
(assert (= nr_10780 nr_9874))
(assert (= Anon_10781 flted_12_9866))
(assert (or (and (and (and (= flted_12_9867 0) (<= 2 bhl_9872)) (<= 1 nl_9871)) (> l_9870 0)) (or (and (and (and (< l_9870 1) (= nl_9871 0)) (= bhl_9872 1)) (= flted_12_9867 0)) (and (and (and (= flted_12_9867 1) (<= 1 bhl_9872)) (<= 1 nl_9871)) (> l_9870 0)))))
(assert (or (and (and (and (= flted_12_9866 0) (<= 2 bhr_9875)) (<= 1 nr_9874)) (> r_9873 0)) (or (and (and (and (< r_9873 1) (= nr_9874 0)) (= bhr_9875 1)) (= flted_12_9866 0)) (and (and (and (= flted_12_9866 1) (<= 1 bhr_9875)) (<= 1 nr_9874)) (> r_9873 0)))))
(assert (= bhl_10680 (+ bhl_10778 1)))
(assert (= bhl_10778 bhr_10782))
(assert (= bhr_10782 bhr_9875))
(assert (= bhl_10778 bhl_9872))
(assert (= bhl_9872 ha))
(assert (= bhr_9875 ha))
(assert (= ha_9876 ha))
(assert (= b_primed b))
(assert (= l_10799 b_primed))
(assert (or (and (and (and (= Anon_20 0) (<= 2 ha_9876)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= ha_9876 1)) (= Anon_20 0)) (and (and (and (= Anon_20 1) (<= 1 ha_9876)) (<= 1 nb)) (> b 0)))))
;Negation of Consequence
(assert (not (or (= nb 0) (< b 1))))
(check-sat)