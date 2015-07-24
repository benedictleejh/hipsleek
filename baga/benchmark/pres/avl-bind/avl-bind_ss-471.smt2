(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun xrightheight_primed () Int)
(declare-fun n_3631 () Int)
(declare-fun xheight_primed () Int)
(declare-fun n_3367 () Int)
(declare-fun n_3699 () Int)
(declare-fun n () Int)
(declare-fun n2_3374 () Int)
(declare-fun Anon_3645 () Int)
(declare-fun n2_3706 () Int)
(declare-fun n1_3703 () Int)
(declare-fun n_3708 () Int)
(declare-fun n_3770 () Int)
(declare-fun n_3717 () Int)
(declare-fun n_3641 () Int)
(declare-fun n1_3371 () Int)
(declare-fun n_3821 () Int)
(declare-fun n_3755 () Int)
(declare-fun n_3651 () Int)
(declare-fun n1_3825 () Int)
(declare-fun n2_3828 () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun cn () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (<= 0 n1_3703))
(assert (<= 0 n2_3706))
(assert (= xrightheight_primed n_3699))
(assert (<= 0 Anon_3645))
(assert (<= 0 n_3631))
(assert (<= 0 n2_3374))
(assert (= n_3631 n2_3374))
(assert (= xheight_primed n_3367))
(assert (= n_3367 n))
(assert (<= n_3708 n_3717))
(assert (<= (+ 0 n2_3706) (+ n1_3703 1)))
(assert (<= n1_3703 (+ 1 n2_3706)))
(assert (exists ((max_3876 Int)) (and (= n_3641 (+ 1 max_3876)) (or (and (= max_3876 n1_3703) (>= n1_3703 n2_3706)) (and (= max_3876 n2_3706) (< n1_3703 n2_3706))))))
(assert (= n_3699 n_3641))
(assert (<= (+ 0 n2_3374) (+ n1_3371 1)))
(assert (<= n1_3371 (+ 1 n2_3374)))
(assert (exists ((max_3875 Int)) (and (= n (+ 1 max_3875)) (or (and (= max_3875 n1_3371) (>= n1_3371 n2_3374)) (and (= max_3875 n2_3374) (< n1_3371 n2_3374))))))
(assert (= n_3641 Anon_3645))
(assert (<= 0 n_3641))
(assert (= n_3708 n2_3706))
(assert (= n_3717 n1_3703))
(assert (<= 0 n_3651))
(assert (<= 0 n1_3825))
(assert (<= 0 n2_3828))
(assert (<= 0 n_3770))
(assert (<= 0 n_3708))
(assert (= n_3770 n_3708))
(assert (= (+ n_3770 1) n_3755))
(assert (<= 0 n_3755))
(assert (<= 0 n_3717))
(assert (= n_3755 n_3717))
(assert (= (+ 2 n_3651) n_3641))
(assert (<= 0 n1_3371))
(assert (= n_3651 n1_3371))
(assert (= n_3821 n_3755))
(assert (exists ((max_3877 Int)) (and (= n_3755 (+ 1 max_3877)) (or (and (= max_3877 n1_3825) (>= n1_3825 n2_3828)) (and (= max_3877 n2_3828) (< n1_3825 n2_3828))))))
(assert (<= n1_3825 (+ 1 n2_3828)))
(assert (<= (+ 0 n2_3828) (+ n1_3825 1)))
(assert (= an n_3651))
(assert (= bn n1_3825))
(assert (= cn n2_3828))
;Negation of Consequence
(assert (not (or (and (= an bn) (>= bn cn)) (and (= an cn) (< bn cn)))))
(check-sat)