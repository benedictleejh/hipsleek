(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun c_primed () Int)
(declare-fun b_primed () Int)
(declare-fun a_primed () Int)
(declare-fun nb_10927 () Int)
(declare-fun Anon_20 () Int)
(declare-fun flted_168_10983 () Int)
(declare-fun nc () Int)
(declare-fun c () Int)
(declare-fun flted_168_10984 () Int)
(declare-fun nb () Int)
(declare-fun b () Int)
(declare-fun flted_168_10985 () Int)
(declare-fun na () Int)
(declare-fun a () Int)
(declare-fun d_primed () Int)
(declare-fun flted_168_10982 () Int)
(declare-fun h () Int)
(declare-fun nd () Int)
(declare-fun d () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= flted_168_10983 0))
(assert (= flted_168_10984 0))
(assert (= flted_168_10985 0))
(assert (= c_primed c))
(assert (= b_primed b))
(assert (= a_primed a))
(assert (= nb_10927 nc))
(assert (= Anon_20 flted_168_10983))
(assert (or (and (and (and (= flted_168_10983 0) (<= 2 h)) (<= 1 nc)) (> c 0)) (or (and (and (and (< c 1) (= nc 0)) (= h 1)) (= flted_168_10983 0)) (and (and (and (= flted_168_10983 1) (<= 1 h)) (<= 1 nc)) (> c 0)))))
(assert (or (and (and (and (= flted_168_10984 0) (<= 2 h)) (<= 1 nb)) (> b 0)) (or (and (and (and (< b 1) (= nb 0)) (= h 1)) (= flted_168_10984 0)) (and (and (and (= flted_168_10984 1) (<= 1 h)) (<= 1 nb)) (> b 0)))))
(assert (or (and (and (and (= flted_168_10985 0) (<= 2 h)) (<= 1 na)) (> a 0)) (or (and (and (and (< a 1) (= na 0)) (= h 1)) (= flted_168_10985 0)) (and (and (and (= flted_168_10985 1) (<= 1 h)) (<= 1 na)) (> a 0)))))
(assert (= flted_168_10982 0))
(assert (= d_primed d))
(assert (or (and (and (and (= flted_168_10982 0) (<= 2 h)) (<= 1 nd)) (> d 0)) (or (and (and (and (< d 1) (= nd 0)) (= h 1)) (= flted_168_10982 0)) (and (and (and (= flted_168_10982 1) (<= 1 h)) (<= 1 nd)) (> d 0)))))
;Negation of Consequence
(assert (not (or (= nd 0) (< d 1))))
(check-sat)