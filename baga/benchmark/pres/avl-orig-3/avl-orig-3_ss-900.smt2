(set-info :source  loris-7.ddns.comp.nus.edu.sg/~project/hip/) 
;Variables declarations
(declare-fun height_79_4752 () Int)
(declare-fun Anon_49 () Int)
(declare-fun Anon_47 () Int)
(declare-fun n_3775 () Int)
(declare-fun Anon_5613 () Int)
(declare-fun b_4133 () Int)
(declare-fun n_4232 () Int)
(declare-fun tn () Int)
(declare-fun b () Int)
(declare-fun n2_3783 () Int)
(declare-fun tn_4092 () Int)
(declare-fun resb_4117 () Int)
(declare-fun resn_4116 () Int)
(declare-fun n1_3779 () Int)
(declare-fun n () Int)
(declare-fun n2_4240 () Int)
(declare-fun n1_4236 () Int)
(declare-fun n_4245 () Int)
(declare-fun resn_4469 () Int)
(declare-fun tmp2_4470 () Int)
(declare-fun cn () Int)
(declare-fun tmp1_4468 () Int)
(declare-fun n_4264 () Int)
(declare-fun n_4153 () Int)
(declare-fun an () Int)
(declare-fun bn () Int)
(declare-fun resln_4471 () Int)
(declare-fun b_4501 () Int)
(declare-fun n1_4526 () Int)
(declare-fun n2_4530 () Int)
(declare-fun n_4611 () Int)
(declare-fun n_4500 () Int)
(declare-fun v_int_79_5605 () Int)
(declare-fun n1_5612 () Int)
(declare-fun n2_5616 () Int)
;Relations declarations
;Axioms assertions
;Antecedent
(assert (= height_79_4752 resn_4469))
(assert (<= 0 n_4245))
(assert (= Anon_49 n_4232))
(assert (= Anon_47 n_3775))
(assert (<= 0 n1_4236))
(assert (<= 0 n2_4240))
(assert (<= 0 n1_3779))
(assert (<= b_4133 2))
(assert (<= 0 b_4133))
(assert (<= resb_4117 2))
(assert (<= 0 resb_4117))
(assert (<= 0 resn_4116))
(assert (= b_4133 resb_4117))
(assert (<= 0 tn_4092))
(assert (<= 0 n2_3783))
(assert (= n_3775 tn))
(assert (= Anon_5613 b_4501))
(assert (< n_4264 n_4245))
(assert (exists ((max_5690 Int)) (and (= n (+ 1 max_5690)) (or (and (= max_5690 n1_4236) (>= n1_4236 n2_4240)) (and (= max_5690 n2_4240) (< n1_4236 n2_4240))))))
(assert (= (+ b_4133 n2_4240) (+ 1 n1_4236)))
(assert (<= n2_4240 (+ 1 n1_4236)))
(assert (<= n1_4236 (+ n2_4240 1)))
(assert (= n_4232 n))
(assert (exists ((max_5689 Int)) (and (= tn (+ 1 max_5689)) (or (and (= max_5689 n1_3779) (>= n1_3779 n2_3783)) (and (= max_5689 n2_3783) (< n1_3779 n2_3783))))))
(assert (= (+ b n2_3783) (+ 1 n1_3779)))
(assert (<= n2_3783 (+ 1 n1_3779)))
(assert (<= n1_3779 (+ n2_3783 1)))
(assert (= tn_4092 n2_3783))
(assert (< 0 tn_4092))
(assert (or (= tn_4092 resn_4116) (and (= resn_4116 (+ 1 tn_4092)) (not (= resb_4117 1)))))
(assert (= n resn_4116))
(assert (<= 0 n))
(assert (= n_4153 n1_3779))
(assert (= (+ 2 n_4153) n))
(assert (= n_4245 n2_4240))
(assert (= n_4264 n1_4236))
(assert (= cn n_4245))
(assert (= resn_4469 (+ 1 tmp2_4470)))
(assert (<= b_4501 2))
(assert (<= 0 b_4501))
(assert (<= 0 n_4500))
(assert (<= 0 n_4611))
(assert (<= n_4611 n_4500))
(assert (<= 0 cn))
(assert (= n_4611 cn))
(assert (<= 0 an))
(assert (<= 0 bn))
(assert (or (and (= tmp2_4470 resln_4471) (>= resln_4471 cn)) (and (= tmp2_4470 cn) (< resln_4471 cn))))
(assert (or (and (= tmp1_4468 an) (>= an bn)) (and (= tmp1_4468 bn) (< an bn))))
(assert (= resln_4471 (+ 1 tmp1_4468)))
(assert (<= 0 n_4153))
(assert (<= 0 n_4264))
(assert (= bn n_4264))
(assert (= an n_4153))
(assert (= n1_4526 an))
(assert (= n2_4530 bn))
(assert (<= n1_4526 (+ n2_4530 1)))
(assert (<= n2_4530 (+ 1 n1_4526)))
(assert (or (and (= resln_4471 (+ n1_4526 1)) (<= n2_4530 n1_4526)) (and (= resln_4471 (+ n2_4530 1)) (< n1_4526 n2_4530))))
(assert (= resln_4471 n_4500))
(assert (= (+ b_4501 n2_4530) (+ 1 n1_4526)))
(assert (exists ((max_5691 Int)) (and (= n_4500 (+ 1 max_5691)) (or (and (= max_5691 n1_4526) (>= n1_4526 n2_4530)) (and (= max_5691 n2_4530) (< n1_4526 n2_4530))))))
(assert (exists ((resb_5693 Int)) (= (+ resb_5693 n2_5616) (+ 1 n1_5612))))
(assert (exists ((max_5692 Int)) (and (= v_int_79_5605 (+ 1 max_5692)) (or (and (= max_5692 n1_5612) (>= n1_5612 n2_5616)) (and (= max_5692 n2_5616) (< n1_5612 n2_5616))))))
(assert (= n2_5616 n_4611))
(assert (= n1_5612 n_4500))
(assert (= v_int_79_5605 (+ 1 n_4500)))
;Negation of Consequence
(assert (not (or (and (= v_int_79_5605 (+ 1 n1_5612)) (<= n2_5616 n1_5612)) (and (= v_int_79_5605 (+ 1 n2_5616)) (< n1_5612 n2_5616)))))
(check-sat)